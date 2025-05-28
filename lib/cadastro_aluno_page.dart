import 'dart:ui';
import 'package:flutter/material.dart';

class CadastroAlunoPage extends StatelessWidget {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController idadeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fundo com imagem de fundo (para refletir o design do exemplo)
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/fundosite.png',
                ), // Substitua pelo seu fundo
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.blue.withOpacity(0.6),
                  BlendMode.darken,
                ),
              ),
            ),
          ),

          // Imagem do lado direito
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/fotologin.png',
                  ), // Substitua pela imagem desejada
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),

          // Formulário
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 60),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 500),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Botão de Voltar
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.pop(context); // Voltar para a tela anterior
                        },
                      ),
                    ),

                    // Logo
                    Image.asset(
                      'assets/images/logosite.png', // Substitua pelo logo
                      width: 500,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 20),

                    // Frase de impacto
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

                    // Campo Nome
                    TextField(
                      controller: nomeController,
                      decoration: InputDecoration(
                        hintText: 'Nome Completo',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Campo Idade
                    TextField(
                      controller: idadeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Idade',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Campo Email
                    TextField(
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
                    ),
                    SizedBox(height: 30),

                    // Botão Cadastrar
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          // Ação para cadastrar o aluno (salvar no banco ou API)
                          print('Nome: ${nomeController.text}');
                          print('Idade: ${idadeController.text}');
                          print('Email: ${emailController.text}');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.blue[800],
                        ),
                        child: Text(
                          'Cadastrar Aluno',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),

                    // Seção Sobre o Curso
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
                                onPressed: () {
                                  // Ação do botão "Saiba Mais"
                                  //novo comit//
                                },
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
                    SizedBox(height: 50),
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
