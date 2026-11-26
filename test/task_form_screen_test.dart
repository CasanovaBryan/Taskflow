import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:taskflow/main.dart';

void main() {
  testWidgets('validates task fields and returns a draft', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TaskFlowApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Nueva tarea'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Escribe un título.'), findsOneWidget);
    expect(find.text('Escribe una descripción.'), findsOneWidget);
    expect(find.text('Selecciona una prioridad.'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'Ab');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'Descripción de prueba',
    );
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Alta').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Usa al menos 3 caracteres.'), findsOneWidget);
    expect(find.text('Escribe una descripción.'), findsNothing);
    expect(find.text('Selecciona una prioridad.'), findsNothing);

    await tester.enterText(find.byType(TextFormField).at(0), 'Nueva tarea');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Formulario válido: Nueva tarea'), findsOneWidget);
  });

  testWidgets('cancelling the form returns without a message', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TaskFlowApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Nueva tarea'));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('Mis tareas'), findsOneWidget);
    expect(find.textContaining('Formulario válido:'), findsNothing);
  });
}
