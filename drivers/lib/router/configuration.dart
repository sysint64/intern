import 'package:drivers/validators/validators.dart';

import 'path.dart';

abstract class PathSegmentDescriptor {
  void read(PathReader pathReader);

  String show();
}

abstract class PathQueryDescriptor {
  void read(Map<String, String> queryParameters);

  String show();
}

class PathDeadEnd implements PathSegmentDescriptor {
  @override
  void read(PathReader pathReader) {
    pathReader.end();
  }

  @override
  String show() => '';
}

class PathStrConst implements PathSegmentDescriptor {
  final String name;

  PathStrConst(this.name);

  @override
  void read(PathReader pathReader) {
    pathReader.readName(name);
  }

  @override
  String show() => name;
}

class PathParameter<T> implements PathSegmentDescriptor {
  final Validator<String, T> validator;
  late T value;

  PathParameter(this.validator);

  @override
  void read(PathReader pathReader) {
    value = pathReader.readParameter(validator);
  }

  @override
  String show() => value.toString();
}

class QueryParameter<T> implements PathQueryDescriptor {
  final String name;
  final Validator<String?, T> validator;
  late T value;

  QueryParameter(this.name, this.validator);

  @override
  void read(Map<String, String> queryParameters) {
    final input = queryParameters[name] ?? '';
    value = validator.validate(input);
  }

  @override
  String show() => '$name=$value';
}

abstract class PathConfigurationParser {
  static void parse(
    PathReader pathReader,
    Iterable<PathSegmentDescriptor> location,
    Iterable<PathQueryDescriptor> queryParameters,
  ) {
    for (final locPart in location) {
      locPart.read(pathReader);
    }

    for (final param in queryParameters) {
      param.read(pathReader.uri.queryParameters);
    }
  }
}
