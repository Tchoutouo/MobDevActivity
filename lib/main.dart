import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'screens/login_page.dart';
import 'screens/notes_list_page.dart';
import 'screens/note_editor_page.dart';

void main() => runApp(const NotesApp());

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    final color = const Color(0xFF6750A4);
    return MaterialApp(
      title: 'Notes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: color),
        useMaterial3: true,
        snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginPage(),
        '/notes': (_) => const NotesListPage(),
        '/edit': (_) => const NoteEditorPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
