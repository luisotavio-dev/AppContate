// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lancamento_contatos/model/cliente_model.dart';
import 'package:lancamento_contatos/theme.dart';
import 'package:lancamento_contatos/view/widgets/card_widget.dart';
import 'package:lancamento_contatos/view/widgets/gradient_floating_action_button_widget.dart';
import 'package:lancamento_contatos/view/widgets/text_field_widget.dart';

class ClientesPage extends StatefulWidget {
  const ClientesPage({super.key});

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  final _pesquisaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Clientes',
          style: TextStyle(
            color: const Color(0xff1D1617),
            fontSize: size.height * 0.025,
            fontWeight: FontWeight.bold,
          ),
        ),
        leadingWidth: defaultLeadingPadding,
      ),
      floatingActionButton: GradientFloatingActionButtonWidget(
        icon: Icons.add,
        text: 'Novo Cliente',
        onTap: () => Navigator.pushNamed(context, '/persistir_cliente').then((value) {
          if (value != null) {
            setState(() {});
          }
        }),
      ),
      body: Center(
        child: Container(
          height: size.height,
          width: size.width,
          decoration: const BoxDecoration(
            color: backgroundColor,
          ),
          padding: defaultPagePadding,
          child: Column(
            children: [
              TextFieldWidget(
                hintText: 'Pesquisar',
                validator: (valuename) {
                  return null;
                },
                controller: _pesquisaController,
                defaultFocus: true,
                textInputAction: TextInputAction.search,
                size: size,
                icon: Icons.search_outlined,
                onChanged: (value) => setState(() {}),
              ),
              Expanded(
                child: FutureBuilder<List<Cliente>>(
                  future: _getDados(pesquisa: _pesquisaController.text),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Center(child: Text(snapshot.error.toString()));
                      }

                      if (!snapshot.hasData || snapshot.hasData && snapshot.data!.isEmpty) {
                        return const Center(child: Text('Não há dados para exibir.'));
                      }

                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, i) {
                                Cliente cliente = snapshot.data![i];

                                return CardWidget(
                                  title: Container(
                                    margin: const EdgeInsets.only(right: 15),
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          cliente.nome!,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Visibility(
                                          visible: cliente.conta != null,
                                          child: Text('Conta: ${cliente.conta ?? ''}'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/detalhes_cliente',
                                      arguments: cliente,
                                    ).then((value) {
                                      setState(() {});
                                    });
                                  },
                                );
                              },
                              itemCount: snapshot.data!.length,
                            ),
                            SizedBox(height: size.height * 0.02),
                          ],
                        ),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Cliente>> _getDados({String pesquisa = ''}) async {
    String boxName = 'clientes';
    List<Cliente> clientes = <Cliente>[];

    if (Hive.isBoxOpen(boxName)) {
      clientes = Hive.box<Cliente>(boxName).values.toList();
      clientes.sort((a, b) => a.nome!.compareTo(b.nome!));
    } else {
      var box = await Hive.openBox<Cliente>(boxName);
      clientes = box.values.toList();
      clientes.sort((a, b) => a.nome!.compareTo(b.nome!));
    }

    if (pesquisa == '') return clientes;
    return clientes
        .where((element) => element.nome!.contains(pesquisa) || element.conta!.toString().contains(pesquisa))
        .toList();
  }
}
