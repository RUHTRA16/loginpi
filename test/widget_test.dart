import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart'; // Corrigido com o nome do projeto

void main() {
  testWidgets('Tela inicial carrega corretamente', (WidgetTester tester) async {
    await tester.pumpWidget(LibrasEscolaApp());

    // Verifica se o título aparece na tela
    expect(find.text('Escola de Libras'), findsOneWidget);
  });
}
