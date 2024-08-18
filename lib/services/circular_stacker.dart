class CircularStacker<T> {
  CircularStacker(this.size);

  final int size;
  final List<T> _buffer = [];
  int _index = 0;

  void push(T value) {
    if (_buffer.length < size) {
      _buffer.add(value);
    } else {
      _buffer[_index] = value;
    }

    _index = (_index + 1) % size;
  }

  // pop the last element from the buffer
  T? pop() {
    if (_buffer.isNotEmpty) {
      return _buffer.removeLast();
    }
    return null;
  }

  //List<T> get buffer => _buffer;

  void clear() {
    _buffer.clear();
    _index = 0;
  }

  // get max size of the buffer
  int getMaxSize()
  {
    return size;
  }

  // get current buffer size of the buffer
  int getSize()
  {
    return _buffer.length;
  }
}