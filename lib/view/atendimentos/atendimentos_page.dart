// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lancamento_contatos/theme.dart';
import 'package:lancamento_contatos/globals.dart';
import 'package:lancamento_contatos/model/atendimento_model.dart';
import 'package:lancamento_contatos/model/cliente_model.dart';
import 'package:lancamento_contatos/util.dart';
import 'package:lancamento_contatos/view/atendimentos/persistir_atendimento_page.dart';
import 'package:lancamento_contatos/view/widget/button_widget.dart';
import 'package:lancamento_contatos/view/widget/card_widget.dart';
import 'package:lancamento_contatos/view/widget/gradient_floating_action_button_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class AtendimentosPage extends StatefulWidget {
  //Consultar atendimentos de um cliente específico
  final Cliente? cliente;
  const AtendimentosPage(this.cliente, {super.key});

  @override
  State<AtendimentosPage> createState() => _AtendimentosPageState();
}

class _AtendimentosPageState extends State<AtendimentosPage> {
  Cliente? get cliente => widget.cliente;

  DateTime filtroDataInicio = DateTime.now();
  DateTime filtroDataFim = DateTime.now();
  DateTime filtroDataMinima = DateTime.now().add(const Duration(days: -365));
  bool filtroAtivo = false;

  List<Atendimento> atendimentosRenderizando = <Atendimento>[];

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
          'Atendimentos',
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
      floatingActionButton: GradientFloatingActionButtonWidget(
        icon: Icons.add,
        text: 'Novo Atendimento',
        onTap: () {
          ParametrosPersistirAtendimento parametros = ParametrosPersistirAtendimento()..clienteSugerido = cliente;

          Navigator.pushNamed(context, '/persistir_atendimento', arguments: parametros).then(
            (value) {
              if (value != null) {
                setState(() {});
              }
            },
          );
        },
      ),
      body: Center(
        child: Container(
          height: size.height,
          width: size.width,
          padding: defaultPagePadding,
          decoration: const BoxDecoration(
            color: backgroundColor,
          ),
          child: Column(
            children: [
              Visibility(
                visible: cliente != null,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: gradient),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: EdgeInsets.only(top: 10, bottom: filtroAtivo ? 0 : 10),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      cliente != null ? cliente!.nome! : 'Cliente: Luis Otavio',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: filtroAtivo,
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color.fromARGB(255, 237, 237, 237)),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Filtro Habilitado',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          TextButton.icon(
                            label: const Text('Remover Filtro'),
                            onPressed: () {
                              setState(() {
                                filtroAtivo = false;
                                filtroDataInicio = DateTime.now();
                                filtroDataFim = DateTime.now();
                              });
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      Text(
                        'Período: ${dateFormatter.format(filtroDataInicio)} a ${dateFormatter.format(filtroDataFim)}',
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Atendimento>>(
                  future: _getDados(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Center(child: Text(snapshot.error.toString()));
                      }

                      if (!snapshot.hasData || snapshot.hasData && snapshot.data!.isEmpty) {
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

                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, i) {
                                Atendimento atendimento = snapshot.data![i];

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
                                              'Data: ' + dateTimeFormatter.format(atendimento.dataLancamento!),
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
                                      arguments: atendimento,
                                    ).then((value) => setState(() {}));
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

  Future<List<Atendimento>> _getDados() async {
    String boxName = 'atendimentos';
    List<Atendimento> atendimentos = <Atendimento>[];

    if (Hive.isBoxOpen(boxName)) {
      atendimentos = Hive.box<Atendimento>(boxName).values.toList();
    } else {
      Box<Atendimento> box = await Hive.openBox(boxName);
      atendimentos = box.values.toList();
    }

    if (cliente != null) {
      atendimentos = atendimentos.where((element) => element.cliente!.idCliente == cliente!.idCliente).toList();
    }

    if (filtroAtivo) {
      //Seta as horas para buscar o dia todo
      filtroDataInicio = Util.setHourToDateTime(filtroDataInicio, 0, 0, 0);
      filtroDataFim = Util.setHourToDateTime(filtroDataFim, 23, 59, 59);

      atendimentos = atendimentos.where((element) => element.dataLancamento!.isAfter(filtroDataInicio) && element.dataLancamento!.isBefore(filtroDataFim)).toList();
    }

    atendimentosRenderizando = atendimentos;

    return atendimentos;
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
              leading: const Icon(Icons.filter_alt_outlined),
              iconColor: Theme.of(context).colorScheme.secondary,
              title: const Text('Filtrar Atendimentos'),
              onTap: () => _filtros(),
            ),
            ListTile(
              leading: const Icon(Icons.file_present_outlined),
              iconColor: Theme.of(context).colorScheme.secondary,
              title: const Text('Gerar Relatório'),
              onTap: () => _relatorioAtendimentos(),
            ),
          ],
        ),
      ),
    );
  }

  _relatorioAtendimentos() async {
    Util.buildSnackMessage('Gerando PDF...', context);
    final pdf = pw.Document();

    final logoApp = await Util.logoAppRelatorios();
    final logoLM = await Util.logoLMSoftwaresRelatorios();

    const String titulo = 'Relação de Atendimentos';

    List<List<String>> linhas = [];
    linhas.add(<String>['Cliente', 'Conta', 'Data', 'Atendeu', 'Descrição']);

    for (Atendimento atendimento in atendimentosRenderizando) {
      if (atendimento.cliente!.conta == null) {
        var dadosCliente = Hive.box<Cliente>('clientes').values.where((element) => element.idCliente == atendimento.cliente!.idCliente).toList();
        atendimento.cliente = dadosCliente[0];
      }

      linhas.add(<String>[
        atendimento.cliente!.nome!,
        (atendimento.cliente!.conta ?? '').toString(),
        dateTimeFormatter.format(atendimento.dataLancamento!),
        atendimento.atendeu! ? 'Sim' : 'Não',
        atendimento.descricao ?? '',
      ]);
    }

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(30),
        build: (pw.Context context) => <pw.Widget>[
          pw.Header(
            level: 0,
            title: titulo,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: <pw.Widget>[
                    pw.Text(
                      titulo,
                      textScaleFactor: 2,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Image(
                      pw.MemoryImage(logoApp),
                      width: 130,
                    ),
                  ],
                ),
                pw.Text(
                  'Período: ${dateFormatter.format(filtroDataInicio)} à ${dateFormatter.format(filtroDataFim)}',
                  style: pw.Theme.of(context).defaultTextStyle.copyWith(
                        color: PdfColors.grey,
                        fontSize: 10,
                      ),
                ),
              ],
            ),
          ),
          pw.Table.fromTextArray(
            context: context,
            data: linhas,
            border: pw.TableBorder(
              horizontalInside: pw.BorderSide(
                width: 1,
                color: PdfColor.fromHex('#747474'),
              ),
            ),
            columnWidths: const {
              0: pw.FixedColumnWidth(3),
              1: pw.FixedColumnWidth(1.5),
              2: pw.FixedColumnWidth(2),
              3: pw.FixedColumnWidth(1.2),
              4: pw.FixedColumnWidth(4),
            },
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            '${atendimentosRenderizando.length} atendimento(s)',
            style: pw.Theme.of(context).defaultTextStyle.copyWith(
                  color: PdfColors.grey,
                  fontSize: 10,
                ),
          ),
        ],
        orientation: pw.PageOrientation.portrait,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          if (context.pageNumber == 1) {
            return pw.SizedBox();
          }
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(
                  width: 0.5,
                  color: PdfColors.grey,
                ),
              ),
            ),
            child: pw.Text(
              titulo,
              style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.grey),
            ),
          );
        },
        footer: (pw.Context context) {
          return pw.Container(
            margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            padding: const pw.EdgeInsets.only(top: 3.0 * PdfPageFormat.mm),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                top: pw.BorderSide(
                  width: 0.5,
                  color: PdfColors.grey,
                ),
              ),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Image(
                  pw.MemoryImage(logoLM),
                  width: 130,
                ),
                pw.Text(
                  'Página ${context.pageNumber} de ${context.pagesCount}',
                  style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.grey),
                ),
              ],
            ),
          );
        },
      ),
    );

    Directory tempDir = await getTemporaryDirectory();

    final file = File('${tempDir.path}/Relatorio de Atendimentos.pdf');
    await file.writeAsBytes(await pdf.save());

    XFile xFile = XFile(file.path);
    Share.shareXFiles([xFile]);
  }

  _filtros() {
    Navigator.pop(context);
    Size size = MediaQuery.of(context).size;

    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filtrar Atendimentos',
              style: TextStyle(
                color: Color(0xff1D1617),
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: size.height * 0.01),
                        child: const Text(
                          'Data Início:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Form(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: size.height * 0.01),
                          child: Container(
                            height: size.height * 0.06,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),
                            child: DateTimeFormField(
                              decoration: const InputDecoration(
                                errorStyle: TextStyle(height: 0),
                                hintStyle: TextStyle(color: Color(0xffADA4A5)),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(top: 17),
                                hintText: 'Data Início',
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Icon(
                                    Icons.date_range_outlined,
                                    color: Color(0xff7B6F72),
                                  ),
                                ),
                              ),
                              firstDate: filtroDataMinima,
                              initialValue: filtroDataInicio,
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                              initialDate: DateTime.now(),
                              autovalidateMode: AutovalidateMode.disabled,
                              dateFormat: dateTimeFormatter,
                              onDateSelected: (value) {
                                setState(() {
                                  filtroDataInicio = value;
                                });
                              },
                              validator: (valuename) {
                                if (valuename == null) {
                                  Util.buildSnackMessage(
                                    'Informe uma data início',
                                    context,
                                  );
                                  return '';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: size.height * 0.01),
                        child: const Text(
                          'Data Fim:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Form(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: size.height * 0.01),
                          child: Container(
                            height: size.height * 0.06,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),
                            child: DateTimeFormField(
                              decoration: const InputDecoration(
                                errorStyle: TextStyle(height: 0),
                                hintStyle: TextStyle(color: Color(0xffADA4A5)),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(top: 17),
                                hintText: 'Data Fim',
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Icon(
                                    Icons.date_range_outlined,
                                    color: Color(0xff7B6F72),
                                  ),
                                ),
                              ),
                              firstDate: filtroDataMinima,
                              initialValue: filtroDataFim,
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                              initialDate: DateTime.now(),
                              autovalidateMode: AutovalidateMode.disabled,
                              dateFormat: dateTimeFormatter,
                              onDateSelected: (value) {
                                setState(() {
                                  filtroDataFim = value;
                                });
                              },
                              validator: (valuename) {
                                if (valuename == null) {
                                  Util.buildSnackMessage(
                                    'Informe uma data fim',
                                    context,
                                  );
                                  return '';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: ButtonWidget(
                  text: 'Filtrar',
                  backColor: gradient,
                  textColor: const [
                    Colors.white,
                    Colors.white,
                  ],
                  onPressed: () async {
                    setState(() {
                      filtroAtivo = true;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
