import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final List<_AcessoItem> acessoItems = [
    _AcessoItem('Alunos', Icons.people, '/abaalunopage'),
    _AcessoItem('Frequência', Icons.calendar_today, '/frequencia'),
    _AcessoItem('Relatórios', Icons.bar_chart, '/relatorios'),
    _AcessoItem('Sair', Icons.exit_to_app, '/login'), // nova opção sair
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/fundosite.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(12),
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Bem-vindo ao Sistema do Curso de Libras Nayara Souza',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    GridView.count(
                      crossAxisCount: 4,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 6,
                      childAspectRatio: 1.5,
                      children:
                          acessoItems.map((item) {
                            return GestureDetector(
                              onTap: () {
                                if (item.label == 'Sair') {
                                  // Volta para login removendo histórico de telas
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    item.route,
                                    (route) => false,
                                  );
                                } else {
                                  Navigator.pushNamed(context, item.route);
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(6),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 1,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      item.icon,
                                      size: 30,
                                      color: Colors.blue[800],
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      item.label,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue[800],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
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

class _AcessoItem {
  final String label;
  final IconData icon;
  final String route;

  _AcessoItem(this.label, this.icon, this.route);
}
