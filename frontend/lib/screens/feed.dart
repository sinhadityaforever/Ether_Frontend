import 'package:flutter/material.dart';
import 'package:frontend/api_calls/data.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class QuestionFeed extends StatefulWidget {
  @override
  _QuestionFeedState createState() => _QuestionFeedState();
}

class _QuestionFeedState extends State<QuestionFeed> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<Data>(context, listen: false).getFeedCards(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            print(
                Provider.of<Data>(context, listen: false).feedCards.toString() +
                    'ferodfe');
            return PageView.builder(
                scrollDirection: Axis.vertical,
                itemCount: Provider.of<Data>(context).feedCards.length,
                itemBuilder: (BuildContext context, int index) {
                  print(Provider.of<Data>(context).feedCards.length);
                  if (Provider.of<Data>(context).feedCards[index].isVideo ==
                      false) {
                    return Card(
                      margin: EdgeInsets.all(20.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 20,
                      shadowColor: Colors.black,
                      color: Color(0xFF111328),
                      child: Column(
                        children: [
                          if (Provider.of<Data>(context, listen: false)
                                  .feedCards[index]
                                  .imageUrl ==
                              'no image')
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
                                  image: NetworkImage(
                                    Provider.of<Data>(context, listen: false)
                                        .feedCards[index]
                                        .imageUrl,
                                  ),
                                ),
                              ),
                            ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Text(
                                  Provider.of<Data>(context, listen: false)
                                      .feedCards[index]
                                      .heading,
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
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                child: Text(
                                  Provider.of<Data>(context, listen: false)
                                      .feedCards[index]
                                      .content
                                      .replaceAll("20", '\n\n\u2022 '),
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
                    YoutubePlayerController ytController =
                        YoutubePlayerController(
                      initialVideoId: YoutubePlayer.convertUrlToId(
                          Provider.of<Data>(context, listen: false)
                              .feedCards[index]
                              .content)!, //Add videoID.

                      flags: YoutubePlayerFlags(
                        hideControls: false,
                        controlsVisibleAtStart: true,
                        autoPlay: false,
                        mute: false,
                        startAt: Provider.of<Data>(context, listen: false)
                            .onVideoResume,
                      ),
                    );
                    return Card(
                      margin: EdgeInsets.all(20.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
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
                            height: 350.h,
                            width: 350.w,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.r),
                                topRight: Radius.circular(30.r),
                              ),
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
                                        Provider.of<Data>(context,
                                                    listen: false)
                                                .videoId =
                                            YoutubePlayer.convertUrlToId(
                                                Provider.of<Data>(context,
                                                        listen: false)
                                                    .feedCards[index]
                                                    .content)!;
                                        Provider.of<Data>(context,
                                                    listen: false)
                                                .videoStartingPoint =
                                            ytController
                                                .value.position.inSeconds;
                                        ytController.pause();
                                        Navigator.pushNamed(
                                            context, '/fullScreenPlayer');
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
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Text(
                                  Provider.of<Data>(context, listen: false)
                                      .feedCards[index]
                                      .heading,
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    color: Color(0xFFEB1555),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                child: Text(
                                  Provider.of<Data>(context, listen: false)
                                      .feedCards[index]
                                      .desco
                                      .replaceAll("20", '\n\n\u2022 '),
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
                  }
                });
          } else {
            return Center(
              child: Container(
                height: 180.h,
                width: 180.w,
                child: LiquidCircularProgressIndicator(
                  value: 0.5, // Defaults to 0.5.
                  valueColor: AlwaysStoppedAnimation(
                    Colors.pink,
                  ), // Defaults to the current Theme's accentColor.
                  backgroundColor: Colors
                      .black, // Defaults to the current Theme's backgroundColor.
                  borderColor: Colors.red,
                  borderWidth: 5.0,
                  direction: Axis
                      .horizontal, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                  center: Text("Loading..."),
                ),
              ),
            );
          }
        });
  }
}
