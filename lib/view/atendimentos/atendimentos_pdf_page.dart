import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:lancamento_contatos/model/atendimento_model.dart';
import 'package:pdf/widgets.dart' as pw;

atendimentoPdf(
  DateTime dataInicio,
  DateTime dataFim,
  Box<Atendimento> atendimentosPeriodo,
) {
  double larguraCliente = 120;
  double larguraData = 110;
  double larguraAtendeu = 50;

  return pw.Container(
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Relatório de Atendimentos',
          style: pw.TextStyle(
            fontSize: 25,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.Text('Período: ${DateFormat('dd/MM/yyyy HH:mm').format(dataInicio)} à ${DateFormat('dd/MM/yyyy HH:mm').format(dataFim)}'),
        pw.Text('Emitido em ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}'),
        pw.SizedBox(height: 25),
        pw.Text('Total de Atendimentos: ${atendimentosPeriodo.length.toString()}'),
        pw.SizedBox(height: 10),
        pw.Container(
          child: pw.Row(
            children: [
              pw.Container(
                width: larguraCliente,
                child: pw.Text('Cliente'),
              ),
              pw.Container(
                width: larguraData,
                child: pw.Text('Data'),
              ),
              pw.Container(
                width: larguraAtendeu,
                child: pw.Text('Atendeu'),
              ),
              pw.Expanded(
                child: pw.Text('Descrição'),
              ),
            ],
          ),
        ),
        pw.Divider(),
        pw.ListView.builder(
          itemBuilder: (context, index) {
            Atendimento atendimento = atendimentosPeriodo.getAt(index)!;

            return pw.Container(
              child: pw.Row(
                children: [
                  pw.Container(
                    width: larguraCliente,
                    child: pw.Text(atendimento.cliente!.nome!),
                  ),
                  pw.Container(
                    width: larguraData,
                    child: pw.Text(DateFormat('dd/MM/yyyy HH:mm').format(atendimento.dataLancamento!)),
                  ),
                  pw.Container(
                    width: larguraAtendeu,
                    child: pw.Text(atendimento.atendeu! ? 'Sim' : 'Não'),
                  ),
                  pw.Expanded(
                    child: pw.Flexible(
                      child: pw.Text(atendimento.descricao ?? '', maxLines: 2),
                    ),
                  ),
                ],
              ),
            );
          },
          itemCount: atendimentosPeriodo.length,
        )
      ],
    ),
  );
}
