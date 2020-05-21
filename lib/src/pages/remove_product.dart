import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:quagga/src/model/data.dart';
import 'package:quagga/src/model/product.dart';
import 'package:quagga/src/themes/light_color.dart';
import 'package:quagga/src/utils/utils.dart';
import 'package:http/http.dart' as http;


class RemoveProduct extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RemoveProductState();
  }
}

class RemoveProductState extends State<RemoveProduct> {
  Future<List<Product>> _productList;

  ProgressDialog _progressDialog;

  @override
  void initState() {
    super.initState();

    _productList = AppData.fetchAllStoreProducts('');
  }

  @override
  Widget build(BuildContext context) {
    _progressDialog = Utils.initializeProgressDialog(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Remove Product'),
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: FutureBuilder(
        future: _productList,
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

              ///task is complete with some data
              return _drawListView(snapshot.data);
          }
          return null;
        },
      ),
    );
  }

  Widget _drawListView(data) {
    return Container(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
                  child: Card(
                    child: ListTile(
                      title: Text(data[index].name),
                      trailing: GestureDetector(
                        child: Icon(
                          Icons.delete_outline,
                          color: LightColor.orange,
                        ),
                        onTap: () async {
                          bool response = await requestAndWaitForAction(
                              context,
                              'Do you want to remove this product from store ?');

                          if(response){
                            _progressDialog.show();
                           bool status = await _deleteProduct(data[index].id);

                            Future.delayed(Duration(seconds: 1)).then((value){
                              _progressDialog.hide().whenComplete((){
                                Utils.showStatus(context, status, "Product deleted");

                                setState(() {
                                  _productList = AppData.fetchAllStoreProducts('');
                                });
                              });
                            });

                          }
                        },
                      ),
                      onTap: () {},
                    ),
                  ));
            })
    );
  }


  Future<bool> requestAndWaitForAction(
      BuildContext context, String message) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text("Yes", style: TextStyle(color: Colors.red[300]),),
                onPressed: () => Navigator.pop(context, true),
              ),
              FlatButton(
                child: Text("No", style: TextStyle(color: Colors.green),),
                onPressed: () => Navigator.pop(context, true),
              )
            ],
          );
        });
  }

  Future<bool> _deleteProduct(id) async{
    String url = Utils.url + '/api/products?id=$id';

    try{
      var res = await http.delete(url, headers: {'Authorization': Utils.token});

      if(res.statusCode == 200){
        return true;
      }else{
        return false;
      }
    } catch(e){
      return false;
    }
  }
}
