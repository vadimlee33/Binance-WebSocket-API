import 'dart:async';

import 'package:binance_task/Utils/constants.dart';
import 'package:flutter/material.dart';

enum ColorEvent { eventRed, eventGreen}

class ColorBloc {
  Color _color = redColor;

  final _inputEventController = StreamController<ColorEvent>();
  StreamSink<ColorEvent> get inputEventSink => _inputEventController.sink;

  final _outputStateController = StreamController<Color>();
  Stream<Color> get outputStateStream => _outputStateController.stream;

  void _mapEventToState(ColorEvent event) {
    if (event == ColorEvent.eventRed) {
      _color = redColor;
    } else if (event == ColorEvent.eventGreen) {
      _color = greenColor;
    } else {
      throw Exception('Wrong Event Type');
    }

    _outputStateController.sink.add(_color);
  }

  ColorBloc() {
    _inputEventController.stream.listen(_mapEventToState);
  }

  // Close input and output streams
  void dispose() {
    _inputEventController.close();
    _outputStateController.close();
  }
}
