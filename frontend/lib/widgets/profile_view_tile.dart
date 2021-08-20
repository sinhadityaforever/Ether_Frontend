import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class profileViewTile extends StatelessWidget {
  final String title;
  final String value;
  profileViewTile({required this.title, required this.value});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20.sp,
                    // fontFamily: 'Caveat',
                    color: Color(0xFFEB1555),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  value,
                  maxLines: 10,
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
