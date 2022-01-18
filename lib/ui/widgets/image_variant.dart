part of '../widgets.dart';

class ImageVariantProgressWidget extends StatelessWidget {
  final ImageVariant image;
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final Color progressColor;
  final bool showError;

  const ImageVariantProgressWidget(
    this.image, {
    Key? key,
    this.borderRadius,
    this.width = double.infinity,
    this.height = double.infinity,
    this.progressColor = Colors.black,
    this.showError = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: SizedBox(
        width: width,
        height: height,
        child: image.match(
          asset: (asset) => Image.asset(asset),
          svg: (svg) => SvgPicture.asset(svg),
          network: (url) =>
              _ProgressNetworkImage(url, progressColor: progressColor, showError: showError),
          file: (file) => Image.file(file),
        ),
      ),
    );
  }
}

// TODO(sysint64): implement
class ImageVariantBlurHashWidget extends StatelessWidget {
  final ImageVariant image;
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final String blurHash;
  final bool showError;

  const ImageVariantBlurHashWidget(
    this.image, {
    Key? key,
    this.borderRadius,
    required this.blurHash,
    this.width = double.infinity,
    this.height = double.infinity,
    this.showError = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        width: width,
        height: height,
        child: image.match(
          asset: (asset) => Image.asset(asset),
          svg: (svg) => SvgPicture.asset(svg),
          network: (url) =>
              _ProgressNetworkImage(url, progressColor: Colors.black, showError: showError),
          file: (file) => Image.file(file),
        ),
      ),
    );
  }
}

class _ProgressNetworkImage extends StatelessWidget {
  final String url;
  final Color progressColor;
  final bool showError;

  const _ProgressNetworkImage(
    this.url, {
    Key? key,
    required this.progressColor,
    required this.showError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: progressColor,
          ),
        ),
      ),
      errorWidget: (context, url, dynamic error) =>
          showError ? const Icon(Icons.error) : const SizedBox(),
    );
  }
}
