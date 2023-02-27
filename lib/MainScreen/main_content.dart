import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:binance_task/MainScreen/color_bloc.dart';
import 'package:binance_task/MainScreen/ticker_search_bloc.dart';
import 'package:binance_task/Models/ticker_obj.dart';
import 'package:binance_task/MainScreen/binance_ticker_bloc.dart';
import 'package:binance_task/Utils/constants.dart';

class MainContent extends StatefulWidget {
  const MainContent({super.key});

  @override
  State createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [_buildSearchBar(), _buildMainContent()]),
        ));
  }
}

Widget _buildSearchBar() => Container(
    margin: const EdgeInsets.only(top: 14, left: 20, right: 20),
    child: CupertinoSearchTextField(
      placeholder: searchHintLabel,
      prefixIcon: const Icon(CupertinoIcons.search, color: greyColor),
      prefixInsets: const EdgeInsetsDirectional.fromSTEB(6, 4, 2, 4),
      suffixIcon:
          const Icon(CupertinoIcons.xmark_circle_fill, color: greyColor),
      backgroundColor: searchBarColor,
      style: const TextStyle(color: greyColor),
      placeholderStyle: const TextStyle(color: greyColor, fontSize: 16),
      onChanged: (String value) {
        tickerSearchBloc.setSearchQuery(value);
      },
      onSubmitted: (String value) {
        tickerSearchBloc.setSearchQuery(value);
      },
    ));

Widget _buildMainContent() {
  binanceTickerBloc.start();
  tickerSearchBloc.start();
  return StreamBuilder<List<Ticker>>(
    stream: tickerSearchBloc.tickersStream,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        binanceTickerBloc.dispose();
        return buildList(snapshot);
      } else if (snapshot.hasError) {
        // Throw an error
        return Text('Error: ${snapshot.error}');
      } else {
        // Show a loading indicator
        return Center(
          child: Container(
              margin: const EdgeInsets.only(top: 250),
              height: 50.0,
              width: 50.0,
              child: const CircularProgressIndicator()),
        );
      }
    },
  );
}

Widget buildList(AsyncSnapshot<List<Ticker>> snapshot) {
  return Expanded(
      child: Container(
          margin: const EdgeInsets.only(top: 20, bottom: 20),
          child: GridView.builder(
              padding: const EdgeInsets.only(left: 20, right: 20),
              itemCount: snapshot.data!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisExtent: 80,
              ),
              itemBuilder: (BuildContext context, int index) {
                final ticker = snapshot.data![index];

                // Calculate a difference between open and close prices
                final difference = (((double.parse(ticker.lastPrice) -
                            double.parse(ticker.openPrice)) /
                        double.parse(ticker.openPrice)) *
                    100);

                // Initialize Color Bloc
                final colorBloc = ColorBloc();
                // Set the color
                final colorEvent = difference > 0
                    ? ColorEvent.eventGreen
                    : ColorEvent.eventRed;
                colorBloc.inputEventSink.add(colorEvent);

                // Transform the floating-point value into a string and substitute any decimal points with commas.
                final diffString = difference > 0
                    ? "+${difference.toStringAsFixed(2).replaceAll('.', ',')} %"
                    : "${difference.toStringAsFixed(2).replaceAll('.', ',')} %";
                // Remove trailing zeros and replace substitute any decimal points with commas
                final priceString = ticker.lastPrice
                    .replaceAll(RegExp(r'(?<=\.\d*?)0+$'), '')
                    .replaceAll('.', ',');
                // Remove trailing zeros and replace substitute any decimal points with commas
                final openPriceString = ticker.openPrice
                    .replaceAll(RegExp(r'(?<=\.\d*?)0+$'), '')
                    .replaceAll('.', ',');

                return StreamBuilder<Color>(
                    stream: colorBloc.outputStateStream,
                    initialData: redColor,
                    builder: (context, snapshotColor) {
                      return Row(
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      ticker.symbol.substring(
                                          0, ticker.symbol.length - 4),
                                      style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: whiteColor,
                                          fontFamily: 'Titillium Web'),
                                    ),
                                    Text(
                                      " /${ticker.symbol.substring(ticker.symbol.length - 4)}",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: greyColor,
                                          fontFamily: 'Barlow'),
                                    ),
                                  ],
                                ),
                                Text(
                                    'Vol ${(double.parse(ticker.quoteAssetVolume) / 1000000).toStringAsFixed(2)}M'
                                        .replaceAll('.', ','),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: greyColor,
                                        fontFamily: 'Barlow'))
                              ]),
                          const Spacer(),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(priceString,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'Barlow',
                                      color: snapshotColor.data,
                                    )),
                                Text("$openPriceString \$",
                                    style: const TextStyle(
                                        fontFamily: 'Barlow',
                                        color: greyColor,
                                        fontSize: 16))
                              ]),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: 103,
                                height: 45,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: snapshotColor.data,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Center(
                                  child: Text(
                                    diffString,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Barlow',
                                        fontSize: 18),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      );
                    });
              })));
}
