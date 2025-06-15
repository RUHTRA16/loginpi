import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dio/dio.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Aluno',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'), // Português do Brasil
      ],
      locale: const Locale('pt', 'BR'),
      home: const CadastroAlunoPage(),
    );
  }
}

class CadastroAlunoPage extends StatefulWidget {
  const CadastroAlunoPage({super.key});

  @override
  State<CadastroAlunoPage> createState() => _CadastroAlunoPageState();
}

class _CadastroAlunoPageState extends State<CadastroAlunoPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController =
      TextEditingController(); // Controller para email
  final TextEditingController _idadeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _dataNascimentoController =
      TextEditingController();

  final Dio _dio = Dio();

  void _selecionarDataNascimento() async {
    final DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate: DateTime(2005),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (dataSelecionada != null && mounted) {
      setState(() {
        _dataNascimentoController.text = DateFormat(
          'dd/MM/yyyy',
        ).format(dataSelecionada);
      });
    }
  }

  Future<void> cadastrarAluno() async {
    final String baseUrl =
        'http://127.0.0.1:8001/api'; // substitua pela sua URL

    // Transformar data para formato ISO (yyyy-MM-dd), que geralmente a API aceita
    String dataNascimentoISO = '';
    try {
      final dt = DateFormat('dd/MM/yyyy').parse(_dataNascimentoController.text);
      dataNascimentoISO = DateFormat('yyyy-MM-dd').format(dt);
    } catch (_) {
      // Caso não consiga converter, usa vazio (deixe a validação cuidar disso)
    }

    try {
      final response = await _dio.post(
        '$baseUrl/alunos',
        data: {
          'nome': _nomeController.text,
          'email': _emailController.text, // Envia email
          'idade': int.tryParse(_idadeController.text) ?? 0,
          'telefone': _telefoneController.text,
          'data_nascimento': dataNascimentoISO,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            // Se sua API usa autenticação, envie o token aqui:
            'Authorization':
                'Bearer 17|l5C3SZ184BvawddP8vXw59YvAFiy232xX12qfZPLcf8e3889',
          },
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        _mostrarDialogo(
          'Sucesso',
          'Aluno ${_nomeController.text} cadastrado com sucesso!',
        );
        _formKey.currentState!.reset();
        _dataNascimentoController.clear();
        _emailController.clear();
      } else {
        _mostrarDialogo(
          'Erro',
          'Falha ao cadastrar aluno: ${response.statusCode}',
        );
      }
    } catch (e) {
      _mostrarDialogo('Erro', 'Erro na requisição: $e');
    }
  }

  void _mostrarDialogo(String titulo, String mensagem) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(titulo),
            content: Text(mensagem),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _salvarCadastro() async {
    print('Botão salvar pressionado');
    if (_formKey.currentState!.validate()) {
      print('Formulário válido, enviando dados...');
      await cadastrarAluno();
    } else {
      print('Formulário inválido');
    }
  }

  Widget _campoTexto({
    required String label,
    required IconData icone,
    required TextEditingController controller,
    required String mensagemErro,
    TextInputType tipoTeclado = TextInputType.text,
    bool validaEmail = false,
    bool somenteLeitura = false,
    VoidCallback? aoTocar,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: somenteLeitura,
      onTap: aoTocar,
      keyboardType: tipoTeclado,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icone),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return mensagemErro;
        if (validaEmail && !value.contains('@'))
          return 'Digite um e-mail válido';
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Aluno'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _campoTexto(
                label: 'Nome Completo',
                icone: Icons.person,
                controller: _nomeController,
                mensagemErro: 'Informe o nome',
              ),
              const SizedBox(height: 16),
              _campoTexto(
                label: 'Email',
                icone: Icons.email,
                controller: _emailController,
                mensagemErro: 'Informe o email',
                tipoTeclado: TextInputType.emailAddress,
                validaEmail: true,
              ),
              const SizedBox(height: 16),
              _campoTexto(
                label: 'Idade',
                icone: Icons.cake,
                controller: _idadeController,
                mensagemErro: 'Informe a idade',
                tipoTeclado: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _campoTexto(
                label: 'Telefone',
                icone: Icons.phone,
                controller: _telefoneController,
                mensagemErro: 'Informe o telefone',
                tipoTeclado: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              _campoTexto(
                label: 'Data de Nascimento',
                icone: Icons.calendar_today,
                controller: _dataNascimentoController,
                mensagemErro: 'Informe a data de nascimento',
                somenteLeitura: true,
                aoTocar: _selecionarDataNascimento,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _salvarCadastro,
                icon: const Icon(Icons.save),
                label: const Text('Salvar Cadastro'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
