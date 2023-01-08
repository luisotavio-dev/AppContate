import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lancamento_contatos/globals.dart';
import 'package:lancamento_contatos/model/atendimento_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

atendimentoPdf(
  Uint8List logoApp,
  Uint8List logoLM,
  DateTime dataInicio,
  DateTime dataFim,
  List<Atendimento> atendimentosPeriodo,
) {
  double larguraCliente = 120;
  double larguraData = 110;
  double larguraAtendeu = 55;

  return pw.Container(
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text(
              'Relação de Atendimentos',
              style: pw.TextStyle(
                fontSize: 25,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Image(
              pw.MemoryImage(logoApp),
              height: 50,
            ),
          ],
        ),
        pw.Text(
          'Período: ${dateFormatter.format(dataInicio)} à ${dateFormatter.format(dataFim)}',
          style: pw.TextStyle(color: PdfColor.fromHex('#747474')),
        ),
        pw.Text(
          'Emitido em ${DateFormat('dd/MM/yy HH:mm').format(
            DateTime.now(),
          )}',
          style: pw.TextStyle(
            color: PdfColor.fromHex('#747474'),
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Container(
          child: pw.Row(
            children: [
              pw.Container(
                width: larguraCliente,
                child: pw.Text(
                  'Cliente',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Container(
                width: larguraData,
                child: pw.Text(
                  'Data',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Container(
                width: larguraAtendeu,
                child: pw.Text(
                  'Atendeu',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Expanded(
                child: pw.Text(
                  'Descrição',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        pw.Divider(height: 5),
        pw.ListView.builder(
          itemBuilder: (context, index) {
            Atendimento atendimento = atendimentosPeriodo[index];

            return pw.Container(
              child: pw.Column(
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Container(
                        width: larguraCliente,
                        child: pw.Text(atendimento.cliente!.nome!),
                      ),
                      pw.Container(
                        width: larguraData,
                        child: pw.Text(dateTimeFormatter.format(atendimento.dataLancamento!)),
                      ),
                      pw.Container(
                        width: larguraAtendeu,
                        child: pw.Text(
                          atendimento.atendeu! ? 'Sim' : 'Não',
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Flexible(
                          child: pw.Text(atendimento.descricao ?? '', maxLines: 2),
                        ),
                      ),
                    ],
                  ),
                  pw.Divider(height: 5),
                ],
              ),
            );
          },
          itemCount: atendimentosPeriodo.length,
        ),
        pw.Text('Total de Atendimentos: ${atendimentosPeriodo.length.toString()}'),
      ],
    ),
  );
}
