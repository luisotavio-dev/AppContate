import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lancamento_contatos/model/atendimento_model.dart';

class DetalhesAtendimentoPage extends StatefulWidget {
  const DetalhesAtendimentoPage({super.key});

  @override
  State<DetalhesAtendimentoPage> createState() => _DetalhesAtendimentoPageState();
}

class _DetalhesAtendimentoPageState extends State<DetalhesAtendimentoPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final atendimento = ModalRoute.of(context)!.settings.arguments as Atendimento;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFfafafa),
        foregroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Detalhes do Atendimento',
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
                        'Lançado em: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(DateFormat('dd/MM/yyyy HH:mm').format(atendimento.dataLancamento!)),
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
                        'Cliente: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Flexible(child: Text(atendimento.cliente!.nome!)),
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
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (value) {},
                    value: atendimento.atendeu,
                    title: const Text('Atendeu'),
                  ),
                ),
              ),
              Padding(
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
                        'Descrição: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(atendimento.descricao ?? ''),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}