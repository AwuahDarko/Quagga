import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';
import 'package:getflutter/shape/gf_avatar_shape.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:quagga/src/model/category.dart';
import 'package:quagga/src/model/data.dart';
import 'package:quagga/src/utils/utils.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';

class NewProduct extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NewProductState();
  }
}

class NewProductState extends State<NewProduct> {
  final _formKey = GlobalKey<FormState>();
  final _pName = TextEditingController();
  final _description = TextEditingController();
  final _minOrder = TextEditingController();
  final _numStock = TextEditingController();
  final _price = TextEditingController();

  File _image_1;
  File _image_2;
  File _image_3;
  File _image_4;
  ProgressDialog _progressDialog;
  Category _category;

  List<int> _loadedImages = [];

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
        color: Colors.white70,
        child: TextFormField(
          autofocus: false,
          controller: _description,
          maxLines: 10,
          keyboardType: TextInputType.text,
          inputFormatters: [
            LengthLimitingTextInputFormatter(500),
          ],
          decoration: InputDecoration(
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
          hintText: 'Min. Order', labelStyle: TextStyle(color: Colors.grey)),
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
          hintText: 'Price', labelStyle: TextStyle(color: Colors.grey)),
      validator: (value) {
        if (value.isEmpty) {
          return 'What is the price?';
        }
        return null;
      },
    );

    DropdownButton categoryMenu = DropdownButton(
      hint: Text('Select product category'), // Not necessary for Option 1
      value: _category,
      onChanged: (newValue) {
        setState(() {
          _category = newValue;
        });
      },
      items: AppData.categoryList.map((category) {
        return DropdownMenuItem(
          child: new Text(category.name),
          value: category,
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
              productName,
              minOrder,
              numberInStock,
              _inputPrice,
              productDescription,
//              categoryMenu,
              SizedBox(height: 15.0),
            ],
          ),
        ),
        GestureDetector(
          child: GFAvatar(
              child: Icon(Icons.camera),
              backgroundImage:
                  _image_1 != null ? Image.file(_image_1).image : null,
              shape: GFAvatarShape.standard),
          onTap: () {
            Utils.photoOptionDialog(context).then((value) {
              if (value == 2) {
                Utils.getImageFromCamera(context).then((file) {
                  _image_1 = file;
                  if (_image_1 != null) {
                    _loadedImages.add(1);
                  }
                  setState(() {});
                });
              } else if (value == 1) {
                Utils.getImageFromGallery(context).then((file) {
                  _image_1 = file;
                  if (_image_1 != null) {
                    _loadedImages.add(1);
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
              backgroundImage:
                  _image_2 != null ? Image.file(_image_2).image : null,
              shape: GFAvatarShape.standard),
          onTap: () {
            Utils.photoOptionDialog(context).then((value) {
              if (value == 2) {
                Utils.getImageFromCamera(context).then((file) {
                  _image_2 = file;
                  if (_image_2 != null) {
                    _loadedImages.add(1);
                  }
                  setState(() {});
                });
              } else if (value == 1) {
                Utils.getImageFromGallery(context).then((file) {
                  _image_2 = file;
                  if (_image_2 != null) {
                    _loadedImages.add(1);
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
              backgroundImage:
                  _image_3 != null ? Image.file(_image_3).image : null,
              shape: GFAvatarShape.standard),
          onTap: () {
            Utils.photoOptionDialog(context).then((value) {
              if (value == 2) {
                Utils.getImageFromCamera(context).then((file) {
                  _image_3 = file;
                  if (_image_3 != null) {
                    _loadedImages.add(1);
                  }
                  setState(() {});
                });
              } else if (value == 1) {
                Utils.getImageFromGallery(context).then((file) {
                  _image_3 = file;
                  if (_image_3 != null) {
                    _loadedImages.add(1);
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
              backgroundImage:
                  _image_4 != null ? Image.file(_image_4).image : null,
              shape: GFAvatarShape.standard),
          onTap: () {
            Utils.photoOptionDialog(context).then((value) {
              if (value == 2) {
                Utils.getImageFromCamera(context).then((file) {
                  _image_4 = file;
                  if (_image_4 != null) {
                    _loadedImages.add(1);
                  }
                  setState(() {});
                });
              } else if (value == 1) {
                Utils.getImageFromGallery(context).then((file) {
                  _image_4 = file;
                  if (_image_4 != null) {
                    _loadedImages.add(1);
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
        title: Text("New Product"),
        actions: <Widget>[
          Container(
            width: 80,
            child: IconButton(
              icon: Text(
                'Save',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                if (_formKey.currentState.validate()) {
//                  if (_category == null) {
//                    showInvalid(context, "Select Category");
//                    return;
//                  }

                  if (_loadedImages.length == 0) {
                    showInvalid(
                        context, "Product must have at least one image");
                    return;
                  }

                  Map<String, dynamic> body = {
                    "product_name": _pName.text,
                    "category_id": 2,
                    "description": _description.text,
                    "price": _price.text,
                    "min_order": _minOrder.text,
                    "number_in_stock": _numStock.text,
                    "discount": 0.0
                  };

                  _progressDialog.show().then((v) {
                    _addNewProduct(body).then((result) {
                      if (result == false) {
                        if (_progressDialog.isShowing()) {
                          _progressDialog.hide().then((v) {
                            Utils.showStatus(context, result, "");
                          });
                        }
                      } else {
                        _uploadImages(result).then((status) {
                          if (_progressDialog.isShowing()) {
                            _progressDialog.hide().then((v) {
                              Utils.showStatus(
                                  context, status, "New product added");
                              reset();
                            });
                          }
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

  Future<dynamic> _addNewProduct(Map<String, dynamic> body) async {
    String url = Utils.url + "/api/products";

    String json = jsonEncode(body);

    try {
      var res = await http.post(url,
          headers: {
            "Authorization": Utils.token,
            "Content-Type": "application/json"
          },
          body: json);

      if (res.statusCode == 200 || res.statusCode == 201) {
        Map<String, dynamic> result = jsonDecode(res.body);
        return result['product_id'];
      } else {
        return false;
      }
    } catch (e) {
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

        var length = await file.length(); //imageFile is your image file

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

  void reset(){
    _pName.text = '';
    _description.text = '';
    _minOrder.text = '';
    _numStock.text = '';
     _price.text = '';

  _image_1 = null;
    _image_2 = null;
    _image_3 = null;
    _image_4 = null;

    _loadedImages = [];

    setState(() {

    });
  }
}
