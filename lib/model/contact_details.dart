class ContactDetails {
  final int id;
  final String user, phone, checkIn;

  ContactDetails({this.id, this.user, this.phone, this.checkIn});

  factory ContactDetails.fromJson(Map<String, dynamic> json) {
    return new ContactDetails(
      id: json['id'],
      user: json['user'],
      phone: json['phone'],
      checkIn: json['check-in'],
    );
  }
}