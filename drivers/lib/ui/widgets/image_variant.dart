part of '../widgets.dart';

class ImageVariantBlankWidget extends StatelessWidget {
  final ImageVariant image;
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final bool showError;

  const ImageVariantBlankWidget(
    this.image, {
    Key? key,
    this.borderRadius,
    this.width = double.infinity,
    this.height = double.infinity,
    this.showError = false,
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
          network: (url, blurHash) => CachedNetworkImage(
            imageUrl: url,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            errorWidget: (context, url, dynamic error) =>
                showError ? const Icon(Icons.error) : const SizedBox(),
          ),
          file: (file) => Image.file(file),
        ),
      ),
    );
  }
}

class ImageVariantProgressWidget extends StatelessWidget {
  final ImageVariant image;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color progressColor;
  final bool showError;

  const ImageVariantProgressWidget(
    this.image, {
    Key? key,
    this.borderRadius,
    this.width,
    this.height,
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
          network: (url, blurHash) =>
              _ProgressNetworkImage(url, progressColor: progressColor, showError: showError),
          file: (file) => Image.file(file),
        ),
      ),
    );
  }
}

class ImageVariantBlurHashWidget extends StatelessWidget {
  final ImageVariant image;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final bool showError;
  final BoxFit fit;

  const ImageVariantBlurHashWidget(
    this.image, {
    Key? key,
    this.borderRadius,
    this.width,
    this.height,
    this.showError = true,
    this.fit = BoxFit.contain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: FittedBox(
        fit: fit,
        child: SizedBox(
          width: width ?? 99999 * image.ratio,
          height: height ?? 99999,
          child: image.match(
            asset: (asset) => Image.asset(asset),
            svg: (svg) => SvgPicture.asset(svg),
            network: (url, blurHash) => _BlurHashNetworkImage(
              url,
              blurHash: image.blurHash ?? '',
              showError: showError,
            ),
            file: (file) => Image.file(file),
          ),
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
    if (url.endsWith('.svg')) {
      return SvgPicture.network(
        url,
        placeholderBuilder: (context) => Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: progressColor,
            ),
          ),
        ),
      );
    } else {
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
}

class _BlurHashNetworkImage extends StatefulWidget {
  final String url;
  final String blurHash;
  final bool showError;

  const _BlurHashNetworkImage(
    this.url, {
    Key? key,
    required this.blurHash,
    required this.showError,
  }) : super(key: key);

  @override
  State<_BlurHashNetworkImage> createState() => _BlurHashNetworkImageState();
}

class _ImageData {
  final Uint8List bytes;
  final bool hasAlphaChannel;

  const _ImageData(this.bytes, this.hasAlphaChannel);
}

Future<_ImageData> encrypt(String url) async {
  final data = await DefaultCacheManager().getSingleFile(url);
  final bytes = await data.readAsBytes();

  final bool hasAlphaChannel;

  if (url.endsWith('.svg')) {
    hasAlphaChannel = true;
  } else {
    // NOTE(aKabylin): Starting Isolate adds pause and UI freezes in Debug Mode, so we ignore it.
    hasAlphaChannel = kProfileMode || kReleaseMode ? await compute(_hasImageAlphaChannel, bytes) : true;
  }

  return _ImageData(bytes, hasAlphaChannel);
}

bool _hasImageAlphaChannel(Uint8List bytes) {
  final i = img.decodeImage(bytes);
  return i?.channels == img.Channels.rgba;
}

class _BlurHashNetworkImageState extends State<_BlurHashNetworkImage> {
  double _blurHashOpacity = 1;
  double _imageOpacity = 0;
  Uint8List _imageBytes = Uint8List.fromList(const []);

  @override
  void initState() {
    super.initState();

    delay(100).then((value) {
      setState(() => _blurHashOpacity = 1);
      encrypt(widget.url).then((data) {
        setState(() {
          _imageBytes = data.bytes;
          _imageOpacity = 1;

          if (data.hasAlphaChannel) {
            _blurHashOpacity = 0;
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget image;
    if (widget.url.endsWith('.svg')) {
      if (_imageBytes.isNotEmpty) {
        image = SvgPicture.memory(_imageBytes, fit: BoxFit.fill);
      } else {
        image = const SizedBox.shrink();
      }
    } else {
      if (_imageBytes.isNotEmpty) {
        image = Image.memory(_imageBytes, fit: BoxFit.fill);
      } else {
        image = const SizedBox.shrink();
      }
    }

    return Stack(
      children: [
        AnimatedOpacity(
          opacity: _blurHashOpacity,
          duration: const Duration(milliseconds: 300),
          child: flutter_blurhash.BlurHash(
            color: Colors.transparent,
            hash: widget.blurHash,
          ),
        ),
        Positioned.fill(
          child: AnimatedOpacity(
            opacity: _imageOpacity,
            duration: const Duration(milliseconds: 300),
            child: image,
          ),
        ),
      ],
    );
  }
}
