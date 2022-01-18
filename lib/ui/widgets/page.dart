part of '../widgets.dart';

class AppPage<S extends PageState, B extends PageBloc<dynamic, S>> extends StatefulWidget {
  final Widget child;
  final void Function(BuildContext context, S state)? onState;
  final void Function(BuildContext context)? onResume;

  const AppPage({
    required this.child,
    this.onState,
    this.onResume,
    Key? key,
  }) : super(key: key);

  @override
  State createState() => _AppPageState<S, B>();
}

class _AppPageState<S extends PageState, B extends PageBloc<dynamic, S>>
    extends LifecycleAwareState<AppPage<S, B>> {
  StreamSubscription<S>? _subscription;
  // final _key = ErrorHandlerKey();
  // final _errorService = resolveDependency<ErrorsService>();
  // late final ErrorsNotifications _errorsNotifications;
  late LifecycleObserver _lifecycleObserver;

  @override
  void initState() {
    super.initState();

    // _errorsNotifications =
    //     resolveLifecycleDependency<ErrorsNotifications>().attach(this);
    _lifecycleObserver = LifecycleObserver(
      onResume: () async {
        widget.onResume?.call(context);
      },
    );
    WidgetsBinding.instance?.addObserver(_lifecycleObserver);

    // _errorService.registerErrorHandler(
    //   _key,
    //   (e, stackTrace) {
    //     BlocProvider.of<AppBloc>(context).add(OnError(e, stackTrace));

    //     if (e is LogicException) {
    //       _errorsNotifications.showError(AppError(e, stackTrace));
    //     } else {
    //       _errorsNotifications.showError(AppError(e, stackTrace));
    //       _errorsReporter.reportError(e, stackTrace);
    //     }

    //     return false;
    //   },
    // );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final bloc = BlocProvider.of<B>(context);
    _subscription = bloc.stream.listen((state) async {
      if (mounted) {
        widget.onState?.call(context, state);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(_lifecycleObserver);
    _subscription?.cancel();
    // _errorService.unregisterErrorHandler(_key);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class LifecycleObserver extends WidgetsBindingObserver {
  final AsyncCallback? onResume;
  final AsyncCallback? suspendingCallBack;

  LifecycleObserver({
    this.onResume,
    this.suspendingCallBack,
  });

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        await onResume?.call();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        await suspendingCallBack?.call();
        break;
    }
  }
}
