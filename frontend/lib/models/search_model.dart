import 'package:flutter/material.dart';
import 'package:frontend/api_calls/data.dart';
import 'package:frontend/screens/chat_page.dart';
import 'package:frontend/widgets/chat_list_tile.dart';
import 'package:provider/provider.dart';

import 'contacts_model.dart';

class ContactSearch extends SearchDelegate {
  ContactsModel selectedResult = ContactsModel(
    imageUrl: '',
    lastMessage: '',
    name: '',
    contactId: 0,
    aboutValue: '',
    karmaNumber: 0,
    level: 0,
  );
  late List<ContactsModel> resultList;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView.builder(
      itemCount: resultList.length,
      itemBuilder: (context, position) => ChatListTile(
        onPressedChatTile: () {
          Navigator.pushNamed(
            context,
            '/chatPage',
            arguments: ChatPageArguments(
              avatarUrl: resultList[position].imageUrl,
              recieverName: resultList[position].name,
              recieverId: resultList[position].contactId,
            ),
          );
        },
        name: resultList[position].name,
        imageUrl: resultList[position].imageUrl,
        lastMessage: resultList[position].lastMessage,
        recieverId: resultList[position].contactId,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<ContactsModel> suggestedContact = [];
    List<ContactsModel> contactsToSearch =
        Provider.of<Data>(context, listen: false).contacts;
    query.isEmpty
        ? suggestedContact = Provider.of<Data>(context, listen: false).contacts
        : suggestedContact.addAll(
            contactsToSearch.where(
              (element) => element.name.contains(query),
            ),
          );
    resultList = suggestedContact;

    return ListView.builder(
      itemCount: suggestedContact.length,
      itemBuilder: (context, position) => ChatListTile(
        onPressedChatTile: () {
          Navigator.pushNamed(
            context,
            '/chatPage',
            arguments: ChatPageArguments(
              avatarUrl: suggestedContact[position].imageUrl,
              recieverName: suggestedContact[position].name,
              recieverId: suggestedContact[position].contactId,
            ),
          );
        },
        name: suggestedContact[position].name,
        imageUrl: suggestedContact[position].imageUrl,
        lastMessage: suggestedContact[position].lastMessage,
        recieverId: suggestedContact[position].contactId,
      ),
    );
  }
}
