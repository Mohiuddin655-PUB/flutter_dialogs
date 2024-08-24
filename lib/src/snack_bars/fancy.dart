import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AndrossyFancySnackBar extends StatelessWidget {
  final String title;
  final String message;
  final Color? color;
  final AndrossyFancySnackBarContent contentType;
  final bool inMaterialBanner;
  final double? titleFontSize;
  final double? messageFontSize;

  const AndrossyFancySnackBar({
    super.key,
    this.color,
    this.titleFontSize,
    this.messageFontSize,
    required this.title,
    required this.message,
    this.contentType = AndrossyFancySnackBarContent.success,
    this.inMaterialBanner = false,
  });

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
    BuildContext context, {
    required String title,
    required String message,
    Color? color,
    AndrossyFancySnackBarContent contentType = AndrossyFancySnackBarContent.success,
    bool inMaterialBanner = false,
    double? titleFontSize,
    double? messageFontSize,
  }) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.transparent,
      content: AndrossyFancySnackBar(
        title: title,
        message: message,
        color: color,
        contentType: contentType,
        inMaterialBanner: inMaterialBanner,
        titleFontSize: titleFontSize,
        messageFontSize: messageFontSize,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    bool isRTL = Directionality.of(context) == TextDirection.rtl;

    final size = MediaQuery.of(context).size;

    // screen dimensions
    bool isMobile = size.width <= 768;
    bool isTablet = size.width > 768 && size.width <= 992;

    final hsl = HSLColor.fromColor(color ?? contentType.color!);
    final hslDark = hsl.withLightness((hsl.lightness - 0.1).clamp(0.0, 1.0));

    double horizontalPadding = 0.0;
    double leftSpace = size.width * 0.12;
    double rightSpace = size.width * 0.12;

    if (isMobile) {
      horizontalPadding = size.width * 0.01;
    } else if (isTablet) {
      leftSpace = size.width * 0.05;
      horizontalPadding = size.width * 0.2;
    } else {
      leftSpace = size.width * 0.05;
      horizontalPadding = size.width * 0.3;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      margin: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
      ),
      height: size.height * 0.125,
      alignment: Alignment.bottomCenter,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: size.width,
            decoration: BoxDecoration(
              color: color ?? contentType.color,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
              ),
              child: SvgPicture.asset(
                _Icons.bubbles,
                height: size.height * 0.06,
                width: size.width * 0.05,
                colorFilter: ColorFilter.mode(
                  hslDark.toColor(),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          Positioned(
            top: -size.height * 0.02,
            left: !isRTL
                ? leftSpace -
                    8 -
                    (isMobile ? size.width * 0.075 : size.width * 0.035)
                : null,
            right: isRTL
                ? rightSpace -
                    8 -
                    (isMobile ? size.width * 0.075 : size.width * 0.035)
                : null,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  _Icons.back,
                  height: size.height * 0.06,
                  colorFilter: ColorFilter.mode(
                    hslDark.toColor(),
                    BlendMode.srcIn,
                  ),
                ),
                Positioned(
                  top: size.height * 0.015,
                  child: SvgPicture.asset(
                    contentType.icon,
                    height: size.height * 0.022,
                  ),
                )
              ],
            ),
          ),
          Positioned.fill(
            left: isRTL ? size.width * 0.03 : leftSpace,
            right: isRTL ? rightSpace : size.width * 0.03,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: titleFontSize ??
                              (!isMobile
                                  ? size.height * 0.03
                                  : size.height * 0.025),
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (inMaterialBanner) {
                          ScaffoldMessenger.of(context)
                              .hideCurrentMaterialBanner();
                          return;
                        }
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      },
                      child: SvgPicture.asset(
                        _Icons.failure,
                        height: size.height * 0.022,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.005,
                ),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      fontSize: messageFontSize ?? size.height * 0.016,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.015,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class AndrossyFancySnackBarContent {
  final String icon;
  final String message;

  final Color? color;

  const AndrossyFancySnackBarContent(
    this.message,
    this.icon, [
    this.color,
  ]);

  static const AndrossyFancySnackBarContent help = AndrossyFancySnackBarContent(
    'help',
    _Icons.help,
    _Colors.helpBlue,
  );
  static const AndrossyFancySnackBarContent failure = AndrossyFancySnackBarContent(
    'failure',
    _Icons.failure,
    _Colors.failureRed,
  );
  static const AndrossyFancySnackBarContent success = AndrossyFancySnackBarContent(
    'success',
    _Icons.success,
    _Colors.successGreen,
  );
  static const AndrossyFancySnackBarContent warning = AndrossyFancySnackBarContent(
    'warning',
    _Icons.warning,
    _Colors.warningYellow,
  );
}

abstract class _Colors {
  static const Color helpBlue = Color(0xff3282B8);

  static const Color failureRed = Color(0xffc72c41);

  static const Color successGreen = Color(0xff2D6A4F);

  static const Color warningYellow = Color(0xffFCA652);
}

abstract class _Icons {
  static const String help = 'assets/help.svg';
  static const String failure = 'assets/failure.svg';
  static const String success = 'assets/success.svg';
  static const String warning = 'assets/warning.svg';

  static const String back = 'assets/back.svg';
  static const String bubbles = 'assets/bubbles.svg';
}
