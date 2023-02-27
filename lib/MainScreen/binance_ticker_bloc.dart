import 'dart:async';
import 'dart:convert';

import 'package:binance_task/Models/ticker_obj.dart';
import 'package:web_socket_channel/io.dart';

class BinanceTickerBloc {
  final _tickersController = StreamController<List<Ticker>>.broadcast();
  Stream<List<Ticker>> get tickersStream => _tickersController.stream;

  final IOWebSocketChannel _channel;

  BinanceTickerBloc()
      : _channel = IOWebSocketChannel.connect(
            'wss://stream.binance.com:9443/ws/!miniTicker@arr');

  void start() {
    _channel.stream.listen((message) {
      final List<dynamic> data = jsonDecode(message);
      final List<Ticker> tickers = data
          .map((tickerJson) => Ticker.fromJson(tickerJson))
          .where((ticker) => ticker.symbol.endsWith("USDT"))
          .toList();
      _tickersController.add(tickers);
    }, onError: (error) {
      _tickersController.addError(error);
    }, onDone: () {
      _tickersController.close();
    });
  }

  void dispose() {
    _channel.sink.close();
  }
}

final binanceTickerBloc = BinanceTickerBloc();
