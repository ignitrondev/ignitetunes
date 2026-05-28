import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/music_service.dart';
import '../widgets/neon_glow_background.dart';
import '../widgets/glass_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MusicService _musicService = MusicService();
  late final AudioPlayer _audioPlayer;
  final TextEditingController _searchController = TextEditingController();

  List<Video> _searchResults = [];
  bool _isLoading = false;
  Video? _currentVideo;

  @override
  void initState() {
    super.initState();
    
    _audioPlayer = AudioPlayer(
      audioLoadConfiguration: const AudioLoadConfiguration(
        androidLoadControl: AndroidLoadControl(
          minBufferDuration: Duration(seconds: 15),
          maxBufferDuration: Duration(seconds: 50),
          bufferForPlaybackDuration: Duration(seconds: 3),
          bufferForPlaybackAfterRebufferDuration: Duration(seconds: 6),
        ),
      ),
    );

    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _audioPlayer.pause();
        _audioPlayer.seek(Duration.zero);
      }
    });
  }

  void _search() async {
    if (_searchController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final results = await _musicService.searchTracks(_searchController.text);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Search Error: $e')),
      );
    }
  }

  void _playVideo(Video video) async {
    setState(() => _currentVideo = video);
    const int maxRetries = 3;

    for (int attempt = 0; attempt < maxRetries; attempt++) {
      try {
        final url = await _musicService.getAudioStreamUrl(video.id.value);
        if (url == null) throw Exception('No valid stream URL found');

        debugPrint('Attempt ${attempt + 1}: $url');

        await _audioPlayer.setAudioSource(
          AudioSource.uri(
            Uri.parse(url),
            headers: {
              'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36',
            },
          ),
        );
        
        await _audioPlayer.load();
        _audioPlayer.play();
        return;
      } catch (e) {
        debugPrint('Attempt $attempt failed: $e');
        if (attempt < maxRetries - 1 && mounted) {
          await Future.delayed(Duration(seconds: 2 + attempt));
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to play after $maxRetries attempts')),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _musicService.dispose();
    _audioPlayer.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NeonGlowBackground(
      showBackgroundImage: true,
      child: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFFddb7ff)))
                : _buildSearchResults(),
          ),
          if (_currentVideo != null) _buildMiniPlayer(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GlassCard(
        borderRadius: 16,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search your rhythm...',
            hintStyle: GoogleFonts.geist(color: Colors.white54),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.search, color: Color(0xFFddb7ff)),
              onPressed: _search,
            ),
          ),
          onSubmitted: (_) => _search(),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Text(
          'Start your Ignite session',
          style: GoogleFonts.spaceGrotesk(color: Colors.white38, fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final video = _searchResults[index];
        final isPlaying = _currentVideo?.id.value == video.id.value;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GlassCard(
            borderRadius: 12,
            padding: const EdgeInsets.all(8),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(video.thumbnails.lowResUrl, fit: BoxFit.cover, width: 50, height: 50),
              ),
              title: Text(
                video.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.geist(
                  color: isPlaying ? const Color(0xFFddb7ff) : Colors.white,
                  fontWeight: isPlaying ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              subtitle: Text(
                video.author,
                style: GoogleFonts.geist(color: Colors.white60, fontSize: 12),
              ),
              trailing: Icon(
                isPlaying ? Icons.equalizer : Icons.play_arrow_rounded,
                color: const Color(0xFFddb7ff),
              ),
              onTap: () => _playVideo(video),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMiniPlayer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.8),
        border: const Border(top: BorderSide(color: Colors.white12, width: 0.5)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamBuilder<Duration>(
            stream: _audioPlayer.positionStream,
            builder: (context, snapshot) {
              final position = snapshot.data ?? Duration.zero;
              final duration = _audioPlayer.duration ?? Duration.zero;
              return ProgressBar(
                progress: position,
                total: duration,
                buffered: _audioPlayer.bufferedPosition,
                onSeek: (duration) => _audioPlayer.seek(duration),
                baseBarColor: Colors.white10,
                progressBarColor: const Color(0xFFddb7ff),
                thumbColor: const Color(0xFFddb7ff),
                barHeight: 3,
                thumbRadius: 6,
                timeLabelTextStyle: GoogleFonts.jetBrainsMono(color: Colors.white54, fontSize: 10),
              );
            },
          ),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(_currentVideo!.thumbnails.lowResUrl, width: 45, height: 45, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentVideo!.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.geist(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      _currentVideo!.author,
                      style: GoogleFonts.geist(color: Colors.white60, fontSize: 11),
                    ),
                  ],
                ),
              ),
              StreamBuilder<PlayerState>(
                stream: _audioPlayer.playerStateStream,
                builder: (context, snapshot) {
                  final playerState = snapshot.data;
                  final processingState = playerState?.processingState;
                  final playing = playerState?.playing;

                  if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering) {
                    return const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFddb7ff)));
                  } else if (playing != true) {
                    return IconButton(
                      icon: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 32),
                      onPressed: _audioPlayer.play,
                    );
                  } else {
                    return IconButton(
                      icon: const Icon(Icons.pause_rounded, color: Colors.white, size: 32),
                      onPressed: _audioPlayer.pause,
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
