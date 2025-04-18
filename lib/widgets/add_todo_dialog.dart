import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';

class AddTodoDialog extends StatefulWidget {
  const AddTodoDialog({super.key});

  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  String _priority = 'Low';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      await Future.delayed(const Duration(milliseconds: 600)); // Simülasyon

      Provider.of<TodoProvider>(context, listen: false).addTodo(
        _titleController.text.trim(),
        _descriptionController.text.trim(),
        _priority,
        _categoryController.text.trim().isEmpty ? 'Genel' : _categoryController.text.trim(),
      );

      setState(() => _isSubmitting = false);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Yeni Görev Ekle',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      autofocus: true,
                      maxLength: 50,
                      decoration: InputDecoration(
                        labelText: 'Başlık',
                        hintText: 'Görev başlığını girin',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        counterText: '',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Lütfen bir başlık girin';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      maxLength: 200,
                      decoration: InputDecoration(
                        labelText: 'Açıklama',
                        hintText: 'İsteğe bağlı açıklama',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        counterText: '',
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _priority,
                      decoration: InputDecoration(
                        labelText: 'Öncelik',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      items: ['Low', 'Medium', 'High']
                          .map((level) => DropdownMenuItem(value: level, child: Text(level)))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) setState(() => _priority = value);
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _categoryController,
                      maxLength: 30,
                      decoration: InputDecoration(
                        labelText: 'Kategori',
                        hintText: 'İş, Kişisel, Okul vb.',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        counterText: '',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isSubmitting ? null : () => Navigator.pop(context),
                    child: const Text('İptal'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigoAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : const Text('Ekle'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
