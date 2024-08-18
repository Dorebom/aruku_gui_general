class CommonCmdCode {
  final int sourcePort;
  final int destinationPort;
  final int priority;
  final int cmdId;
  final int cmdType;
  final int dataSize;
  final bool isSysCmd;
  final bool isUsedMesgpack;

  CommonCmdCode({
    this.sourcePort = 0,
    this.destinationPort = 0,
    this.priority = 0,
    this.cmdId = 0,
    this.cmdType = 0,
    this.dataSize = 0,
    this.isSysCmd = false,
    this.isUsedMesgpack = false,
  });

  CommonCmdCode copyWith({
    int? sourcePort,
    int? destinationPort,
    int? priority,
    int? cmdId,
    int? cmdType,
    int? dataSize,
    bool? isSysCmd,
    bool? isUsedMesgpack,
  }) {
    return CommonCmdCode(
      sourcePort: sourcePort ?? this.sourcePort,
      destinationPort: destinationPort ?? this.destinationPort,
      priority: priority ?? this.priority,
      cmdId: cmdId ?? this.cmdId,
      cmdType: cmdType ?? this.cmdType,
      dataSize: dataSize ?? this.dataSize,
      isSysCmd: isSysCmd ?? this.isSysCmd,
      isUsedMesgpack: isUsedMesgpack ?? this.isUsedMesgpack,
    );
  }
}