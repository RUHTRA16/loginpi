import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(); // chave do formulário
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  bool loading = false;

  Future<void> fazerLogin() async {
    if (!_formKey.currentState!.validate())
      return; // valida antes de tentar login

    final dio = Dio();
    setState(() => loading = true);

    try {
      final response = await dio.post(
        'http://127.0.0.1:8001/api/login', // troque pelo endereço real da API Laravel
        data: {
          'email': emailController.text.trim(),
          'password': senhaController.text.trim(),
        },
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final token = response.data['token'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        Navigator.pushReplacementNamed(context, '/homepage');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao fazer login. Tente novamente.')),
        );
      }
    } on DioException catch (e) {
      String msg = 'Erro inesperado';

      if (e.response != null) {
        if (e.response?.statusCode == 401) {
          msg = 'Email ou senha inválidos';
        } else if (e.response?.statusCode == 422) {
          msg = 'Por favor, preencha os campos corretamente';
        } else {
          msg = 'Erro: ${e.response?.statusMessage}';
        }
      } else {
        msg = 'Sem conexão com o servidor';
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fundo com imagem e filtro azul escuro
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fundosite.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.blue.withOpacity(0.6),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          // Imagem lateral direita
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/fotologin.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Conteúdo do formulário
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 60),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 500),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/logosite.png', width: 500),
                    SizedBox(height: 20),
                    Text(
                      'Comunicar é incluir.',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40),

                    // Formulário com validação
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: Icon(Icons.email),
                            ),
                            validator: (email) {
                              if (email == null || email.isEmpty) {
                                return 'Digite seu email';
                              }
                              // validação simples de email
                              if (!RegExp(
                                r'^[^@]+@[^@]+\.[^@]+',
                              ).hasMatch(email)) {
                                return 'Digite um email válido';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: senhaController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Senha',
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: Icon(Icons.lock),
                            ),
                            validator: (senha) {
                              if (senha == null || senha.isEmpty) {
                                return 'Digite sua senha';
                              }
                              if (senha.length < 4) {
                                return 'Sua senha deve ter pelo menos 4 caracteres';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 30),

                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: loading ? 50 : 200,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: loading ? null : fazerLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child:
                            loading
                                ? CircularProgressIndicator(color: Colors.blue)
                                : Text(
                                  'Entrar',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.blue[800],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                      ),
                    ),

                    SizedBox(height: 50),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Sobre o Curso',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(1, 1),
                                      blurRadius: 2,
                                      color: Colors.black45,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 15),
                              Text(
                                'Nosso curso de Libras é ideal para quem deseja aprender a se comunicar com a comunidade surda. Com conteúdo didático, interativo e acessível, o curso oferece fundamentos essenciais da Língua Brasileira de Sinais.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 15),
                              Text(
                                '🕒 Duração: 6 meses/módulo\n🎓 Nível: A partir do Iniciante\n👥 Público-alvo: Qualquer pessoa interessada em inclusão',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white60,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'Saiba Mais',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
