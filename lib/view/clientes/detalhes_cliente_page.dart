import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lancamento_contatos/model/cliente_model.dart';

class DetalhesClientePage extends StatefulWidget {
  const DetalhesClientePage({super.key});

  @override
  State<DetalhesClientePage> createState() => _DetalhesClientePageState();
}

class _DetalhesClientePageState extends State<DetalhesClientePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final cliente = ModalRoute.of(context)!.settings.arguments as Cliente;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFfafafa),
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
      ),
      body: Container(
        height: size.height,
        width: size.height,
        padding: const EdgeInsets.only(left: 24.0, right: 25.0, top: 15.0, bottom: 15.0),
        decoration: const BoxDecoration(
          color: Color(0xFFfafafa),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                      Text(DateFormat('dd/MM/yyyy HH:mm').format(cliente.dataLancamento!)),
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
            ],
          ),
        ),
      ),
    );
  }
}
