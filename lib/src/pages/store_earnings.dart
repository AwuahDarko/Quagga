import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:quagga/src/model/store_earnings_model.dart';
import 'package:quagga/src/utils/utils.dart';
import 'package:quagga/src/wigets/bidirectional_listview.dart';


class StoreEarnings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StoreEarningsState();
  }
}

class StoreEarningsState extends State<StoreEarnings> {
  Future<List<EarningData>> _tableData;

  @override
  void initState() {
    super.initState();
    _tableData = _getEarnings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Earnings"),
      ),
      body: FutureBuilder(
        future: _tableData,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return CircularProgressIndicator();
            case ConnectionState.waiting:
              return Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)));

            case ConnectionState.active:
              return Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)));
              break;
            case ConnectionState.done:
              if (snapshot.hasError)
                return Center(
                    child: Text(
                  'Error:\n\n Network Error ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ));

              ///task is complete with some data
              return _drawTable(snapshot.data);
          }
          return null;
        },
      ),
    );
  }

  Widget _drawTable(List<EarningData> data) {
//    data.sort((a, b) => a.name.compareTo(b.name));
    return BidirectionalScrollViewPlugin(
      child: DataTable(
          onSelectAll: (b) {},
          sortColumnIndex: 3,
          sortAscending: true,
          columns: <DataColumn>[
            DataColumn(
              label: Text("Trans. ID.",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
              numeric: false,
              onSort: (i, b) {
                setState(() {
                  data.sort((a, b) =>
                      a.transactionNumber.compareTo(b.transactionNumber));
                });
              },
              tooltip: "Displays transaction identity numbers",
            ),
            DataColumn(
              label: Text("Amt / GH\u20B5",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
              numeric: false,
              onSort: (i, b) {
                setState(() {
                  data.sort((a, b) => a.amount.compareTo(b.amount));
                });
              },
              tooltip: "Displays your earnings for each transaction",
            ),
            DataColumn(
              label: Text("Payment",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
              numeric: false,
              onSort: (i, b) {
                setState(() {
                  data.sort((a, b) => a.date.compareTo(b.date));
                });
              },
              tooltip: "Shows whether money is paid or not",
            ),
            DataColumn(
              label: Text("Date",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
              numeric: false,
              onSort: (i, b) {
                setState(() {
                  data.sort((a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));//a.date.compareTo(b.date)
                });
              },
              tooltip: "Displays date the transaction was confirmed",
            ),
          ],
          rows: data
              .map(
                (oneData) => DataRow(
                  cells: [
                    DataCell(
                      Text(oneData.transactionNumber),
                      showEditIcon: false,
                      placeholder: false,
                    ),
                    DataCell(
                      Text(oneData.amount.toStringAsFixed(2)),
                      showEditIcon: false,
                      placeholder: false,
                    ),
                    DataCell(
                      Text(oneData.paid),
                      showEditIcon: false,
                      placeholder: false,
                    ),
                    DataCell(
                      Text(oneData.date),
                      showEditIcon: false,
                      placeholder: false,
                    ),
                  ],
                ),
              )
              .toList()),
    );
  }

  Future<List<EarningData>> _getEarnings() async {
    String url = Utils.url + '/api/store-earnings';

    var res = await http.get(url, headers: {'Authorization': Utils.token});

    url = Utils.url + '/api/admin/get';

    var res2 = await http.get(url, headers: {'Authorization': Utils.token});

    var discount = 0.00;
    if (res2.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(res2.body);
      discount = map['discount'];
    }

    List<EarningData> mList = [];

    if (res.statusCode == 200) {

      List<dynamic> dataList = jsonDecode(res.body);


      dataList.forEach((oneEarning) {
        List<String> q = oneEarning['created_at'].split('T');
//        List<String> w = q[0].split('-');
//        String d = '${w[2]}/${w[1]}/${w[0]}';
        mList.add(EarningData(
            'FAL ${oneEarning['transaction_id'].toString()}',
            oneEarning['amount'] - (discount * 0.01 * oneEarning['amount']),
            q[0],
            oneEarning['payment']));

      });
    }

    return mList;
  }
}
