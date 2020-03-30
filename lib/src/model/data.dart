import 'package:quagga/src/model/product.dart';
import 'package:quagga/src/model/category.dart';

class AppData {
  static List<Product> productList = [
    Product(
        id:1,
        name: 'Item 1',
        price: 240.00,
        isSelected: true,
        isliked: true,
        image: 'http://placekitten.com/120/120',
        category: "Latest Stock"),
    Product(
        id:2,
        name: 'Drug 1',
        price: 220.00,
        isliked: false,
        isSelected: true,
        image: 'http://placekitten.com/120/120',
        category: "Latest Stock"),
    Product(
        id:2,
        name: 'Drug 2',
        price: 220.00,
        isliked: false,
        image: 'http://placekitten.com/120/120',
        category: "Latest Stock"),
    Product(
        id:2,
        name: 'Drug 3',
        price: 220.00,
        isliked: false,
        image: 'http://placekitten.com/120/120',
        category: "Latest Stock"),
  ];
  static List<Product> cartList = [
    Product(
        id:1,
        name: 'Item 1',
        price: 240.00,
        isSelected: true,
        isliked: false,
        image: 'http://placekitten.com/120/120',
        category: "Favorites"),
    Product(
        id:2,
        name: 'Drug 1',
        price: 190.00,
        isliked: false,
        image: 'http://placekitten.com/120/120',
        category: "Fovorites"),
    Product(
        id:1,
        name: 'Drug 3',
        price: 220.00,
        isliked: false,
        image: 'http://placekitten.com/120/120',
        category: "Trending Now"),
     Product(
        id:2,
        name: 'Aspirin',
        price: 240.00,
        isSelected: true,
        isliked: false,
        image: 'http://placekitten.com/120/120',
        category: "New Stock"),
  ];
  static List<Category> categoryList = [
    Category(),
    Category(id:1,name: "Category 1",image: 'http://placekitten.com/120/120',isSelected: true),
    Category(id:2,name: "Category 2", image: 'http://placekitten.com/120/120'),
    Category(id:3,name: "Category 3", image: 'http://placekitten.com/120/120'),
    Category(id:4,name: "Category 4", image: 'http://placekitten.com/120/120'),
  ];
  static List<String> showThumbnailList = [
    "http://placekitten.com/90/60",
    "http://placekitten.com/90/60",
    "http://placekitten.com/90/60",
    "http://placekitten.com/90/60",
  ];
  static String description = "The Most Extensive Range of First Aid Kit available in a single Kit. Known for their transparent packaging which provides quick identification and ...Check website for latest pricing and availability. Learn More";
}
