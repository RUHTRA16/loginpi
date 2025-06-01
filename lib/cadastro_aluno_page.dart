import 'package:flutter/material.dart';

class CadastroAlunoPage extends StatefulWidget {
  @override
  _CadastroAlunoPageState createState() => _CadastroAlunoPageState();
}

class _CadastroAlunoPageState extends State<CadastroAlunoPage> {
  final nomeController = TextEditingController();
  final idadeController = TextEditingController();
  final emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void salvarAluno() {
    if (_formKey.currentState!.validate()) {
      final novoAluno = {
        'nome': nomeController.text,
        'idade': idadeController.text,
        'email': emailController.text,
      };

      // Envia os dados para a tela anterior (Ver Alunos)
      Navigator.pop(context, novoAluno);
    }
  }

  @override
  void dispose() {
    nomeController.dispose();
    idadeController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Aluno'),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Digite o nome' : null,
              ),
              TextFormField(
                controller: idadeController,
                decoration: InputDecoration(labelText: 'Idade'),
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Digite a idade'
                            : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Digite o email'
                            : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: salvarAluno, child: Text('Salvar')),
            ],
          ),
        ),
      ),
    );
  }
}
