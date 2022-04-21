/// Widgets to help build UI Kit browser pages.

import 'package:flutter/material.dart';

/// Button with right arrow to navigate between different pages.
class UIKitNavigatorButton extends StatelessWidget {
  /// Button title.
  final String text;

  /// On tap button callback.
  final VoidCallback onTap;

  /// Whether to draw a top border.
  final bool drawTopBorder;

  /// Wheter to draw a bottom border.
  final bool drawBottomBorder;

  /// Create widget.
  const UIKitNavigatorButton(
    this.text, {
    Key? key,
    required this.onTap,
    this.drawTopBorder = false,
    this.drawBottomBorder = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          if (drawTopBorder)
            Container(
              width: double.infinity,
              color: Theme.of(context).dividerColor,
              height: 1,
            ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                Expanded(child: Text(text)),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
          if (drawBottomBorder)
            Container(
              width: double.infinity,
              color: Theme.of(context).dividerColor,
              height: 1,
            ),
        ],
      ),
    );
  }
}

/// Gather widgets into a group with a label.
class UIKitGroup extends StatelessWidget {
  /// Top label of the group.
  final String label;

  /// Group content, if null, the [children] field is used.
  final Widget? child;

  /// Group content, arranged as a column, if null, the [child] field is used.
  final List<Widget>? children;

  /// Create widget
  const UIKitGroup(this.label, {Key? key, this.child, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return UIKitRoom(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(4),
                topLeft: Radius.circular(4),
              ),
            ),
            child: Text(
              label,
              style: TextStyle(color: theme.colorScheme.onPrimary),
            ),
          ),
          Container(
            width: double.infinity,
            color: theme.colorScheme.primary,
            height: 2,
          ),
          if (child != null) const SizedBox(height: 8),
          if (child != null) child!,
          if (children != null) const SizedBox(height: 8),
          if (children != null) ...children!,
        ],
      ),
    );
  }
}

/// Additional space aroudn the.
class UIKitRoom extends StatelessWidget {
  /// Widget content.
  final Widget child;

  /// Create widget.
  const UIKitRoom({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      child: child,
    );
  }
}

/// Widget that shows additional information about widget like type and
/// description with information about how to use it.
class UIKitDescribe extends StatelessWidget {
  /// Description with information about how to use the widget.
  final String? description;

  /// Widget content.
  final Widget child;

  /// Create widget.
  const UIKitDescribe({
    Key? key,
    required this.child,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDescribeDialog(
        context,
        title: child.runtimeType.toString(),
        description: description,
      ),
      child: child,
    );
  }
}

Future<void> _showDescribeDialog(
  BuildContext context, {
  required String title,
  String? description,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(description ?? ''),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
