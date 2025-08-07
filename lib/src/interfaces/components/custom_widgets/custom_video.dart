import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:ipaconnect/src/data/utils/youtube_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

Widget customVideo({required BuildContext context, required String videoUrl}) {
  final videoId = extractYouTubeVideoId(videoUrl) ?? '';
  final ytController = YoutubePlayerController(
    initialVideoId: videoId,
    flags: const YoutubePlayerFlags(disableDragSeek: true,
      autoPlay: false,
      loop: true,
      mute: false,
      controlsVisibleAtStart: true,
      enableCaption: true,
      isLive: false,
    ),
  );

  log(
    name: 'Video ID:',
    videoId,
  );
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Auto-scrolling marquee for the video title
      // Padding(
      //   padding: const EdgeInsets.only(top: 10),
      //   child: AutoScrollText(
      //     text: video.title ?? '',
      //     width: MediaQuery.of(context).size.width *
      //         0.9, // Set width to avoid taking full screen
      //   ),
      // ),
      Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          width: MediaQuery.of(context).size.width, // Full-screen width
          height: 200,
          decoration: BoxDecoration(
            color: Colors.transparent, // Transparent background
          ),
          child: ClipRRect(
            child: YoutubePlayer(
              controller: ytController,
              showVideoProgressIndicator: true,
              aspectRatio: 16 / 9,
            ),
          ),
        ),
      ),
    ],
  );
}
