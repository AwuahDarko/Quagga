import 'package:quagga/src/model/product.dart';
import 'package:quagga/src/model/category.dart';

class AppData {
  static List<Product> productList = [
    Product(
        id:1,
        name: 'Item 1',
        price: 240.00,
        isSelected: true,
        isliked: false,
        image: 'assets/1.jpeg',
        category: "Latest Stock"),
    Product(
        id:2,
        name: 'Drug 1',
        price: 220.00,
        isliked: false,
        image: 'assets/2.jpeg',
        category: "Latest Stock"),
    Product(
        id:2,
        name: 'Drug 2',
        price: 220.00,
        isliked: false,
        image: 'assets/3.jpeg',
        category: "Latest Stock"),
    Product(
        id:2,
        name: 'Drug 3',
        price: 220.00,
        isliked: false,
        image: 'assets/4.jpeg',
        category: "Latest Stock"),
  ];
  static List<Product> cartList = [
    Product(
        id:1,
        name: 'Item 1',
        price: 240.00,
        isSelected: true,
        isliked: false,
        image: 'assets/3.jpeg',
        category: "Favorites"),
    Product(
        id:2,
        name: 'Drug 1',
        price: 190.00,
        isliked: false,
        image: 'assets/2.jpeg',
        category: "Fovorites"),
    Product(
        id:1,
        name: 'Drug 3',
        price: 220.00,
        isliked: false,
        image: 'assets/5.jpeg',
        category: "Trending Now"),
     Product(
        id:2,
        name: 'Aspirin',
        price: 240.00,
        isSelected: true,
        isliked: false,
        image: 'assets/4.jpeg',
        category: "New Stock"),
  ];
  static List<Category> categoryList = [
    Category(),
    Category(id:1,name: "Category 1",image: 'assets/3.jpeg',isSelected: true),
    Category(id:2,name: "Category 2", image: 'assets/3.jpeg'),
    Category(id:3,name: "Category 3", image: 'assets/3.jpeg'),
    Category(id:4,name: "Category 4", image: 'assets/3.jpeg'),
  ];
  static List<String> showThumbnailList = [
    "assets/5.jpeg",
    "assets/3.jpeg",
    "assets/3.jpeg",
    "assets/shoe_thumb_3.png",
  ];
  static String description = "The Most Extensive Range of First Aid Kit available in a single Kit. Known for their transparent packaging which provides quick identification and ...Check website for latest pricing and availability. Learn More";
}
