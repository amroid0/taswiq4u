import 'package:flutter/material.dart';

final RangeThumbSelector _customRangeThumbSelector = (
  TextDirection textDirection,
  RangeValues values,
  double tapValue,
  Size thumbSize,
  Size trackSize,
  double dx,
) {
  final double start = (tapValue - values.start).abs();
  final double end = (tapValue - values.end).abs();
  return start < end ? Thumb.start : Thumb.end;
};
