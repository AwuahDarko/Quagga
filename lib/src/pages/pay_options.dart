import 'package:flutter/material.dart';
import 'package:quagga/src/pages/mobile_money_payment.dart';


class PayOptions extends StatelessWidget {
  PayOptions(this.totalAmount);
  final double totalAmount;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.2;
    double height = MediaQuery.of(context).size.width * 0.2;
    return Scaffold(
      appBar: AppBar(
        title: Text('How do you want to pay?'),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 10,),
          ListTile(
            leading: Image.asset('assets/mtn.png', width: width, height: height,),
            title: Text('MTN MoMo'),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => MobileMoneyPayment(totalAmount, false, 'MTN')));
            },
          ),
          SizedBox(height: 10,),
          ListTile(
            leading: Image.asset('assets/tigo.jpeg', width: width, height: height,),
            title: Text('ATMoney'),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => MobileMoneyPayment(totalAmount, false, 'AIR')));
            },
          ),
          SizedBox(height: 10,),
          ListTile(
            leading: Image.asset('assets/voda.jpg', width: width , height: height ,),
            title: Text('Vadafone Cash'),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => MobileMoneyPayment(totalAmount, true, "VOD")));
            },
          ),
          SizedBox(height: 10,),
          ListTile(
            leading: Image.asset('assets/card.jpg', width: width, height: height ,),
            title: Text('Card'),
            onTap: (){},
          )
        ],
      ),
    );
  }

}