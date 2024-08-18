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

  factory CommonStateCode.fromBytes(List<int> bytes) {
    return CommonStateCode(
      //       byteData.setInt32(0, 255, Endian.little); // int source
      // リトルエンディアンでbytes[0]を4バイトの整数に変換
      
      nodeId: bytes[0],
      stateMachine: bytes[1],
      transitDestinationNodeStateMachine: bytes[2],
      dataSize: bytes[3],
    );
  }
}