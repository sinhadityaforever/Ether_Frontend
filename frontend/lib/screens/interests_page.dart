import 'package:flutter/material.dart';
import 'package:frontend/models/interestModel.dart';
import '../widgets/interest_button.dart';
import 'package:provider/provider.dart';
import '../api_calls/data.dart';
import '../widgets/rounded_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InterestsPage extends StatelessWidget {
  final List<String> interestText = [];
  final List<InterestModel> intereststobe = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tap to select and long press to delete:',
          maxLines: 2,
          style: TextStyle(
            fontSize: 22.sp,
            color: Color(0xFFEB1555),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              itemBuilder: (context, index) {
                final interest = Provider.of<Data>(context).interests[index];
                return InterestButton(
                  isSelected: interest.isSelected,
                  textOfWidget: interest.textOfButton,
                  onPressedInterestButton: () {
                    if (intereststobe.contains(interest) == false) {
                      intereststobe.add(interest);
                    }
                    Provider.of<Data>(context, listen: false)
                        .changeColorInterest(interest);
                    for (var i = 0; i < intereststobe.length; i++) {
                      if (interestText
                              .contains(intereststobe[i].textOfButton) ==
                          false) {
                        interestText.add(intereststobe[i].textOfButton);
                      }
                    }
                  },
                  onLongTap: () {
                    intereststobe.remove(interest);
                    interestText.remove(interest.textOfButton);
                    Provider.of<Data>(context, listen: false)
                        .deleteColorInterest(interest);
                  },
                );
              },
              itemCount: Provider.of<Data>(context).interests.length,
            ),
          ),
          RoundedButton(
            colorOfButton: Color(0xFFEB1555),
            onPressedRoundButton: () async {
              Provider.of<Data>(context, listen: false)
                  .updateToggle(interestText);
              Provider.of<Data>(context, listen: false).scheduleMatches();
              Provider.of<Data>(context, listen: false).interestSave(context);
            },
            textOfButton: 'Next',
          )
        ],
      ),
    );
  }
}
