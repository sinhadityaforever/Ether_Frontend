import 'package:flutter/material.dart';
import '../../widgets/interest_button.dart';
import 'package:provider/provider.dart';
import '../../api_calls/data.dart';
import '../../widgets/rounded_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditInterestAfterOccupation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Provider.of<Data>(context, listen: false)
            .backPressedOnInterestEdit(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Tap to select and long press to delete:',
            maxLines: 2,
            style: TextStyle(
              color: Color(0xFFEB1555),
              fontSize: 22.sp,
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Flexible(
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 150.w / 100.h,
                  ),
                  itemBuilder: (context, index) {
                    final interest =
                        Provider.of<Data>(context).generatedInterests[index];
                    return InterestButton(
                      isSelected: Provider.of<Data>(context, listen: false)
                          .checkUserInterest(interest.textOfButton),
                      textOfWidget: interest.textOfButton,
                      onPressedInterestButton: () {
                        Provider.of<Data>(context, listen: false)
                            .changeColorInterest(interest);
                        if (Provider.of<Data>(context, listen: false)
                                .generatedInterestsText
                                .contains(interest.textOfButton) ==
                            false) {
                          Provider.of<Data>(context, listen: false)
                              .generatedInterestsText
                              .add(interest.textOfButton);
                        }
                      },
                      onLongTap: () {
                        Provider.of<Data>(context, listen: false)
                            .deleteColorInterest(interest);
                        Provider.of<Data>(context, listen: false)
                            .generatedInterestsText
                            .remove(interest.textOfButton);
                      },
                    );
                  },
                  itemCount:
                      Provider.of<Data>(context).generatedInterests.length),
            ),
            RoundedButton(
              colorOfButton: Color(0xFFEB1555),
              onPressedRoundButton: () async {
                Provider.of<Data>(context, listen: false).changeIndicator();
                await Provider.of<Data>(context, listen: false).updateToggle(
                    Provider.of<Data>(context, listen: false)
                        .generatedInterestsText);

                await Provider.of<Data>(context, listen: false)
                    .interestSave(context);
                Provider.of<Data>(context, listen: false).changeIndicator();
                Provider.of<Data>(context, listen: false)
                    .generatedInterests
                    .clear();
              },
              textOfButton: 'Save',
            )
          ],
        ),
      ),
    );
  }
}
