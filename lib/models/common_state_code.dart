import 'dart:typed_data';

class CommonStateCode {
  final int nodeId;
  final int stateMachine;
  final int transitDestinationNodeStateMachine;
  final int dataSize;

  CommonStateCode({
    this.nodeId = 0,
    this.stateMachine = 0,
    this.transitDestinationNodeStateMachine = 0,
    this.dataSize = 0,
  });

  CommonStateCode copyWith({
    int? nodeId,
    int? stateMachine,
    int? transitDestinationNodeStateMachine,
    int? dataSize,
  }) {
    return CommonStateCode(
      nodeId: nodeId ?? this.nodeId,
      stateMachine: stateMachine ?? this.stateMachine,
      transitDestinationNodeStateMachine: transitDestinationNodeStateMachine ?? this.transitDestinationNodeStateMachine,
      dataSize: dataSize ?? this.dataSize,
    );
  }

  factory CommonStateCode.fromBytes(Uint8List bytes) {
    return CommonStateCode(
      //       byteData.setInt32(0, 255, Endian.little); // int source
      // リトルエンディアンでbytes[0]を4バイトの整数に変換

      nodeId: bytes.buffer.asByteData(0, 4).getInt32(0, Endian.little),
      stateMachine: bytes.buffer.asByteData(4, 4).getInt32(0, Endian.little),
      transitDestinationNodeStateMachine: bytes.buffer.asByteData(8, 4).getInt32(0, Endian.little),
      dataSize: bytes.buffer.asByteData(12, 4).getInt32(0, Endian.little),
    );
  }
}
