import 'package:flutter/material.dart';
import 'database_manager.dart';
import 'modele/Redacteur.dart';

void main() {
  runApp(const MonApplication());
}

class MonApplication extends StatelessWidget {
  const MonApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion des rédacteurs',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Gestion des rédacteurs',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
        ),
        body: const RedacteurInterface(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RedacteurInterface extends StatefulWidget {
  const RedacteurInterface({super.key});

  @override
  State<RedacteurInterface> createState() => _RedacteurInterfaceState();
}

class _RedacteurInterfaceState extends State<RedacteurInterface> {
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();

  List<Redacteur> redacteurs = [];

  @override
  void initState() {
    super.initState();
    _loadRedacteurs();
  }

  /// Charger tous les rédacteurs depuis la base
  Future<void> _loadRedacteurs() async {
    final data = await DatabaseManager.instance.getAllRedacteurs();
    setState(() {
      redacteurs = data;
    });
  }

  /// Ajouter un rédacteur
  Future<void> _addRedacteur() async {
    if (_nomController.text.isEmpty ||
        _prenomController.text.isEmpty ||
        _emailController.text.isEmpty) {
      return;
    }

    final redacteur = Redacteur(
      nom: _nomController.text,
      prenom: _prenomController.text,
      email: _emailController.text,
    );

    await DatabaseManager.instance.insertRedacteur(redacteur);

    _nomController.clear();
    _prenomController.clear();
    _emailController.clear();

    _loadRedacteurs();
  }

  /// Modifier un rédacteur
  Future<void> _editRedacteur(Redacteur redacteur) async {
    final nomController = TextEditingController(text: redacteur.nom);
    final prenomController = TextEditingController(text: redacteur.prenom);
    final emailController = TextEditingController(text: redacteur.email);

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Modifier Rédacteur"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nomController, decoration: const InputDecoration(labelText: "Nouveau Nom"), style: TextStyle(color: Colors.blue),),
            TextField(controller: prenomController, decoration: const InputDecoration(labelText: "Nouveau Prénom"), style: TextStyle(color: Colors.blue),),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Nouveau Email"), style: TextStyle(color: Colors.blue),),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Annuler", style: TextStyle(color: Colors.blue)),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            child: const Text("Enregistrer", style: TextStyle(color: Colors.blue)),
            onPressed: () async {
              final updated = Redacteur(
                id: redacteur.id,
                nom: nomController.text,
                prenom: prenomController.text,
                email: emailController.text,
              );

              await DatabaseManager.instance.updateRedacteur(updated);

              Navigator.pop(ctx);
              _loadRedacteurs();
            },
          )
        ],
      ),
    );
  }

  /// Supprimer un rédacteur
  Future<void> _deleteRedacteur(Redacteur redacteur) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Supprimer Rédacteur"),
        content: Text("Voulez-vous vraiment supprimer ${redacteur.nom} ${redacteur.prenom} ?"),
        actions: [
          TextButton(
            child: const Text("Annuler"),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Supprimer"),
            onPressed: () async {
              await DatabaseManager.instance.deleteRedacteur(redacteur.id!);
              Navigator.pop(ctx);
              _loadRedacteurs();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(controller: _nomController, decoration: const InputDecoration(labelText: "Nom")),
            TextField(controller: _prenomController, decoration: const InputDecoration(labelText: "Prénom")),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email")),
            const SizedBox(height: 10),
            
            SizedBox(
              width: double.infinity, // largeur max
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add, color: Colors.white),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.orange),
                  padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 16)), // optionnel : augmente la hauteur
                ),
                label: const Text(
                  "Ajouter un Rédacteur",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: _addRedacteur,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: redacteurs.isEmpty
                  ? const Center(child: Text("Aucun rédacteur enregistré"))
                  : ListView.builder(
                      itemCount: redacteurs.length,
                      itemBuilder: (context, index) {
                        final r = redacteurs[index];
                        return Card(
                          child: ListTile(
                            title: Text("${r.nom} ${r.prenom}"),
                            subtitle: Text(r.email),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteRedacteur(r),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.grey),
                                  onPressed: () => _editRedacteur(r),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      );
  }
}
