import 'package:flutter/material.dart';
import 'home_page.dart';
import 'cadastro_aluno_page.dart'; // Importando a página de cadastro
import 'ver_alunos_page.dart'; // Página para ver alunos

void main() {
  runApp(LibrasEscolaApp());
}

class LibrasEscolaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Escola de Libras',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/', // Tela inicial
      routes: {
        '/': (context) => HomePage(),
        '/cadastro':
            (context) => CadastroAlunoPage(), // Rota para Cadastro de Aluno
        '/ver_alunos': (context) => VerAlunosPage(), // Rota para ver os alunos
      },
    );
  }
}
