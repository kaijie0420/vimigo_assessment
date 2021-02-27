class ContactDetails {
  final String user, phone, checkIn;

  ContactDetails({this.user, this.phone, this.checkIn = ''});

  factory ContactDetails.fromJson(Map<String, dynamic> json) {
    return new ContactDetails(
      user: json['user'],
      phone: json['phone'],
      checkIn: json['check-in'],
    );
  }
}