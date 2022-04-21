import 'package:common_device_services/copy_service.dart';
import 'package:common_ui_services/material/material_snackbar_notifications_service.dart';
import 'package:debug_services/widgets.dart';
import 'package:drivers/dependencies.dart';
import 'package:drivers/ui/lifecycle_aware_widget_mixin.dart';
import 'package:error_services/app_error.dart';
import 'package:flutter/material.dart';

class ErrorDetailsPage extends StatefulWidget {
  static Route<void> route(AppError error) => MaterialPageRoute<void>(
        builder: (_) => ErrorDetailsPage(error),
      );

  final AppError error;

  const ErrorDetailsPage(this.error, {Key? key}) : super(key: key);

  @override
  State<ErrorDetailsPage> createState() => _ErrorDetailsPageState();
}

class _ErrorDetailsPageState extends LifecycleAwareWidgetState<ErrorDetailsPage> {
  late final _copyService = resolveLifecycleDependency<CopyService>().attach(this);
  late final _notificationsServices = MaterialSnackbarNotificationsService.attach(this);

  @override
  Widget build(BuildContext context) {
    return DebugServicesThemeWidget(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Error details'),
          actions: [
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () {
                _copyService.copy(widget.error.getReportWithStackTrace());
                _notificationsServices.show('Copied');
              },
            ),
          ],
        ),
        body: _Body(widget.error),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final AppError error;

  const _Body(this.error, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(error.getReport()),
            ),
            if (error.stackTrace != null)
              _Spoiler(
                showTitle: 'Show stack trace',
                hideTitle: 'Hide stack trace',
                child: Text(error.stackTrace.toString()),
              ),
          ],
        ),
      ),
    );
  }
}

class _Spoiler extends StatefulWidget {
  final String showTitle;
  final String hideTitle;
  final Widget child;

  const _Spoiler({
    required this.child,
    required this.showTitle,
    required this.hideTitle,
    Key? key,
  }) : super(key: key);

  @override
  _SpoilerState createState() => _SpoilerState();
}

class _SpoilerState extends State<_Spoiler> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _isVisible = !_isVisible;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isVisible ? widget.hideTitle : widget.showTitle,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (_isVisible)
          Padding(
            padding: const EdgeInsets.all(16),
            child: widget.child,
          ),
      ],
    );
  }
}
