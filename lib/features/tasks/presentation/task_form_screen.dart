import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TaskDraft {
  const TaskDraft(this.title, this.description, this.priority, {this.dueDate});

  final String title;
  final String description;
  final String priority;
  final DateTime? dueDate;
}

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  static const _priorities = ['Alta', 'Media', 'Baja'];

  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  String? _priority;
  DateTime? _dueDate;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? today,
      firstDate: today,
      lastDate: DateTime(today.year + 5),
    );

    if (selectedDate != null && mounted) {
      setState(() => _dueDate = selectedDate);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    context.pop(
      TaskDraft(
        _title.text.trim(),
        _description.text.trim(),
        _priority!,
        dueDate: _dueDate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva tarea')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Título'),
              validator: (value) {
                final title = value?.trim() ?? '';
                if (title.isEmpty) return 'Escribe un título.';
                if (title.length < 3) return 'Usa al menos 3 caracteres.';
                return null;
              },
            ),
            TextFormField(
              controller: _description,
              decoration: const InputDecoration(labelText: 'Descripción'),
              maxLines: 3,
              validator: (value) {
                if (value?.trim().isEmpty ?? true) {
                  return 'Escribe una descripción.';
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              initialValue: _priority,
              decoration: const InputDecoration(labelText: 'Prioridad'),
              items: _priorities
                  .map(
                    (value) =>
                        DropdownMenuItem(value: value, child: Text(value)),
                  )
                  .toList(),
              validator: (value) =>
                  value == null ? 'Selecciona una prioridad.' : null,
              onChanged: (value) => setState(() => _priority = value),
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Fecha límite (opcional)'),
              subtitle: Text(
                _dueDate == null
                    ? 'Sin fecha'
                    : MaterialLocalizations.of(context)
                          .formatMediumDate(_dueDate!),
              ),
              trailing: Wrap(
                children: [
                  IconButton(
                    tooltip: 'Seleccionar fecha',
                    onPressed: _selectDueDate,
                    icon: const Icon(Icons.calendar_today),
                  ),
                  if (_dueDate != null)
                    IconButton(
                      tooltip: 'Quitar fecha',
                      onPressed: () => setState(() => _dueDate = null),
                      icon: const Icon(Icons.clear),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: _submit, child: const Text('Guardar')),
          ],
        ),
      ),
    );
  }
}
