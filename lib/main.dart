import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quagga/src/config/route.dart';
import 'package:quagga/src/pages/product_detail.dart';
import 'package:quagga/src/themes/theme.dart';
import 'package:quagga/src/wigets/customRoute.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quagga',
      theme: AppTheme.lightTheme.copyWith(
        textTheme: GoogleFonts.muliTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      debugShowCheckedModeBanner: false,
      routes: Routes.getRoute(),
      // ignore: missing_return
      onGenerateRoute: (RouteSettings settings) {
        final List<String> pathElements = settings.name.split('/');
        if (pathElements[1].contains('detail')) {
          return CustomRoute<bool>(
              builder: (BuildContext context) => ProductDetailPage());
        }
      },
    );
  }
}
