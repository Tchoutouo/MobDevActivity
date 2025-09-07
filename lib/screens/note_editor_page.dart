import 'package:flutter/material.dart';
import '../modele/Note.dart';
import '../services/database_service.dart';

class NoteEditorPage extends StatefulWidget {
  const NoteEditorPage({super.key});

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  final _db = DatabaseService();

  Note? _original;
  bool _saving = false;
  bool _isPinned = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is Note && _original == null) {
      _original = arg;
      _titleCtrl.text = arg.title;
      _contentCtrl.text = arg.content;
      _isPinned = arg.isPinned;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  bool get _hasChanges {
    return _titleCtrl.text != (_original?.title ?? '') ||
        _contentCtrl.text != (_original?.content ?? '') ||
        _isPinned != (_original?.isPinned ?? false);
  }

  Future<void> _save() async {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Le titre ne peut pas être vide.')));
      return;
    }
    setState(() => _saving = true);
    try {
      final now = DateTime.now();
      if (_original == null) {
        await _db.insert(
          Note(
            title: title,
            content: _contentCtrl.text,
            createdAt: now,
            updatedAt: now,
            isPinned: _isPinned,
          ),
        );
      } else {
        await _db.update(
          _original!.copyWith(
            title: title,
            content: _contentCtrl.text,
            updatedAt: now,
            isPinned: _isPinned,
          ),
        );
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Note enregistrée')));
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Échec de l’enregistrement.')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    if (_original?.id == null) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Supprimer la note ?'),
        content: const Text('Cette action est irréversible.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Supprimer')),
        ],
      ),
    );
    if (confirm != true) return;
    await _db.delete(_original!.id!);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Note supprimée')));
    Navigator.pop(context, true);
  }

  Future<bool> _onWillPop() async {
    if (!_hasChanges) return true;
    final discard = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Enregistrer les modifications ?'),
            content: const Text('Vous avez des modifications non enregistrées.'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Ignorer')),
              FilledButton(onPressed: () async { Navigator.pop(context, false); await _save(); }, child: const Text('Enregistrer')),
            ],
          ),
        ) ??
        false;
    return discard;
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = _original != null;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEdit ? 'Modifier la note' : 'Nouvelle note'),
          actions: [
            IconButton(
              tooltip: _isPinned ? 'Désépingler' : 'Épingler',
              icon: Icon(_isPinned ? Icons.push_pin : Icons.push_pin_outlined),
              onPressed: () => setState(() => _isPinned = !_isPinned),
            ),
            IconButton(
              tooltip: 'Sauvegarder',
              icon: const Icon(Icons.check),
              onPressed: _saving ? null : _save,
            ),
          ],
        ),
        body: SafeArea(
          minimum: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Titre',
                  hintText: 'Ex: Course, Idées, Tâches…',
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: TextField(
                  controller: _contentCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Contenu',
                    alignLabelWithHint: true,
                  ),
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (isEdit)
                    TextButton.icon(
                      onPressed: _saving ? null : _delete,
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      label: const Text('Supprimer'),
                    ),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: () => Navigator.maybePop(context),
                    child: const Text('Annuler'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Sauvegarder'),
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
