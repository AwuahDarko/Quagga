import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:quagga/src/model/product.dart';
import 'package:quagga/src/model/sub_product.dart';
import 'package:quagga/src/themes/light_color.dart';
import 'package:quagga/src/themes/theme.dart';
import 'package:quagga/src/utils/utils.dart';
import 'package:quagga/src/wigets/title_text.dart';
import 'package:getflutter/getflutter.dart';

class ProductDetailPage extends StatefulWidget {
  ProductDetailPage({Key key}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  static Product model;

  bool _describeMainProduct = true;
  String _subProductDescription = "";
  ProgressDialog _progressDialog;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInToLinear));
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool isLiked = false;

  int imageIndex = 0;
  List<Image> productImages = [];
  int _counter = 0;

  Widget _appBar() {
    return Container(
      padding: AppTheme.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: _icon(Icons.arrow_back_ios,
                color: Colors.black54, size: 15, padding: 12, isOutLine: true),
          ),
          InkWell(
            onTap: () {
              _progressDialog.show().then((v){
                Utils.addToFavorites(
                    model.id, Utils.customerInfo.userID, 'main')
                    .then((status) {
                  if(_progressDialog.isShowing()){
                    _progressDialog.hide().then((bool value){
                      Utils.showStatus(context, status, "Added to your wish list");
                      if(value){
                        setState(() {
                          isLiked = !isLiked;
                        });
                      }
                    });
                  }
                });
              });
            },
            child: _icon(isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? LightColor.red : LightColor.lightGrey,
                size: 15,
                padding: 12,
                isOutLine: false),
          )
        ],
      ),
    );
  }

  Widget _icon(IconData icon,
      {Color color = LightColor.iconColor,
      double size = 20,
      double padding = 10,
      bool isOutLine = false}) {
    return Container(
      height: 40,
      width: 40,
      padding: EdgeInsets.all(padding),
      // margin: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        border: Border.all(
            color: LightColor.iconColor,
            style: isOutLine ? BorderStyle.solid : BorderStyle.none),
        borderRadius: BorderRadius.all(Radius.circular(13)),
        color:
            isOutLine ? Colors.transparent : Theme.of(context).backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Color(0xfff8f8f8),
              blurRadius: 5,
              spreadRadius: 10,
              offset: Offset(5, 5)),
        ],
      ),
      child: Icon(icon, color: color, size: size),
    );
  }

  Widget _productImage() {
    return GestureDetector(
      onTap: () {
        _subProductDescription = model.description;
        _describeMainProduct = true;
        setState(() {});
      },
      child: AnimatedBuilder(
        builder: (context, child) {
          return AnimatedOpacity(
            duration: Duration(milliseconds: 500),
            opacity: animation.value,
            child: child,
          );
        },
        animation: animation,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            TitleText(
              text: model.name,
              fontSize: 50,
              color: LightColor.lightGrey,
            ),
            Dismissible(
              resizeDuration: null,
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.startToEnd) {
                  if (_counter > 0) {
                    _counter--;
                  } else {
                    _counter = model.image.length - 1;
                  }
                }

                if (direction == DismissDirection.endToStart) {
                  if (_counter < model.image.length - 1) {
                    _counter++;
                  } else {
                    _counter = 0;
                  }
                }

                setState(() {});
              },
              key: new ValueKey(_counter),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.27,
                  child: productImages[_counter]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryWidget() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0),
      width: AppTheme.fullWidth(context),
      height: 80,
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: model.image
              .map((x) => _thumbnail('${Utils.url}/api/images?url=$x'))
              .toList()),
    );
  }

  Widget _thumbnail(String image) {
    return GestureDetector(
      onTap: () {
        _subProductDescription = model.description;
        _describeMainProduct = true;
        setState(() {});
      },
      child: AnimatedBuilder(
          animation: animation,
          //  builder: null,
          builder: (context, child) => AnimatedOpacity(
            opacity: animation.value,
            duration: Duration(milliseconds: 500),
            child: child,
          ),
          child: Container(
              height: 40,
              width: 50,
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: LightColor.grey,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(13),
                ),
//                 color: Theme.of(context).backgroundColor,
              ),
              child: GestureDetector(
                child: GFAvatar(
                  backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(image),
                    shape: GFAvatarShape.standard),
              ) //Image.network(image),
          )),
    );

  }

  Widget _detailWidget() {
    return DraggableScrollableSheet(
      maxChildSize: .8,
      initialChildSize: .53,
      minChildSize: .53,
      builder: (context, scrollController) {
        return Container(
          padding: AppTheme.padding.copyWith(bottom: 0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              color: Colors.white),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(height: 5),
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                        color: LightColor.iconColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TitleText(text: model.name, fontSize: 25),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              TitleText(
                                text: "GH\u20B5 ",
                                fontSize: 18,
                                color: LightColor.red,
                              ),
                              TitleText(
                                text: model.price.toString(),
                                fontSize: 25,
                              ),
                            ],
                          ),
//                          Row(
//                            children: <Widget>[
//                              Icon(Icons.star,
//                                  color: LightColor.yellowColor, size: 17),
//                              Icon(Icons.star,
//                                  color: LightColor.yellowColor, size: 17),
//                              Icon(Icons.star,
//                                  color: LightColor.yellowColor, size: 17),
//                              Icon(Icons.star,
//                                  color: LightColor.yellowColor, size: 17),
//                              Icon(Icons.star_border, size: 17),
//                            ],
//                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TitleText(
                  text: "Categories",
                ),
                _subProducts(),
                SizedBox(
                  height: 20,
                ),
//                _availableColor(),
                SizedBox(
                  height: 20,
                ),
                _description(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _subProducts() {
    return Container(
        height: 140.0,
        width: MediaQuery.of(context).size.width,
        child: ListView(
            scrollDirection: Axis.horizontal,
            children: model.subProducts
                .map((sub) => _subCategoryWidget(sub))
                .toList()));
  }

  Widget _subCategoryWidget(SubProduct sub,
      {Color color = LightColor.iconColor, bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        _subProductDescription = sub.description;
        _describeMainProduct = false;
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: const EdgeInsets.all(10.0),
        width: 140.0,
        decoration: BoxDecoration(
          border: Border.all(
              color: LightColor.iconColor,
              style: !isSelected ? BorderStyle.solid : BorderStyle.none),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: isSelected
              ? LightColor.orange
              : Theme.of(context).backgroundColor,
        ),
        child: Stack(
          children: <Widget>[
            TitleText(
              text: sub.name,
              fontSize: 12,
              color: isSelected
                  ? LightColor.background
                  : LightColor.titleTextColor,
            ),
            Positioned(
              top: 17,
              left: 0,
              right: 0,
              bottom: 0,
              child: GFAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: sub.image.length > 0
                    ? NetworkImage("${Utils.url}/api/images?url=${sub.image}")
                    : null,
                shape: GFAvatarShape.standard,
              ),
            ),
            Positioned(
              right: -10,
              top: 5,
              child: IconButton(
                  iconSize: 30,
                  icon: Icon(
                    Icons.shopping_cart,
                    color: LightColor.orange,
                  ),
                  onPressed: () {
                _progressDialog.show().then((v){
                  Utils.addToCart(
                      sub.id, Utils.customerInfo.userID, 'sub', sub.minOrder)
                      .then((status) {
                    if(_progressDialog.isShowing()){
                      _progressDialog.hide().then((bool value){
                        Utils.showStatus(context, status, "Added to cart");
                      });
                    }
                  });
                });
                  }),
            )
          ],
        ),
      ),
    );
  }

  Widget _availableColor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TitleText(
          text: "Available Colors",
          fontSize: 14,
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _colorWidget(LightColor.yellowColor, isSelected: true),
            SizedBox(
              width: 30,
            ),
            _colorWidget(LightColor.lightBlue),
            SizedBox(
              width: 30,
            ),
            _colorWidget(LightColor.black),
            SizedBox(
              width: 30,
            ),
            _colorWidget(LightColor.red),
            SizedBox(
              width: 30,
            ),
            _colorWidget(LightColor.skyBlue),
          ],
        )
      ],
    );
  }

  Widget _colorWidget(Color color, {bool isSelected = false}) {
    return CircleAvatar(
      radius: 12,
      backgroundColor: color.withAlpha(150),
      child: isSelected
          ? Icon(
              Icons.check_circle,
              color: color,
              size: 18,
            )
          : CircleAvatar(radius: 7, backgroundColor: color),
    );
  }

  Widget _description() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TitleText(
          text: "Description",
          fontSize: 14,
        ),
        SizedBox(height: 20),
        _describeMainProduct
            ? Text(model.description)
            : Text(_subProductDescription),
      ],
    );
  }

  FloatingActionButton _floatingButton() {
    return FloatingActionButton(
      onPressed: () {
        _progressDialog.show().then((v){
            Utils.addToCart(
                model.id, Utils.customerInfo.userID, 'main', model.minOrder)
                .then((status) {
              if(_progressDialog.isShowing()){
                _progressDialog.hide().then((bool value){
                  Utils.showStatus(context, status, "Added to cart");
                });
              }
            });
          });
      },
      backgroundColor: LightColor.orange,
      child: Icon(Icons.shopping_cart,
          color: Theme.of(context).floatingActionButtonTheme.backgroundColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    _progressDialog = Utils.initializeProgressDialog(context);
    final Product product = ModalRoute.of(context).settings.arguments;
    model = product;
    productImages = _fetchAllImages(model.image);
    return Scaffold(
      floatingActionButton: _floatingButton(),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Color(0xfffbfbfb),
              Color(0xfff7f7f7),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  _appBar(),
                  _productImage(),
                  SizedBox(
                    height: 10.0,
                  ),
                  _categoryWidget(),
                ],
              ),
              _detailWidget()
            ],
          ),
        ),
      ),
    );
  }

  List<Image> _fetchAllImages(List<dynamic> imageLinks) {
    List<Image> images = [];
    imageLinks.forEach((oneLink) {
      images.add(Image.network("${Utils.url}/api/images?url=$oneLink"));
    });
    return images;
  }

  Image setImages() {
    return productImages[imageIndex];
  }
}
