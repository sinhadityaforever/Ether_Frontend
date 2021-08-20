import 'package:flutter/material.dart';
import 'package:frontend/models/screening.dart';
import 'package:frontend/widgets/popup_screen.dart';
import 'package:frontend/widgets/screen_button.dart';
import 'package:provider/provider.dart';
import '../../api_calls/data.dart';
import '../../widgets/rounded_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OccupationEdit extends StatelessWidget {
  final List<ScreeningModel> choosedScreens = [];
  final List<String> choosedScreenTexts = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'What are you upto? choose just two',
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
                  final screen = Provider.of<Data>(
                    context,
                  ).screens[index];

                  return ScreenButton(
                    isSelected: Provider.of<Data>(context, listen: false)
                        .occupationCheck(screen.textOfButton),
                    iconOfWidget: screen.iconFromModel,
                    textOfWidget: screen.textOfButton,
                    onLongTap: () {
                      Provider.of<Data>(context, listen: false)
                          .userOccupation
                          .remove(screen.textOfButton);
                      choosedScreenTexts.remove(screen.textOfButton);
                      Provider.of<Data>(context, listen: false)
                          .deleteScreen(screen);
                    },
                    onPressedInterestButton: () {
                      if (Provider.of<Data>(context, listen: false)
                              .userOccupation
                              .length >
                          1) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => Popup(
                            popupTitle: "Multi tasking is injurious to health",
                            popuptext: "Just select 2 of them and peace out",
                          ),
                        );
                      } else {
                        Provider.of<Data>(context, listen: false)
                            .changeColorScreen(screen);

                        if (Provider.of<Data>(context, listen: false)
                                .userOccupation
                                .contains(screen.textOfButton) ==
                            false) {
                          Provider.of<Data>(context, listen: false)
                              .userOccupation
                              .add(screen.textOfButton);
                        }
                      }
                    },
                  );
                },
                itemCount:
                    Provider.of<Data>(context, listen: false).screens.length,
              ),
            ),
            RoundedButton(
              colorOfButton: Color(0xFFEB1555),
              onPressedRoundButton: () async {
                Provider.of<Data>(context, listen: false)
                    .generateListromOccupation();
                Provider.of<Data>(context, listen: false)
                    .generateInterestText();
                await Provider.of<Data>(context, listen: false).addScreen(
                    Provider.of<Data>(context, listen: false).userOccupation);

                Navigator.pushNamed(context, '/editInterest');
              },
              textOfButton: 'Next',
            )
          ],
        ),
      ),
    );
  }
}
