import 'package:flutter/material.dart';
import 'package:quagga/src/wigets/title_text.dart';




class PhotoOption extends StatelessWidget{

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
          width: MediaQuery.of(context).size.width * 0.75,
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
          child: ListView(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Take a photo from camera'),
                onTap: () => Navigator.pop(context, 2)
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Get photo from gallery'),
                onTap: () => Navigator.pop(context, 1),
              )
            ],
          )
      ),
    );



  }
}
