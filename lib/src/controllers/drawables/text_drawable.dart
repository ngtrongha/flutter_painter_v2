import 'dart:ui';

import 'package:flutter/material.dart';
// import 'package:flutter_painter/flutter_painter.dart';
import 'package:flutter_painter_v2/flutter_painter.dart';

/// Text Drawable
class TextDrawable extends ObjectDrawable {
  /// The text to be drawn.
  final String text;

  /// The style the text will be drawn with.
  final TextStyle style;

  /// The direction of the text to be drawn.
  final TextDirection direction;

  // A text painter which will paint the text on the canvas.
  final TextPainter textPainter;

  /// Creates a [TextDrawable] to draw [text].
  ///
  /// The path will be drawn with the passed [style] if provided.
  ///
  final bool isEditable;

  final double? backgroundOpacity;
  TextDrawable({
    required this.isEditable,
    required this.text,
    required Offset position,
    double rotation = 0,
    double scale = 1,
    this.style = const TextStyle(
      fontSize: 14,
      color: Colors.black,
    ),
    this.direction = TextDirection.ltr,
    bool locked = false,
    bool hidden = false,
    this.backgroundOpacity,
    Set<ObjectDrawableAssist> assists = const <ObjectDrawableAssist>{},
  })  : textPainter = TextPainter(
          text: TextSpan(text: text, style: style),
          textAlign: TextAlign.center,
          textScaleFactor: scale,
          textDirection: direction,
        ),
        super(
            position: position,
            rotationAngle: rotation,
            scale: scale,
            assists: assists,
            locked: locked,
            hidden: hidden);

  /// Draws the text on the provided [canvas] of size [size].
  @override
  void drawObject(Canvas canvas, Size size) {
    // Render the text according to the size of the canvas taking the scale in mind
    textPainter.layout(maxWidth: size.width * scale);
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2; // Fill the rectangle
    final height = textPainter.height;
    final width = textPainter.width;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
          (position - Offset(textPainter.width / 2, textPainter.height / 2))
                  .dx -
              10,
          (position - Offset(textPainter.width / 2, textPainter.height / 2))
                  .dy -
              10,
          width + 20,
          height + 20),
      const Radius.circular(8),
    ); // Define rectangle dimensions
    canvas.drawRRect(rect, paint);

    final fillPaint = Paint()
      ..color = Colors.white.withOpacity(backgroundOpacity ?? 0.7)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rect, fillPaint);
    // Paint the text on the canvas
    // It is shifted back by half of its width and height to be drawn in the center
    textPainter.paint(canvas,
        position - Offset(textPainter.width / 2, textPainter.height / 2));
  }

  /// Creates a copy of this but with the given fields replaced with the new values.
  @override
  TextDrawable copyWith({
    bool? hidden,
    Set<ObjectDrawableAssist>? assists,
    String? text,
    Offset? position,
    double? rotation,
    double? scale,
    TextStyle? style,
    bool? locked,
    TextDirection? direction,
    bool? isEditable,
  }) {
    return TextDrawable(
      text: text ?? this.text,
      position: position ?? this.position,
      rotation: rotation ?? rotationAngle,
      scale: scale ?? this.scale,
      style: style ?? this.style,
      direction: direction ?? this.direction,
      assists: assists ?? this.assists,
      hidden: hidden ?? this.hidden,
      locked: locked ?? this.locked,
      isEditable: isEditable ?? true,
    );
  }

  /// Calculates the size of the rendered object.
  @override
  Size getSize({double minWidth = 0.0, double maxWidth = double.infinity}) {
    // Generate the text as a visual layout
    textPainter.layout(minWidth: minWidth, maxWidth: maxWidth * scale);
    return textPainter.size;
  }

  /// Compares two [TextDrawable]s for equality.
  // @override
  // bool operator ==(Object other) {
  //   return other is TextDrawable &&
  //       super == other &&
  //       other.text == text &&
  //       other.style == style &&
  //       other.direction == direction;
  // }
  //
  // @override
  // int get hashCode => hashValues(
  //     hidden,
  //     hashList(assists),
  //     hashList(assistPaints.entries),
  //     position,
  //     rotationAngle,
  //     scale,
  //     style,
  //     direction);
}
