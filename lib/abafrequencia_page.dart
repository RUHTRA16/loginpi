import 'package:flutter/material.dart';

enum FrequenciaStatus { presente, falta, faltaJustificada }

class Aluno {
  final String nome;
  FrequenciaStatus status;

  Aluno({required this.nome, this.status = FrequenciaStatus.presente});
}

class AlunoNota {
  final String nome;
  String nota;
  Map<int, Map<String, String>> notasDetalhadas;

  AlunoNota({
    required this.nome,
    this.nota = '',
    Map<int, Map<String, String>>? notasDetalhadas,
  }) : notasDetalhadas =
           notasDetalhadas ??
           {
             1: {'atividade': '', 'prova': ''},
             2: {'atividade': '', 'prova': ''},
             3: {'atividade': '', 'prova': ''},
             4: {'atividade': '', 'prova': ''},
           };
}

void main() {
  runApp(const MaterialApp(home: AvaliacaoPage()));
}

class AvaliacaoPage extends StatelessWidget {
  const AvaliacaoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Avaliação'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.check_circle_outline), text: 'Frequência'),
              Tab(icon: Icon(Icons.grade_outlined), text: 'Nota'),
            ],
          ),
        ),
        body: const TabBarView(children: [FrequenciaTab(), NotaTab()]),
      ),
    );
  }
}

class FrequenciaTab extends StatefulWidget {
  const FrequenciaTab({super.key});

  @override
  State<FrequenciaTab> createState() => _FrequenciaTabState();
}

class _FrequenciaTabState extends State<FrequenciaTab> {
  final List<Aluno> alunos = [
    Aluno(nome: 'Ana Silva'),
    Aluno(nome: 'Bruno Souza'),
    Aluno(nome: 'Carla Pereira'),
    Aluno(nome: 'Diego Martins'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: alunos.length,
      itemBuilder: (context, index) {
        final aluno = alunos[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  aluno.nome,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Radio<FrequenciaStatus>(
                      value: FrequenciaStatus.presente,
                      groupValue: aluno.status,
                      onChanged: (value) {
                        setState(() {
                          aluno.status = value!;
                        });
                      },
                    ),
                    const Text('Presença'),
                    const SizedBox(width: 20),
                    Radio<FrequenciaStatus>(
                      value: FrequenciaStatus.falta,
                      groupValue: aluno.status,
                      onChanged: (value) {
                        setState(() {
                          aluno.status = value!;
                        });
                      },
                    ),
                    const Text('Falta'),
                    const SizedBox(width: 20),
                    Radio<FrequenciaStatus>(
                      value: FrequenciaStatus.faltaJustificada,
                      groupValue: aluno.status,
                      onChanged: (value) {
                        setState(() {
                          aluno.status = value!;
                        });
                      },
                    ),
                    const Text('Falta Justificada'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class NotaTab extends StatefulWidget {
  const NotaTab({super.key});

  @override
  State<NotaTab> createState() => _NotaTabState();
}

class _NotaTabState extends State<NotaTab> {
  final List<AlunoNota> alunosNotas = [
    AlunoNota(nome: 'Ana Silva'),
    AlunoNota(nome: 'Bruno Souza'),
    AlunoNota(nome: 'Carla Pereira'),
    AlunoNota(nome: 'Diego Martins'),
  ];

  void visualizarNotas(AlunoNota aluno) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Notas de ${aluno.nome}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(4, (i) {
                final bimestre = i + 1;
                final atividade =
                    aluno.notasDetalhadas[bimestre]?['atividade'] ?? '';
                final prova = aluno.notasDetalhadas[bimestre]?['prova'] ?? '';
                return Text(
                  'Bimestre $bimestre:\n  Atividade: $atividade\n  Prova: $prova',
                  textAlign: TextAlign.left,
                );
              }),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Fechar'),
              ),
            ],
          ),
    );
  }

  void salvarNotas() {
    for (var aluno in alunosNotas) {
      print('Aluno: ${aluno.nome} - Nota geral: ${aluno.nota}');
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Notas salvas com sucesso!')));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: alunosNotas.length,
            itemBuilder: (context, index) {
              final aluno = alunosNotas[index];
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {},
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              aluno.nome,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.search),
                            tooltip: 'Visualizar Notas',
                            onPressed: () => visualizarNotas(aluno),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            tooltip: 'Adicionar/Editar Notas',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => NotaDetalhadaPage(aluno: aluno),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        //Padding(
        //padding: const EdgeInsets.all(12.0),
        //child: ElevatedButton(
        //onPressed: salvarNotas,
        //child: const Text('Salvar Notas'),
        //),
        //),
      ],
    );
  }
}

class NotaDetalhadaPage extends StatefulWidget {
  final AlunoNota aluno;

  const NotaDetalhadaPage({super.key, required this.aluno});

  @override
  State<NotaDetalhadaPage> createState() => _NotaDetalhadaPageState();
}

class _NotaDetalhadaPageState extends State<NotaDetalhadaPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Map<int, Map<String, TextEditingController>> controllers = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    for (var i = 1; i <= 4; i++) {
      controllers[i] = {
        'atividade': TextEditingController(
          text: widget.aluno.notasDetalhadas[i]?['atividade'],
        ),
        'prova': TextEditingController(
          text: widget.aluno.notasDetalhadas[i]?['prova'],
        ),
      };
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (var map in controllers.values) {
      map['atividade']?.dispose();
      map['prova']?.dispose();
    }
    super.dispose();
  }

  void salvarNotasDetalhadas() {
    for (var i = 1; i <= 4; i++) {
      widget.aluno.notasDetalhadas[i]!['atividade'] =
          controllers[i]!['atividade']!.text;
      widget.aluno.notasDetalhadas[i]!['prova'] =
          controllers[i]!['prova']!.text;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Notas detalhadas salvas!')));
    Navigator.pop(context);
  }

  Widget buildBimestreTab(int bimestre) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: controllers[bimestre]!['atividade'],
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Atividade - Bimestre $bimestre',
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controllers[bimestre]!['prova'],
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Prova - Bimestre $bimestre',
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notas de ${widget.aluno.nome}'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '1º Bimestre'),
            Tab(text: '2º Bimestre'),
            Tab(text: '3º Bimestre'),
            Tab(text: '4º Bimestre'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildBimestreTab(1),
          buildBimestreTab(2),
          buildBimestreTab(3),
          buildBimestreTab(4),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: salvarNotasDetalhadas,
        child: const Icon(Icons.save),
        tooltip: 'Salvar notas detalhadas',
      ),
    );
  }
}
