import 'package:flutter/material.dart';
import 'dart:convert';

class Resultado extends StatefulWidget {
  final String informacion;

  const Resultado({Key? key, required this.informacion}) : super(key: key);

  @override
  State<Resultado> createState() => _Resultado();
}

class _Resultado extends State<Resultado> {
  @override
  Widget build(BuildContext context) {
    final List<dynamic> resultados = json.decode(widget.informacion);

    final List<List<Map<String, dynamic>>> listaDeMonedas = [];

    for (var resultado in resultados) {
      final List<Map<String, dynamic>> monedas = [];
      resultado['currencies'].forEach((abreviatura, datos) {
        final moneda = {
          'abreviatura': abreviatura,
          'nombre': datos['name'],
          'simbolo': datos['symbol'],
        };
        monedas.add(moneda);
      });
      listaDeMonedas.add(monedas);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados de búsqueda'),
      ),
      body: ListView.builder(
        itemCount: resultados.length,
        itemBuilder: (context, index) {
          final resultado = resultados[index];
          final List<Map<String, dynamic>> monedas = listaDeMonedas[index];

          // Decodificar la traducción en ruso
          String traduccionRusa = resultado['translations']['rus']['official'];
          String traduccionDecodificada =
              utf8.decode(traduccionRusa.runes.toList());
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text('Nombre oficial: ${resultado['name']['official']}'),
                ),
                // Iterar sobre la lista de monedas
                for (final moneda in monedas)
                  ListTile(
                    title: Text('Moneda'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Abreviatura: ${moneda['abreviatura']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Nombre: ${moneda['nombre']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Símbolo: ${utf8.decode(moneda['simbolo'].runes.toList())}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ListTile(
                  title: Text('Capital: ${utf8.decode(resultado['capital'].toString().codeUnits)}'),
                ),
                ListTile(
                  title: Text('Region: ${resultado['region']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sub region: ${resultado['subregion']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Lenguajes: ${resultado['languages']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text('Traducción en ruso: $traduccionDecodificada'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
