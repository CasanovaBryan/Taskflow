import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/taskflow_app.dart';
import 'features/tasks/data/remote_task_repository.dart';
import 'features/tasks/data/task_api_service.dart';
import 'features/tasks/data/task_repository.dart';
import 'features/tasks/presentation/tasks_view_model.dart';
import 'features/tasks/domain/task.dart';

export 'app/taskflow_app.dart';

// Compatibility exports for the widget test from the previous session.
export 'features/tasks/domain/task.dart';

const demoTasks = <Task>[
  Task(
    id: 1,
    title: 'Configurar el proyecto Flutter',
    description: 'Preparar la estructura inicial de TaskFlow',
    priority: 'Alta',
    isCompleted: true,
    userId: 1,
  ),
  Task(
    id: 2,
    title: 'Diseñar la tarjeta de tarea',
    description: 'Mostrar título, prioridad y descripción',
    priority: 'Alta',
    isCompleted: false,
    userId: 1,
  ),
  Task(
    id: 3,
    title: 'Implementar la lista desplazable',
    description: 'Construir elementos con ListView.builder',
    priority: 'Alta',
    isCompleted: false,
    userId: 1,
  ),
  Task(
    id: 4,
    title: 'Validar el estado de las tareas',
    description: 'Distinguir tareas pendientes y completadas',
    priority: 'Media',
    isCompleted: false,
    userId: 1,
  ),
  Task(
    id: 5,
    title: 'Revisar y evidenciar el avance',
    description: 'Ejecutar pruebas y flutter analyze',
    priority: 'Media',
    isCompleted: false,
    userId: 1,
  ),
];

void main() {
  final TaskRepository repository = RemoteTaskRepository(TaskApiService());

  runApp(
    ChangeNotifierProvider<TasksViewModel>(
      create: (_) => TasksViewModel(repository)..loadTasks(),
      child: const TaskFlowApp(wrapProvider: false),
    ),
  );
}
