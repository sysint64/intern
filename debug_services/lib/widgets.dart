import 'package:common_device_services/copy_service.dart';
import 'package:common_ui_services/material/material_snackbar_notifications_service.dart';
import 'package:debug_services/ui_services/debug_float_panel.dart';
import 'package:drivers/dependencies.dart';
import 'package:drivers/ui/lifecycle_aware_widget_mixin.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class DebugServicesThemeWidget extends StatelessWidget {
  final Widget child;

  const DebugServicesThemeWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.orange,
          brightness: Brightness.light,
        ),
      ),
      child: child,
    );
  }
}

class DebugServicesProvider extends StatelessWidget {
  final Widget child;
  final bool isEnabled;

  const DebugServicesProvider({
    Key? key,
    this.isEnabled = true,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: _DebugServicesProviderInner(
        isEnabled: isEnabled,
        child: child,
      ),
    );
  }
}

class _DebugServicesProviderInner extends StatefulWidget {
  final Widget child;
  final bool isEnabled;

  const _DebugServicesProviderInner({
    Key? key,
    required this.child,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  State<_DebugServicesProviderInner> createState() => _DebugServicesProviderInnerState();
}

class _DebugServicesProviderInnerState
    extends LifecycleAwareWidgetState<_DebugServicesProviderInner> {
  late DebugFloatPanelService _debugMenuService;

  @override
  void didChangeDependencies() {
    _debugMenuService = resolveLifecycleDependency<DebugFloatPanelService>().attach(this);

    WidgetsBinding.instance?.addPostFrameCallback(
      (_) {
        if (mounted) {
          _debugMenuService.setEnabled(widget.isEnabled);
          if (widget.isEnabled) {
            _debugMenuService.showDebugPanel();
          }
        }
      },
    );

    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant _DebugServicesProviderInner oldWidget) {
    WidgetsBinding.instance?.addPostFrameCallback(
      (_) {
        if (mounted) {
          _debugMenuService.setEnabled(widget.isEnabled);
        }
      },
    );

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class DebugServicePanelWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final VoidCallback onFlip;

  const DebugServicePanelWidget({Key? key, required this.onPressed, required this.onFlip})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: onFlip,
          child: Container(
            height: 32,
            width: 32,
            color: Colors.deepOrangeAccent,
            child: const Center(
              child: Icon(
                Icons.flip,
                size: 24,
                color: Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: onPressed,
          child: Container(
            height: 100,
            width: 32,
            color: Colors.deepOrangeAccent,
            child: const Center(
              child: Icon(
                Icons.bug_report,
                size: 24,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DebugServicesSectionTitleWidget extends StatelessWidget {
  final String title;

  const DebugServicesSectionTitleWidget(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(title, style: theme.textTheme.headline6),
    );
  }
}

class DebugServicesInfoEntryWidget extends StatefulWidget {
  final String title;
  final String value;
  final VoidCallback? onTap;

  const DebugServicesInfoEntryWidget({
    Key? key,
    required this.title,
    required this.value,
    this.onTap,
  }) : super(key: key);

  @override
  State<DebugServicesInfoEntryWidget> createState() => _DebugServicesInfoEntryWidgetState();
}

class _DebugServicesInfoEntryWidgetState
    extends LifecycleAwareWidgetState<DebugServicesInfoEntryWidget> {
  late final _copyService = resolveLifecycleDependency<CopyService>().attach(this);
  late final _notificationsServices = MaterialSnackbarNotificationsService.attach(this);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: widget.onTap ??
          () {
            _copyService.copy(widget.value);
            _notificationsServices.show('Copied');
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
              Text(widget.title, style: theme.textTheme.subtitle1),
              Text(
                widget.value.toString(),
                style: theme.textTheme.subtitle2!.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DebugServicesStackedSwitchWidget extends StatefulWidget {
  final Widget? icon;
  final bool isChecked;
  final bool isLoading;
  final String title;
  final ValueChanged<bool>? onChanged;

  const DebugServicesStackedSwitchWidget({
    required this.isChecked,
    required this.title,
    required this.onChanged,
    this.icon,
    this.isLoading = false,
    Key? key,
  }) : super(key: key);

  @override
  _DebugServicesStackedSwitchWidgetState createState() => _DebugServicesStackedSwitchWidgetState();
}

class _DebugServicesStackedSwitchWidgetState extends State<DebugServicesStackedSwitchWidget> {
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.isChecked;
  }

  @override
  void didUpdateWidget(DebugServicesStackedSwitchWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _isChecked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        setState(() {
          widget.onChanged?.call(_isChecked);
        });
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 12, 4),
        child: Row(
          children: [
            if (widget.icon != null) widget.icon!,
            if (widget.icon != null) const SizedBox(width: 16),
            Expanded(
              child: Text(widget.title, style: theme.textTheme.headline4),
            ),
            if (widget.isLoading)
              const Padding(
                padding: EdgeInsets.only(right: 18, top: 12, bottom: 12),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
              ),
            if (!widget.isLoading) Switch(value: _isChecked, onChanged: widget.onChanged),
          ],
        ),
      ),
    );
  }
}

class DebugServicesNavigatorButtonWidget extends StatelessWidget {
  final Widget? icon;
  final String title;
  final String? subTitle;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final bool autoFocus;
  final bool isLoading;

  const DebugServicesNavigatorButtonWidget({
    required this.title,
    required this.onTap,
    this.icon,
    this.subTitle,
    this.focusNode,
    this.autoFocus = false,
    this.isLoading = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Focus(
      focusNode: focusNode,
      autofocus: autoFocus,
      child: InkWell(
        onTap: isLoading
            ? null
            : () {
                focusNode?.requestFocus();
                onTap?.call();
              },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: isLoading
              ? const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  ),
                )
              : Row(
                  children: <Widget>[
                    if (icon != null) icon!,
                    if (icon != null) const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(title, style: theme.textTheme.subtitle1),
                          if (subTitle != null)
                            Text(
                              subTitle!,
                              style: theme.textTheme.subtitle2!.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (onTap != null) Icon(Icons.chevron_right, color: theme.colorScheme.primary),
                  ],
                ),
        ),
      ),
    );
  }
}
