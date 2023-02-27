class Ticker {
  final String eventType;
  final int eventTime;
  final String symbol;
  final String lastPrice;
  final String openPrice;
  final String highPrice;
  final String lowPrice;
  final String volume;
  final String quoteAssetVolume;

  Ticker({
    required this.eventType,
    required this.eventTime,
    required this.symbol,
    required this.lastPrice,
    required this.openPrice,
    required this.highPrice,
    required this.lowPrice,
    required this.volume,
    required this.quoteAssetVolume,
  });

  factory Ticker.fromJson(Map<String, dynamic> json) {
    return Ticker(
      eventType: json['e'],
      eventTime: json['E'],
      symbol: json['s'],
      lastPrice: json['c'],
      openPrice: json['o'],
      highPrice: json['h'],
      lowPrice: json['l'],
      volume: json['v'],
      quoteAssetVolume: json['q'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['e'] = eventType;
    data['E'] = eventTime;
    data['s'] = symbol;
    data['c'] = lastPrice;
    data['o'] = openPrice;
    data['h'] = highPrice;
    data['l'] = lowPrice;
    data['v'] = volume;
    data['q'] = quoteAssetVolume;

    return data;
  }
}
