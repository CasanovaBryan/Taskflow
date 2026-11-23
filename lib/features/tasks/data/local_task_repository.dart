import '../domain/task.dart';
import 'task_repository.dart';

class LocalTaskRepository implements TaskRepository {
  final List<Task> _tasks = [
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

  @override
  Future<List<Task>> getTasks() async => List.unmodifiable(_tasks);

  @override
  void save(Task task) {
    final index = _tasks.indexWhere((item) => item.id == task.id);
    if (index == -1) return;
    _tasks[index] = task;
  }
}
