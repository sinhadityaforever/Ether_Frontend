import 'package:flutter/material.dart';
import 'package:frontend/api_calls/data.dart';
import 'package:provider/provider.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
            return TikTokStyleFullPageScroller(
                contentSize: Provider.of<Data>(context).feedCards.length,
                swipePositionThreshold: 0.2,
                swipeVelocityThreshold: 3000,
                animationDuration: const Duration(milliseconds: 250),
                builder: (BuildContext context, int index) {
                  print(Provider.of<Data>(context).feedCards.length);
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
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
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
                });
          } else {
            return CircularProgressIndicator(
              color: Color(0xFFEB1555),
            );
          }
        });
  }
}
