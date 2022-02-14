class OrdersStatusModel {
  String buyerId;
  String titleMessage;

  String orderId;
  String sellerId;
  String time;

  OrdersStatusModel(
      this.buyerId, this.titleMessage, this.orderId, this.sellerId, this.time);

  factory OrdersStatusModel.fromJson(Map<String, dynamic> response) =>
      OrdersStatusModel(
        response['buyerId'],
        response['titleMessage'],
        response['orderId'],
        response['sellerId'],
        response['localTime'],
      );
}
