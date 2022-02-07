class Seller {
  String address,
      businessType,
      description,
      fcm,
      name,
      onlineStatus,
      picUrl,
      uuid;

  Seller(
      this.address,
      this.blockByAdmin,
      this.businessType,
      this.description,
      this.completeOrders,
      this.timeStamp,
      this.lat,
      this.lng,
      this.name,
      this.onlineStatus,
      this.picUrl,
      this.fcm,
      this.rating,
      this.uuid);

  int blockByAdmin, completeOrders, rating;
  double lat;
  double lng;
  String timeStamp;

  factory Seller.fromJson(Map<String, dynamic> response) => Seller(
        response['address'],
        response['blockByAdmin'],
        response['businessType'],
        response['businessDescription'],
        response['completeOrders'],
        response['joinTimeStamp'],
        response['lat'],
        response['lng'],
        response['name'],
        response['onlineStatus'],
        response['picUrl'],
        response['fcm'],
        response['rating'],
        response['uuid'],
      );
}
// Seller(
//     {this.address,
//     this.businessType,
//     this.description,
//     this.fcm,
//     this.name,
//     this.onlineStatus,
//     this.picUrl,
//     this.uuid,
//     this.blockByAdmin,
//     this.completeOrders,
//     this.rating,
//     this.lat,
//     this.lng,
//     this.timeStamp});
//
// factory Seller.fromRTDB(Map<String, dynamic> snapshot) {
//   return Seller(
//     address: snapshot["address"],
//     blockByAdmin: snapshot["blockByAdmin"],
//     businessType: snapshot["businessType"],
//     description: snapshot["description"],
//     completeOrders: snapshot["completeOrders"],
//     fcm: snapshot["fcm"],
//     timeStamp: snapshot["joinTimeStamp"],
//     lat: snapshot["lat"],
//     lng: snapshot["lng"],
//     name: snapshot["name"],
//     onlineStatus: snapshot["onlineStatus"],
//     picUrl: snapshot["pic"],
//     rating: snapshot["rating"],
//     uuid: snapshot["uuid"],
//   );
// }
