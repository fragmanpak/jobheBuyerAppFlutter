class Seller {
  String address,
      businessType,
      description,
      fcm,
      name,
      onlineStatus,
      picUrl,
      uuid,
      blockByAdmin,
      completeOrders,
      rating,
      lat,
      lng,
      timeStamp;

  Seller(
      {this.address,
      this.businessType,
      this.description,
      this.fcm,
      this.name,
      this.onlineStatus,
      this.picUrl,
      this.uuid,
      this.blockByAdmin,
      this.completeOrders,
      this.rating,
      this.lat,
      this.lng,
      this.timeStamp});

  factory Seller.fromRTDB(Map<String, dynamic> snapshot) {
    return Seller(
      address: snapshot["address"],
      blockByAdmin: snapshot["blockByAdmin"],
      businessType: snapshot["businessType"],
      description: snapshot["description"],
      completeOrders: snapshot["completeOrders"],
      fcm: snapshot["fcm"],
      timeStamp: snapshot["joinTimeStamp"],
      lat: snapshot["lat"],
      lng: snapshot["lng"],
      name: snapshot["name"],
      onlineStatus: snapshot["onlineStatus"],
      picUrl: snapshot["pic"],
      rating: snapshot["rating"],
      uuid: snapshot["uuid"],
    );
  }

}
