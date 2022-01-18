import 'package:equatable/equatable.dart';
import 'dart:io';

class ImageVariant extends Equatable {
  final String? assetName;
  final String? svg;
  final String? url;
  final File? file;

  const ImageVariant.url(this.url)
      : assetName = null,
        file = null,
        svg = null;

  const ImageVariant.asset(this.assetName)
      : url = null,
        file = null,
        svg = null;

  const ImageVariant.file(this.file)
      : url = null,
        assetName = null,
        svg = null;

  const ImageVariant.svg(this.svg)
      : url = null,
        assetName = null,
        file = null;

  T match<T>({
    required T Function(String name) asset,
    required T Function(String name) svg,
    required T Function(String url) network,
    required T Function(File file) file,
  }) {
    if (url != null) {
      return network(url!);
    } else if (assetName != null) {
      return asset(assetName!);
    } else if (this.file != null) {
      return file(this.file!);
    } else if (this.svg != null) {
      return svg(this.svg!);
    } else {
      throw StateError('At least one element should not be null');
    }
  }

  @override
  List<Object?> get props => [assetName, url];
}
