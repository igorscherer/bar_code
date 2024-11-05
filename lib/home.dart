import 'dart:io';

import 'package:bar_code/dados.dart';
import 'package:bar_code/scanner.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'db/bar_code_db.dart';
import 'model/codigo_de_barras.dart';

//Home page com botões principais do app
class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.computer,
        ),
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(25),
            child: Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(120, 100),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DadosPage()));
                  },
                  child: const Text("Dados armazenados")),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(25),
            child: Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(120, 100),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ScannerPage()));
                  },
                  child: const Text("Leitor de código de barras")),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(25),
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(120, 100),
                ),
                onPressed: () {
                  exportToCSV(context);
                },
                child: const Text("Exportar dados para planilha"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> exportToCSV(BuildContext context) async {
  
  SqlHelper sqlHelper = SqlHelper(); 
  List<Codigo> codigos = await sqlHelper.codigos();

  List<List<dynamic>> rows = [];
  rows.add(["id", "Codigo Escaneado", "Data Leitura"]); 

  for (Codigo codigo in codigos) {
    rows.add([codigo.id, codigo.codigoEscaneado, codigo.createdTime]);
  }

  String csvData = const ListToCsvConverter().convert(rows);

  final directory = await getTemporaryDirectory();
  String now = DateFormat('yyyy-MM-dd_HH-mm').format(DateTime.now());
  final path = '${directory.path}/barcode_scan$now.csv';
  final file = File(path);

  try {
    await file.writeAsString(csvData);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Exportar Dados"),
          content: const Text("Você deseja compartilhar ou salvar o arquivo?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Salvar Localmente"),
              onPressed: () async {
                await saveLocally(context, file);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Compartilhar"),
              onPressed: () {
                Navigator.of(context).pop();
                shareFile(file.path);
              },
            ),
          ],
        );
      },
    );
  } catch (e) {
    if (kDebugMode) {
      print("Erro ao exportar CSV: $e");
    }
  }
}

Future<void> saveLocally(BuildContext context, File file) async {
  String now = DateFormat('yyyy-MM-dd_HH-mm').format(DateTime.now());

  String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
  if (selectedDirectory != null) {
    final newPath = '$selectedDirectory/barcode_scan_$now.csv';
    await file.copy(newPath);
    if (kDebugMode) {
      print('Arquivo CSV salvo em: $newPath');
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Arquivo exportado com sucesso!'),
        duration: Duration(seconds: 5),
      ),
    );
  } else {
    if (kDebugMode) {
      print('Cancelando...');
    }
  }
}

void shareFile(String filePath) {
  Share.shareXFiles([XFile(filePath)],
      text: 'Aqui estão todas as leituras feitas pelo app BarcodeScan!');
}
}
