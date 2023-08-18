import 'package:drag_n_drop/models/node.dart';
import 'package:flutter/material.dart';

import '../models/complex_type.dart';
import '../models/enum_type.dart';

class TextNode extends Node {
  TextNode({super.key})
      : super(
          name: 'Text',
          args: const {
            'text': 'Text',
          },
          canHaveChildren: false,
          supportedParameters: const {
            'text': String,
            'textAlign': EnumType<TextAlign>(
              type: TextAlign,
              values: TextAlign.values,
            ),
            'style': ComplexType<TextStyle>(
              {
                'color': Color,
                'fontSize': double,
                'fontWeight': EnumType<FontWeight>(
                  type: FontWeight,
                  values: FontWeight.values,
                ),
              },
              type: TextStyle,
            ),
          },
          builder: (args, children) {
            return Text(
              args['text'],
              textAlign: args['textAlign'],
              style: args['style'],
            );
          },
        );
}
