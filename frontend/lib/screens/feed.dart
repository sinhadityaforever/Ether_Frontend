// import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/api_calls/data.dart';
import 'package:frontend/screens/bookmark_page.dart';
import 'package:frontend/widgets/rounded_button.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:like_button/like_button.dart';

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
                  bool isBookmarked = Provider.of<Data>(context, listen: false)
                      .isBookMark(Provider.of<Data>(context, listen: false)
                          .feedCards[index]
                          .id);
                  bool isLoved = Provider.of<Data>(context, listen: false)
                      .isLiked(Provider.of<Data>(context, listen: false)
                          .feedCards[index]
                          .id);
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
                    print(
                      Provider.of<Data>(context, listen: false)
                          .feedCards[index]
                          .startAt,
                    );
                    print(Provider.of<Data>(context, listen: false)
                        .feedCards[index]
                        .endAt);
                    try {
                      String notes = "";
                      YoutubePlayerController ytController =
                          YoutubePlayerController(
                        initialVideoId: YoutubePlayer.convertUrlToId(
                          Provider.of<Data>(context, listen: false)
                              .feedCards[index]
                              .content,
                        )!, //Add videoID.

                        flags: YoutubePlayerFlags(
                          disableDragSeek: true,
                          hideControls: false,
                          controlsVisibleAtStart: true,
                          autoPlay: false,
                          mute: false,
                          startAt: Provider.of<Data>(context, listen: false)
                              .feedCards[index]
                              .startAt,
                          endAt: Provider.of<Data>(context, listen: false)
                              .feedCards[index]
                              .endAt,
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
                                    showVideoProgressIndicator: false,
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
                                          Provider.of<Data>(context,
                                                      listen: false)
                                                  .videoEndingPoint =
                                              Provider.of<Data>(context,
                                                      listen: false)
                                                  .feedCards[index]
                                                  .endAt;
                                          ytController.pause();
                                          Navigator.pushNamed(
                                              context, '/fullScreenPlayer');
                                        },
                                        icon: Icon(Icons.fullscreen),
                                      ),
                                      // ProgressBar(
                                      //   isExpanded: true,
                                      // ),
                                      // CurrentPosition(),
                                      // RemainingDuration(),
                                    ],
                                    aspectRatio: 16 / 9,
                                    controller: ytController,
                                    progressIndicatorColor: Color(0xFFEB1555),
                                  ),
                                  builder: (context, player) {
                                    return player;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Text(
                                    Provider.of<Data>(context, listen: false)
                                        .firstCharacterUpper(Provider.of<Data>(
                                                context,
                                                listen: false)
                                            .feedCards[index]
                                            .heading),
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      color: Color(0xFFEB1555),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                  child: Text(
                                    "\u2022 Write Your Notes By Pressing On The 'Take Note' Button \n\n\u2022 Show Your Love For The Idea By Liking \n\n\u2022 Share With Your Friends To Grow Together",
                                    maxLines: 8,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 17.sp,
                                      color: Colors.white60,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    LikeButton(
                                      isLiked: isLoved,
                                      onTap: (isLiked) async {
                                        isLoved = !isLoved;
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .interactWithLike(Provider.of<Data>(
                                                    context,
                                                    listen: false)
                                                .feedCards[index]
                                                .id);
                                        return !isLiked;
                                      },
                                    ),
                                    RoundedButton(
                                      colorOfButton: Color(0xFFEB1555),
                                      onPressedRoundButton: () {
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
                                        Provider.of<Data>(context,
                                                    listen: false)
                                                .videoEndingPoint =
                                            Provider.of<Data>(context,
                                                    listen: false)
                                                .feedCards[index]
                                                .endAt;
                                        ytController.pause();
                                        Navigator.pushNamed(
                                          context,
                                          '/bookmarkPage',
                                          arguments: BookmarkArguments(
                                            content: Provider.of<Data>(context,
                                                    listen: false)
                                                .feedCards[index]
                                                .content,
                                            heading: Provider.of<Data>(context,
                                                    listen: false)
                                                .feedCards[index]
                                                .heading,
                                            imageUrl: Provider.of<Data>(context,
                                                    listen: false)
                                                .feedCards[index]
                                                .imageUrl,
                                            isVideo: Provider.of<Data>(context,
                                                    listen: false)
                                                .feedCards[index]
                                                .isVideo,
                                            cardId: Provider.of<Data>(context,
                                                    listen: false)
                                                .feedCards[index]
                                                .id,
                                          ),
                                        );
                                        // Provider.of<Data>(context,
                                        //             listen: false)
                                        //         .videoId =
                                        //     YoutubePlayer.convertUrlToId(
                                        //         Provider.of<Data>(context,
                                        //                 listen: false)
                                        //             .feedCards[index]
                                        //             .content)!;
                                        // Provider.of<Data>(context,
                                        //             listen: false)
                                        //         .videoStartingPoint =
                                        //     ytController
                                        //         .value.position.inSeconds;
                                        // ytController.pause();
                                        // Provider.of<Data>(context,
                                        //         listen: false)
                                        //     .increasekarma();
                                        // showDialog(
                                        //   context: context,
                                        //   builder: (BuildContext context) =>
                                        //       Popup(
                                        //     popupTitle: "Karma up by 5!",
                                        //     popuptext:
                                        //         "Deep diving into videos and watching them completely increments your karma keep goin",
                                        //   ),
                                        // );
                                        // Navigator.pushNamed(
                                        //   context,
                                        //   '/feedCard',
                                        //   arguments: FeedCardArguments(
                                        //     cardId: Provider.of<Data>(context,
                                        //             listen: false)
                                        //         .feedCards[index]
                                        //         .id,
                                        //     content: Provider.of<Data>(context,
                                        //             listen: false)
                                        //         .feedCards[index]
                                        //         .content,
                                        //     desco: Provider.of<Data>(context,
                                        //             listen: false)
                                        //         .feedCards[index]
                                        //         .desco,
                                        //     heading: Provider.of<Data>(context,
                                        //             listen: false)
                                        //         .firstCharacterUpper(
                                        //             Provider.of<Data>(context,
                                        //                     listen: false)
                                        //                 .feedCards[index]
                                        //                 .heading),
                                        //     imageUrl: Provider.of<Data>(context,
                                        //             listen: false)
                                        //         .feedCards[index]
                                        //         .imageUrl,
                                        //     isVideo: Provider.of<Data>(context,
                                        //             listen: false)
                                        //         .feedCards[index]
                                        //         .isVideo,
                                        //   ),
                                        // );
                                      },
                                      textOfButton: Provider.of<Data>(context,
                                                  listen: false)
                                              .isBookMark(Provider.of<Data>(
                                                      context,
                                                      listen: false)
                                                  .feedCards[index]
                                                  .id)
                                          ? 'Edit Note'
                                          : 'Take Note',
                                    ),
                                    LikeButton(
                                        isLiked: isBookmarked,
                                        likeBuilder: (isLiked) {
                                          return Icon(
                                            FontAwesomeIcons.share,
                                            color: isLiked
                                                ? Colors.deepPurpleAccent
                                                : Colors.grey,
                                          );
                                        },
                                        onTap: (isLiked) async {
                                          final ByteData bytes =
                                              await rootBundle
                                                  .load('images/share.jpg');
                                          // await Share.file(
                                          //     'Share Ether with',
                                          //     'esys.png',
                                          //     bytes.buffer.asUint8List(),
                                          //     'image/png',
                                          //     text:
                                          //         "Hey let's get Smart together on Ether.\n get Ether: https://play.google.com/store/apps/details?id=com.Wired.frontend");
                                          return !isLiked;
                                        }),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    } catch (e) {
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Text(
                                    'This piece of gold is not available',
                                    maxLines: 2,
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
                                    'You continue learning we are getting back with this content',
                                    maxLines: 8,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 17.sp,
                                      color: Colors.white60,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }
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
