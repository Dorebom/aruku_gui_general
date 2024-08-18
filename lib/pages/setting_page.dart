import 'dart:convert';
import 'dart:io';

//import 'package:aruku_gui_general/models/recv_data_stack.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//import '../services/udp_manager.dart';
import '../providers/user_data_provider.dart';
import '../models/common_state_code.dart';
//import '../providers/recv_data_stack_provider.dart';


class SettingsPage extends ConsumerWidget {
  SettingsPage({super.key});
  final Logger logger = Logger();

  final _dstIpController = TextEditingController();
  final _dstPortController = TextEditingController();
  final _srcPortController = TextEditingController();

  //var _shouldNavigate = false;
  //var _srcPort = 0;

  bool _isUdpRecvRunning =false; // true;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider);

    void sendUDPStartMessage() {
      final ip = _dstIpController.text;
      final port = int.tryParse(_dstPortController.text);
      final srcPort = int.tryParse(_srcPortController.text);

      if (ip.isEmpty || port == null || srcPort == null || srcPort < 0 || srcPort > 65535) {
        return;
      }

      final byteData = ByteData(26);     // 2 + 2 + 4 + 4
      // make common cmd code
      byteData.setInt32(0, 255, Endian.little); // int source
      byteData.setInt32(4, 0, Endian.little);   // int destination
      byteData.setInt32(8, 0, Endian.little);   // int priority
      byteData.setInt32(12, 0, Endian.little);  // int cmd_id
      byteData.setInt32(16, 6, Endian.little);  // int cmd_type 6: Start GUI
      byteData.setInt32(20, 0, Endian.little);  // int data_size
      // set boolean data
      byteData.setUint8(24, 0);  // boolean is_sys_cmd
      byteData.setUint8(25, 0);  // boolean is_used_mesgpack

      final data = byteData.buffer.asUint8List();

      RawDatagramSocket.bind(InternetAddress.anyIPv4, 0).then((socket) {
        socket.send(data, InternetAddress(ip), port);
        socket.close();
      });

      logger.i('sendUDPMessage: $ip:$port, $srcPort');
    }

    void sendUDPEndMessage() {
      final ip = _dstIpController.text;
      final port = int.tryParse(_dstPortController.text);
      final srcPort = int.tryParse(_srcPortController.text);

      if (ip.isEmpty || port == null || srcPort == null || srcPort < 0 || srcPort > 65535) {
        return;
      }

      final byteData = ByteData(26);     // 2 + 2 + 4 + 4
      // make common cmd code
      byteData.setInt32(0, 255, Endian.little); // int source
      byteData.setInt32(4, 0, Endian.little);   // int destination
      byteData.setInt32(8, 0, Endian.little);   // int priority
      byteData.setInt32(12, 0, Endian.little);  // int cmd_id
      byteData.setInt32(16, 7, Endian.little);  // int cmd_type 7: End GUI
      byteData.setInt32(20, 0, Endian.little);  // int data_size
      // set boolean data
      byteData.setUint8(24, 0);  // boolean is_sys_cmd
      byteData.setUint8(25, 0);  // boolean is_used_mesgpack

      final data = byteData.buffer.asUint8List();

      RawDatagramSocket.bind(InternetAddress.anyIPv4, 0).then((socket) {
        socket.send(data, InternetAddress(ip), port);
        socket.close();
      });

      logger.i('sendUDPMessage: $ip:$port, $srcPort');
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        title: const Text('Settings Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Divider(),
            Text(
              'UDP Settings Page',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 20),
            // Line
            ElevatedButton(
              onPressed: (){
                _loadFromFile(ref);
                },
              child: const Text('Load from JSON File'),
            ),
            //const SizedBox(height: 20),
            TextField(
              controller: _dstIpController,
              decoration: const InputDecoration(labelText: 'IP Address(Destination)'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                ref.read(userDataProvider.notifier).state = userData?.copyWith(dstIpAddress: value);
                logger.i('dstIpAddress: ${userData?.dstIpAddress}');
                //_shouldNavigate = false;
              },
            ),
            TextField(
              controller: _dstPortController,
              decoration: const InputDecoration(labelText: 'Port(Destination)'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                ref.read(userDataProvider.notifier).state = userData?.copyWith(dstPort: int.tryParse(value) ?? 0);
                logger.i('dstPort: ${userData?.dstPort}');
                //_shouldNavigate = false;
              },
            ),
            TextField(
              controller: _srcPortController,
              decoration: const InputDecoration(labelText: 'Port(Source)'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                //srcPort = int.tryParse(value) ?? 0;
                ref.read(userDataProvider.notifier).state = userData?.copyWith(srcPort: int.tryParse(value) ?? 0);
                logger.i('srcPort: ${userData?.srcPort}');
                //_shouldNavigate = false;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: (){
                ref.read(userDataProvider.notifier).state = userData?.copyWith(isSendingUdpConnectMessage: true);
                if (!_isUdpRecvRunning) {
                  _recvUDPMessage(ref);
                }
                sendUDPStartMessage();
              },
              child: const Text('Send UDP Connect Message'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: (){
                ref.read(userDataProvider.notifier).state = userData?.copyWith(isSendingUdpConnectMessage: false);
                ref.read(userDataProvider.notifier).state = userData?.copyWith(isUdpConnected: false);
                sendUDPEndMessage();
              },
              child: const Text('Send UDP Disconnect Message'),
            ),
            const SizedBox(height: 20),
          ],
        ),

      ),
    );
  }

  Future<void> _loadFromFile(WidgetRef ref) async {
    final userData = ref.watch(userDataProvider);

    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/data.json');
      final contents = await file.readAsString();
      final json = jsonDecode(contents);

      //print directory
      logger.i('Load from file: $json');

      _dstIpController.text = json['dst_ip'];
      _dstPortController.text = json['dst_port'].toString();
      _srcPortController.text = json['src_port'].toString();

      ref.read(userDataProvider.notifier).state = userData?.copyWith(dstIpAddress: _dstIpController.text);
      ref.read(userDataProvider.notifier).state = userData?.copyWith(dstPort: int.tryParse(_dstPortController.text) ?? 0);
      ref.read(userDataProvider.notifier).state = userData?.copyWith(srcPort: int.tryParse(_srcPortController.text) ?? 0);
    } catch (e) {
      logger.e('Failed to load from file: $e');
    }
    //_shouldNavigate = false;
  }

  void _recvUDPMessage(WidgetRef ref) {  // ここに追加
    final userData = ref.watch(userDataProvider);

    // ここにUDPメッセージ受信処理を追加
    _isUdpRecvRunning = true;

    // UDP メッセージ受信処理
    logger.i('UDP Recv Start: ${userData?.srcPort}');

    Future.doWhile(() async {
      final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, userData?.srcPort ?? 0);
      socket.listen((event) {
        if (event == RawSocketEvent.read) {
          final datagram = socket.receive();
          if (datagram != null) {
            // 受信できたら、isUdpConnected を true にする
            // isSendingUdpConnectMessageがtrueの場合は、falseにする
            if (userData?.isSendingUdpConnectMessage ?? true) {
              ref.read(userDataProvider.notifier).state = userData?.copyWith(isUdpConnected: true);
            }
            final data = datagram.data;
            logger.i('Received UDP Message: ${data.length} bytes');
            logger.i('Received UDP Message: $data');
            // ここで受信したデータを処理する
            // recvDataStackにデータを追加
            _processUdpMessage(data, ref);
          }
        }
      });
      // sleep 5 millisecond
      await Future.delayed(const Duration(milliseconds: 50));
      return true;
    }).whenComplete(() => _isUdpRecvRunning = false);
  }

  Future<void> _processUdpMessage(Uint8List data, WidgetRef ref) async{
    // ここで受信したデータを処理する
    //final commonStateCode = CommonStateCode.fromBytes(data);

    // data[0]に1byteのデータサイズが入っている
    final headerDataSize = data[0];

    final nodeId = data[0];
    final stateMachine = data[1];
    final dataSize = data[3];

    //ByteData byteData = data.buffer.asByteData(0, 4);
    //final nodeId = byteData.getInt32(0, Endian.little);
    //byteData = data.buffer.asByteData(4, 4);
    //final stateMachine = byteData.getInt32(0, Endian.little);
    //byteData = data.buffer.asByteData(12, 4);
    //final dataSize = byteData.getInt32(0, Endian.little);

    logger.i('CommonStateCode: (node id)$nodeId, (SM)$stateMachine, (data size)$dataSize');
  }

}