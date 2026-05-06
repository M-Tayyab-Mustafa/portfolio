import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget buildPlatformFileImage({
  required String path,
  required bool isSvg,
  required BoxFit fit,
  Color? color,
  BlendMode? colorBlendMode,
  double? height,
  double? width,
}) {
  if (isSvg) {
    return SvgPicture.file(
      io.File(path),
      fit: fit,
      colorFilter: color != null
          ? ColorFilter.mode(color, colorBlendMode ?? BlendMode.srcIn)
          : null,
      height: height,
      width: width,
    );
  }

  return Image.file(
    io.File(path),
    fit: fit,
    colorBlendMode: colorBlendMode,
    color: color,
    height: height,
    width: width,
  );
}
