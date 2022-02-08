import 'dart:io';

import 'package:bitcoin_ticker/http_and_coin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String currency = currenciesList.first;

  @override
  void initState() {
    super.initState();
    setVirtualMoneyValue();
  }

  List<DropdownMenuItem> getPullDownItems() {
    return currenciesList
        .map((e) => DropdownMenuItem(
              child: Text(e),
              value: e,
            ))
        .toList();
  }

  HttpCoinGet myApi = HttpCoinGet();

  bool isWaiting = true;

  void setVirtualMoneyValue() async {
    isWaiting = true;
    /*
    await Future.wait([
      myApi.get('BTC', currency, (double rate) {
        setState(() {
          print('BTC - $currency - $rate');
          this.btc = rate.toStringAsFixed(0);
        });
      }),
      myApi.get('ETH', currency, (double rate) {
        setState(() {
          print('ETH - $currency - $rate');
          this.eth = rate.toStringAsFixed(0);
        });
      }),
      myApi.get('LTC', currency, (double rate) {
        setState(() {
          print('LTC - $currency - $rate');
          this.ltc = rate.toStringAsFixed(0);
        });
      }),
    ]);
    */
    var coinList = coins.keys.toList();
    for (int i = 0, l = coinList.length; i < l; i++) {
      print('$currency ${coinList[i]}');
      await myApi.get(coinList[i], currency, (double rate) {
        setState(() {
          print('$key to $currency is $rate');
          this.coins[coinList[i]] = rate.toStringAsFixed(0);
        });
      });
    }
    isWaiting = false;
    print('done');
  }

  void setIOSSelect2Currency(int index) {
    setState(() {
      currency = currenciesList[index];
      print(currency);
    });
  }

  Widget getPicker() {
    if (Platform.isIOS) {
      return CupertinoPicker(
        itemExtent: 32.0,
        children: currenciesList.map((e) => Text(e)).toList(),
        backgroundColor: Colors.lightBlue,
        onSelectedItemChanged: (selected) {
          setIOSSelect2Currency(selected);
          print(selected);
          setVirtualMoneyValue();
        },
      );
    } else {
      return DropdownButton(
        value: currency,
        items: getPullDownItems(),
        onChanged: (value) {
          setState(() {
            currency = value;
            setVirtualMoneyValue();
          });
        },
      );
    }
  }

  Map<String, String> coins = {'BTC': '0', 'ETH': '0', 'LTC': '0'};

  List<Widget> makeCard() {
    List<Widget> ll = [];
    var coinList = coins.keys.toList();
    for (var i = 0, l = coinList.length; i < l; i++) {
      String coinString = '1 ${coinList[i]} = ' +
          (isWaiting ? '?' : '${coins[coinList[i]]} $currency');
      ll.add(
        MyCard(
          coinString: coinString,
        ),
      );
    }
    return ll;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: makeCard(),
            ),
          ),
          Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: getPicker()),
        ],
      ),
    );
  }
}

class MyCard extends StatelessWidget {
  const MyCard({
    Key key,
    @required this.coinString,
  }) : super(key: key);

  final String coinString;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlueAccent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
        child: Text(
          coinString,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
