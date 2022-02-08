import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

//import 'dart:convert' as convert;
//import 'package:http/http.dart' as http;
/*
curl https://rest.coinapi.io/v1/exchangerate/BTC/USD \
  --request GET
  --header "X-CoinAPI-Key: 73034021-THIS-IS-SAMPLE-KEY"
The above command returns JSON structured like this:

{
  "time": "2017-08-09T14:31:18.3150000Z",
  "asset_id_base": "BTC",
  "asset_id_quote": "USD",
  "rate": 3260.3514321215056208129867667
}
 */
const u = 'https://rest.coinapi.io/v1/exchangerate/';
const key = '74DA00E2-CE09-4DAC-BE05-516678B41DC6';

class HttpCoinGet {
  Future<double> get(String from, String to, Function f) async {
    var url = Uri.parse(u + from + '/' + to + '/?apiKey=$key');
    print(url);
    var rate = 0.0;
    http.Response response = await http.get(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      print(jsonResponse);
      rate = jsonResponse['rate'];
      f(rate);
      return rate;
    } else {
      return rate;
    }
  }
}
