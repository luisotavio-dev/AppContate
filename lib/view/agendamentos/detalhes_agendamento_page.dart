import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lancamento_contatos/globals.dart';
import 'package:lancamento_contatos/model/agendamento_model.dart';
import 'package:lancamento_contatos/theme.dart';
import 'package:lancamento_contatos/util.dart';
import 'package:lancamento_contatos/view/agendamentos/persistir_agendamento_page.dart';
import 'package:lancamento_contatos/view/widget/alert_dialog_widget.dart';

class DetalhesAgendamentoPage extends StatefulWidget {
  final Agendamento agendamento;
  const DetalhesAgendamentoPage(this.agendamento, {super.key});

  @override
  State<DetalhesAgendamentoPage> createState() =>
      _DetalhesAgendamentoPageState();
}

class _DetalhesAgendamentoPageState extends State<DetalhesAgendamentoPage> {
  late Agendamento agendamento = Agendamento();

  @override
  void initState() {
    agendamento = widget.agendamento;
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
          'Detalhes do Agend.',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: const Color(0xff1D1617),
            fontSize: size.height * 0.025,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          SizedBox(
            width: defaultLeadingPadding,
            child: IconButton(
              onPressed: () => _menu(),
              icon: const Icon(Icons.more_vert),
            ),
          ),
        ],
        leadingWidth: defaultLeadingPadding,
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
                        'Lançado em: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(dateTimeFormatter
                          .format(agendamento.dataLancamento!)),
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
                        'Agendado para: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(dateTimeFormatter
                          .format(agendamento.dataAgendamento!)),
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
                      Flexible(
                        child: Text(
                          '${agendamento.cliente!.nome!} - Conta ${agendamento.cliente!.conta!}',
                        ),
                      ),
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
                      Text(agendamento.descricao ?? ''),
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

  _menu() {
    showModalBottomSheet(
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
              title: const Text('Editar Agendamento'),
              onTap: () {
                ParametrosPersistirAgendamento parametros =
                    ParametrosPersistirAgendamento();
                parametros.agendamentoEdicao = agendamento;

                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  '/persistir_agendamento',
                  arguments: parametros,
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      agendamento = value as Agendamento;
                    });
                  }
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.close),
              iconColor: Theme.of(context).colorScheme.secondary,
              title: const Text('Exluir Agendamento'),
              onTap: () {
                AlertDialogWidget.alertYesNo(
                  context: context,
                  title: 'Confirmação',
                  message: 'Deseja realmente excluir o agendamento?',
                  onNo: () => Navigator.pop(context),
                  onYes: () async {
                    await Hive.box<Agendamento>('agendamentos')
                        .delete(agendamento.key)
                        .then((value) {
                      Util.buildSnackMessage(
                        'Agendamento Excluído',
                        context,
                        maxHeight: 40,
                      );
                      Navigator.pop(context); // fecha o alert
                      Navigator.pop(context); // fecha a bottom bar
                      Navigator.pop(context); // volta a pagina
                    }).onError((error, stackTrace) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Util.buildSnackMessage(
                        error.toString(),
                        context,
                      );
                    });
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
