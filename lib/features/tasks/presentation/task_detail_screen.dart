import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'tasks_view_model.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key, required this.taskId});

  final int? taskId;

  @override
  Widget build(BuildContext context) {
    final task = context.watch<TasksViewModel>().findTask(taskId);

    if (task == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Tarea no encontrada')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('No existe una tarea con ese identificador.'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.go('/'),
                child: const Text('Volver al listado'),
              ),
            ],
          ),
        ),
      );
    }

    final statusColor = task.isCompleted
        ? Colors.green
        : Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de tarea')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Volver al listado'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  context.read<TasksViewModel>().toggleCompleted(task.id);
                },
                child: Text(
                  task.isCompleted
                      ? 'Marcar como pendiente'
                      : 'Marcar como completada',
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(task.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('Prioridad: ${task.priority}'),
            const SizedBox(height: 8),
            Text(
              task.isCompleted ? 'Estado: completada' : 'Estado: pendiente',
              style: TextStyle(color: statusColor),
            ),
            const SizedBox(height: 8),
            Text(task.description),
            const SizedBox(height: 8),
            Text('Usuario: ${task.userId}'),
          ],
        ),
      ),
    );
  }
}
