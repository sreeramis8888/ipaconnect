import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:ipaconnect/src/data/utils/youtube_player.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

Widget customVideo({required BuildContext context, required String videoUrl,String? videoHeading}) {
  if (videoUrl.contains('youtube.com') || videoUrl.contains('youtu.be')) {
    final videoId = extractYouTubeVideoId(videoUrl) ?? '';
    final ytController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        disableDragSeek: true,
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
    print(videoUrl);
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
  }else {
    // Handle non-YouTube  urls Instagram, Facebook
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(videoUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Could not open video")),
          );
        }
      },
      child: Container(
        height: 200,
        color: Colors.black12,
        child: Center(
          child: 
        //   Column(
        //     children: [
        //       if (videoHeading != null && videoHeading.isNotEmpty)
        // Padding(
        //   padding: const EdgeInsets.only(bottom: 8),
        //   child:
        //    Text(
        //     videoHeading, 
        //     style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        //   ),
        // ),
        //     ],
        //   )
          
          Icon(Icons.open_in_browser, size: 40, color: Colors.blue),
        ),
      ),
    );
  }
}

  

