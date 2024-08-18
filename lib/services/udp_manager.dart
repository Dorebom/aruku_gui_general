import 'package:flutter/foundation.dart';

import 'dart:io';
import 'dart:async';

import 'package:logger/logger.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_data_provider.dart';


class UdpManager {
  final Logger logger = Logger();

  static final UdpManager _singleton = UdpManager._internal();
  late RawDatagramSocket _socket;
  bool _isReceiving = false;
  WidgetRef? ref;

  int cnt = 0;

  factory UdpManager(WidgetRef? ref) {
    _singleton.ref = ref;
    return _singleton;
  }

  UdpManager._internal();

  Future<void> initSocket(int srcPort_) async {
    _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, srcPort_);
    logger.i('Listening on port $srcPort_');

    final userData = ref?.watch(userDataProvider);

    _socket.listen((RawSocketEvent e) {
      if (e == RawSocketEvent.read) {
        Datagram? datagram = _socket.receive();
        if (datagram != null) {
          logger.i('Received data: ${datagram.data}');

          final byteData = ByteData.sublistView(datagram.data);
          final int16Value = byteData.getInt16(0, Endian.little);

          cnt++;
          ref?.read(userDataProvider.notifier).state = userData?.copyWith(a: cnt);

          if (int16Value == 1) {
            // 2バイト目が1の場合はログイン成功
            // 画面遷移
            logger.i('Navigating to the second page');
            ref?.read(userDataProvider.notifier).state = userData?.copyWith(shouldNavigateHome: true);
          }
        }
      }
    });
    _isReceiving = true;
  }

  void closeSocket() {
    if (_isReceiving) {
      _socket.close();
      _isReceiving = false;
    }
  }
}


/*
  void _startListenings(int srcPort_) async {
    RawDatagramSocket? socket;
    socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, srcPort_);
    logger.i('Listening on port $srcPort_');
    socket.listen((event) {
      if (event == RawSocketEvent.read) {
        Datagram? dg = socket?.receive();
        if (dg != null) {
          //_handleReceivedData(dg.data);
          logger.i('Received data: ${dg.data}');

          final byteData = ByteData.sublistView(dg.data);
          final int16Value = byteData.getInt16(0, Endian.little);

          if (int16Value == 1) {
            // 2バイト目が1の場合はログイン成功
            // 画面遷移
            logger.i('Navigating to the second page');
            _shouldNavigate = true;
          }
        }
      }
    });
  }
*/
