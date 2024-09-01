import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AndrossyFancySnackBar extends StatefulWidget {
  final double animationDuration;
  final double reverseAnimationDuration;
  final double duration;
  final Widget? title;
  final String? titleText;
  final AndrossyFancySnackBarType type;
  final Widget? message;
  final String? messageText;
  final Color? color;

  const AndrossyFancySnackBar({
    super.key,
    this.animationDuration = 0.3,
    this.reverseAnimationDuration = 0.3,
    this.titleText,
    this.title,
    this.messageText,
    this.message,
    this.duration = 3,
    this.type = AndrossyFancySnackBarType.success,
    this.color,
  });

  static show(
    BuildContext context, {
    double duration = 3,
    VoidCallback? onCloseEvent,
    Color? color,
    double animationDuration = 0.3,
    double reverseAnimationDuration = 0.3,
    String? titleText,
    Widget? title,
    AndrossyFancySnackBarType type = AndrossyFancySnackBarType.success,
    String? messageText,
    Widget? message,
  }) async {
    OverlayEntry d = OverlayEntry(
      builder: (context) {
        return AndrossyFancySnackBar(
          duration: duration,
          animationDuration: animationDuration,
          reverseAnimationDuration: reverseAnimationDuration,
          title: title,
          titleText: titleText,
          messageText: messageText,
          message: message,
          type: type,
          color: color,
        );
      },
    );
    Overlay.of(context).insert(d);
    await Future.delayed(Duration(milliseconds: (duration * 1000).toInt()));
    if (d.mounted) d.remove();
    if (onCloseEvent != null) onCloseEvent();
  }

  @override
  State<AndrossyFancySnackBar> createState() => _AndrossyFancySnackBarState();
}

class _AndrossyFancySnackBarState extends State<AndrossyFancySnackBar>
    with TickerProviderStateMixin {
  late AnimationController _bubbleAnimationController;
  late Animation _bubbleAnimation;

  @override
  void initState() {
    super.initState();
    _bubbleAnimationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: (widget.animationDuration * 1000).toInt(),
      ),
      reverseDuration: Duration(
        milliseconds: (widget.animationDuration * 1000).toInt(),
      ),
    );

    _bubbleAnimation = Tween<double>(begin: -0.2, end: -0.6).animate(
      CurvedAnimation(
        parent: _bubbleAnimationController,
        curve: Curves.bounceInOut,
      ),
    );

    _bubbleAnimationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _bubbleAnimationController.dispose();
    super.dispose();
  }

  Color dx(double percentage) {
    assert(percentage >= 0 && percentage <= 100);
    final x = (percentage / 100 * 255).round();
    final base = widget.color ?? widget.type.color;
    int r = base.red - x;
    int g = base.green - x;
    int b = base.blue - x;
    if (r < 0) r = 0;
    if (g < 0) g = 0;
    if (b < 0) b = 0;
    return Color.fromARGB(base.alpha, r, g, b);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width - 20,
                decoration: BoxDecoration(
                  color: (widget.color ?? widget.type.color),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: -10,
                      left: -2,
                      child: CustomPaint(
                        size: const Size(50, 50),
                        painter: _BackShape(
                          color: dx(10),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 50),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                widget.title ??
                                    Text(
                                      widget.titleText ?? widget.type.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 24,
                                      ),
                                    ),
                                const SizedBox(height: 5),
                                widget.message ??
                                    Text(
                                      widget.messageText ?? widget.type.message,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                      ),
                                    ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _bubbleAnimation,
              builder: (context, child) {
                return Positioned(
                  top: -(_bubbleAnimation.value * 10) - 20,
                  left: 20,
                  child: Transform(
                    transform: Matrix4.rotationZ(_bubbleAnimation.value),
                    alignment: Alignment.center,
                    child: CustomPaint(
                      painter: _BubblePainter(
                        color: dx(10),
                      ),
                      child: Container(
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        child: Icon(
                          widget.type.icon,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _BubblePainter extends CustomPainter {
  final Color color;

  _BubblePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.5000029, size.height * 0.9031579);
    path_0.cubicTo(
        size.width * 0.7707800,
        size.height * 0.9031579,
        size.width * 0.9902886,
        size.height * 0.7009789,
        size.width * 0.9902886,
        size.height * 0.4515789);
    path_0.cubicTo(size.width * 0.9902886, size.height * 0.2021789,
        size.width * 0.7707800, 0, size.width * 0.5000029, 0);
    path_0.cubicTo(
        size.width * 0.2292257,
        0,
        size.width * 0.009716800,
        size.height * 0.2021789,
        size.width * 0.009716800,
        size.height * 0.4515789);
    path_0.cubicTo(
        size.width * 0.009716800,
        size.height * 0.5920079,
        size.width * 0.07931071,
        size.height * 0.7174658,
        size.width * 0.1884643,
        size.height * 0.8002895);
    path_0.cubicTo(
        size.width * 0.1886386,
        size.height * 0.8004211,
        size.width * 0.1884843,
        size.height * 0.8006776,
        size.width * 0.1882700,
        size.height * 0.8006105);
    path_0.lineTo(size.width * 0.1882700, size.height * 0.8006105);
    path_0.cubicTo(
        size.width * 0.1881400,
        size.height * 0.8005697,
        size.width * 0.1880029,
        size.height * 0.8006592,
        size.width * 0.1880029,
        size.height * 0.8007868);
    path_0.lineTo(size.width * 0.1880029, size.height * 0.9408447);
    path_0.cubicTo(
        size.width * 0.1880029,
        size.height * 0.9800447,
        size.width * 0.2328629,
        size.height * 1.005488,
        size.width * 0.2708671,
        size.height * 0.9878421);
    path_0.lineTo(size.width * 0.4424600, size.height * 0.9081737);
    path_0.cubicTo(
        size.width * 0.4519371,
        size.height * 0.9037724,
        size.width * 0.4625543,
        size.height * 0.9019658,
        size.width * 0.4731529,
        size.height * 0.9024921);
    path_0.cubicTo(
        size.width * 0.4820429,
        size.height * 0.9029342,
        size.width * 0.4909943,
        size.height * 0.9031579,
        size.width * 0.5000029,
        size.height * 0.9031579);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = color;
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _BackShape extends CustomPainter {
  final Color color;

  _BackShape({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = color;
    canvas.drawCircle(Offset(size.width * 0.8609272, size.height * 0.05365854),
        size.width * 0.07284768, paint0Fill);

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = color;
    canvas.drawCircle(Offset(size.width * 0.7298344, size.height * 0.2103351),
        size.width * 0.02754927, paint1Fill);

    Paint paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.color = color;
    canvas.drawCircle(Offset(size.width * 0.3906755, size.height * 0.03304044),
        size.width * 0.01836616, paint2Fill);

    Path path_3 = Path();
    path_3.moveTo(size.width * 0.8335828, size.height * 0.3567707);
    path_3.cubicTo(
        size.width * 1.039278,
        size.height * 0.4924732,
        size.width * 1.056682,
        size.height * 0.7253073,
        size.width * 0.8724503,
        size.height * 0.8768244);
    path_3.cubicTo(
        size.width * 0.6882185,
        size.height * 1.028337,
        size.width * 0.3721185,
        size.height * 1.041156,
        size.width * 0.1664199,
        size.height * 0.9054537);
    path_3.cubicTo(
        size.width * -0.03927907,
        size.height * 0.7697512,
        size.width * -0.05668199,
        size.height * 0.5369171,
        size.width * 0.1275490,
        size.height * 0.3854020);
    path_3.cubicTo(
        size.width * 0.2159106,
        size.height * 0.3127327,
        size.width * 0.3346060,
        size.height * 0.2719678,
        size.width * 0.4569073,
        size.height * 0.2641922);
    path_3.cubicTo(
        size.width * 0.4853722,
        size.height * 0.2623829,
        size.width * 0.5088384,
        size.height * 0.2455971,
        size.width * 0.5087841,
        size.height * 0.2245522);
    path_3.lineTo(size.width * 0.5087629, size.height * 0.2163015);
    path_3.cubicTo(
        size.width * 0.5087364,
        size.height * 0.2062137,
        size.width * 0.4999728,
        size.height * 0.1975049,
        size.width * 0.4896424,
        size.height * 0.1908824);
    path_3.cubicTo(
        size.width * 0.4599689,
        size.height * 0.1718595,
        size.width * 0.4568497,
        size.height * 0.1387195,
        size.width * 0.4826748,
        size.height * 0.1168624);
    path_3.cubicTo(
        size.width * 0.5085007,
        size.height * 0.09500537,
        size.width * 0.5534914,
        size.height * 0.09270780,
        size.width * 0.5831649,
        size.height * 0.1117302);
    path_3.cubicTo(
        size.width * 0.6128391,
        size.height * 0.1307532,
        size.width * 0.6159583,
        size.height * 0.1638927,
        size.width * 0.5901325,
        size.height * 0.1857498);
    path_3.cubicTo(
        size.width * 0.5879331,
        size.height * 0.1876112,
        size.width * 0.5855947,
        size.height * 0.1893312,
        size.width * 0.5831391,
        size.height * 0.1909078);
    path_3.cubicTo(
        size.width * 0.5655967,
        size.height * 0.2021683,
        size.width * 0.5468470,
        size.height * 0.2159220,
        size.width * 0.5468914,
        size.height * 0.2330615);
    path_3.cubicTo(
        size.width * 0.5469371,
        size.height * 0.2508473,
        size.width * 0.5653881,
        size.height * 0.2655180,
        size.width * 0.5891517,
        size.height * 0.2686722);
    path_3.cubicTo(
        size.width * 0.6771854,
        size.height * 0.2803576,
        size.width * 0.7620596,
        size.height * 0.3095859,
        size.width * 0.8335828,
        size.height * 0.3567707);
    path_3.close();

    Paint paint3Fill = Paint()..style = PaintingStyle.fill;
    paint3Fill.color = color;
    canvas.drawPath(path_3, paint3Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

enum AndrossyFancySnackBarType {
  success(
    title: "Well done!",
    message: "You successfully read this important message.",
    icon: Icons.check,
    color: Color(0xFF09653F),
  ),
  error(
    title: "Oh snap!",
    message: "Change a few things up and try submitting again.",
    icon: CupertinoIcons.clear,
    color: Color(0xffc72c41),
  ),
  info(
    title: "Hi there!",
    message: "Do you have a problem? Just use the contact form.",
    icon: CupertinoIcons.question,
    color: Color(0xFF6353C7),
  ),
  warning(
    title: "Warning!",
    message: "Sorry! There was a problem with your request.",
    icon: CupertinoIcons.exclamationmark,
    color: Color(0xFFA75F40),
  ),
  waiting(
    title: "Waiting!",
    message: "Please wait for a moment while fetching data.",
    icon: CupertinoIcons.clock,
    color: Color(0xFF0B5778),
  );

  final String title;
  final String message;
  final IconData icon;
  final Color color;

  const AndrossyFancySnackBarType({
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
  });
}
