import 'package:flutter/material.dart';
import 'package:quagga/src/wigets/title_text.dart';




class ItemQuantity extends StatefulWidget{
  final minOrder;
  final numberInStock;
  ItemQuantity(this.minOrder, this.numberInStock);
  
  @override
  State<StatefulWidget> createState() {
    return ItemQuantityState(this.minOrder, this.numberInStock);
  }

}


class ItemQuantityState extends State<ItemQuantity>{
  ItemQuantityState(this._minOrder, this._numberInStock){
    _quantity = _minOrder;
  }

  int _numberInStock;
  int _minOrder;
  int _quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        height: 130.0,
        width: 300.0,
        padding: const EdgeInsets.only(top: 10.0, left: 20),
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: const Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Center(
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: TitleText(
                  text: 'Quantity',
                  color: Colors.green,
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.remove_circle, color: Colors.green,),
                      onPressed: (){
                        setState(() {

                          if(_quantity > _minOrder){
                            _quantity -= _minOrder;
                          }
                        });
                      },
                    ),
                    Text('$_quantity', style: TextStyle(color: Colors.green,fontSize: 20),),
                    IconButton(
                      icon: Icon(Icons.add_circle, color: Colors.green),
                      onPressed: (){
                        setState(() {

                          if(_quantity < _numberInStock){
                            _quantity += _minOrder;
                          }
                        });
                      },
                    ),
                    Spacer()
                  ],
                ),
              ),
              Container(
                  child: Row(
                    children: <Widget>[
                      Spacer(),
                      FlatButton(
                        child: Icon(Icons.done, color: Colors.green[300],size: 30.0,),
                        onPressed: (){
                          Navigator.pop(context, {'res': true, 'val': _quantity});
                        },
                      ),
                      FlatButton(
                        child: Icon(Icons.clear, color: Colors.red[300],size: 30.0,),
                        onPressed: (){
                          Navigator.pop(context, {'res': false, 'val': _quantity});
                        },
                      ),
                    ],
                  )
              )
            ],
          ),
        )
      ),
    );



  }

}