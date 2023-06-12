/*
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class Annotation extends Comparable<Annotation> {
  Annotation({required this.range, this.style});

  final TextRange range;
  final TextStyle? style;

  @override
  int compareTo(Annotation other) {
    return range.start.compareTo(other.range.start);
  }

  @override
  String toString() {
    return 'Annotation(range:$range, style:$style)';
  }
}

class AnnotatedEditableText extends EditableText {
  AnnotatedEditableText({
    Key? key,
    required FocusNode focusNode,
    required TextEditingController controller,
    required TextStyle style,
    required ValueChanged<String> onChanged,
    required ValueChanged<String> onSubmitted,
    required Color cursorColor,
    required Color selectionColor,
    required TextSelectionControls selectionControls,
    required this.annotations,
  }) : super(
            key: key,
            focusNode: focusNode,
            controller: controller,
            cursorColor: cursorColor,
            style: style,
            keyboardType: TextInputType.text,
            autocorrect: true,
            autofocus: true,
            selectionColor: selectionColor,
            selectionControls: selectionControls,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            backgroundCursorColor: Colors.black54);

  final List<Annotation> annotations;

  @override
  AnnotatedEditableTextState createState() => AnnotatedEditableTextState();
}

class AnnotatedEditableTextState extends EditableTextState {
  @override
  AnnotatedEditableText get widget => super.widget;

  List<Annotation> getRanges() {
    var source = widget.annotations;
    source.sort();
    var result = <Annotation>[];
    Annotation? prev;
    for (var item in source) {
      if (prev == null) {
        // First item, check if we need one before it.
        if (item.range.start > 0) {
          result.add(Annotation(
            range: TextRange(start: 0, end: item.range.start),
          ));
        }
        result.add(item);
        prev = item;
        continue;
      } else {
        // Consequent item, check if there is a gap between.
        if (prev.range.end > item.range.start) {
          // Invalid ranges
          throw new StateError('Invalid (intersecting) ranges for annotated field');
        } else if (prev.range.end < item.range.start) {
          result.add(Annotation(
            range: TextRange(start: prev.range.end, end: item.range.start),
          ));
        }
        // Also add current annotation
        result.add(item);
        prev = item;
      }
    }
    // Also check for trailing range
    final String text = textEditingValue.text;
    if (result.last.range.end < text.length) {
      result.add(Annotation(
        range: TextRange(start: result.last.range.end, end: text.length),
      ));
    }
    return result;
  }

  @override
  TextSpan buildTextSpan() {
    final String text = textEditingValue.text;
    int textLength = text.length;
    if (widget.annotations != null && textLength > 0) {
      var items = getRanges();
      var children = <TextSpan>[];
      for (var item in items) {
        if (item.range.end < textLength) {
          children.add(
            TextSpan(style: item.style, text: item.range.textInside(text)),
          );
        } else if (item.range.start <= textLength) {
          children.add(
            TextSpan(style: item.style, text: TextRange(start: item.range.start, end: text.length).textInside(text)),
          );
        }
      }
      return new TextSpan(style: widget.style, children: children);
    }

    return new TextSpan(style: widget.style, text: text);
  }
}
*/
