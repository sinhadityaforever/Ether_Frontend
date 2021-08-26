import 'package:flutter/material.dart';
import 'package:frontend/api_calls/data.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:provider/provider.dart';

class FullScreenPlayer extends StatefulWidget {
  @override
  _FullScreenPlayerState createState() => _FullScreenPlayerState();
}

class _FullScreenPlayerState extends State<FullScreenPlayer> {
  @override
  Widget build(BuildContext context) {
    YoutubePlayerController myController = YoutubePlayerController(
      initialVideoId: Provider.of<Data>(context, listen: false).videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        startAt: Provider.of<Data>(context, listen: false).videoStartingPoint,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          YoutubePlayerBuilder(
              player: YoutubePlayer(
                controller: myController,
                aspectRatio: 4 / 3,
                topActions: [
                  PlaybackSpeedButton(
                    icon: Icon(Icons.speed),
                  ),
                ],
                bottomActions: [
                  ProgressBar(
                    isExpanded: true,
                  ),
                  CurrentPosition(),
                  RemainingDuration(),
                ],
              ),
              builder: (context, player) {
                return Column(
                  children: [
                    // some widgets
                    player,
                    //some other widgets
                  ],
                );
              }),
        ],
      ),
    );
  }
}
