import 'package:flutter/material.dart';

class AlunosPage extends StatelessWidget {
  final List<_OpcaoItem> opcaoItems = [
    _OpcaoItem('Ver Alunos', Icons.people, '/veralunos'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Alunos'), backgroundColor: Colors.blue[800]),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children:
              opcaoItems.map((item) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, item.route); // ✅ CORRIGIDO
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 3,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item.icon, size: 48, color: Colors.blue[800]),
                        SizedBox(height: 12),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
      ),
    );
  }
}

class _OpcaoItem {
  final String label;
  final IconData icon;
  final String route;

  _OpcaoItem(this.label, this.icon, this.route);
}
