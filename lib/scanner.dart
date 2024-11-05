import 'package:flutter/material.dart';
import 'package:bar_code/model/codigo_de_barras.dart';
import 'package:bar_code/db/bar_code_db.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart'; // Import this package for clipboard functionality

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

String? scanResult;

var lista = <String>[];

class _ScannerPageState extends State<ScannerPage> {
  late SqlHelper sqlHelper;

  @override
  void initState() {
    super.initState();
    sqlHelper = SqlHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Escaneie um código")),
      body: Center(
        child: Column(
          children: [
            Text(scanResult == null || scanResult == '-1'
                ? ""
                : "Último código escaneado: ${scanResult.toString()}"),
            const SizedBox(height: 100),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 168, 0, 0),
                foregroundColor: Colors.white,
                minimumSize: const Size(50, 50),
              ),
              onPressed: () {
                if (lista.isNotEmpty) {
                  lista.removeLast();
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Nada para excluir"),
                      content:
                          const Text("Nao ha registros para serem deletados"),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Ok"))
                      ],
                    ),
                  );
                }
                setState(() {});
              },
              child: const Text("Apagar ultimo cadastro apenas desta tela"),
            ),
            const SizedBox(height: 120),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(90, 110)),
              onPressed: scanBarcode,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt_outlined),
                  Text("Escanear código de barras"),
                ],
              ),
            ),
            const SizedBox(height: 60),
            SelectableText(lista.toString()),
            Text("Itens na lista: ${lista.length.toString()}"),
            const SizedBox(height: 20), // Added spacing
            ElevatedButton(
              onPressed: () {
                // Copy the text to the clipboard
                Clipboard.setData(ClipboardData(text: lista.join(', ')));
              },
              child: const Text("Copiar Texto"),
            ),
          ],
        ),
      ),
    );
  }

  Future scanBarcode() async {
    scanResult = await SimpleBarcodeScanner.scanBarcode(
        isShowFlashIcon: true,
        context,
        barcodeAppBar: const BarcodeAppBar(
            appBarTitle: 'Test',
            centerTitle: false,
            enableBackButton: true,
            backButtonIcon: Icon(Icons.arrow_back_ios)));
    if (scanResult != "-1") {
      addToList();
      insertIntoDB(scanResult);
      setState(() {});
    }
  }

  void addToList() async {
    lista.add(scanResult.toString());
  }

  insertIntoDB(String? a) {
    Codigo b = Codigo(
        codigoEscaneado: a!,
        createdTime: DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now()));
    sqlHelper.insertCodigo(b);
  }
}
