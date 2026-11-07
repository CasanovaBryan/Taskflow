import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:taskflow/main.dart';

void main() {
  testWidgets('task actions update pending and daily completed counts', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TaskFlowApp());

    expect(find.text('Tareas pendientes: 3'), findsOneWidget);
    expect(find.text('Completadas hoy: 0 de 5'), findsOneWidget);

    await tester.tap(find.text('Agregar tarea'));
    await tester.pump();
    await tester.tap(find.text('Agregar tarea'));
    await tester.pump();
    expect(find.text('Tareas pendientes: 5'), findsOneWidget);

    for (var i = 0; i < 5; i++) {
      await tester.tap(find.text('Completar una tarea'));
      await tester.pump();
    }

    expect(find.text('Tareas pendientes: 0'), findsOneWidget);
    expect(find.text('Completadas hoy: 5 de 5'), findsOneWidget);
    expect(
      tester
          .widget<OutlinedButton>(
            find.widgetWithText(OutlinedButton, 'Completar una tarea'),
          )
          .onPressed,
      isNull,
    );
    expect(
      find.text('¡Excelente! No tienes tareas pendientes.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Agregar tarea'));
    await tester.pump();
    expect(find.text('Tareas pendientes: 1'), findsOneWidget);
    expect(
      tester
          .widget<OutlinedButton>(
            find.widgetWithText(OutlinedButton, 'Completar una tarea'),
          )
          .onPressed,
      isNotNull,
    );

    await tester.tap(find.text('Completar una tarea'));
    await tester.pump();
    expect(find.text('Tareas pendientes: 0'), findsOneWidget);
    expect(find.text('Completadas hoy: 5 de 5'), findsOneWidget);
  });
}
