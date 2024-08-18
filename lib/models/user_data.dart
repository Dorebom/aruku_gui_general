class UserData {
  final String text;
  final int a;
  final int b;

  final String srcIpAddress;
  final int srcPort;
  final String dstIpAddress;
  final int dstPort;
  final bool shouldNavigateHome;
  final bool isUdpConnected;
  final bool isSendingUdpConnectMessage;

  UserData({
    this.text = '',
    this.a = 0,
    this.b = 0,
    this.srcIpAddress = '127.0.0.1',
    this.srcPort = 50121,
    this.dstIpAddress = '127.0.0.1',
    this.dstPort = 50120,
    this.shouldNavigateHome = false,
    this.isUdpConnected = false,
    this.isSendingUdpConnectMessage = false,
  });

  UserData copyWith({
    String? text,
    int? a,
    int? b,
    String? srcIpAddress,
    int? srcPort,
    String? dstIpAddress,
    int? dstPort,
    bool? shouldNavigateHome,
    bool? isUdpConnected,
    bool? isSendingUdpConnectMessage,
  }) {
    return UserData(
      text: text ?? this.text,
      a: a ?? this.a,
      b: b ?? this.b,
      srcIpAddress: srcIpAddress ?? this.srcIpAddress,
      srcPort: srcPort ?? this.srcPort,
      dstIpAddress: dstIpAddress ?? this.dstIpAddress,
      dstPort: dstPort ?? this.dstPort,
      shouldNavigateHome: shouldNavigateHome ?? this.shouldNavigateHome,
      isUdpConnected: isUdpConnected ?? this.isUdpConnected,
      isSendingUdpConnectMessage: isSendingUdpConnectMessage ?? this.isSendingUdpConnectMessage,
    );
  }
}