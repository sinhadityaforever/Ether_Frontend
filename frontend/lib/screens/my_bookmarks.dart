import 'package:esys_flutter_share/esys_flutter_share.dart';
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

class MyBookmarks extends StatefulWidget {
  @override
  _MyBookmarks createState() => _MyBookmarks();
}

class _MyBookmarks extends State<MyBookmarks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ether.',
          style: TextStyle(
            fontSize: 30.sp,
            fontWeight: FontWeight.w700,
            color: Color(0xFFEB1555),
          ),
        ),
      ),
      body: FutureBuilder(
          future: Provider.of<Data>(context, listen: false).getBookMark(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              print(Provider.of<Data>(context, listen: false)
                      .bookmarkedFeedCards
                      .toString() +
                  'ferodfe');
              return Provider.of<Data>(context).bookmarkedFeedCards.length == 0
                  ? Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            'images/doggy.png',
                            height: 350.h,
                            width: 350.w,
                          ),
                          SizedBox(
                            height: 10.w,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(22.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Your bookmarked contents along with your notes appear here.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    color: Color(0xFFEB1555),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Designed by Freepik',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.white60,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : (PageView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount:
                          Provider.of<Data>(context).bookmarkedFeedCards.length,
                      itemBuilder: (BuildContext context, int index) {
                        bool isBookmarked =
                            Provider.of<Data>(context, listen: false)
                                .isBookMark(
                                    Provider.of<Data>(context, listen: false)
                                        .bookmarkedFeedCards[index]
                                        .id);
                        bool isLoved = Provider.of<Data>(context, listen: false)
                            .isLiked(Provider.of<Data>(context, listen: false)
                                .bookmarkedFeedCards[index]
                                .id);
                        if (Provider.of<Data>(context)
                                .bookmarkedFeedCards[index]
                                .isVideo ==
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
                                        .bookmarkedFeedCards[index]
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
                                          Provider.of<Data>(context,
                                                  listen: false)
                                              .bookmarkedFeedCards[index]
                                              .imageUrl,
                                        ),
                                      ),
                                    ),
                                  ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 0),
                                      child: Text(
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .bookmarkedFeedCards[index]
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
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 10),
                                      child: Text(
                                        Provider.of<Data>(context,
                                                listen: false)
                                            .bookmarkedFeedCards[index]
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
                          try {
                            String notes = "";
                            YoutubePlayerController ytController =
                                YoutubePlayerController(
                              initialVideoId: YoutubePlayer.convertUrlToId(
                                Provider.of<Data>(context, listen: false)
                                    .bookmarkedFeedCards[index]
                                    .content,
                              )!, //Add videoID.

                              flags: YoutubePlayerFlags(
                                hideControls: false,
                                controlsVisibleAtStart: true,
                                autoPlay: false,
                                mute: false,
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
                                                    YoutubePlayer
                                                        .convertUrlToId(Provider
                                                                .of<Data>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                            .bookmarkedFeedCards[
                                                                index]
                                                            .content)!;
                                                Provider.of<Data>(context,
                                                            listen: false)
                                                        .videoStartingPoint =
                                                    ytController.value.position
                                                        .inSeconds;
                                                ytController.pause();
                                                Navigator.pushNamed(context,
                                                    '/fullScreenPlayer');
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
                                          progressIndicatorColor:
                                              Color(0xFFEB1555),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 10, 0),
                                        child: Text(
                                          Provider.of<Data>(context,
                                                  listen: false)
                                              .firstCharacterUpper(Provider.of<
                                                          Data>(context,
                                                      listen: false)
                                                  .bookmarkedFeedCards[index]
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
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 10, 10),
                                        child: Text(
                                          "\u2022 Write Your Notes By Bookmarking The idea \n\n\u2022 Show Your Love For The Idea By Liking \n\n\u2022 Deepdive To See Other People's Notes On This Idea",
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
                                                  .interactWithLike(
                                                      Provider.of<Data>(context,
                                                              listen: false)
                                                          .bookmarkedFeedCards[
                                                              index]
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
                                                          .bookmarkedFeedCards[
                                                              index]
                                                          .content)!;
                                              Provider.of<Data>(context,
                                                          listen: false)
                                                      .videoStartingPoint =
                                                  ytController
                                                      .value.position.inSeconds;
                                              ytController.pause();
                                              Navigator.pushNamed(
                                                context,
                                                '/bookmarkPage',
                                                arguments: BookmarkArguments(
                                                  content: Provider.of<Data>(
                                                          context,
                                                          listen: false)
                                                      .bookmarkedFeedCards[
                                                          index]
                                                      .content,
                                                  heading: Provider.of<Data>(
                                                          context,
                                                          listen: false)
                                                      .bookmarkedFeedCards[
                                                          index]
                                                      .heading,
                                                  imageUrl: Provider.of<Data>(
                                                          context,
                                                          listen: false)
                                                      .bookmarkedFeedCards[
                                                          index]
                                                      .imageUrl,
                                                  isVideo: Provider.of<Data>(
                                                          context,
                                                          listen: false)
                                                      .bookmarkedFeedCards[
                                                          index]
                                                      .isVideo,
                                                  cardId: Provider.of<Data>(
                                                          context,
                                                          listen: false)
                                                      .bookmarkedFeedCards[
                                                          index]
                                                      .id,
                                                ),
                                              );
                                            },
                                            textOfButton: Provider.of<Data>(
                                                        context,
                                                        listen: false)
                                                    .isBookMark(Provider.of<
                                                                Data>(context,
                                                            listen: false)
                                                        .bookmarkedFeedCards[
                                                            index]
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
                                                    await rootBundle.load(
                                                        'images/share.jpg');
                                                await Share.file(
                                                    'Share Ether with',
                                                    'esys.png',
                                                    bytes.buffer.asUint8List(),
                                                    'image/png',
                                                    text:
                                                        "Hey let's get Smart together on Ether.\n get Ether: https://play.google.com/store/apps/details?id=com.Wired.frontend");
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 10, 0),
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
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 10, 10),
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
                      }));
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
          }),
    );
  }
}
