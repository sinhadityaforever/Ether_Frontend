import 'package:flutter/material.dart';
import 'package:frontend/api_calls/data.dart';
import 'package:share_plus/share_plus.dart';
import 'package:frontend/widgets/rounded_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

class BookmarkArguments {
  bool isVideo;
  String imageUrl;
  String heading;
  String content;
  int cardId;

  BookmarkArguments({
    required this.content,
    required this.heading,
    required this.imageUrl,
    required this.isVideo,
    required this.cardId,
  });
}

class BookmarkPage extends StatefulWidget {
  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as BookmarkArguments;
    if (args.isVideo == false) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Ether.',
            style: TextStyle(
              fontSize: 30.sp,
              fontWeight: FontWeight.w700,
              color: Color(0xFFEB1555),
            ),
          ),
        ),
        body: Card(
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
        ),
      );
    } else {
      String notes = "";
      YoutubePlayerController ytController = YoutubePlayerController(
        initialVideoId:
            Provider.of<Data>(context, listen: false).videoId, //Add videoID.

        flags: YoutubePlayerFlags(
          hideControls: false,
          controlsVisibleAtStart: true,
          autoPlay: true,
          mute: false,
          startAt: Provider.of<Data>(context, listen: false).videoStartingPoint,
        ),
      );

      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Ether.',
            style: TextStyle(
              fontSize: 30.sp,
              fontWeight: FontWeight.w700,
              color: Color(0xFFEB1555),
            ),
          ),
        ),
        body: SingleChildScrollView(
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
              SizedBox(
                height: 20.h,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(9, 0, 10, 0),
                    child: Text(
                      args.heading,
                      style: TextStyle(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFEB1555),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 9,
                          maxLength: 280,
                          minLines: 6,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xFF2A2F32),
                            hintText: 'Type a message',
                            hintStyle: TextStyle(
                              color: Color(0xFFA9AAAC),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                          ),
                          onChanged: (String value) {
                            notes = value;
                          },
                        ),
                      ),
                      RoundedButton(
                        colorOfButton: Color(0xFFEB1555),
                        onPressedRoundButton: () {
                          Provider.of<Data>(context, listen: false)
                              .postBookmark(
                            args.cardId,
                            notes,
                          );
                          showDialog(
                            context: context,
                            builder: (_) => AssetGiffyDialog(
                              buttonOkText: Text('Share'),
                              image: Image.asset(
                                "images/kuch_bhi.gif",
                              ),
                              title: Text(
                                'Idea bookmarked Share it if you like 😄',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              entryAnimation: EntryAnimation.TOP,
                              onOkButtonPressed: () {},
                            ),
                          );
                        },
                        textOfButton: 'Bookmark',
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      );
    }
  }
}
