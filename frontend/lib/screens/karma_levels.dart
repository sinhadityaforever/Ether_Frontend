import 'package:flutter/material.dart';
import 'package:frontend/widgets/karma.dart';

class KarmaView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Karma.',
            style: TextStyle(
              color: Color(0xFFEB1555),
            ),
          ),
        ),
        body: Column(
          children: [
            KarmaListTile(
              name: '0 --> 100',
              path: 'images/badge-1.png',
              levelName: 'Novice',
            ),
            KarmaListTile(
              name: '100 --> 500',
              path: 'images/badge-2.png',
              levelName: 'Intermediate',
            ),
            KarmaListTile(
              name: '500 --> 1200',
              path: 'images/badge-3.png',
              levelName: 'Professional',
            ),
            KarmaListTile(
              name: '1200 --> 3800',
              path: 'images/badge-4.png',
              levelName: 'Intermediate',
            ),
            KarmaListTile(
              name: '3800 --> 5000',
              path: 'images/badge-5.png',
              levelName: 'Expert',
            ),
            KarmaListTile(
              name: '5000 --> 10000',
              path: 'images/badge-6.png',
              levelName: 'Grand Master',
            ),
          ],
        ),
      ),
    );
  }
}
