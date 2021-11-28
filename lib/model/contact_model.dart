/*class MainContactModel {
  List<ContactModel> contactModelList;

  MainContactModel(this.contactModelList);

  factory MainContactModel.fromJson(List<dynamic> parsedJson) {
    List<ContactModel> mainContactModelList =
        parsedJson.map((key) => ContactModel.fromJson(key)).toList();

    return MainContactModel(
      mainContactModelList,
    );
  }
}*/

class ContactModel {
  String? address;
  String? dob;
  String? contact;
  String? lastName;
  String? firstName;
  String? imageUri;
  String? userId;
  String? id;

  ContactModel(
      {this.address,
      this.dob,
      this.contact,
      this.lastName,
      this.firstName,
      this.imageUri,
      this.userId,
      this.id});

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
      address: json["address"],
      dob: json["dob"],
      contact: json["contact"],
      lastName: json["last_name"],
      firstName: json["first_name"],
      imageUri: json["image_uri"],
      userId: json["user_id"],
      id: json["id"]);

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "dob": dob,
        "contact": contact,
        "address": address,
        "image_uri": imageUri,
        "user_id": userId,
        "id": id
      };
}
