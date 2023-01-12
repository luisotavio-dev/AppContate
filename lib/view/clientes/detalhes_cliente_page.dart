import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:lancamento_contatos/globals.dart';
import 'package:lancamento_contatos/model/cliente_model.dart';
import 'package:lancamento_contatos/theme.dart';
import 'package:lancamento_contatos/view/widget/gradient_floating_action_button_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DetalhesClientePage extends StatefulWidget {
  final Cliente cliente;
  const DetalhesClientePage(this.cliente, {super.key});

  @override
  State<DetalhesClientePage> createState() => _DetalhesClientePageState();
}

class _DetalhesClientePageState extends State<DetalhesClientePage> {
  late Cliente cliente = Cliente();

  @override
  void initState() {
    cliente = widget.cliente;
    super.initState();
  }

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
          'Detalhes do Cliente',
          style: TextStyle(
            color: const Color(0xff1D1617),
            fontSize: size.height * 0.025,
            fontWeight: FontWeight.bold,
          ),
        ),
        leadingWidth: defaultLeadingPadding,
        actions: [
          SizedBox(
            width: defaultLeadingPadding,
            child: IconButton(
              onPressed: () => _menu(),
              icon: const Icon(Icons.more_vert),
            ),
          ),
        ],
      ),
      body: Container(
        height: size.height,
        width: size.width,
        padding: defaultPagePadding,
        decoration: const BoxDecoration(
          color: backgroundColor,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(bottom: size.height * 0.01),
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: size.height * 0.06,
                  ),
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Nome: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Flexible(child: Text(cliente.nome!)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: size.height * 0.01),
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: size.height * 0.06,
                  ),
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Lançado em: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(dateTimeFormatter.format(cliente.dataLancamento!)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: size.height * 0.01),
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: size.height * 0.06,
                  ),
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Conta: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(cliente.conta!.toString()),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: size.height * 0.01),
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: size.height * 0.06,
                  ),
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Telefone Principal: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(UtilBrasilFields.obterTelefone(cliente.telefone1!)),
                    ],
                  ),
                ),
              ),
              cliente.telefone2 != null && cliente.telefone2 != ""
                  ? Padding(
                      padding: EdgeInsets.only(bottom: size.height * 0.01),
                      child: Container(
                        constraints: BoxConstraints(
                          minHeight: size.height * 0.06,
                        ),
                        width: size.width * 0.9,
                        padding: const EdgeInsets.all(15),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Row(
                          children: [
                            const Text(
                              'Telefone Alternativo: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(UtilBrasilFields.obterTelefone(cliente.telefone2!)),
                          ],
                        ),
                      ),
                    )
                  : const Visibility(visible: false, child: SizedBox()),
              cliente.observacoes != null && cliente.observacoes != ''
                  ? Padding(
                      padding: EdgeInsets.only(bottom: size.height * 0.01),
                      child: Container(
                        constraints: BoxConstraints(
                          minHeight: size.height * 0.06,
                        ),
                        width: size.width * 0.9,
                        padding: const EdgeInsets.all(15),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Observações: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(cliente.observacoes!.toString()),
                          ],
                        ),
                      ),
                    )
                  : const Visibility(visible: false, child: SizedBox()),
            ],
          ),
        ),
      ),
      floatingActionButton: GradientFloatingActionButtonWidget(
        icon: Icons.chat_outlined,
        text: 'Atendimentos',
        onTap: () {
          Navigator.pushNamed(
            context,
            '/atendimentos',
            arguments: cliente,
          );
        },
      ),
    );
  }

  _menu() {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              iconColor: Theme.of(context).colorScheme.secondary,
              title: const Text('Editar Cliente'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  '/persistir_cliente',
                  arguments: cliente,
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      cliente = value as Cliente;
                    });
                  }
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_outlined),
              iconColor: Theme.of(context).colorScheme.secondary,
              title: const Text('Novo Atendimento para o Cliente'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  '/novo_atendimento',
                  arguments: cliente,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
