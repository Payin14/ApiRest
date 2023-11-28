import 'dart:convert';
import 'dart:io';

import 'package:apirest_app/resultado.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'alerts.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController countryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  Future<void> obtenerInformacionAPI() async {
  if (!_formKey.currentState!.validate()) {
    return;
  }

  if (countryController.text.isEmpty) {
    mostrarError('Por favor, ingresa al menos un dato.', context);
    return;
  }

  mostrarAlertDialog(context, 'Buscando información...');

  try {
    // URL de la API con el nombre del país deseado
    String apiUrl = 'https://restcountries.com/v3.1/name/${countryController.text}';

    var response = await http.get(Uri.parse(apiUrl));
   
    if (response.statusCode == 200) {
      var data = response.body;

      mostrarResultados(data);
    }else{
    Navigator.of(context, rootNavigator: true).pop();
    mostrarError('No se encontraron datos', context);
    }
  } on SocketException {
    Navigator.of(context, rootNavigator: true).pop();
    mostrarError('Error de red: No se pudo conectar al servidor', context);
  } catch (e) {
    Navigator.of(context, rootNavigator: true).pop();
    mostrarError('Otro error inesperado: $e', context);
  }
}

  Future<void> mostrarResultados(dynamic data) async {
    try {
      var jsonResponse = json.decode(data);
      
      if (jsonResponse is Map) {
        // Caso: Respuesta es un objeto
        bool success = jsonResponse['status'];
        String message = jsonResponse['message'];
        if (!success) {
          Navigator.of(context, rootNavigator: true).pop();
          mostrarError(message, context);
          return;
        }
      } else if (jsonResponse is List) {
        // Caso: Respuesta es una lista de objetos
        if (jsonResponse.isEmpty) {
          Navigator.of(context, rootNavigator: true).pop();
          mostrarError('La lista de resultados está vacía.', context);
          return;
        }
        Navigator.of(context, rootNavigator: true).pop();
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Resultado(
              informacion: data,
            ),
          ),
        );        
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        mostrarError('Error: Respuesta de la API inesperada.', context);
      }
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      mostrarError('Error al procesar la respuesta de la API', context);      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar País'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                TextFormField(
                  controller: countryController,
                  decoration: const InputDecoration(
                    hintText: 'País',
                    prefixIcon: Icon(Icons.map_outlined),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    onPressed: obtenerInformacionAPI,
                    icon: const Icon(Icons.search),
                    label: const Text('Buscar', style: TextStyle(fontSize: 20)),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
