import '../export.dart';

extension CText on Text {
  Text w400({double? fontSize, Color? color}) {
    return Text(data ?? '', style: CTextStyle.fontStyle(fontSize: fontSize, color: color), overflow: TextOverflow.ellipsis, softWrap: true);
  }

  Text w500({double? fontSize, Color? color}) {
    return Text(data ?? '', style: CTextStyle.fontStyle(fontSize: fontSize, fontWeight: FontWeight.w500, color: color), overflow: TextOverflow.ellipsis, softWrap: true);
  }

  Text w600({double? fontSize, Color? color}) {
    return Text(data ?? '', style: CTextStyle.fontStyle(fontSize: fontSize ?? 14, fontWeight: FontWeight.w600, color: color), overflow: TextOverflow.ellipsis, softWrap: true);
  }

  Text w700({double? fontSize, Color? color}) {
    return Text(data ?? '', style: CTextStyle.fontStyle(fontSize: fontSize ?? 16, fontWeight: FontWeight.w700, color: color), overflow: TextOverflow.ellipsis, softWrap: true);
  }

  Text w800({double? fontSize, Color? color}) {
    return Text(data ?? '', style: CTextStyle.fontStyle(fontSize: fontSize ?? 18, fontWeight: FontWeight.w800, color: color), overflow: TextOverflow.ellipsis, softWrap: true);
  }

  Text w900({double? fontSize, Color? color}) {
    return Text(data ?? '', style: CTextStyle.fontStyle(fontSize: fontSize ?? 22, fontWeight: FontWeight.w900, color: color), overflow: TextOverflow.ellipsis, softWrap: true);
  }
}

class CTextStyle {
  static double get defaultFontSize => 13;
  static FontWeight get defaultFontWeight => FontWeight.w400;

  static TextStyle fontStyle({double? fontSize, FontWeight? fontWeight, Color? color}) {
    return TextStyle(
      color: color,
      fontSize: fontSize ?? defaultFontSize,
      fontWeight: fontWeight ?? defaultFontWeight,
      overflow: TextOverflow.ellipsis,
    );
  }
}
