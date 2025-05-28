import 'package:flutter/material.dart';

class VerAlunosPage extends StatelessWidget {
  // Lista simulada de alunos
  final List<String> alunos = [
    'João Silva',
    'Maria Oliveira',
    'Carlos Souza',
    'Ana Pereira',
    'Lucas Lima',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Alunos'),
        backgroundColor: Colors.blue[800],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Voltar para a tela anterior (Home)
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lista de Alunos',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            SizedBox(height: 20),
            // Exibe a lista de alunos
            Expanded(
              child: ListView.builder(
                itemCount: alunos.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(alunos[index]),
                      leading: Icon(Icons.person),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
