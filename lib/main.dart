import 'package:flutter/material.dart';

void main() {
  runApp(const MonAppli());
}

class MonAppli extends StatelessWidget {
  const MonAppli({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magazine',
      home: PageAccueil(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PageAccueil extends StatelessWidget {
  const PageAccueil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Magazine Infos',
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
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(
              image: AssetImage('assets/images/magazineInfo.png'),
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            PartieTitre(),
            PartieTexte(),
            PartieIcone(),
            PartieRubrique(),
          ],
        ),
      ),
    );
  }
}

class PartieTitre extends StatelessWidget {
  const PartieTitre({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bienvenue au Magazine Infos",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            "Votre magazine numérique, votre source d'inspiration.",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}


class PartieTexte extends StatelessWidget {
  const PartieTexte({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: const Text(
        "Magazine Infos est un magazine numérique moderne qui offre "
        "des articles variés sur la culture, la presse et la mode. "
        "Son objectif est de donner aux lecteurs un accès simple et "
        "rapide à des contenus intéressants et enrichissants.",
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
    );
  }
}


class PartieIcone extends StatelessWidget {
  const PartieIcone({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _IconeItem(icon: Icons.phone, label: "TEL"),
          _IconeItem(icon: Icons.email, label: "MAIL"),
          _IconeItem(icon: Icons.share, label: "PARTAGE"),
        ],
      ),
    );
  }
}

// Widget réutilisable pour chaque icône
class _IconeItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _IconeItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.pink, size: 30),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            color: Colors.pink,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}


class PartieRubrique extends StatelessWidget {
  const PartieRubrique({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/images/presse.png',
              width: 150,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/images/mode.png',
              width: 150,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
