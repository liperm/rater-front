import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:rater/modules/home/pages/tabs/tab_adicionar.dart';
import 'package:rater/modules/home/pages/tabs/tab_favoritos.dart';
import 'package:rater/modules/home/pages/tabs/tab_home.dart';
import 'package:rater/modules/home/pages/tabs/tab_reviews.dart';
import 'package:rater/modules/home/pages/tabs/tab_usuario.dart';

class HomePage extends StatefulWidget {
  final int id;

  const HomePage({Key? key, required this.id}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      TabHome(idUser: widget.id),
      TabFavoritos(idUser: widget.id),
      TabCriados(idUser: widget.id),
      TabUsuario(id: widget.id),
      const TabProdutos(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(0, 56, 107, 1), // Definindo a cor de fundo
        ),
        child: GNav(
          curve: Curves.easeInOutCirc,
          color: Colors.grey[300],
          activeColor: Colors.white,
          mainAxisAlignment: MainAxisAlignment.center,
          tabActiveBorder: Border.all(
            color: Colors.grey[300]!,
          ),
          gap: 8,
          tabs: const [
            GButton(
              icon: Icons.home,
              text: 'Feed',
            ),
            GButton(
              icon: Icons.favorite,
              text: 'Favoritos',
            ),
            GButton(
              icon: Icons.volunteer_activism_rounded,
              text: 'Criados',
            ),
            GButton(
              icon: Icons.plus_one,
              text: 'Adicionar',
            ),
            GButton(
              icon: Icons.bookmark,
              text: 'Categorias',
            ),
          ],
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
