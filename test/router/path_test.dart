import 'package:drivers/validators/validators.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drivers/router/path.dart';
import 'package:drivers/router/configuration.dart';

class ProfilePathConfiguration extends RouterPathConfiguration<void> {
  ProfilePathConfiguration();

  ProfilePathConfiguration.parse(PathReader pathReader) {
    PathConfigurationParser.parse(pathReader, location, queryParameters);
  }

  @override
  Iterable<PathSegmentDescriptor> get location => [PathStrConst('profile')];

  @override
  dynamic normalizeResult(dynamic result) => null;

  static Iterable<RouterPathConfiguration> config(PathReader pathReader) =>
      RouterPathFactory.category(
        pathReader,
        home: ProfilePathConfiguration.parse(pathReader),
        unknownPath: () => UnknownRoutePath(),
        children: [
          ProfileSettingsPathConfiguration.config,
        ],
      );
}

class ProfileSettingsPathConfiguration extends RouterPathConfiguration<void> {
  ProfileSettingsPathConfiguration();

  ProfileSettingsPathConfiguration.parse(PathReader pathReader) {
    PathConfigurationParser.parse(pathReader, location, queryParameters);
  }

  @override
  Iterable<PathSegmentDescriptor> get location => [PathStrConst('settings'), PathDeadEnd()];

  @override
  dynamic normalizeResult(dynamic result) => null;

  static List<RouterPathConfiguration> config(PathReader pathReader) =>
      [ProfileSettingsPathConfiguration.parse(pathReader)];
}

class ProductsPathConfiguration extends RouterPathConfiguration<void> {
  ProductsPathConfiguration();

  ProductsPathConfiguration.parse(PathReader pathReader) {
    PathConfigurationParser.parse(pathReader, location, queryParameters);
  }

  @override
  Iterable<PathSegmentDescriptor> get location => [PathStrConst('products')];

  @override
  dynamic normalizeResult(dynamic result) => null;

  static Iterable<RouterPathConfiguration> config(PathReader pathReader) {
    return RouterPathFactory.category(
      pathReader,
      home: ProductsPathConfiguration.parse(pathReader),
      children: [
        ProductDetailsRoutePath.config,
      ],
    );
  }
}

class ProductDetailsRoutePath extends RouterPathConfiguration<void> {
  final id = PathParameter<int>(StringIsIntValidator());

  ProductDetailsRoutePath(int id) {
    this.id.value = id;
  }

  ProductDetailsRoutePath.parse(PathReader pathReader) {
    PathConfigurationParser.parse(pathReader, location, queryParameters);
  }

  @override
  dynamic normalizeResult(dynamic result) => null;

  @override
  Iterable<PathSegmentDescriptor> get location => [PathStrConst('details'), id, PathDeadEnd()];

  static List<RouterPathConfiguration> config(PathReader pathReader) {
    return [ProductDetailsRoutePath.parse(pathReader)];
  }
}

class PopupRoutePath extends RouterPathConfiguration<void> {
  PopupRoutePath.parse(PathReader pathReader) {
    PathConfigurationParser.parse(pathReader, location, queryParameters);
  }

  @override
  Iterable<PathSegmentDescriptor> get location => [PathStrConst('popup')];

  @override
  bool get skipOnPop => true;

  @override
  dynamic normalizeResult(dynamic result) => null;

  static Iterable<RouterPathConfiguration> config(PathReader pathReader) {
    return [
      PopupRoutePath.parse(pathReader),
      ...RouterPathFactory.category(
        pathReader,
        children: [
          YesNoPopupRoutePath.config,
          OkPopupRoutePath.config,
        ],
      ),
    ];
  }
}

class YesNoPopupRoutePath extends RouterPathConfiguration<void> {
  YesNoPopupRoutePath.parse(PathReader pathReader) {
    PathConfigurationParser.parse(pathReader, location, queryParameters);
  }

  @override
  Iterable<PathSegmentDescriptor> get location => [PathStrConst('yes_no'), PathDeadEnd()];

  @override
  dynamic normalizeResult(dynamic result) => null;

  static List<RouterPathConfiguration> config(PathReader pathReader) {
    return [YesNoPopupRoutePath.parse(pathReader)];
  }
}

class OkPopupRoutePath extends RouterPathConfiguration<void> {
  OkPopupRoutePath.parse(PathReader pathReader) {
    PathConfigurationParser.parse(pathReader, location, queryParameters);
  }

  @override
  Iterable<PathSegmentDescriptor> get location => [PathStrConst('ok'), PathDeadEnd()];

  @override
  dynamic normalizeResult(dynamic result) => null;

  static List<RouterPathConfiguration> config(PathReader pathReader) {
    return [OkPopupRoutePath.parse(pathReader)];
  }
}

RouterPath _parse(Uri uri) {
  final pathReader = PathReader(uri);
  final segments = RouterPathFactory.stack(
    pathReader,
    root: (pathReader) => RouterPathFactory.category(
      pathReader,
      unknownPath: () => UnknownRoutePath(),
      children: [
        ProfilePathConfiguration.config,
        ProductsPathConfiguration.config,
      ],
    ),
    children: [
      PopupRoutePath.config,
    ],
  );

  return RouterPath(segments);
}

void main() {
  test('parse profile', () async {
    final path = _parse(Uri.parse('myapp://profile'));
    expect(path.isUnknown(), false);
    expect(path.location, '/profile');
  });

  test('parse profile/', () async {
    final path = _parse(Uri.parse('myapp://profile/'));
    expect(path.isUnknown(), false);
    expect(path.location, '/profile');
  });

  test('parse profile/test', () async {
    final path = _parse(Uri.parse('myapp://profile/test'));
    expect(path.isUnknown(), true);
  });

  test('parse products', () async {
    final path = _parse(Uri.parse('myapp://products'));
    expect(path.isUnknown(), false);
    expect(path.location, '/products');
  });

  test('parse profile/settings', () async {
    final path = _parse(Uri.parse('myapp://profile/settings'));
    expect(path.isUnknown(), false);
    expect(path.location, '/profile/settings');
  });

  test('parse products/details/3', () async {
    final path = _parse(Uri.parse('myapp://products/details/3'));
    expect(path.isUnknown(), false);
    expect(path.location, '/products/details/3');
  });

  test('parse products/details/3/', () async {
    final path = _parse(Uri.parse('/products/details/3/'));
    expect(path.isUnknown(), false);
    expect(path.location, '/products/details/3');
  });

  test('parse products/details/3/test', () async {
    final path = _parse(Uri.parse('/products/details/3/test'));
    expect(path.isUnknown(), true);
  });

  test('parse products/details/id', () async {
    final path = _parse(Uri.parse('/products/details/id'));
    expect(path.isUnknown(), true);
  });

  test('parse products/details/4/test', () async {
    final path = _parse(Uri.parse('/products/details/4/test'));
    expect(path.isUnknown(), true);
  });

  test('parse products/details/4/test', () async {
    final path = _parse(Uri.parse('/products/details/4/test'));
    expect(path.isUnknown(), true);
  });

  test('parse stack products/details/4/popup/ok', () async {
    final path = _parse(Uri.parse('/products/details/4/popup/ok'));
    expect(path.isUnknown(), false);
    expect(path.location, '/products/details/4/popup/ok');
  });

  test('parse stack products/details/4/popup/yes_no', () async {
    final path = _parse(Uri.parse('/products/details/4/popup/yes_no'));
    expect(path.isUnknown(), false);
    expect(path.location, '/products/details/4/popup/yes_no');
  });

  test('parse stack products/details/4/popup/', () async {
    final path = _parse(Uri.parse('/products/details/4/popup/'));
    expect(path.isUnknown(), true);
  });

  test('pop stack products/details/4/popup/', () async {
    final path = _parse(Uri.parse('/products/details/4/popup/yes_no'));
    path.pop(null);
    expect(path.location, '/products/details/4');
    path.pop(null);
    expect(path.location, '/products');
    path.pop(null);
    expect(path.location, '/');
    path.pop(null);
    expect(path.location, '/');
  });
}
