import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:taskflow/main.dart';

void main() {
  testWidgets('shows local task cards in a scrollable list', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(400, 400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const TaskFlowApp());
    await tester.pumpAndSettle();

    expect(find.text('Mis tareas'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('Configurar el proyecto Flutter'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Revisar y evidenciar el avance'),
      200,
      scrollable: find.byType(Scrollable),
    );
    await tester.pumpAndSettle();

    expect(find.text('Revisar y evidenciar el avance'), findsOneWidget);
    expect(find.text('Prioridad: Media'), findsWidgets);
    expect(demoTasks, hasLength(5));

    await tester.tap(find.text('Revisar y evidenciar el avance'));
    await tester.pumpAndSettle();
    expect(find.text('Detalle de tarea'), findsOneWidget);
    expect(find.text('Revisar y evidenciar el avance'), findsOneWidget);
    expect(find.text('Prioridad: Media'), findsOneWidget);
    expect(find.text('Estado: pendiente'), findsOneWidget);

    await tester.tap(find.text('Volver al listado'));
    await tester.pumpAndSettle();
    expect(find.text('Mis tareas'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, 1000));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Configurar el proyecto Flutter'));
    await tester.pumpAndSettle();
    expect(
      find.text('Preparar la estructura inicial de TaskFlow'),
      findsOneWidget,
    );
    expect(find.text('Estado: completada'), findsOneWidget);

    await tester.tap(find.text('Volver al listado'));
    await tester.pumpAndSettle();
    appRouter.go('/task/invalid');
    await tester.pumpAndSettle();
    expect(find.text('Tarea no encontrada'), findsOneWidget);
    expect(
      find.text('No existe una tarea con ese identificador.'),
      findsOneWidget,
    );
  });
}
