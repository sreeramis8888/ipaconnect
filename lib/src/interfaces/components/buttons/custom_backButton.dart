import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';

class PrimaryBackButton extends StatelessWidget {
  const PrimaryBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            const Color.fromARGB(255, 1, 17, 36),
            kCardBackgroundColor
          ], stops: [
            0.1,
            .5
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          border: Border.all(color: kStrokeColor),
          borderRadius: BorderRadius.circular(30)),
      child: InkWell(
        onTap: () => Navigator.pop(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Transform.translate(
            offset: Offset(4, 0),
            child: SvgPicture.asset(
              'assets/svg/icons/arrow_back_ios.svg',
              color: Color(0xFFAEB9E1),
            ),
          ),
        ),
      ),
    );
  }
}
