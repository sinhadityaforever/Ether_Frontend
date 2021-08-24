import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:frontend/widgets/rounded_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../api_calls/data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Avatar extends StatefulWidget {
  @override
  _AvatarState createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  final storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
                Provider.of<Data>(context, listen: false).avatarUrlOfUser),
            radius: 80.r,
          ),
          Positioned(
            bottom: 10.h,
            right: 0,
            child: FloatingActionButton(
              backgroundColor: Color(0xFFEB1555),
              child: Icon(Icons.camera_alt),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => bottomSheet()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomSheet() {
    final id = Provider.of<Data>(context).idOfUser;
    return Container(
      color: Color(0xFF090E11),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
          color: Color(0xFF11163B),
        ),
        height: 250.h,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                'Choose Profile Picture',
                style: TextStyle(
                  fontSize: 20.sp,
                  color: Color(0xFFEB1555),
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ignore: deprecated_member_use
                FlatButton.icon(
                  onPressed: () async {
                    Provider.of<Data>(context, listen: false).changeIndicator();
                    final pickedFile = await _picker.pickImage(
                        source: ImageSource.camera, imageQuality: 30);
                    if (pickedFile == null) {
                      Provider.of<Data>(context, listen: false)
                          .changeIndicator();
                    }
                    var snapshot = await storage
                        .ref()
                        .child('ProfilePicture/$id')
                        .putFile(File(pickedFile!.path));

                    imageUrl = await snapshot.ref.getDownloadURL();

                    print(imageUrl + 'This is image url');
                    await Provider.of<Data>(context, listen: false).updateSelf(
                      Provider.of<Data>(context, listen: false).nameOfUser,
                      Provider.of<Data>(context, listen: false).bioOfUser,
                      imageUrl,
                    );

                    Provider.of<Data>(context, listen: false).changeIndicator();
                  },
                  icon: Icon(
                    Icons.camera,
                  ),
                  label: Text('Camera'),
                ),
                SizedBox(
                  width: 50.w,
                ),
                // ignore: deprecated_member_use
                FlatButton.icon(
                  onPressed: () async {
                    Provider.of<Data>(context, listen: false).changeIndicator();
                    final pickedFile = await _picker.pickImage(
                        source: ImageSource.gallery, imageQuality: 30);
                    print(pickedFile);
                    if (pickedFile == null) {
                      Provider.of<Data>(context, listen: false)
                          .changeIndicator();
                    }

                    var snapshot = await storage
                        .ref()
                        .child('ProfilePicture/$id')
                        .putFile(File(pickedFile!.path));

                    imageUrl = await snapshot.ref.getDownloadURL();

                    print(imageUrl + 'This is image url');
                    await Provider.of<Data>(context, listen: false).updateSelf(
                        Provider.of<Data>(context, listen: false).nameOfUser,
                        Provider.of<Data>(context, listen: false).bioOfUser,
                        imageUrl);
                    Provider.of<Data>(context, listen: false).changeIndicator();
                  },
                  icon: Icon(
                    Icons.image,
                  ),
                  label: Text('Gallery'),
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            RoundedButton(
              colorOfButton: Color(0xFFEB1555),
              onPressedRoundButton: () {
                Navigator.pop(context);
              },
              textOfButton: 'Save',
            )
          ],
        ),
      ),
    );
  }
}
