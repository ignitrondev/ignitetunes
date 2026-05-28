import 'package:flutter/foundation.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class MusicService {
  final _yt = YoutubeExplode();

  Future<List<Video>> searchTracks(String query) async {
    var searchList = await _yt.search.search('$query music');
    return searchList.toList();
  }

  Future<String?> getAudioStreamUrl(String videoId) async {
    try {
      final manifest = await _yt.videos.streams.getManifest(videoId);
      
      final audioOnly = manifest.audioOnly.toList()
        ..sort((a, b) => b.bitrate.compareTo(a.bitrate));

      final candidates = <StreamInfo>[
        if (audioOnly.isNotEmpty) audioOnly[0],
        if (audioOnly.length > 1) audioOnly[1],
        manifest.muxed.withHighestBitrate(),
      ].whereType<StreamInfo>();

      for (final stream in candidates) {
        final url = stream.url.toString();
        if (url.isNotEmpty) return url;
      }
      
      return null;
    } catch (e) {
      debugPrint('Error getting audio stream for $videoId: $e');
      return null;
    }
  }
  
  void dispose() {
    _yt.close();
  }
}
