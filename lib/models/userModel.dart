
class UserModel{
  String? id;
  String? userName;
  String? email;
  String? password;
  String? telNo;
  String? image='';
  String? address;
  String? businessName;
  UserModel({this.id,this.userName, this.email, this.password, this.telNo, this.address, this.businessName,required this.image});
  UserModel.fromMap(Map<String, dynamic> json) {
    userName = json['userName'];
    email = json['email'];
    password = json['password'];
    telNo=json['telNo'];
    image=json['image'];
    address=json['address'];
    businessName=json['businessName'];
    id=json['userId'];
  }
  Map<String,dynamic>toMap(){
    return {
      'userName':userName,
      'email':email,
      'password':password,
      'telNo':telNo,
      'image':image,
      'address':address,
      'businessName':businessName,
    };
  }
}