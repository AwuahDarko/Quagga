import 'package:flutter/material.dart';
import 'package:flutter_launch/flutter_launch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quagga/src/pages/customer_orders.dart';
import 'package:quagga/src/pages/shoping_cart_page.dart';
import 'package:quagga/src/pages/wish_list_page.dart';
import 'package:quagga/src/themes/light_color.dart';
import 'package:quagga/src/themes/theme.dart';
import 'package:quagga/src/utils/utils.dart';
import 'package:quagga/src/wigets/BottomNavigationBar/bottom_navigation_bar.dart';
import 'package:quagga/src/wigets/title_text.dart';
import 'package:url_launcher/url_launcher.dart';


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
  bool isCustomerOrderPageSelected = false;
  bool isWishPageSelected = false;
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();

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
            onTap: () {
              _globalKey.currentState.openDrawer();
            },
          ),
        ],
      ),
    );
  }

  Widget _icon(IconData icon, {Color color = LightColor.iconColor}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(13)),
          color: Theme.of(context).backgroundColor,
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
          ],
        ));
  }

  void onBottomIconPressed(int index) {
    if (index == 0 /*|| index == 1*/) {
      setState(() {
        isHomePageSelected = true;
        isShoppingCartSelected = false;
        isWishPageSelected = false;
        isCustomerOrderPageSelected = false;
      });
    } else if (index == 2) {
      setState(() {
        isShoppingCartSelected = true;
        isHomePageSelected = false;
        isWishPageSelected = false;
        isCustomerOrderPageSelected = false;
      });
    } else if (index == 3) {
      setState(() {
        isWishPageSelected = false;
        isShoppingCartSelected = false;
        isHomePageSelected = false;
        isCustomerOrderPageSelected = true;
      });
    } else if (index == 1) {
      setState(() {
        isCustomerOrderPageSelected = false;
        isWishPageSelected = true;
        isShoppingCartSelected = false;
        isHomePageSelected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                  '${Utils.customerInfo.fName} ${Utils.customerInfo.sName}'),
              accountEmail: Text(Utils.customerInfo.email),
              currentAccountPicture: CircleAvatar(
                backgroundImage: Utils.customerInfo.image == ''
                    ? Image.asset('assets/avatar.jpeg').image
                    : NetworkImage(Utils.customerInfo.image),
                backgroundColor:
                    Theme.of(context).platform == TargetPlatform.iOS
                        ? Colors.blue
                        : Colors.white,
              ),
            ),
            Utils.customerInfo.role == 'distributor'
                ? _distributorMenu()
                : _customerMenu(),
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                height: AppTheme.fullHeight(context) - 100,
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
    } else if (isCustomerOrderPageSelected) {
      return Align(
        alignment: Alignment.topCenter,
        child: CustomerOrderDetailsPage(),
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
    } else if (isCustomerOrderPageSelected) {
      return "My";
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
      return "Distributors";
    } else if (isCustomerOrderPageSelected) {
      return "Orders";
    } else if (isWishPageSelected) {
      return "Wish List";
    } else if (isShoppingCartSelected) {
      return "Cart";
    } else {
      return "";
    }
  }

  Widget _distributorMenu() {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text("My Store"),
        ),
        ListTile(
          leading: Icon(Icons.local_shipping, color: LightColor.orange),
          title: Text("Orders"),
          onTap: () {
            Navigator.of(context).pushNamed('/ordersummary');
          },
        ),
        ListTile(
          leading: Icon(Icons.shop, color: LightColor.orange),
          title: Text("New product"),
          onTap: () {
            Navigator.of(context).pushNamed('/newproduct');
          },
        ),
        ListTile(
          leading: Icon(Icons.update, color: LightColor.orange),
          title: Text("Update product"),
          onTap: () {
            Navigator.of(context).pushNamed('/updateproduct');
          },
        ),
        ListTile(
          leading: Icon(Icons.delete_outline, color: LightColor.orange),
          title: Text("Remove product"),
          onTap: () {
            Navigator.of(context).pushNamed('/removeproduct');
          },
        ),
        ListTile(
          leading: FaIcon(FontAwesomeIcons.moneyBillAlt,size: 20 ,color: LightColor.orange,),
          title: Text("Earnings"),
          onTap: () {
            Navigator.of(context).pushNamed('/earnings');
          },
        ),
        ListTile(
          leading: Icon(
            Icons.person,
            color: LightColor.orange,
          ),
          title: Text("Profile"),
          onTap: () {
            Navigator.of(context).pushNamed('/profile');
          },
        ),
        Divider(),
        ListTile(
          title: Text("Feedback & Questions"),
        ),
        ListTile(
          leading: Icon(Icons.phone_android, color: LightColor.orange),
          title: Text("Call Us"),
          onTap: () => launch('tel:+233553567136'),
        ),
        ListTile(
          leading: Icon(Icons.feedback, color: LightColor.orange),
          title: Text("By Email"),
          onTap: () => launch('mailto:mjadarko@gmail.com'),
        ),
        ListTile(
          leading: Icon(Icons.feedback, color: LightColor.orange),
          title: Text("By SMS"),
          onTap: () => launch('sms:+233553567136'),
        ),
        ListTile(
          leading: Icon(Icons.feedback, color: LightColor.orange),
          title: Text("WhatsApp"),
          onTap: () async => await FlutterLaunch.launchWathsApp(phone: '+233553567136', message: ''),
        ),
        Divider(),
        ListTile(
          title: Text("Legal"),
        ),
        ListTile(
          leading: Icon(Icons.book, color: LightColor.orange),
          title: Text("Terms & Conditions"),
          onTap: () {
            Navigator.of(context).pushNamed('/privacy',
                arguments: {'head': 'Terms & Conditions', 'file': 'terms.pdf'});
          },
        ),
        ListTile(
          leading: Icon(Icons.poll, color: LightColor.orange),
          title: Text("Privacy Policy"),
          onTap: () {
            Navigator.of(context).pushNamed('/privacy',
                arguments: {'head': 'Privacy Policy', 'file': 'privacy.pdf'});
          },
        ),
        ListTile(
          leading: Icon(Icons.business, color: LightColor.orange),
          title: Text("About Us"),
          onTap: () => Navigator.of(context).pushNamed('/privacy',
              arguments: {'head': 'About Us', 'file': 'about.pdf'})
        ),
        Divider(),
        ListTile(
          title: Text("App"),
        ),
        ListTile(
          leading: Icon(
            Icons.exit_to_app,
            color: LightColor.orange,
          ),
          title: Text("Logout"),
        ),
      ],
    );
  }

  Widget _customerMenu() {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text("Manage"),
        ),
        ListTile(
          leading: Icon(
            Icons.person,
            color: LightColor.orange,
          ),
          title: Text("Profile"),
          onTap: () {
            Navigator.of(context).pushNamed('/profile');
          },
        ),
        Divider(),
        ListTile(
          title: Text("Feedback & Questions"),
        ),
        ListTile(
          leading: Icon(Icons.phone_android, color: LightColor.orange),
          title: Text("Call Us"),
          onTap: () => launch('tel:+233553567136'),
        ),
        ListTile(
          leading: Icon(Icons.email, color: LightColor.orange),
          title: Text("By Email"),
          onTap: () => launch('mailto:mjadarko@gmail.com'),
        ),
        ListTile(
          leading: Icon(Icons.message, color: LightColor.orange),
          title: Text("By SMS"),
          onTap: () => launch('sms:+233553567136'),
        ),
        ListTile(
          leading: FaIcon(FontAwesomeIcons.whatsapp, color: Colors.lightGreen,),
          title: Text("WhatsApp"),
          onTap: () async => await FlutterLaunch.launchWathsApp(phone: '+233553567136', message: ''),
        ),
        Divider(),
        ListTile(
          title: Text("Legal"),
        ),
        ListTile(
          leading: Icon(Icons.book, color: LightColor.orange),
          title: Text("Terms & Conditions"),
          onTap: (){
            Navigator.of(context).pushNamed('/privacy',
              arguments: {'head': 'Terms & Conditions', 'file': 'terms.pdf'});
            },
        ),
        ListTile(
          leading: Icon(Icons.poll, color: LightColor.orange),
          title: Text("Privacy Policy"),
          onTap: () {
            Navigator.of(context).pushNamed('/privacy',
                arguments: {'head': 'Privacy Policy', 'file': 'privacy.pdf'});
          },
        ),
        ListTile(
          leading: Icon(Icons.business, color: LightColor.orange),
          title: Text("About Us"),
            onTap: () => Navigator.of(context).pushNamed('/privacy',
                arguments: {'head': 'About Us', 'file': 'about.pdf'})
        ),
        Divider(),
        ListTile(
          title: Text("App"),
        ),
        ListTile(
          leading: Icon(
            Icons.exit_to_app,
            color: LightColor.orange,
          ),
          title: Text("Logout"),
        ),
      ],
    );
  }
}
