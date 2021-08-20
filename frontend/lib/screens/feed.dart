import 'package:flutter/material.dart';
import 'package:frontend/api_calls/data.dart';
import 'package:provider/provider.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';

class QuestionFeed extends StatefulWidget {
  @override
  _QuestionFeedState createState() => _QuestionFeedState();
}

class _QuestionFeedState extends State<QuestionFeed> {
  @override
  void initState() {
    super.initState();
    Provider.of<Data>(context, listen: false).getFeedCards();
  }

  @override
  Widget build(BuildContext context) {
    return TikTokStyleFullPageScroller(
        contentSize: Provider.of<Data>(context).feedCards.length,
        swipePositionThreshold: 0.2,
        swipeVelocityThreshold: 2000,
        animationDuration: const Duration(milliseconds: 300),
        builder: (BuildContext context, int index) {
          if (Provider.of<Data>(context, listen: false)
                  .feedCards[index]
                  .isQuestion ==
              false) {
            return Card(
              child: Column(
                children: [
                  Provider.of<Data>(context, listen: false)
                              .feedCards[index]
                              .imageUrl ==
                          'no image'
                      ? SizedBox(height: 0)
                      : Image(
                          image: NetworkImage(
                            Provider.of<Data>(context, listen: false)
                                .feedCards[index]
                                .imageUrl,
                          ),
                        ),
                  Text(
                    Provider.of<Data>(context, listen: false)
                        .feedCards[index]
                        .heading,
                  ),
                  Text(
                    Provider.of<Data>(context, listen: false)
                        .feedCards[index]
                        .content,
                  )
                ],
              ),
            );
          } else {
            Provider.of<Data>(context, listen: false).getOptions(
                Provider.of<Data>(context, listen: false).feedCards[index].id);

            return Card(
              child: Column(
                children: [
                  Provider.of<Data>(context, listen: false)
                              .feedCards[index]
                              .imageUrl ==
                          'no image'
                      ? SizedBox(height: 0)
                      : Image(
                          image: NetworkImage(
                            Provider.of<Data>(context, listen: false)
                                .feedCards[index]
                                .imageUrl,
                          ),
                        ),
                  Text(
                    Provider.of<Data>(context, listen: false)
                        .feedCards[index]
                        .heading,
                  ),
                  Text(Provider.of<Data>(context).options[0].option),
                  Text(Provider.of<Data>(context).options[1].option),
                  Text(Provider.of<Data>(context).options[2].option),
                  Text(Provider.of<Data>(context).options[3].option),
                ],
              ),
            );
          }
        });
  }
}
