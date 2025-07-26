class TourBooking {
  final int? bookId;
  final int? userId;
  final DateTime startTour;
  final DateTime endTour;
  final String tourPackage;
  final int? noPeople;
  final double packagePrice;

  TourBooking({
    this.bookId,
    this.userId,
    required this.startTour,
    required this.endTour,
    required this.tourPackage,
    this.noPeople,
    required this.packagePrice,
  });

  factory TourBooking.fromMap(Map<String, dynamic> json) => TourBooking(
        bookId: json["bookid"],
        userId: json["userid"],
        startTour: DateTime.parse(json["starttour"]),
        endTour: DateTime.parse(json["endtour"]),
        tourPackage: json["tourpackage"],
        noPeople: json["nopeople"],
        packagePrice: json["packageprice"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "bookid": bookId,
        "userid": userId,
        "starttour": startTour.toIso8601String(),
        "endtour": endTour.toIso8601String(),
        "tourpackage": tourPackage,
        "nopeople": noPeople,
        "packageprice": packagePrice,
      };

  TourBooking copyWith({
    int? bookId,
    int? userId,
    DateTime? startTour,
    DateTime? endTour,
    String? tourPackage,
    int? noPeople,
    double? packagePrice,
  }) {
    return TourBooking(
      bookId: bookId ?? this.bookId,
      userId: userId ?? this.userId,
      startTour: startTour ?? this.startTour,
      endTour: endTour ?? this.endTour,
      tourPackage: tourPackage ?? this.tourPackage,
      noPeople: noPeople ?? this.noPeople,
      packagePrice: packagePrice ?? this.packagePrice,
    );
  }
}
