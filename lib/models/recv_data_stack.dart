import 'package:flutter/foundation.dart';

import '../services/circular_stacker.dart';

class RecvDataStack {

  final CircularStacker<Uint8List> _stacker;

  RecvDataStack(int size) : _stacker = CircularStacker(size);

  void push(Uint8List value) {
    _stacker.push(value);
  }

  Uint8List? pop() {
    return _stacker.pop();
  }

  void clear() {
    _stacker.clear();
  }

  int getMaxSize() {
    return _stacker.getMaxSize();
  }

  int getSize() {
    return _stacker.getSize();
  }
}