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

      final byteData = ByteData(32);     // 2 + 2 + 4 + 4
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

      final byteData = ByteData(32);     // 2 + 2 + 4 + 4
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

    void sendRequestHubInfoMessage(){
      final ip = _dstIpController.text;
      final port = int.tryParse(_dstPortController.text);
      final srcPort = int.tryParse(_srcPortController.text);

      if (ip.isEmpty || port == null || srcPort == null || srcPort < 0 || srcPort > 65535) {
        return;
      }

      final byteData = ByteData(32);     // 2 + 2 + 4 + 4
      // make common cmd code
      byteData.setInt32(0, 255, Endian.little); // int source
      byteData.setInt32(4, 0, Endian.little);   // int destination
      byteData.setInt32(8, 0, Endian.little);   // int priority
      byteData.setInt32(12, 0, Endian.little);  // int cmd_id
      byteData.setInt32(16, 8, Endian.little);  // int cmd_type 8: Send Hub info
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

    void sendStreamNodeData(int nodeId){
      final ip = _dstIpController.text;
      final port = int.tryParse(_dstPortController.text);
      final srcPort = int.tryParse(_srcPortController.text);

      if (ip.isEmpty || port == null || srcPort == null || srcPort < 0 || srcPort > 65535) {
        return;
      }

      final byteData = ByteData(32 + 4);     // 2 + 2 + 4 + 4
      // make common cmd code
      byteData.setInt32(0, 255, Endian.little); // int source
      byteData.setInt32(4, 0, Endian.little);   // int destination
      byteData.setInt32(8, 0, Endian.little);   // int priority
      byteData.setInt32(12, 0, Endian.little);  // int cmd_id
      byteData.setInt32(16, 10, Endian.little);  // int cmd_type 10: Send Stream Node Data
      byteData.setInt32(20, 4, Endian.little);  // int data_size
      // set boolean data
      byteData.setUint8(24, 0);  // boolean is_sys_cmd
      byteData.setUint8(25, 0);  // boolean is_used_mesgpack

      byteData.setInt32(32, nodeId, Endian.little);  // int node_id

      final data = byteData.buffer.asUint8List();

      RawDatagramSocket.bind(InternetAddress.anyIPv4, 0).then((socket) {
        socket.send(data, InternetAddress(ip), port);
        //socket.send(nodeData, InternetAddress(ip), port);
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
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(userData?.isUdpConnected ?? false ? Colors.green : Colors.white70),
              ),
              child: const Text('Send UDP Connect Message'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: (){
                ref.read(userDataProvider.notifier).state = userData?.copyWith(isSendingUdpConnectMessage: false);
                ref.read(userDataProvider.notifier).state = userData?.copyWith(isUdpConnected: false);
                sendUDPEndMessage();
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(userData?.isUdpConnected ?? false ? Colors.red : Colors.white70),
              ),
              child: const Text('Send UDP Disconnect Message'),
            ),
            const SizedBox(height: 20),
            const Divider(),
            // Get system information
            ElevatedButton(
              onPressed: (){
                // ここにシステム情報取得処理を追加
                sendRequestHubInfoMessage();
              },
              child: const Text('Get System Information'),
            ),
            const SizedBox(height: 20),
            // userData?.nodeInfoの情報を表示
            Text(
              'Node Information',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: userData?.nodeInfo.length ?? 0,
                itemBuilder: (context, index) {
                  final key = userData?.nodeInfo.keys.elementAt(index);
                  final value = userData?.nodeInfo.values.elementAt(index);
                  // 表を中央に揃えて表示
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //Text('Node ID: $key, Node Name: $value'),
                      //const Divider(),
                      ListTile(
                        title: Text('Node ID: $key'),
                        subtitle: Text('Node Name: $value'),
                        leading: const Icon(Icons.account_circle),
                        onTap: (){
                          sendStreamNodeData(key!);
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
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

    // B-HUbのsend_state.hppで定義されているデータ構造に従ってデータを処理する
    // データの構造は、send_state.hppを参照
    ByteData byteData = data.buffer.asByteData(0, 4);
    //ByteData byteData = data.buffer.asByteData(0, 4);
    final fixedHeaderDataSize = byteData.getInt32(0, Endian.little);
    byteData = data.buffer.asByteData(4, 4);
    final maxStackMarkerSize = byteData.getInt32(0, Endian.little);
    byteData = data.buffer.asByteData(8, 4);
    final recvStateHeaderSize = byteData.getInt32(0, Endian.little);
    byteData = data.buffer.asByteData(12, 4);
    final oneStackSize = byteData.getInt32(0, Endian.little);
    byteData = data.buffer.asByteData(16, 4);
    final stackMarkerNum = byteData.getInt32(0, Endian.little);
    // ここまでで、固定ヘッダのデータを取得

    // ここから、stackMarkerNumの数だけ、stackMarkerに従って、スタックデータを取得
    if (stackMarkerNum <= maxStackMarkerSize){
      for (var i = 0; i < stackMarkerNum; i++) {
        byteData = data.buffer.asByteData(20 + i, 1);
        final int stackNum = byteData.getInt8(0);
        logger.i('StackMarker: $stackNum');

        //final Uint8List stackByteData = data.buffer.asUint8List(recvStateHeaderSize, oneStackSize * stackNum);
        Uint8List stackByteData = Uint8List(oneStackSize * stackNum);
        stackByteData.setRange(0, oneStackSize * stackNum, data, recvStateHeaderSize);
        //Uint8List stackByteData = data.buffer.asByteData(recvStateHeaderSize, oneStackSize * stackNum);
        logger.i('StackData: ${stackByteData.length} bytes');
        logger.i('StackData: $stackByteData');

        // ここで、スタックデータを処理する
        final commonStateCode = CommonStateCode.fromBytes(stackByteData);
        logger.i('NodeID: ${commonStateCode.nodeId}');
        logger.i('StateMachine: ${commonStateCode.stateMachine}');
        logger.i('NodeDataSize: ${commonStateCode.dataSize}');
        Uint8List nodeStateByteData = Uint8List(commonStateCode.dataSize);
        nodeStateByteData.setRange(0, commonStateCode.dataSize, stackByteData, fixedHeaderDataSize);
        logger.i('NodeStateData: $nodeStateByteData');

        // switch文で、Node IDに応じた処理を行う
        switch (commonStateCode.nodeId) {
          case 0: // Hub
            ByteData byteData3 = nodeStateByteData.buffer.asByteData(4, 4);
            final maxNodeNum = byteData3.getInt32(0, Endian.little);
            byteData3 = nodeStateByteData.buffer.asByteData(8, 4);
            final maxNodeNameSize = byteData3.getInt32(0, Endian.little);
            byteData3 = nodeStateByteData.buffer.asByteData(0, 4);
            final nodeNum = byteData3.getInt32(0, Endian.little);
            final Map<int, String> nodes = {};

            for (var i = 0; i < nodeNum; i++) {
              byteData3 = nodeStateByteData.buffer.asByteData(12 + i * 4, 4);
              final nodeId = byteData3.getInt32(0, Endian.little);
              Uint8List nodeNameByteData = Uint8List(maxNodeNameSize);
              nodeNameByteData.setRange(0, maxNodeNameSize, nodeStateByteData, 12 + maxNodeNum * 4 + i * maxNodeNameSize);
              final nodeName = utf8.decode(nodeNameByteData);
              logger.i('NodeID: $nodeId, NodeName: $nodeName');

              nodes[nodeId] = nodeName;
              }
            final userData = ref.watch(userDataProvider);
            ref.read(userDataProvider.notifier).state = userData?.copyWith(nodeInfo: nodes);
            break;
          case 1:
            // Node ID 1の処理
            break;
          case 2:
            // Node ID 2の処理
            break;
          default:
            break;
        }

      }
    }
  }

}