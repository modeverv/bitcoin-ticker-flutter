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
  String btc = '3000';
  String eth = '4000';
  String ltc = '5000';

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

  void setVirtualMoneyValue() async {
    print(currency);
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
    await myApi.get('BTC', currency, (double rate) {
      setState(() {
        print('BTC - $currency - $rate');
        this.btc = rate.toStringAsFixed(0);
      });
    });
    await myApi.get('ETH', currency, (double rate) {
      setState(() {
        print('ETH - $currency - $rate');
        this.eth = rate.toStringAsFixed(0);
      });
    });
    await myApi.get('LTC', currency, (double rate) {
      setState(() {
        print('LTC - $currency - $rate');
        this.ltc = rate.toStringAsFixed(0);
      });
    });
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
              children: [
                Card(
                  color: Colors.lightBlueAccent,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                    child: Text(
                      '1 BTC = $btc $currency',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Card(
                  color: Colors.lightBlueAccent,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                    child: Text(
                      '1 ETH = $eth $currency',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Card(
                  color: Colors.lightBlueAccent,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                    child: Text(
                      '1 LTC = $ltc $currency',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
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
