import 'package:flutter/material.dart';
import 'package:flutter_application_1/abaaluno_page.dart';
import 'package:flutter_application_1/abafrequencia_page.dart';
import 'package:flutter_application_1/cadastro_aluno_page.dart';
import 'package:flutter_application_1/home_page.dart';
import 'package:flutter_application_1/login_page.dart';
import 'package:flutter_application_1/ver_alunos_page.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Escola de Libras',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(), // Página inicial
      routes: {
        '/login': (context) => LoginPage(), // rota do login
        '/cadastro': (context) => CadastroAlunoPage(),
        '/homepage': (context) => HomePage(),
        '/veralunos': (context) => VerAlunosPage(),
        '/abaalunopage': (context) => AlunosPage(),
        '/avaliacao': (context) => const AvaliacaoPage(), // nova rotaova rota
      },
    );
  }
}
