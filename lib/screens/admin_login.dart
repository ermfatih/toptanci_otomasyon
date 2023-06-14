import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toptanci_otomasyon/core/locator.dart';
import 'package:toptanci_otomasyon/screens/login_page.dart';
import 'package:toptanci_otomasyon/screens/user_register_page.dart';
import 'package:toptanci_otomasyon/view_models/admin_sign_in_model.dart';
import 'package:toptanci_otomasyon/view_models/sign_in_model.dart';
import 'package:toptanci_otomasyon/widgets/custom_elevated_button.dart';
import 'package:toptanci_otomasyon/widgets/custom_text_field.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({Key? key}) : super(key: key);

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final GlobalKey<FormState> _key = GlobalKey();
  late TextEditingController emailController;
  late TextEditingController passwordController;
  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;

    return ChangeNotifierProvider(
      create:(context) => getIt<AdminSignInModel>(),
      child:Consumer<AdminSignInModel>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(),
            body:SingleChildScrollView(
              child: Padding(
                padding:  EdgeInsets.all(height/13),
                child:model.busy?Center(child: CircularProgressIndicator(),): Form(
                  key: _key,
                  child: Column(
                    children: [
                      Icon(Icons.ac_unit_outlined, size: height/5),
                      const Space(),
                      CustomTextField(
                        validator: mailValidate,
                        labelText: 'Email',
                        textEditingController: emailController,
                      ),
                      const Space(),
                      CustomTextField(
                        validator: passwordValidate,
                        obscureText: true,
                          labelText: 'Şifre',
                          textEditingController: passwordController),
                      const Space(),
                      CustomElevatedButton(
                        text: 'Giriş Yap',
                        onPressed: () async{
                          if(_key.currentState?.validate() ?? false){
                            await model.adminSignIn(emailController.text, passwordController.text);
                          }
                      },)
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
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
String? passwordValidate(value) {
  if (value?.toString().isEmpty ?? false) {
    return 'bu alan boş geçilemez';
  }
  return (value.toString().length > 5)
      ? null
      : 'şifre en az 6 karakter olmalı';
}

