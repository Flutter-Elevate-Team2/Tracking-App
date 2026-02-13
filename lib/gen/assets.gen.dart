// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsFontsGen {
  const $AssetsFontsGen();

  /// File path: assets/fonts/IMFellEnglish-Regular.ttf
  String get iMFellEnglishRegular => 'assets/fonts/IMFellEnglish-Regular.ttf';

  /// File path: assets/fonts/Outfit.ttf
  String get outfit => 'assets/fonts/Outfit.ttf';

  /// File path: assets/fonts/inter.ttf
  String get inter => 'assets/fonts/inter.ttf';

  /// File path: assets/fonts/roboto.ttf
  String get roboto => 'assets/fonts/roboto.ttf';

  /// List of all assets
  List<String> get values => [iMFellEnglishRegular, outfit, inter, roboto];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/Rectangle.png
  AssetGenImage get rectangle =>
      const AssetGenImage('assets/images/Rectangle.png');

  /// File path: assets/images/arrow_back_ios.png
  AssetGenImage get arrowBackIos =>
      const AssetGenImage('assets/images/arrow_back_ios.png');

  /// File path: assets/images/arrow_back_left.png
  AssetGenImage get arrowBackLeft =>
      const AssetGenImage('assets/images/arrow_back_left.png');

  /// File path: assets/images/bg.png
  AssetGenImage get bg => const AssetGenImage('assets/images/bg.png');

  /// File path: assets/images/logouticon.png
  AssetGenImage get logouticon =>
      const AssetGenImage('assets/images/logouticon.png');

  /// File path: assets/images/onBoardingImage.png
  AssetGenImage get onBoardingImage =>
      const AssetGenImage('assets/images/onBoardingImage.png');

  /// File path: assets/images/successApplyImage.png
  AssetGenImage get successApplyImage =>
      const AssetGenImage('assets/images/successApplyImage.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    rectangle,
    arrowBackIos,
    arrowBackLeft,
    bg,
    logouticon,
    onBoardingImage,
    successApplyImage,
  ];
}

class $AssetsJsonGen {
  const $AssetsJsonGen();

  /// File path: assets/json/country.json
  String get country => 'assets/json/country.json';

  /// List of all assets
  List<String> get values => [country];
}

class $AssetsLottieGen {
  const $AssetsLottieGen();

  /// File path: assets/lottie/Check Animation.json
  String get checkAnimation => 'assets/lottie/Check Animation.json';

  /// File path: assets/lottie/Delivery Service-Delivery man.json
  String get deliveryServiceDeliveryMan =>
      'assets/lottie/Delivery Service-Delivery man.json';

  /// List of all assets
  List<String> get values => [checkAnimation, deliveryServiceDeliveryMan];
}

class Assets {
  const Assets._();

  static const String aEnv = '.env';
  static const $AssetsFontsGen fonts = $AssetsFontsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsJsonGen json = $AssetsJsonGen();
  static const $AssetsLottieGen lottie = $AssetsLottieGen();

  /// List of all assets
  static List<String> get values => [aEnv];
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
