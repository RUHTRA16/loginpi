import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class VerAlunosPage extends StatefulWidget {
  @override
  _VerAlunosPageState createState() => _VerAlunosPageState();
}

class _VerAlunosPageState extends State<VerAlunosPage> {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://127.0.0.1:8001/api', // Ajuste para seu ambiente
      headers: {
        'Authorization':
            'Bearer 17|l5C3SZ184BvawddP8vXw59YvAFiy232xX12qfZPLcf8e3889',
        'Accept': 'application/json',
      },
    ),
  );

  List<Map<String, dynamic>> alunos = [];
  List<Map<String, dynamic>> alunosFiltrados = [];
  final TextEditingController searchController = TextEditingController();

  Map<String, dynamic>? alunoRemovido;
  int? indexRemovido;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    buscarAlunos();
    searchController.addListener(filtrarAlunos);
  }

  Future<void> buscarAlunos() async {
    setState(() => isLoading = true);
    try {
      final response = await dio.get('/alunos');
      if (!mounted) return;
      setState(() {
        alunos = List<Map<String, dynamic>>.from(response.data);
        alunosFiltrados = List.from(alunos);
      });
    } catch (e) {
      print('Erro ao buscar alunos: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao carregar alunos')));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void filtrarAlunos() {
    final query = searchController.text.toLowerCase();
    setState(() {
      alunosFiltrados =
          alunos
              .where(
                (aluno) =>
                    (aluno['nome'] as String).toLowerCase().contains(query),
              )
              .toList();
    });
  }

  Future<void> removerAluno(int index) async {
    final aluno = alunos[index];
    final int id = aluno['id'];

    try {
      await dio.delete('alunos/$id');
      if (!mounted) return;
      setState(() {
        alunoRemovido = aluno;
        indexRemovido = index;
        alunos.removeAt(index);
        filtrarAlunos();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Aluno removido'),
          action: SnackBarAction(
            label: 'Desfazer',
            onPressed: () async {
              if (alunoRemovido != null && indexRemovido != null) {
                try {
                  final response = await dio.post(
                    'alunos',
                    data: alunoRemovido,
                  );
                  if (!mounted) return;
                  setState(() {
                    alunos.insert(indexRemovido!, response.data);
                    filtrarAlunos();
                  });
                } catch (e) {
                  print('Erro ao desfazer remoção: $e');
                }
              }
            },
          ),
          duration: Duration(seconds: 4),
        ),
      );
    } catch (e) {
      print('Erro ao remover aluno: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao remover aluno')));
    }
  }

  String calcularIdade(String? dataNascimento) {
    if (dataNascimento == null) return 'N/A';
    try {
      final nascimento = DateTime.parse(dataNascimento);
      final hoje = DateTime.now();
      int idade = hoje.year - nascimento.year;
      if (hoje.month < nascimento.month ||
          (hoje.month == nascimento.month && hoje.day < nascimento.day)) {
        idade--;
      }
      return idade.toString();
    } catch (_) {
      return 'N/A';
    }
  }

  void mostrarDetalhes(Map<String, dynamic> aluno) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Detalhes do Aluno'),
            content: Text(
              'Nome: ${aluno['nome']}\n'
              'Idade: ${calcularIdade(aluno['data_nascimento'])}\n'
              'Email: ${aluno['email'] ?? 'N/A'}',
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

  void editarAluno(Map<String, dynamic> aluno, int index) {
    TextEditingController nomeController = TextEditingController(
      text: aluno['nome'],
    );
    TextEditingController emailController = TextEditingController(
      text: aluno['email'] ?? '',
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
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final nome = nomeController.text.trim();
                  final email = emailController.text.trim();

                  if (nome.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('O nome não pode ficar vazio')),
                    );
                    return;
                  }

                  final int id = aluno['id'];
                  final dataAtualizada = {'nome': nome, 'email': email};

                  try {
                    final response = await dio.put(
                      'alunos/$id',
                      data: dataAtualizada,
                    );
                    if (!mounted) return;
                    setState(() {
                      alunos[index] = response.data;
                      filtrarAlunos();
                    });
                    Navigator.pop(context);
                    if (!mounted) return;
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Aluno atualizado')));
                  } catch (e) {
                    print('Erro ao atualizar aluno: $e');
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro ao atualizar aluno')),
                    );
                  }
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
              if (novoAluno != null && novoAluno is Map<String, dynamic>) {
                try {
                  final response = await dio.post('alunos', data: novoAluno);
                  if (!mounted) return;
                  setState(() {
                    alunos.add(response.data);
                    filtrarAlunos();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Aluno adicionado: ${response.data['nome']}',
                      ),
                    ),
                  );
                } catch (e) {
                  print('Erro ao adicionar aluno: $e');
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao adicionar aluno')),
                  );
                }
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
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : alunosFiltrados.isEmpty
                      ? Center(child: Text('Nenhum aluno encontrado'))
                      : ListView.builder(
                        itemCount: alunosFiltrados.length,
                        itemBuilder: (context, index) {
                          final aluno = alunosFiltrados[index];
                          final realIndex = alunos.indexOf(aluno);

                          return Card(
                            child: ListTile(
                              leading: Icon(Icons.person),
                              title: Text(aluno['nome']),
                              subtitle: Text(
                                'Idade: ${calcularIdade(aluno['data_nascimento'])}',
                              ),
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
