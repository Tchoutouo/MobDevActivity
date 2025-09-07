import 'package:flutter/material.dart';
import '../modele/Note.dart';
import '../services/database_service.dart';
import 'note_editor_page.dart';

class NotesListPage extends StatefulWidget {
  const NotesListPage({super.key});

  @override
  State<NotesListPage> createState() => _NotesListPageState();
}

class _NotesListPageState extends State<NotesListPage> {
  final _db = DatabaseService();
  String _query = '';
  List<Note> _notes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() => _loading = true);
    try {
      _notes = await _db.getNotes(query: _query);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible de charger les notes.')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _delete(Note n) async {
    final backup = n;
    setState(() => _notes.removeWhere((x) => x.id == n.id));
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Note supprimée'),
        action: SnackBarAction(
          label: 'Annuler',
          onPressed: () async {
            await _db.insert(backup.copyWith(id: null));
            _refresh();
          },
        ),
      ),
    );
    await _db.delete(n.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes notes'),
        actions: [
          IconButton(
            tooltip: 'Actualiser',
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SearchBar(
              hintText: 'Rechercher une note…',
              leading: const Icon(Icons.search),
              onChanged: (v) {
                _query = v;
                _refresh();
              },
            ),
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _notes.isEmpty
              ? const _EmptyState()
              : RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _notes.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final n = _notes[i];
                      return Dismissible(
                        key: ValueKey(n.id),
                        background: Container(
                          color: Theme.of(context).colorScheme.errorContainer,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Icon(Icons.delete, color: Theme.of(context).colorScheme.onErrorContainer),
                        ),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (_) async {
                          return await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Supprimer la note ?'),
                                  content: const Text('Cette action est irréversible.'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
                                    FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Supprimer')),
                                  ],
                                ),
                              ) ??
                              false;
                        },
                        onDismissed: (_) => _delete(n),
                        child: ListTile(
                          leading: n.isPinned ? const Icon(Icons.push_pin) : null,
                          title: Text(n.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold),),
                          subtitle: Text(n.content, maxLines: 2, overflow: TextOverflow.ellipsis),
                          onTap: () async {
                            await Navigator.pushNamed(context, '/edit', arguments: n);
                            _refresh();
                          },
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Ajouter'),
        onPressed: () async {
          await Navigator.pushNamed(context, '/edit');
          _refresh();
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.note_alt_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 12),
            Text('Aucune note pour l’instant.'),
            SizedBox(height: 4),
            Text('Appuyez sur + pour créer votre première note.'),
          ],
        ),
      ),
    );
  }
}
