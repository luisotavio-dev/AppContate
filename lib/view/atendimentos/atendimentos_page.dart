// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:lancamento_contatos/model/atendimento_model.dart';
import 'package:lancamento_contatos/util.dart';
import 'package:lancamento_contatos/view/widget/card_widget.dart';
import 'package:lancamento_contatos/view/widget/gradient_floating_action_button_widget.dart';
import 'package:path_provider/path_provider.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import 'atendimentos_pdf_page.dart';

class AtendimentosPage extends StatefulWidget {
  const AtendimentosPage({super.key});

  @override
  State<AtendimentosPage> createState() => _AtendimentosPageState();
}

class _AtendimentosPageState extends State<AtendimentosPage> {
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
          'Atendimentos',
          style: TextStyle(
            color: const Color(0xff1D1617),
            fontSize: size.height * 0.025,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _relatorioAtendimentos(),
            icon: const Icon(Icons.file_present_outlined),
          ),
        ],
      ),
      floatingActionButton: GradientFloatingActionButtonWidget(
        icon: Icons.add,
        text: 'Novo Atendimento',
        onTap: () => Navigator.pushNamed(context, '/novo_atendimento').then(
          (value) {
            if (value == true) {
              setState(() {});
            }
          },
        ),
      ),
      body: Center(
        child: Container(
          height: size.height,
          width: size.height,
          decoration: const BoxDecoration(
            color: Color(0xFFfafafa),
          ),
          child: FutureBuilder<Box<Atendimento>>(
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
                            Atendimento atendimento = snapshot.data!.getAt(i)!;

                            return CardWidget(
                              title: Container(
                                margin: const EdgeInsets.only(right: 15),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            atendimento.cliente!.nome!,
                                            maxLines: 2,
                                            overflow: TextOverflow.clip,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          // ignore: prefer_interpolation_to_compose_strings
                                          'Data: ' +
                                              DateFormat('dd/MM/yyyy HH:mm').format(
                                                atendimento.dataLancamento!,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Descrição: ${atendimento.descricao ?? ''}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/detalhes_atendimento',
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

  Future<Box<Atendimento>> _getDados() async {
    String boxName = 'atendimentos';

    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<Atendimento>(boxName);
    } else {
      return Hive.openBox(boxName);
    }
  }

  _relatorioAtendimentos() async {
    Util.buildSnackMessage('Gerando PDF...', context);
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(30),
        build: (pw.Context context) => atendimentoPdf(
          DateTime(2018, 12, 31),
          DateTime(2023, 12, 31),
          Hive.box('atendimentos'),
        ),
      ),
    );

    Directory tempDir = await getTemporaryDirectory();

    final file = File('${tempDir.path}/Relatorio de Atendimentos.pdf');
    await file.writeAsBytes(await pdf.save());

    XFile xFile = XFile(file.path);
    Share.shareXFiles([xFile]);
  }
}
