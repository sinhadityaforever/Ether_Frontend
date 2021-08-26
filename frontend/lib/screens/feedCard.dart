import 'package:flutter/material.dart';
import 'package:frontend/api_calls/data.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FeedCardArguments {
  bool isVideo;
  String imageUrl;
  int id;
  String heading;
  String content;
  String desco;

  FeedCardArguments(
      {required this.content,
      required this.desco,
      required this.heading,
      required this.id,
      required this.imageUrl,
      required this.isVideo});
}

class FeedCard extends StatefulWidget {
  @override
  _FeedCardState createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as FeedCardArguments;
    if (args.isVideo == false) {
      return Card(
        elevation: 20,
        shadowColor: Colors.black,
        color: Color(0xFF111328),
        child: Column(
          children: [
            if (args.imageUrl == 'no image')
              SizedBox(height: 0)
            else
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r),
                  ),
                  child: Image(
                    fit: BoxFit.fitWidth,
                    height: 300.h,
                    width: double.infinity,
                    image: NetworkImage(args.imageUrl),
                  ),
                ),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Text(
                    args.heading,
                    style: TextStyle(
                      fontSize: 25.sp,
                      color: Color(0xFFEB1555),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Text(
                    args.content.replaceAll("20", '\n\n\u2022 '),
                    style: TextStyle(
                      fontSize: 17.sp,
                      color: Colors.white60,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    } else {
      YoutubePlayerController ytController = YoutubePlayerController(
        initialVideoId:
            YoutubePlayer.convertUrlToId(args.content)!, //Add videoID.

        flags: YoutubePlayerFlags(
          hideControls: false,
          controlsVisibleAtStart: true,
          autoPlay: false,
          mute: false,
          startAt: Provider.of<Data>(context, listen: false).onVideoResume,
        ),
      );
      return Card(
        elevation: 20,
        shadowColor: Colors.black,
        color: Color(0xFF111328),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 10.h,
            ),
            Container(
              child: YoutubePlayerBuilder(
                player: YoutubePlayer(
                  topActions: [
                    PlaybackSpeedButton(
                      icon: Icon(Icons.speed),
                    ),
                  ],
                  bottomActions: [
                    IconButton(
                      onPressed: () {
                        Provider.of<Data>(context, listen: false).videoId =
                            YoutubePlayer.convertUrlToId(args.content)!;
                        Provider.of<Data>(context, listen: false)
                                .videoStartingPoint =
                            ytController.value.position.inSeconds;
                        ytController.pause();
                        Navigator.pushNamed(context, '/fullScreenPlayer');
                      },
                      icon: Icon(Icons.fullscreen),
                    ),
                    ProgressBar(
                      isExpanded: true,
                    ),
                    CurrentPosition(),
                    RemainingDuration(),
                  ],
                  aspectRatio: 16 / 9,
                  controller: ytController,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Color(0xFFEB1555),
                ),
                builder: (context, player) {
                  return player;
                },
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child: Text(
                    args.heading,
                    style: TextStyle(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFEB1555),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: SingleChildScrollView(
                    child: Text(
                      args.desco.replaceAll("20", '\n\n\u2022 '),
                      style: TextStyle(
                        fontSize: 17.sp,
                        color: Colors.white60,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }
  }
}
