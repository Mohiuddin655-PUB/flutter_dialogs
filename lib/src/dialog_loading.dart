part of 'dialogs.dart';

typedef OnLoadingProgressBuilder = Widget Function(
  BuildContext context,
  double value,
);

class LoadingDialogConfig extends DialogConfig {
  final ValueNotifier<double>? progress;
  final String progressPrefix;
  final TextStyle? progressStyle;
  final OnLoadingProgressBuilder? progressBuilder;

  const LoadingDialogConfig({
    this.progress,
    this.progressPrefix = "LOADING...",
    this.progressBuilder,
    this.progressStyle,
  });

  LoadingDialogConfig copy({
    ValueNotifier<double>? progress,
    String? progressPrefix,
    TextStyle? progressStyle,
    OnLoadingProgressBuilder? progressBuilder,
  }) {
    return LoadingDialogConfig(
      progress: progress ?? this.progress,
      progressPrefix: progressPrefix ?? this.progressPrefix,
      progressStyle: progressStyle ?? this.progressStyle,
      progressBuilder: progressBuilder ?? this.progressBuilder,
    );
  }
}

class _LoadingDialog extends StatelessWidget {
  final LoadingDialogConfig config;

  const _LoadingDialog({
    super.key,
    required this.config,
  });

  Widget _loader(BuildContext context) {
    return const Material(
      color: Colors.transparent,
      child: SizedBox(
        width: 60,
        height: 60,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeAlign: BorderSide.strokeAlignInside,
          strokeCap: StrokeCap.round,
        ),
      ),
    );
  }

  Widget _progress(BuildContext context) {
    return Positioned(
      bottom: 24,
      left: 0,
      right: 0,
      child: ListenableBuilder(
        listenable: config.progress!,
        builder: (context, child) {
          final value = config.progress!.value;
          if (value > 0 && value < 100) {
            if (config.progressBuilder != null) {
              return config.progressBuilder!(context, value);
            } else {
              return Text(
                "${config.progressPrefix}$value",
                textAlign: TextAlign.center,
                style: config.progressStyle,
              );
            }
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: SizedBox(
          width: 250,
          height: 250,
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              _loader(context),
              if (config.progress != null) _progress(context),
            ],
          ),
        ),
      ),
    );
  }
}
