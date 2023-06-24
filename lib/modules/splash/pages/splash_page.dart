import 'package:flutter/material.dart';
import 'package:rater/modules/login/pages/entrarcadastro_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../components/title.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      await Future.delayed(const Duration(seconds: 1, milliseconds: 500));
      final preferences = await SharedPreferences.getInstance();
      final token = preferences.getString('auth_token');
      if (token != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const EntrarCadastroPage(),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const EntrarCadastroPage(),
          ),
        );
      }
    });
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 56, 107, 1),
      body: Stack(
        children: [
          Center(
            child: Wrap(
              direction: Axis.vertical,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: const [
                TitleRater(size: 100),
                Padding(padding: EdgeInsets.only(top: 32)),
                CircularProgressIndicator(color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
