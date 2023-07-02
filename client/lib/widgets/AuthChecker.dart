import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/LoginPage.dart';
import '../widgets/profile_widget.dart';

class AuthChecker extends StatelessWidget {
  Future<bool> checkIfLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return token != null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkIfLoggedIn(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Beklerken bir yüklenme göstergesi gösterilir
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          // Kullanıcı giriş yaptıysa ProfileWidget'a, yapmadıysa LoginPage'ye yönlendirir
          return snapshot.data == true ? ProfileWidget() : LoginPage();
        }
      },
    );
  }
}
