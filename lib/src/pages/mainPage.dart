import 'package:flutter/material.dart';
import 'package:quagga/src/pages/search_page.dart';
import 'package:quagga/src/pages/shoping_cart_page.dart';
import 'package:quagga/src/pages/wish_list_page.dart';
import 'package:quagga/src/themes/light_color.dart';
import 'package:quagga/src/themes/theme.dart';
import 'package:quagga/src/utils/utils.dart';
import 'package:quagga/src/wigets/BottomNavigationBar/bottom_navigation_bar.dart';
import 'package:quagga/src/wigets/title_text.dart';

import 'home_page.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isHomePageSelected = true;
  bool isShoppingCartSelected = false;
  bool isSearchPageSelected = false;
  bool isWishPageSelected = false;

  Widget _appBar() {
    return Container(
      padding: AppTheme.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            child: RotatedBox(
              quarterTurns: 4,
              child: _icon(Icons.sort, color: Colors.black54),
            ),
            onTap: (){
              Navigator.of(context).pushNamed(
                '/menu'
              );
            },
          ),
          ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(13)),
              child: GestureDetector(
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Theme
                        .of(context)
                        .backgroundColor,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Color(0xfff8f8f8),
                          blurRadius: 10,
                          spreadRadius: 10),
                    ],
                  ),
                  child: Utils.customerInfo.image.isEmpty
                      ? CircleAvatar(
                    backgroundImage:
                    Image
                        .asset("assets/avatar.jpeg")
                        .image,
                  )
                      : CircleAvatar(
                    backgroundImage:
                    Image
                        .network(Utils.customerInfo.image)
                        .image,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(
                      '/profile'
                  );
                },
              ))
        ],
      ),
    );
  }

  Widget _icon(IconData icon, {Color color = LightColor.iconColor}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(13)),
          color: Theme
              .of(context)
              .backgroundColor,
          boxShadow: AppTheme.shadow),
      child: Icon(
        icon,
        color: color,
      ),
    );
  }

  Widget _title() {
    return Container(
        margin: AppTheme.padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TitleText(
                  text: _topHeader(),
                  fontSize: 27,
                  fontWeight: FontWeight.w400,
                ),
                TitleText(
                  text: _subHeader(),
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
            Spacer(),
            Container(
              child: RaisedButton(
                color: LightColor.orange,
                child: Text("Orders"),
                onPressed: (){
                  Navigator.of(context).pushNamed(
                      '/customerorders'
                  );
                },
              ),
            )
          ],

        ));
  }

  void onBottomIconPressed(int index) {
    if (index == 0 /*|| index == 1*/) {
      setState(() {
        isHomePageSelected = true;
        isShoppingCartSelected = false;
        isWishPageSelected = false;
        isSearchPageSelected = false;
      });
    } else if (index == 2) {
      setState(() {
        isShoppingCartSelected = true;
        isHomePageSelected = false;
        isWishPageSelected = false;
        isSearchPageSelected = false;
      });
    } else if (index == 3) {
      setState(() {
        isWishPageSelected = true;
        isShoppingCartSelected = false;
        isHomePageSelected = false;
        isSearchPageSelected = false;
      });
    } else if (index == 1) {
      setState(() {
        isSearchPageSelected = true;
        isWishPageSelected = false;
        isShoppingCartSelected = false;
        isHomePageSelected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                height: AppTheme.fullHeight(context) - 50,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xfffbfbfb),
                        Color(0xfff7f7f7),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _appBar(),
                    _title(),
                    Expanded(
                        child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            switchInCurve: Curves.easeInToLinear,
                            switchOutCurve: Curves.easeOutBack,
                            child: _screenToShow()))
                  ],
                ),
              ),
            ),
            Positioned(
                bottom: 0,
                right: 0,
                child: CustomBottomNavigationBar(
                  onIconPressedCallback: onBottomIconPressed,
                ))
          ],
        ),
      ),
    );
  }

  Widget _screenToShow() {
    if (isHomePageSelected) {
      return MyHomePage(
        onIconPressedCallback: onBottomIconPressed,
      );
    } else if (isShoppingCartSelected) {
      return Align(
        alignment: Alignment.topCenter,
        child: ShoppingCartPage(),
      );
    } else if (isSearchPageSelected) {
      return Align(
        alignment: Alignment.topCenter,
        child: SearchPage(),
      );
    } else if (isWishPageSelected) {
      return Align(
        alignment: Alignment.topCenter,
        child: WishListPage(),
      );
    } else {
      return MyHomePage();
    }
  }

  String _topHeader() {
    if (isHomePageSelected) {
      return "Our";
    } else if (isSearchPageSelected) {
      return "Search";
    } else if (isWishPageSelected) {
      return "My";
    } else if (isShoppingCartSelected) {
      return "Shopping";
    } else {
      return "";
    }
  }

  String _subHeader() {
    if (isHomePageSelected) {
      return "Products";
    } else if (isSearchPageSelected) {
      return "Products";
    } else if (isWishPageSelected) {
      return "Wish List";
    } else if (isShoppingCartSelected) {
      return "Cart";
    } else {
      return "";
    }
  }
}
