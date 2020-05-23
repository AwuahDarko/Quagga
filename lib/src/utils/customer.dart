import 'package:quagga/src/utils/utils.dart';

class CustomerInfo {
  String fName;
  String sName;
  int userID;
  String role;
  String email;
  String phone;
  String image;
  String location;

  CustomerInfo(this.userID, this.fName, this.sName, this.email, this.role,
      this.phone, String image, this.location) {
    this.image = image.isEmpty ? "" : "${Utils.url}/api/images?url=$image";
  }
}
