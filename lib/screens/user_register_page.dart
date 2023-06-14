import 'package:flutter/material.dart';
import 'package:toptanci_otomasyon/core/services/auth_service.dart';
import 'package:toptanci_otomasyon/screens/login_page.dart';
import 'package:toptanci_otomasyon/service/auth.dart';
import 'package:toptanci_otomasyon/models/userModel.dart';
import 'package:toptanci_otomasyon/widgets/custom_text_field.dart';

class UserRegisterPage extends StatefulWidget {
  const UserRegisterPage({Key? key}) : super(key: key);

  @override
  State<UserRegisterPage> createState() => _UserRegisterPageState();
}
class _UserRegisterPageState extends State<UserRegisterPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController passwordAgainController;
  late TextEditingController phoneNumberController;
  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController businessNameController;

  @override
  void initState() {
    super.initState();
    emailController=TextEditingController();
    passwordController=TextEditingController();
    passwordAgainController=TextEditingController();
    phoneNumberController=TextEditingController();
    nameController=TextEditingController();
    addressController=TextEditingController();
    businessNameController=TextEditingController();

  }
  final GlobalKey<FormState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left:height/13,right: height/13),
          child: Form(
            key: _key,
            child: Column(
              children: [

                Icon(Icons.ac_unit_outlined, size: height/5),
                Space(),
                CustomTextField(
                  validator: nameValidate,
                    labelText: 'İsim Soyisim',textEditingController: nameController), Space(),
                CustomTextField(
                  validator: mailValidate,
                    labelText: 'Email Giriniz',textEditingController: emailController), Space(),
                CustomTextField(
                  obscureText: true,
                  validator: passwordValidate,
                    labelText: 'Şifre',textEditingController: passwordController), Space(),
                CustomTextField(
                  obscureText: true,
                    labelText: 'Şifre Tekrar',textEditingController: passwordAgainController), Space(),
                CustomTextField(
                  validator: phoneValidate,
                    labelText: 'Telefon Numarası',textEditingController: phoneNumberController), Space(),
                CustomTextField(
                  validator: addressValidate,
                    labelText: 'Adres',textEditingController: addressController), Space(),
                CustomTextField(
                  validator: nameValidate,
                    labelText: 'İşletme Adı',textEditingController: businessNameController), Space(),
                ElevatedButton(
                  onPressed: ()async{
                  if(_key.currentState?.validate() ?? false){
                    UserModel userModel=UserModel(
                        image: '',
                        userName: nameController.text,
                        email: emailController.text,password: passwordController.text,
                        address: addressController.text,businessName: businessNameController.text,
                        telNo:phoneNumberController.text);
                    await AuthService2().createAccount(userModel);
                    if(!mounted)return;
                    buildShowDialog(context);

                  }
                }, child: Text('Kayıt Ol'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.indigo,
                      minimumSize: Size(width/1.5, height/17),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }

  Future<dynamic> buildShowDialog(BuildContext context) {
    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text('hesabınız oluşturuldu'),
        actions: [
          ElevatedButton(onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          }, child: Text(('Tamam')))
        ],
      )
      ;},);
  }
}
String? mailValidate(value) {
  if (value?.toString().isEmpty ?? false) {
    return 'bu alan boş geçilemez';
  }
  //return value.toString().contains(RegExp(r'[a,z]')) ? null:'';
  return (value?.toString().contains('@') ?? false)
      ? null
      : 'lütfen mail formatında giriniz ornek@gmail.com';
}
String? addressValidate(value) {
  if (value?.toString().isEmpty ?? false) {
    return 'bu alan boş geçilemez';
  }
}
String? phoneValidate(value) {
  if (value?.toString().isEmpty ?? false) {
    return 'bu alan boş geçilemez';
  }
  return ((value?.toString().length ?? 0) > 10)
      ? null
      : 'telefon minimum 11 karakter olmalı';
}
String? nameValidate(value) {
  if (value?.toString().isEmpty ?? false) {
    return 'bu alan boş geçilemez';
  }
  return ((value?.toString().length ?? 0) > 2)
      ? null
      : 'isim minimum 3 karakter olmalı';
}
String? passwordValidate(value) {
  if (value?.toString().isEmpty ?? false) {
    return 'bu alan boş geçilemez';
  }
  return (value.toString().length > 5)
      ? null
      : 'şifre en az 6 karakter olmalı';
}


