import 'dart:io';

import 'package:equatable/equatable.dart';

class ImageVariant extends Equatable {
  final String? assetName;
  final String? svg;
  final String? url;
  final File? file;
  final String? blurHash;
  final double ratio;

  const ImageVariant.url(this.url, {this.blurHash, this.ratio = 1})
      : assetName = null,
        file = null,
        svg = null;

  const ImageVariant.asset(this.assetName, {this.ratio = 1})
      : url = null,
        file = null,
        svg = null,
        blurHash = null;

  const ImageVariant.file(this.file, {this.ratio = 1})
      : url = null,
        assetName = null,
        svg = null,
        blurHash = null;

  const ImageVariant.svg(this.svg, {this.ratio = 1})
      : url = null,
        assetName = null,
        file = null,
        blurHash = null;

  T match<T>({
    required T Function(String name) asset,
    required T Function(String name) svg,
    required T Function(String url, String? blurHash) network,
    required T Function(File file) file,
  }) {
    if (url != null) {
      return network(url!, blurHash);
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
