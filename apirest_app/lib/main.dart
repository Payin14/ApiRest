import 'package:flutter/material.dart';

import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Mi Aplicación',
      home: PaginaPrincipal(),
    );
  }
}

class PaginaPrincipal extends StatelessWidget {
  const PaginaPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página Principal'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('¡Búsquemos información de un país!'),
            ElevatedButton(
              onPressed: () {
                // Navegar a la vista secundaria
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MyHomePage(title: 'ola',),
                  ),
                );
              },
              child: const Text('Ir al buscador'),
            ),
          ],
        ),
      ),
    );
  }
}