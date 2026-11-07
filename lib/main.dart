import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const TaskFlowApp());
}

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'TaskFlow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}

class Task {
  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.isCompleted,
  });

  final int id;
  final String title;
  final String description;
  final String priority;
  final bool isCompleted;
}

const demoTasks = [
  Task(
    id: 1,
    title: 'Configurar el proyecto Flutter',
    description: 'Preparar la estructura inicial de TaskFlow',
    priority: 'Alta',
    isCompleted: true,
  ),
  Task(
    id: 2,
    title: 'Diseñar la tarjeta de tarea',
    description: 'Mostrar título, prioridad y descripción',
    priority: 'Alta',
    isCompleted: false,
  ),
  Task(
    id: 3,
    title: 'Implementar la lista desplazable',
    description: 'Construir elementos con ListView.builder',
    priority: 'Alta',
    isCompleted: false,
  ),
  Task(
    id: 4,
    title: 'Validar el estado de las tareas',
    description: 'Distinguir tareas pendientes y completadas',
    priority: 'Media',
    isCompleted: false,
  ),
  Task(
    id: 5,
    title: 'Revisar y evidenciar el avance',
    description: 'Ejecutar pruebas y flutter analyze',
    priority: 'Media',
    isCompleted: false,
  ),
];

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const TaskListScreen()),
    GoRoute(
      path: '/task/:id',
      builder: (context, state) {
        final taskId = int.tryParse(state.pathParameters['id'] ?? '');
        if (taskId == null) {
          return const TaskNotFoundScreen();
        }

        return TaskDetailScreen(taskId: taskId);
      },
    ),
  ],
);

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task, this.onTap});

  final Task task;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: task.isCompleted ? Colors.green : null,
        ),
        title: Text(task.title),
        subtitle: Text('${task.priority} · ${task.description}'),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis tareas')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: demoTasks.length,
        itemBuilder: (context, index) {
          final task = demoTasks[index];
          return TaskCard(
            task: task,
            onTap: () => context.push('/task/${task.id}'),
          );
        },
      ),
    );
  }
}

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key, required this.taskId});

  final int taskId;

  @override
  Widget build(BuildContext context) {
    Task? task;
    for (final item in demoTasks) {
      if (item.id == taskId) {
        task = item;
        break;
      }
    }

    if (task == null) {
      return const TaskNotFoundScreen();
    }

    final currentTask = task;
    final statusColor = currentTask.isCompleted
        ? Colors.green
        : Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de tarea')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Text(
                    currentTask.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Text(currentTask.description),
                  const SizedBox(height: 16),
                  Chip(
                    avatar: const Icon(Icons.flag_outlined),
                    label: Text('Prioridad: ${currentTask.priority}'),
                  ),
                  const SizedBox(height: 12),
                  Chip(
                    avatar: Icon(
                      currentTask.isCompleted
                          ? Icons.check_circle
                          : Icons.pending,
                      color: statusColor,
                    ),
                    label: Text(
                      currentTask.isCompleted
                          ? 'Estado: completada'
                          : 'Estado: pendiente',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Volver al listado'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskNotFoundScreen extends StatelessWidget {
  const TaskNotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tarea no encontrada')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('No existe una tarea con ese identificador.'),
            const SizedBox(height: 16),
            FilledButton.tonalIcon(
              onPressed: () => context.go('/'),
              icon: const Icon(Icons.list),
              label: const Text('Volver al listado'),
            ),
          ],
        ),
      ),
    );
  }
}
