import 'package:flutter/material.dart';
import 'package:frontend/models/screening.dart';
import 'package:frontend/widgets/popup_screen.dart';
import 'package:frontend/widgets/screen_button.dart';
import 'package:provider/provider.dart';
import '../api_calls/data.dart';
import '../widgets/rounded_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EntryScreen extends StatelessWidget {
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
                    isSelected: screen.isSelected,
                    iconOfWidget: screen.iconFromModel,
                    textOfWidget: screen.textOfButton,
                    onLongTap: () {
                      choosedScreens.remove(screen);
                      choosedScreenTexts.remove(screen.textOfButton);
                      Provider.of<Data>(context, listen: false)
                          .deleteScreen(screen);
                      for (var i = 0;
                          i < screen.screenedInterests.length;
                          i++) {
                        Provider.of<Data>(context, listen: false)
                            .interests
                            .remove(screen.screenedInterests[i]);
                      }
                    },
                    onPressedInterestButton: () {
                      if (choosedScreens.length > 1) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => Popup(
                            popupTitle: "Multi tasking is injurious to health",
                            popuptext: "Just select 2 of them and peace out",
                          ),
                        );
                      } else {
                        choosedScreens.add(screen);
                        Provider.of<Data>(context, listen: false)
                            .changeColorScreen(screen);

                        for (var i = 0; i < choosedScreens.length; i++) {
                          if (choosedScreenTexts
                                  .contains(choosedScreens[i].textOfButton) ==
                              false) {
                            choosedScreenTexts
                                .add(choosedScreens[i].textOfButton);
                          }
                        }
                        for (var i = 0;
                            i < screen.screenedInterests.length;
                            i++) {
                          Provider.of<Data>(context, listen: false)
                              .interests
                              .add(screen.screenedInterests[i]);
                        }
                      }
                      // Provider.of<Data>(context, listen:false).interests.add(screen.screenedInterests)
                    },
                  );
                },
                itemCount:
                    Provider.of<Data>(context, listen: false).screens.length,
              ),
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
                    'Press to select long press to delete',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: Color(0xFFEB1555),
                    ),
                  ),
                ),
              ),
            ),
            RoundedButton(
              colorOfButton: Color(0xFFEB1555),
              onPressedRoundButton: () {
                Provider.of<Data>(context, listen: false)
                    .addScreen(choosedScreenTexts);
                Navigator.pushNamed(context, '/interests');
              },
              textOfButton: 'Next',
            ),
          ],
        ),
      ),
    );
  }
}
