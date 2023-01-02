// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lancamento_contatos/model/cliente_model.dart';
import 'package:lancamento_contatos/view/widget/card_widget.dart';
import 'package:lancamento_contatos/view/widget/gradient_floating_action_button_widget.dart';

class ClientesPage extends StatefulWidget {
  const ClientesPage({super.key});

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFfafafa),
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
      ),
      floatingActionButton: GradientFloatingActionButtonWidget(
        icon: Icons.add,
        text: 'Novo Cliente',
        onTap: () => Navigator.pushNamed(context, '/novo_cliente').then((value) {
          if (value == true) {
            setState(() {});
          }
        }),
      ),
      body: Center(
        child: Container(
          height: size.height,
          width: size.height,
          decoration: const BoxDecoration(
            color: Color(0xFFfafafa),
          ),
          child: FutureBuilder<Box<Cliente>>(
            future: _getDados(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }

                if (!snapshot.hasData || snapshot.hasData && snapshot.data!.length <= 0) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.clear,
                        size: 40,
                      ),
                      SizedBox(height: 10),
                      Text('Não há dados para exibir.'),
                    ],
                  );
                }

                return Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.02,
                    horizontal: size.height * 0.03,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, i) {
                            Cliente cliente = snapshot.data!.getAt(i)!;

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
                                    Text('Conta: ${cliente.conta!}'),
                                  ],
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/detalhes_cliente',
                                  arguments: snapshot.data!.getAt(i),
                                );
                              },
                            );
                          },
                          itemCount: snapshot.data!.length,
                        ),
                        SizedBox(height: size.height * 0.02),
                      ],
                    ),
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }

  Future<Box<Cliente>> _getDados() async {
    String boxName = 'clientes';

    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<Cliente>(boxName);
    } else {
      return Hive.openBox(boxName);
    }
  }
}
