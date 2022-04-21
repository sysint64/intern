import 'dart:async';

import 'package:drivers/exceptions.dart';
import 'package:drivers/validators/validators.dart';
import 'package:flutter/material.dart';

import 'configuration.dart';

abstract class RouterPathConfiguration<T> {
  Iterable<PathSegmentDescriptor> get location => const [];

  Iterable<PathQueryDescriptor> get queryParameters => const [];

  bool get skipOnPop => false;

  final _completer = Completer<T>();

  RouterPathConfiguration();

  Iterable<Page<dynamic>> generatePages(String pathId) =>
      throw UnsupportedError('Route has no pages');

  Future<T> waitResult() => _completer.future;

  T normalizeResult(dynamic result);

  void pushResult(T result) {
    _completer.complete(result);
  }

  String locationToString() => location.map((e) => e.show()).join('/');

  String queryParametersToString() => queryParameters.map((e) => e.show()).join('&');

  @override
  String toString() => '${locationToString()}?${queryParametersToString()}';

  bool get isEmpty => this is EmptyRoutePath;

  bool get isUnknown => this is UnknownRoutePath;
}

class RouterPath {
  final List<RouterPathConfiguration> segments;

  RouterPath(Iterable<RouterPathConfiguration> items) : segments = items.toList();

  RouterPath.empty() : segments = [];

  bool isUnknown() => segments.whereType<UnknownRoutePath>().isNotEmpty;

  static Uri joinWithUri(RouterPath path, Uri uri) {
    if (path.isUnknown()) {
      throw ValidationException.string('path is unknown');
    }

    if (path.location == '/') {
      return uri;
    }

    final pathUri = Uri.parse(path.location);
    final uriSegments = uri.pathSegments.join('/');
    final pathSegments = pathUri.pathSegments.join('/');
    final pathQS =
        pathUri.queryParameters.keys.map((key) => '$key=${pathUri.queryParameters[key]}').join('&');
    final uriQS =
        uri.queryParameters.keys.map((key) => '$key=${uri.queryParameters[key]}').join('&');

    final uriStr = StringBuffer();

    if (uri.hasAuthority) {
      uriStr.write(uri.authority);
      uriStr.write('://');
    }

    if (pathSegments.isNotEmpty && pathSegments != '/') {
      uriStr.write('/');
      uriStr.write(pathSegments);
    }

    if (uriSegments.isNotEmpty && uriSegments != '/') {
      uriStr.write('/');
      uriStr.write(uriSegments);
    }

    if (pathQS.isNotEmpty || uriQS.isNotEmpty) {
      uriStr.write('?');
    }

    if (pathQS.isNotEmpty) {
      uriStr.write(pathQS);
    }

    if (uriQS.isNotEmpty) {
      uriStr.write('&');
      uriStr.write(uriQS);
    }

    return Uri.parse(uriStr.toString());
  }

  String get location {
    final location = segments
        .map((segment) => segment.location)
        .expand((e) => e)
        .map((e) => e.show())
        .where((e) => e.isNotEmpty)
        .join('/');
    final queryParameters = segments
        .map((segment) => segment.queryParameters)
        .expand((e) => e)
        .map((e) => e.show())
        .where((e) => e.isNotEmpty)
        .join('&');

    if (queryParameters.isNotEmpty) {
      return '/$location?$queryParameters';
    } else {
      return '/$location';
    }
  }

  List<Page<dynamic>> generatePages() {
    final pages = <Page<dynamic>>[];
    var id = 'router-path:/';

    for (final segment in segments) {
      id += segment.locationToString();
      final queryParameters = segment.queryParametersToString();
      id += '?$queryParameters';
      pages.addAll(segment.generatePages(id));
    }

    return pages;
  }

  bool contains<T>() {
    return segments.whereType<T>().isNotEmpty;
  }

  bool containsAtLeastOne(Iterable<Type> types) =>
      segments.where((element) => types.contains(element.runtimeType)).isNotEmpty;

  @override
  String toString() {
    return location;
  }

  bool pop<T extends Object?>(T result) {
    if (segments.isEmpty) {
      return false;
    }

    final segment = segments.last;
    segment.pushResult(segment.normalizeResult(result));
    segments.removeLast();

    while (segments.isNotEmpty && segments.last.skipOnPop) {
      final segment = segments.last;
      segment.pushResult(segment.normalizeResult(result));
      segments.removeLast();
    }

    return true;
  }

  bool canPop() => segments.isNotEmpty;
}

class EmptyRoutePath extends RouterPathConfiguration<dynamic> {
  @override
  final Iterable<PathSegmentDescriptor> location = const [];

  EmptyRoutePath();

  @override
  dynamic normalizeResult(dynamic result) => null;
}

class UnknownRoutePath extends RouterPathConfiguration<dynamic> {
  @override
  final Iterable<PathSegmentDescriptor> location = const [];

  UnknownRoutePath();

  @override
  dynamic normalizeResult(dynamic result) => null;
}

class PathReader {
  final Uri uri;
  int _cursor;
  int _rightCursor;

  int get cursor => _cursor;

  PathReader._(this.uri, this._cursor, this._rightCursor);

  PathReader(this.uri, {bool hostAware = false})
      : _cursor = hostAware ? 0 : -1, // NOTE(sysint64): -1 means that we need read authority first.
        _rightCursor = uri.pathSegments.length;

  PathReader clone() => PathReader._(uri, _cursor, _rightCursor);

  bool get reachedEnd => _cursor >= _rightCursor;

  void setEndsAt(int newEnd) {
    _rightCursor = newEnd;
  }

  String readNextSegment() {
    if (_cursor == -1) {
      _cursor += 1;

      if (uri.authority.isNotEmpty) {
        return uri.authority;
      } else {
        return readNextSegment();
      }
    }

    if (_cursor >= _rightCursor) {
      throw ValidationException.string('no segments');
    } else {
      final segment = uri.pathSegments[_cursor];
      _cursor += 1;

      if (!reachedEnd && uri.pathSegments[_cursor].isEmpty) {
        _cursor += 1;
      }

      return segment;
    }
  }

  void readName(String name) {
    final segment = readNextSegment();
    if (segment != name) {
      throw ValidationException.string('$segment != $name');
    }
  }

  void end() {
    if (!reachedEnd) {
      throw ValidationException.string('not reached end');
    }
  }

  String createLocation() {
    return 'TODO';
  }

  R readParameter<R>(Validator<String, R> validator) {
    final segment = readNextSegment();
    return validator.validate(segment);
  }

  String readStringParameter() {
    return readNextSegment();
  }
}

abstract class RouterPathFactory {
  static Iterable<RouterPathConfiguration> any(
    PathReader pathReader, {
    required Iterable<RouterPathConfiguration Function(PathReader)> children,
  }) {
    final stackPathReader = pathReader.clone();
    final segments = <RouterPathConfiguration>[];

    while (!stackPathReader.reachedEnd) {
      for (final pathParser in children) {
        try {
          final path = pathParser(stackPathReader.clone());
          pathReader.setEndsAt(stackPathReader.cursor);
          segments.add(path);
        } on ValidationException catch (_) {
          continue;
        }
      }

      if (!stackPathReader.reachedEnd) {
        try {
          stackPathReader.readNextSegment();
        } on ValidationException catch (_) {
          continue;
        }
      }
    }

    return segments;
  }

  static Iterable<RouterPathConfiguration> stack(
    PathReader pathReader, {
    required Iterable<RouterPathConfiguration> Function(PathReader) root,
    required Iterable<Iterable<RouterPathConfiguration> Function(PathReader)> children,
  }) {
    final stackPathReader = pathReader.clone();

    while (!stackPathReader.reachedEnd) {
      for (final pathParser in children) {
        try {
          final path = pathParser(stackPathReader.clone());
          pathReader.setEndsAt(stackPathReader.cursor);
          return [...root(pathReader), ...path];
        } on ValidationException catch (_) {
          continue;
        }
      }

      if (!stackPathReader.reachedEnd) {
        try {
          stackPathReader.readNextSegment();
        } on ValidationException catch (_) {
          continue;
        }
      }
    }

    return root(pathReader);
  }

  static Iterable<RouterPathConfiguration> category(
    PathReader pathReader, {
    required Iterable<Iterable<RouterPathConfiguration> Function(PathReader pathReader)> children,
    RouterPathConfiguration Function()? unknownPath,
    RouterPathConfiguration? home,
  }) {
    if (pathReader.reachedEnd) {
      if (unknownPath != null) {
        return home != null ? [home] : [unknownPath()];
      } else {
        return home != null ? [home] : throw ValidationException.string('Failed find category');
      }
    }

    for (final pathParser in children) {
      try {
        final path = pathParser(pathReader.clone());
        return [if (home != null) home, ...path];
      } on ValidationException catch (_) {
        continue;
      }
    }

    if (unknownPath != null) {
      return [unknownPath()];
    } else {
      throw ValidationException.string('Failed find category');
    }
  }
}
