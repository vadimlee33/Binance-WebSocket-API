import 'dart:async';

import 'package:binance_task/Models/ticker_obj.dart';
import 'package:binance_task/MainScreen/binance_ticker_bloc.dart';

class TickerSearchBloc {
  final _tickersController = StreamController<List<Ticker>>.broadcast();
  Stream<List<Ticker>> get tickersStream => _tickersController.stream;

  List<Ticker> _tickers = [];
  String _searchQuery = '';

  void start() {
    binanceTickerBloc.tickersStream.listen((tickers) {
      _tickers = tickers;
      _search();
    });
  }

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _search();
  }

  void _search() {
    final filteredTickers = _tickers.where((ticker) {
      final symbol = ticker.symbol.toLowerCase();
      return symbol.contains(_searchQuery);
    }).toList();
    _tickersController.add(filteredTickers);
  }

  void dispose() {
    _tickersController.close();
  }
}

final tickerSearchBloc = TickerSearchBloc();