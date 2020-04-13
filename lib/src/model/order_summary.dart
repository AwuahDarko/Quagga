class OrderSummary {
  String publicID;
  int customerID;
  String name;
  String email;
  String phone;
  String image;
  String username;
  String location;

  OrderSummary(
      {this.name,
      this.image,
      this.customerID,
      this.phone,
      this.email,
      this.location,
      this.username,
      this.publicID});
}
