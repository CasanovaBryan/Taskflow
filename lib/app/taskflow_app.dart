import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/app_theme.dart';
import '../features/tasks/data/local_task_repository.dart';
import '../features/tasks/presentation/task_detail_screen.dart';
import '../features/tasks/presentation/task_form_screen.dart';
import '../features/tasks/presentation/task_list_screen.dart';
import '../features/tasks/presentation/tasks_view_model.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const TaskListScreen()),
    GoRoute(
      path: '/task/:id',
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '');
        return TaskDetailScreen(taskId: id);
      },
    ),
    GoRoute(path: '/new', builder: (context, state) => const TaskFormScreen()),
  ],
);

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key, this.wrapProvider = true});

  final bool wrapProvider;

  @override
  Widget build(BuildContext context) {
    final app = MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'TaskFlow',
      theme: appTheme,
      routerConfig: appRouter,
    );

    if (!wrapProvider) return app;

    return ChangeNotifierProvider<TasksViewModel>(
      create: (_) => TasksViewModel(LocalTaskRepository())..loadTasks(),
      child: app,
    );
  }
}
