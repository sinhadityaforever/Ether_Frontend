import 'package:flutter/material.dart';
import 'package:frontend/api_calls/data.dart';
import 'package:frontend/screens/chat_page.dart';
import 'package:frontend/widgets/chat_list_tile.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return Provider.of<Data>(context).contacts.length == 0
        ? Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  'images/6.png',
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
                        'Your new friends appear here. Just wait for a match',
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
        : (ListView.builder(
            itemCount: Provider.of<Data>(context).contacts.length,
            itemBuilder: (context, index) {
              final contact = Provider.of<Data>(context).contacts[index];
              return ChatListTile(
                name: contact.name,
                imageUrl: contact.imageUrl,
                lastMessage: Provider.of<Data>(context)
                    .getlastMessage(contact.contactId),
                recieverId: contact.contactId,
                onPressedChatTile: () {
                  Provider.of<Data>(context, listen: false)
                      .addToSelectedContact(
                    contact.name,
                    contact.imageUrl,
                    contact.lastMessage,
                    contact.contactId,
                    contact.aboutValue,
                    contact.karmaNumber,
                    contact.level,
                  );
                  Navigator.pushNamed(
                    context,
                    '/chatPage',
                    arguments: ChatPageArguments(
                      avatarUrl: contact.imageUrl,
                      recieverName: contact.name,
                      recieverId: contact.contactId,
                    ),
                  );
                },
              );
            }));
  }
}
