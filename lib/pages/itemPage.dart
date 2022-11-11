import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:supercalc/helpers/utils.dart';
import 'package:supercalc/models/lista_items.dart';
import 'package:supercalc/repositories/items_repository.dart';
import 'package:provider/provider.dart';
import 'package:supercalc/repositories/lista_repository.dart';
import 'package:supercalc/widgets/alert_dialogs.dart';

class ItemPage extends StatefulWidget {
  final int listId;
  const ItemPage({super.key, required this.listId, required this.title});

  final String title;

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  late ItemsRepository items;

  Future<void> showInformationDialog(
      BuildContext context, int listId, String descricao) async {
    final CurrencyTextInputFormatter _currencyTextInputFormatter =
        CurrencyTextInputFormatter(
            locale: 'pt_BR', decimalDigits: 2, symbol: 'R\$');

    final TextEditingController _descricaoController =
        TextEditingController(text: descricao);
    final TextEditingController _precoController =
        TextEditingController(text: _currencyTextInputFormatter.format('0'));
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
                    TextFormField(
                        controller: _descricaoController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(),
                        validator: ((value) {
                          if (value == null) return 'Digite uma descrição';
                          return value.isNotEmpty
                              ? null
                              : 'Digite um descrição';
                        })),
                    TextFormField(
                      controller: _precoController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        CurrencyTextInputFormatter(
                            locale: 'pt_BR', decimalDigits: 2, symbol: 'R\$')
                      ],
                      decoration: const InputDecoration(hintText: "R\$0,00"),
                    )
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: (() {
                        Navigator.of(context).pop();
                      }),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 253, 118, 0)),
                      )),
                  TextButton(
                      onPressed: (() {
                        if (formKey.currentState!.validate()) {
                          var _item = ListaItems(
                              descricao: _descricaoController.text,
                              valor: _precoController.text.toDouble(),
                              listaId: listId);

                          if (_item.valor == 0) {
                            infoDialog(
                                context, 'Digite um valor diferente de zero.');
                          } else {
                            Provider.of<ItemsRepository>(context, listen: false)
                                .save(
                                    item: _item,
                                    onSuccess: () => {
                                          Provider.of<ListaRepository>(context,
                                                  listen: false)
                                              .loadAll(),
                                          Navigator.of(context).pop()
                                        },
                                    onError: () {
                                      errorDialog(context,
                                          'Não foi possivel salvar os dados');
                                    });
                          }
                        }
                      }),
                      child: const Text('Somar',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 8, 85, 11)))),
                  TextButton(
                      onPressed: (() {
                        if (formKey.currentState!.validate()) {
                          var _item = ListaItems(
                              descricao: _descricaoController.text,
                              valor: _precoController.text.toDouble() * -1,
                              listaId: listId);
                          if (_item.valor == 0) {
                            infoDialog(
                                context, 'Digite um valor diferente de zero.');
                          } else {
                            Provider.of<ItemsRepository>(context, listen: false)
                                .save(
                                    item: _item,
                                    onSuccess: () => {
                                          Provider.of<ListaRepository>(context,
                                                  listen: false)
                                              .loadAll(),
                                          Navigator.of(context).pop()
                                        },
                                    onError: () {
                                      errorDialog(context,
                                          'Não foi possivel salvar os dados');
                                    });
                          }
                        }
                      }),
                      child: const Text('Subtrair',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 174, 0, 0))))
                ],
              ),
            );
          });
        });
  }

  @override
  void initState() {
    Provider.of<ItemsRepository>(context, listen: false).loadAll(widget.listId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    items = context.watch<ItemsRepository>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () => showInformationDialog(context, widget.listId,
                  'Item - ${items.getListaItems.length}'),
              icon: const Icon(Icons.add_shopping_cart_outlined))
        ],
      ),
      body: Consumer<ItemsRepository>(builder: (_, itemsRepository, __) {
        final items = itemsRepository.getListaItems;
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemBuilder: ((context, index) {
                    return ListTile(
                        title: Text(
                          items[index].descricao,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(
                          items[index].valor.toString().toReal(),
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: items[index].valor > 0
                                  ? Colors.black
                                  : Colors.red),
                        ),
                        trailing:
                            Row(mainAxisSize: MainAxisSize.min, children: [
                          /*  IconButton(
                              onPressed: () => {
                                    infoDialog(
                                        context, 'Editar ${items[index].id}')
                                  },
                              icon: const Icon(
                                Icons.edit,
                                color: Color.fromARGB(255, 96, 118, 136),
                              )), */
                          IconButton(
                              onPressed: () => {
                                    confirmationDialog(context,
                                        'Deseja realmente excluir este item ?\n${items[index].descricao}',
                                        title: 'Exclusão',
                                        icon: AlertDialogIcon.ERROR_ICON,
                                        color: AlertDialogColors.ERROR,
                                        textAlign: TextAlign.left,
                                        confirm: true, positiveAction: () {
                                      Provider.of<ItemsRepository>(context,
                                              listen: false)
                                          .remove(
                                              id: items[index].id ?? 0,
                                              listId: items[index].listaId,
                                              onSuccess: () async => {
                                                    Provider.of<ListaRepository>(
                                                            context,
                                                            listen: false)
                                                        .loadAll(),
                                                    infoDialog(context,
                                                        'Excluido ${items[index].id}')
                                                  },
                                              onError: () => {});
                                    })
                                  },
                              icon: const Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                              )),
                        ]));
                  }),
                  itemCount: items.length),
            ),
            Container(
              color: Colors.blue[50],
              width: double.infinity,
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Somatoria:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  items.isNotEmpty
                      ? Text(
                          items
                              .map((e) => e.valor)
                              .reduce((value, current) => value + current)
                              .toString()
                              .toReal(),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))
                      : const Text('R\$0,00',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}
