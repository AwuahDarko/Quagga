import 'package:flutter/material.dart';
import 'package:quagga/src/model/data.dart';
import 'package:quagga/src/model/order_summary.dart';
import 'package:quagga/src/utils/utils.dart';


class MyOrders extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return MyOrdersState();
  }

}


class MyOrdersState extends State<MyOrders>{

  Future<List<OrderSummary>> _orderList;

  @override
  void initState() {
    super.initState();
    _orderList = AppData.getOrderSummary(Utils.customerInfo.userID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Orders"),),
      body: FutureBuilder(
        future: _orderList,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)));
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
                      'Error:\n\n Network Error',
                      textAlign: TextAlign.center,
                      style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ));

              return _drawListView(snapshot.data);
          }
          return null;
        },
      ),
    );
  }


  Widget _drawListView(data){
    return Container(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
                  child: Card(
                    child: ListTile(
                        onTap: () {
                          if (data[index].selected) {
                            setState(() {
//                              _setCheck(data[index], false);
                            });
                          } else {
                            setState(() {
//                              _setCheck(data[index], true);
                            });
                          }
                        },
                        leading:
                        Icon(Icons.timer_off, color: Color(0xFF000080)),
                        title: Text(data[index].name),
                        subtitle: Text(
                          data[index].subTitle,
                          style: TextStyle(color: Color(0xFF4B0082)),
                        ),
                        trailing: Checkbox(
                          value: data[index].selected,
                          onChanged: (newValue) {
                            if (newValue) {
                              setState(() {
//                                _setCheck(data[index], newValue);
                              });
                            } else {
                              setState(() {
//                                _setCheck(data[index], newValue);
                              });
                            }
                          },
                        )),
                  ));
            }));
  }

}