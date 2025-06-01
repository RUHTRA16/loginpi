import 'package:flutter/material.dart';

class VerAlunosPage extends StatefulWidget {
  @override
  _VerAlunosPageState createState() => _VerAlunosPageState();
}

class _VerAlunosPageState extends State<VerAlunosPage> {
  List<Map<String, String>> alunos = [
    {'nome': 'João Silva', 'idade': '20', 'email': 'joao@example.com'},
    {'nome': 'Maria Oliveira', 'idade': '22', 'email': 'maria@example.com'},
    {'nome': 'Carlos Souza', 'idade': '21', 'email': 'carlos@example.com'},
  ];

  late List<Map<String, String>> alunosFiltrados;
  final TextEditingController searchController = TextEditingController();

  Map<String, String>? alunoRemovido;
  int? indexRemovido;

  @override
  void initState() {
    super.initState();
    alunosFiltrados = List.from(alunos);
    searchController.addListener(filtrarAlunos);
  }

  void filtrarAlunos() {
    final query = searchController.text.toLowerCase();
    setState(() {
      alunosFiltrados =
          alunos
              .where((aluno) => aluno['nome']!.toLowerCase().contains(query))
              .toList();
    });
  }

  void removerAluno(int index) {
    setState(() {
      alunoRemovido = alunos[index];
      indexRemovido = index;
      alunos.removeAt(index);
      filtrarAlunos();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Aluno removido'),
        action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () {
            if (alunoRemovido != null && indexRemovido != null) {
              setState(() {
                alunos.insert(indexRemovido!, alunoRemovido!);
                filtrarAlunos();
              });
            }
          },
        ),
        duration: Duration(seconds: 4),
      ),
    );
  }

  void mostrarDetalhes(Map<String, String> aluno) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Detalhes do Aluno'),
            content: Text(
              'Nome: ${aluno['nome']}\nIdade: ${aluno['idade']}\nEmail: ${aluno['email']}',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Fechar'),
              ),
            ],
          ),
    );
  }

  void editarAluno(Map<String, String> aluno, int index) {
    TextEditingController nomeController = TextEditingController(
      text: aluno['nome'],
    );
    TextEditingController idadeController = TextEditingController(
      text: aluno['idade'],
    );
    TextEditingController emailController = TextEditingController(
      text: aluno['email'],
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Editar Aluno'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomeController,
                  decoration: InputDecoration(labelText: 'Nome'),
                ),
                TextField(
                  controller: idadeController,
                  decoration: InputDecoration(labelText: 'Idade'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    alunos[index] = {
                      'nome': nomeController.text,
                      'idade': idadeController.text,
                      'email': emailController.text,
                    };
                    filtrarAlunos();
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Aluno atualizado')));
                },
                child: Text('Salvar'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Alunos'),
        backgroundColor: Colors.blue[800],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Adicionar novo aluno',
            onPressed: () async {
              final novoAluno = await Navigator.pushNamed(context, '/cadastro');
              if (novoAluno != null && novoAluno is Map<String, String>) {
                setState(() {
                  alunos.add(novoAluno);
                  filtrarAlunos();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Aluno adicionado: ${novoAluno['nome']}'),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Pesquisar aluno',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child:
                  alunosFiltrados.isEmpty
                      ? Center(child: Text('Nenhum aluno encontrado'))
                      : ListView.builder(
                        itemCount: alunosFiltrados.length,
                        itemBuilder: (context, index) {
                          final aluno = alunosFiltrados[index];
                          final realIndex = alunos.indexOf(aluno);

                          return Card(
                            child: ListTile(
                              leading: Icon(Icons.person),
                              title: Text(aluno['nome']!),
                              subtitle: Text('Idade: ${aluno['idade']}'),
                              onTap: () => mostrarDetalhes(aluno),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed:
                                        () => editarAluno(aluno, realIndex),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => removerAluno(realIndex),
                                  ),
                                ],
                              ),
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

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
