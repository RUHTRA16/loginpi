import 'package:flutter/material.dart';
import 'package:flutter_application_1/cadastro_aluno_page.dart';
import 'package:flutter_application_1/home_page.dart';
import 'package:flutter_application_1/login_page.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Escola de Libras',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(),
      routes: {
        '/cadastro': (context) => CadastroAlunoPage(),
        '/homepage': (context) => HomePage(),
      },
    );
  }
}
