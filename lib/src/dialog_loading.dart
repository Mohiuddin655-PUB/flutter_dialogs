part of 'dialogs.dart';

typedef OnLoadingProgressBuilder = Widget Function(
  BuildContext context,
  double value,
);

class LoadingDialogConfig extends DialogConfig {
  const LoadingDialogConfig();
}

class _LoadingDialog extends StatelessWidget {
  final LoadingDialogConfig config;

  const _LoadingDialog({
    super.key,
    required this.config,
  });

  Widget _loader(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          width: 3.5,
        ),
      ),
      child: const FittedBox(
        child: CircularProgressIndicator(
          strokeCap: StrokeCap.round,
          strokeWidth: 3.5,
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 10,
        sigmaY: 10,
      ),
      child: Center(
        child: Container(
          width: 160,
          height: 160,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).dialogBackgroundColor,
            borderRadius: BorderRadius.circular(32),
          ),
          child: _loader(context),
        ),
      ),
    );
  }
}
