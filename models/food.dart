class Food{
  final String? url;
  final num? itemNum;
  final double? latitude;
  final double? longitude;
  final DateTime? date;

  Food({this.url, this.itemNum, this.latitude, this.longitude, this.date});

  factory Food.fromJSON(Map<String, dynamic> json){
    return Food(
        url: json['url'],
        itemNum: json['itemNum'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        date: json['date']
    );
  }
}