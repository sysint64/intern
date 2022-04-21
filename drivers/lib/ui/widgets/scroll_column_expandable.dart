import 'package:flutter/material.dart';

/// Original solution: https://stackoverflow.com/a/56327933/4626918
class ScrollColumnExpandableWidget extends StatelessWidget {
  final List<Widget>? children;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final VerticalDirection verticalDirection;
  final TextDirection? textDirection;
  final TextBaseline? textBaseline;
  final EdgeInsetsGeometry padding;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final bool? primary;

  const ScrollColumnExpandableWidget({
    Key? key,
    this.children,
    CrossAxisAlignment? crossAxisAlignment,
    MainAxisAlignment? mainAxisAlignment,
    VerticalDirection? verticalDirection,
    EdgeInsetsGeometry? padding,
    this.textDirection,
    this.textBaseline,
    this.physics,
    this.controller,
    this.primary,
  })  : crossAxisAlignment = crossAxisAlignment ?? CrossAxisAlignment.center,
        mainAxisAlignment = mainAxisAlignment ?? MainAxisAlignment.start,
        verticalDirection = verticalDirection ?? VerticalDirection.down,
        padding = padding ?? EdgeInsets.zero,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[const SizedBox(width: double.infinity)];

    if (this.children != null) {
      children.addAll(this.children!);
    }

    return LayoutBuilder(
      builder: (context, constraint) {
        return SingleChildScrollView(
          controller: controller,
          physics: physics,
          padding: padding,
          primary: primary,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight - padding.vertical),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: crossAxisAlignment,
                mainAxisAlignment: mainAxisAlignment,
                mainAxisSize: MainAxisSize.max,
                verticalDirection: verticalDirection,
                textBaseline: textBaseline,
                textDirection: textDirection,
                children: children,
              ),
            ),
          ),
        );
      },
    );
  }
}
