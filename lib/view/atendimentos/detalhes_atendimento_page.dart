import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lancamento_contatos/globals.dart';
import 'package:lancamento_contatos/model/atendimento_model.dart';
import 'package:lancamento_contatos/theme.dart';
import 'package:lancamento_contatos/util.dart';
import 'package:lancamento_contatos/view/atendimentos/persistir_atendimento_page.dart';
import 'package:lancamento_contatos/view/widget/alert_dialog_widget.dart';

class DetalhesAtendimentoPage extends StatefulWidget {
  final Atendimento atendimento;
  const DetalhesAtendimentoPage(this.atendimento, {super.key});

  @override
  State<DetalhesAtendimentoPage> createState() =>
      _DetalhesAtendimentoPageState();
}

class _DetalhesAtendimentoPageState extends State<DetalhesAtendimentoPage> {
  late Atendimento atendimento = Atendimento();

  @override
  void initState() {
    atendimento = widget.atendimento;
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
          'Detalhes do Atend.',
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
                          .format(atendimento.dataLancamento!)),
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
                          '${atendimento.cliente!.nome!} - Conta ${atendimento.cliente!.conta!}',
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
              title: const Text('Editar Atendimento'),
              onTap: () {
                ParametrosPersistirAtendimento parametros =
                    ParametrosPersistirAtendimento();
                parametros.atendimentoEdicao = atendimento;

                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  '/persistir_atendimento',
                  arguments: parametros,
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      atendimento = value as Atendimento;
                    });
                  }
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.close),
              iconColor: Theme.of(context).colorScheme.secondary,
              title: const Text('Exluir Atendimento'),
              onTap: () {
                AlertDialogWidget.alertYesNo(
                  context: context,
                  title: 'Confirmação',
                  message: 'Deseja realmente excluir o atendimento?',
                  onNo: () => Navigator.pop(context),
                  onYes: () async {
                    await Hive.box<Atendimento>('atendimentos')
                        .delete(atendimento.key)
                        .then((value) {
                      Util.buildSnackMessage(
                        'Atendimento Excluído',
                        context,
                        maxHeight: 40,
                      );
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
