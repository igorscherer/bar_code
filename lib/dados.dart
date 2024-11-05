import 'package:bar_code/model/codigo_de_barras.dart';
import 'package:flutter/material.dart';
import 'package:bar_code/db/bar_code_db.dart';

class DadosPage extends StatefulWidget {
  const DadosPage({super.key});

  @override
  State<DadosPage> createState() => _DadosPageState();
}

class _DadosPageState extends State<DadosPage> {
  late SqlHelper sqlHelper;
  @override
  Widget build(BuildContext context) {
    sqlHelper = SqlHelper();
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        automaticallyImplyLeading: false,
        title: const Row(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Icon(Icons.data_object),
            SizedBox(width: 15),
            Text("Dados armazenados"),
          ],
        ),
      ),
      body: FutureBuilder<List<Codigo>>(
        future: sqlHelper.codigos(),
        builder: (BuildContext context, AsyncSnapshot<List<Codigo>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (BuildContext context, int index) {
                  Codigo item = snapshot.data![index];
                  return Wrap(
                    children: [
                      Text(item.id.toString()),
                      const Padding(padding: EdgeInsets.all(5)),
                      Text(item.codigoEscaneado),
                      const Padding(padding: EdgeInsets.all(5)),
                      Text(item.createdTime ?? "Sem data definida!"),
                      const Padding(padding: EdgeInsets.all(5)),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.red),
                          onPressed: () {
                            showDialog<void>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Excluir dado'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text(
                                            "Deseja realmente excluir o código: ${item.codigoEscaneado}?")
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('SIM'),
                                      onPressed: () {
                                        sqlHelper.deleteCodigo(item.id!);
                                        Navigator.of(context).pop();
                                        setState(() {});
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('NÃO'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Text("DELETE"),
                        ),
                      ),
                      const Divider(color: Colors.grey),
                    ],
                  );
                });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      drawer: ElevatedButton(
        style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.orange),
        onPressed: () {
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Excluir todos os dados!'),
                content: const SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text("Deseja realmente excluir todos os dados do banco? Isso é irreversível!")
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('SIM'),
                    onPressed: () {
                      sqlHelper.deleteAllCodigos();
                      Navigator.of(context)
                        ..pop()
                        ..pop();
                      setState(() {});
                    },
                  ),
                  TextButton(
                    child: const Text('NÃO'),
                    onPressed: () {
                      Navigator.of(context)
                        ..pop()
                        ..pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Text("DELETAR TODOS DADOS"),
      ),
    );
  }
}
