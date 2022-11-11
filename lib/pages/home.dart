import 'package:flutter/material.dart';
import 'package:supercalc/helpers/utils.dart';
import 'package:supercalc/models/item_arguments.dart';
import 'package:supercalc/models/lista.dart';
import 'package:supercalc/repositories/lista_repository.dart';
import 'package:provider/provider.dart';
import 'package:supercalc/widgets/alert_dialogs.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> showInformationDialog(
      BuildContext context, bool update, int id, String nome) async {
    final TextEditingController _nomeController =
        TextEditingController(text: nome);
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Form(
              key: formKey,
              child: AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Nome da Lista'),
                    TextFormField(
                      controller: _nomeController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(),
                      validator: ((value) {
                        if (value == null) return 'Digite um nome';
                        return value.isNotEmpty ? null : 'Digite um nome';
                      }),
                    )
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.red),
                      )),
                  TextButton(
                      onPressed: (() {
                        if (formKey.currentState!.validate()) {
                          var _lista =
                              Lista(nome: _nomeController.text, saldo: 0);
                          if (update) {
                            Provider.of<ListaRepository>(context, listen: false)
                                .update(
                                    id: id,
                                    nome: _nomeController.text,
                                    onSuccess: () {
                                      Navigator.of(context).pop();
                                    },
                                    onError: () {
                                      errorDialog(context,
                                          'Não foi possivel alterar os dados');
                                    });
                          } else {
                            Provider.of<ListaRepository>(context, listen: false)
                                .save(
                                    lista: _lista,
                                    onSuccess: () {
                                      Navigator.of(context).pop();
                                    },
                                    onError: () {
                                      errorDialog(context,
                                          'Não foi possivel salvar os dados');
                                    });
                          }
                        }
                      }),
                      child: const Text('OK'))
                ],
              ),
            );
          });
        });
  }

  @override
  void initState() {
    Provider.of<ListaRepository>(context, listen: false).loadAll();
    print('inicial home');
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Consumer<ListaRepository>(builder: (_, listaRepository, __) {
        final listas = listaRepository.getListas;
        return ListView.builder(
            itemBuilder: ((context, index) {
              return ListTile(
                  title: Text(
                    listas[index].nome,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(listas[index].saldo.toString().toReal()),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(
                        onPressed: () => {
                              Navigator.of(context).pushNamed('/items',
                                  arguments: ItemArguments(
                                      listas[index].nome, listas[index].id!))
                            },
                        icon: const Icon(
                          Icons.add_shopping_cart_outlined,
                          color: Color.fromARGB(255, 240, 140, 0),
                        )),
                    IconButton(
                        onPressed: () => {
                              showInformationDialog(context, true,
                                  listas[index].id!, listas[index].nome)
                            },
                        icon: const Icon(
                          Icons.edit,
                          color: Color.fromARGB(255, 96, 118, 136),
                        )),
                    IconButton(
                        onPressed: () => {
                              confirmationDialog(context,
                                  'Deseja realmente excluir esta lista e todos os items vinculados a ela?\n${listas[index].nome}',
                                  title: 'Exclusão',
                                  icon: AlertDialogIcon.ERROR_ICON,
                                  color: AlertDialogColors.ERROR,
                                  textAlign: TextAlign.left,
                                  confirm: true, positiveAction: () {
                                Provider.of<ListaRepository>(context,
                                        listen: false)
                                    .remove(
                                        id: listas[index].id ?? 0,
                                        onSuccess: () => {
                                              infoDialog(context,
                                                  'Excluido ${listas[index].id}')
                                            },
                                        onError: () => {});
                              })
                            },
                        icon: const Icon(
                          Icons.delete_forever,
                          color: Colors.red,
                        )),
                  ]));
            }),
            itemCount: listas.length);
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showInformationDialog(context, false, 0, ''),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
