import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';
import 'package:getflutter/shape/gf_avatar_shape.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:quagga/src/model/data.dart';
import 'package:quagga/src/model/product.dart';
import 'package:quagga/src/utils/utils.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:async/async.dart';

class ProductUpdate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProductUpdateState();
  }
}

class ProductUpdateState extends State<ProductUpdate> {
  final _formKey = GlobalKey<FormState>();
  final _pName = TextEditingController();
  final _description = TextEditingController();
  final _minOrder = TextEditingController();
  final _numStock = TextEditingController();
  final _price = TextEditingController();

  String name = '';
  String des = '';
  String min = '';
  String num = '';
  String pri = '';

  File _image_1;
  File _image_2;
  File _image_3;
  File _image_4;
  ProgressDialog _progressDialog;
  Product _product;

  int _productId;

  bool _textChange = false;
  bool _imageChange = false;

  List<Product> _productList = [];

  bool _newImage1 = false;
  bool _newImage2 = false;
  bool _newImage3 = false;
  bool _newImage4 = false;


  @override
  void initState() {
    super.initState();

    // listeners
    _pName.addListener(() {
      if (name != _pName.text) {
        _textChange = true;
      }
    });

    _description.addListener(() {
      if (des != _description.text) {
        _textChange = true;
      }
    });

    _minOrder.addListener(() {
      if (min != _minOrder.text) {
        _textChange = true;
      }
    });

    _numStock.addListener(() {
      if (num != _numStock.text) {
        _textChange = true;
      }
    });

    _price.addListener(() {
      if (pri != _price.text) {
        _textChange = true;
      }
    });

    AppData.fetchAllStoreProducts('').then((list) {
      _productList.clear();
      _productList = List.from(list);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    _progressDialog = Utils.initializeProgressDialog(context);
    TextFormField productName = TextFormField(
      controller: _pName,
      autofocus: false,
      keyboardType: TextInputType.text,
      inputFormatters: [
        LengthLimitingTextInputFormatter(45),
      ],
      decoration: InputDecoration(
          labelText: 'Product Name', labelStyle: TextStyle(color: Colors.grey)),
      validator: (value) {
        if (value.isEmpty) {
          return 'Product must have a name';
        }
        return null;
      },
    );

    Card productDescription = Card(
        color: Colors.white,
        child: TextFormField(
          autofocus: false,
          controller: _description,
          maxLines: 10,
          keyboardType: TextInputType.text,
          inputFormatters: [
            LengthLimitingTextInputFormatter(500),
          ],
          decoration: InputDecoration(
              labelText: 'Enter product description here',
              hintText: "Enter product description here",
              labelStyle: TextStyle(color: Colors.grey)),
          validator: (value) {
            if (value.isEmpty) {
              return "Enter product description here";
            }
            return null;
          },
        ));

    TextFormField minOrder = TextFormField(
      autofocus: false,
      controller: _minOrder,
      inputFormatters: [
        LengthLimitingTextInputFormatter(10),
      ],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          labelText: 'Min. Order',
          hintText: 'Min. Order',
          labelStyle: TextStyle(color: Colors.grey)),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter a minimum order';
        }
        return null;
      },
    );

    TextFormField numberInStock = TextFormField(
      autofocus: false,
      controller: _numStock,
      inputFormatters: [
        LengthLimitingTextInputFormatter(10),
      ],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          labelText: 'Quantity in stock',
          hintText: 'Quantity in stock',
          labelStyle: TextStyle(color: Colors.grey)),
      validator: (value) {
        if (value.isEmpty) {
          return 'How many is in stock';
        }
        return null;
      },
    );

    TextFormField _inputPrice = TextFormField(
      autofocus: false,
      controller: _price,
      inputFormatters: [
        LengthLimitingTextInputFormatter(10),
      ],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          labelText: 'Price',
          hintText: 'Price',
          labelStyle: TextStyle(color: Colors.grey)),
      validator: (value) {
        if (value.isEmpty) {
          return 'What is the price?';
        }
        return null;
      },
    );

    DropdownButton productMenu = DropdownButton(
      hint: Text('Select product'), // Not necessary for Option 1
      value: _product,
      onChanged: (newValue) {
        setState(() {
          _product = newValue;
          name = _pName.text = _product.name;
          des = _description.text = _product.description;
          min = _minOrder.text = _product.minOrder.toString();
          num = _numStock.text = _product.numberInStock.toString();
          pri = _price.text = _product.price.toString();
          _productId = _product.id;

          // reset stuff
          _textChange = false;
          _imageChange = false;
          _newImage4 = false;
          _newImage3 = false;
          _newImage2 = false;
          _newImage1 = false;
        });
      },
      items: _productList.map((prod) {
        return DropdownMenuItem(
          child: new Text(prod.name),
          value: prod,
        );
      }).toList(),
    );

    StaggeredGridView content = StaggeredGridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12.0,
      mainAxisSpacing: 12.0,
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      children: <Widget>[
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 10.0),
              productMenu,
              productName,
              minOrder,
              numberInStock,
              _inputPrice,
              productDescription,
              SizedBox(height: 15.0),
            ],
          ),
        ),
        GestureDetector(
          child: GFAvatar(
              child: Icon(Icons.camera),
              backgroundImage: imageOne(),
              shape: GFAvatarShape.standard),
          onTap: () {
            Utils.photoOptionDialog(context).then((value) {
              if (value == 2) {
                Utils.getImageFromCamera(context).then((file) {
                  _image_1 = file;
                  if (_image_1 != null) {
                    _newImage1 = true;
                    _imageChange = true;

                  }
                  setState(() {});
                });
              } else if (value == 1) {
                Utils.getImageFromGallery(context).then((file) {
                  _image_1 = file;
                  if (_image_1 != null) {
                    _newImage1 = true;
                    _imageChange = true;

                  }
                  setState(() {});
                });
              }
            });
          },
        ),
        GestureDetector(
          child: GFAvatar(
              child: Icon(Icons.camera),
              backgroundImage: imageTwo(),
              shape: GFAvatarShape.standard),
          onTap: () {
            Utils.photoOptionDialog(context).then((value) {
              if (value == 2) {
                Utils.getImageFromCamera(context).then((file) {
                  _image_2 = file;
                  if (_image_2 != null) {
                    _newImage2 = true;
                    _imageChange = true;

                  }
                  setState(() {});
                });
              } else if (value == 1) {
                Utils.getImageFromGallery(context).then((file) {
                  _image_2 = file;
                  if (_image_2 != null) {
                    _newImage2 = true;
                    _imageChange = true;

                  }
                  setState(() {});
                });
              }
            });
          },
        ),
        GestureDetector(
          child: GFAvatar(
              child: Icon(Icons.camera),
              backgroundImage: imageThree(),
              shape: GFAvatarShape.standard),
          onTap: () {
            Utils.photoOptionDialog(context).then((value) {
              if (value == 2) {
                Utils.getImageFromCamera(context).then((file) {
                  _image_3 = file;
                  if (_image_3 != null) {
                    _newImage3 = true;
                    _imageChange = true;

                  }
                  setState(() {});
                });
              } else if (value == 1) {
                Utils.getImageFromGallery(context).then((file) {
                  _image_3 = file;
                  if (_image_3 != null) {
                    _newImage3 = true;
                    _imageChange = true;

                  }
                  setState(() {});
                });
              }
            });
          },
        ),
        GestureDetector(
          child: GFAvatar(
              child: Icon(Icons.camera),
              backgroundImage: imageFour(),
              shape: GFAvatarShape.standard),
          onTap: () {
            Utils.photoOptionDialog(context).then((value) {
              if (value == 2) {
                Utils.getImageFromCamera(context).then((file) {
                  _image_4 = file;
                  if (_image_4 != null) {
                    _newImage4 = true;
                    _imageChange = true;

                  }
                  setState(() {});
                });
              } else if (value == 1) {
                Utils.getImageFromGallery(context).then((file) {
                  _image_4 = file;
                  if (_image_4 != null) {
                    _newImage4 = true;
                    _imageChange = true;

                  }
                  setState(() {});
                });
              }
            });
          },
        ),
      ],
      staggeredTiles: [
        StaggeredTile.fit(2),
        StaggeredTile.extent(1, 130.0),
        StaggeredTile.extent(1, 130.0),
        StaggeredTile.extent(1, 130.0),
        StaggeredTile.extent(1, 130.0),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("Update Product"),
        actions: <Widget>[
          Container(
            width: 80,
            child: IconButton(
              icon: Text(
                'Save',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                if (!_textChange && !_imageChange) {
                  Fluttertoast.showToast(
                      msg: 'No changes detected',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.black,
                      textColor: Colors.white);
                  return;
                }

                if (_formKey.currentState.validate()) {

                  Map<String, dynamic> body = {
                    "product_name": _pName.text,
                    "category_id": _product.id,
                    "description": _description.text,
                    "price": _price.text,
                    "min_order": _minOrder.text,
                    "number_in_stock": _numStock.text,
                    "discount": 0.0
                  };

                  _progressDialog.show().then((v) {
                    _updateNewProduct(body).then((result) {
                      if (result == false) {
                        Future.delayed(Duration(seconds: 1)).then((value) {
                          _progressDialog.hide().whenComplete(() {
                            Utils.showStatus(context, result, "");
                          });
                        });
                      } else {
                        _uploadImages(_productId).then((status) {
                          Future.delayed(Duration(seconds: 1)).then((value) {
                            _progressDialog.hide().whenComplete(() {
                              Utils.showStatus(
                                  context, status, "Product updated");
                            });
                          });
                        });
                      }
                    });
                  });
                }
              },
            ),
          )
        ],
      ),
      body: content,
    );
  }

  void showInvalid(BuildContext context, String message) {
    var alertDialog = AlertDialog(
        title: Text(
          "Invalid",
          style: TextStyle(fontSize: 20, color: Colors.green),
        ),
        content: Text(message));

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  Future<bool> _updateNewProduct(Map<String, dynamic> body) async {
    String url = Utils.url + "/api/products";

    String json = jsonEncode(body);

    try{
      var res = await http.put(url,
          headers: {
            "Authorization": Utils.token,
            "Content-Type": "application/json"
          },
          body: json);

      if (res.statusCode == 200 || res.statusCode == 201) {

        return true;
      } else {
        return false;
      }
    }catch(e){
      return false;
    }
  }

  Future<bool> _uploadImages(int productID) async {
    String url = Utils.url + "/api/product-image";

    List<File> allFiles = [];
    if (_image_1 != null) {
      allFiles.add(_image_1);
    }
    if (_image_2 != null) {
      allFiles.add(_image_2);
    }
    if (_image_3 != null) {
      allFiles.add(_image_3);
    }
    if (_image_4 != null) {
      allFiles.add(_image_4);
    }

    if(allFiles.length == 0){
      return true;
    }

//    FormData formData = FormData.fromMap({
//      "product_image": allFiles
//          .map((oneFile) => MultipartFile.fromFileSync(oneFile.path,
//              filename: oneFile.path.split("/").last))
//          .toList(),
//      "product_id": productID
//    });
//
//    Dio dio = Dio();
//    dio.options.headers["Authorization"] = Utils.token;
//    var res = await dio.post(url, data: formData);
//
//    if (res.statusCode == 200 || res.statusCode == 201) {
//      return true;
//    } else {
//      return false;
//    }


    var uri = Uri.parse(url);
    try {
      var request = http.MultipartRequest('POST', uri);

      request.fields['product_id'] = productID.toString();
      request.headers['Authorization'] = Utils.token;

      for (var file in allFiles) {
        String fileName = file.path.split("/").last;
        var stream =
        new http.ByteStream(DelegatingStream.typed(file.openRead()));

        // get file length

        var length = await file.length(); // imageFile is your image file

        // multipart that takes file
        var multipartFileSign =
        new http.MultipartFile('image', stream, length, filename: fileName);

        request.files.add(multipartFileSign);
      }

      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  ImageProvider imageOne(){
    if(!_newImage1){
      if(_product == null){
        return null;
      }else if(_product.image.length >= 1){
        return  NetworkImage('${Utils.url}/api/images?url=${_product.image[0]}');
      }else{
        return null;
      }
    }else{
      return Image.file(_image_1).image;
    }
  }

  ImageProvider imageTwo(){
    if(!_newImage2){
      if(_product == null){
        return null;
      }else if(_product.image.length >= 2){
        return  NetworkImage('${Utils.url}/api/images?url=${_product.image[1]}');
      }else{
        return null;
      }
    }else{
      return Image.file(_image_2).image;
    }
  }

  ImageProvider imageThree(){
    if(!_newImage3){
      if(_product == null){
        return null;
      }else if(_product.image.length >= 3){
        return  NetworkImage('${Utils.url}/api/images?url=${_product.image[2]}');
      }else{
        return null;
      }
    }else{
      return Image.file(_image_3).image;
    }
  }

  ImageProvider imageFour(){
    if(!_newImage4){
      if(_product == null){
        return null;
      }else if(_product.image.length >= 4){
        return  NetworkImage('${Utils.url}/api/images?url=${_product.image[3]}');
      }else{
        return null;
      }
    }else{
      return Image.file(_image_4).image;
    }
  }
}
