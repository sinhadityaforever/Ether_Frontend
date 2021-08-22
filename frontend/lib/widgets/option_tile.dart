import 'package:flutter/cupertino.dart';
import 'package:frontend/api_calls/data.dart';
import 'package:frontend/widgets/quiz_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OptionTile extends StatelessWidget {
  final String optionText;
  final int optionSerial;
  OptionTile({
    required this.optionText,
    required this.optionSerial,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      child: Row(
        children: [
          Text(optionText),
          SizedBox(width: 70.w),
          QuizButton(
            textOfButton: Provider.of<Data>(context, listen: false)
                .options[optionSerial]
                .option,
            isCorrect: Provider.of<Data>(context, listen: false)
                .options[optionSerial]
                .isAnswer,
          ),
        ],
      ),
    );
  }
}
