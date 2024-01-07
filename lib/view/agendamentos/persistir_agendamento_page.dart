import 'package:date_field/date_field.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lancamento_contatos/model/agendamento_model.dart';
import 'package:lancamento_contatos/theme.dart';
import 'package:lancamento_contatos/globals.dart';
import 'package:lancamento_contatos/model/cliente_model.dart';
import 'package:lancamento_contatos/view/widget/button_widget.dart';
import 'package:lancamento_contatos/view/widget/text_field_widget.dart';

import '../../util.dart';

class ParametrosPersistirAgendamento {
  Agendamento? agendamentoEdicao;
  Cliente? clienteSugerido;
  DateTime? dataSugerida;
}

class PersistirAgendamentoPage extends StatefulWidget {
  final ParametrosPersistirAgendamento parametros;
  const PersistirAgendamentoPage(this.parametros, {super.key});

  @override
  State<PersistirAgendamentoPage> createState() =>
      _PersistirAgendamentoPageState();
}

class _PersistirAgendamentoPageState extends State<PersistirAgendamentoPage> {
  Agendamento? get agendamentoEdicao => widget.parametros.agendamentoEdicao;
  Cliente? get clienteSugerido => widget.parametros.clienteSugerido;
  DateTime? get dataSugerida => widget.parametros.dataSugerida;

  String? idClienteSelecionado;
  final _clienteController = TextEditingController();
  DateTime? dataAgendamento = DateTime.now();
  final _descricaoController = TextEditingController();

  final _clienteKey = GlobalKey<FormState>();
  final _descricaoKey = GlobalKey<FormState>();

  late Future carregarDados;

  @override
  void initState() {
    carregarDados = _carregarDados();
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
          agendamentoEdicao != null ? 'Editar Agendamento' : 'Novo Agendamento',
          style: TextStyle(
            color: const Color(0xff1D1617),
            fontSize: size.height * 0.025,
            fontWeight: FontWeight.bold,
          ),
        ),
        leadingWidth: defaultLeadingPadding,
      ),
      body: Container(
        height: size.height,
        width: size.width,
        padding: defaultPagePadding,
        decoration: const BoxDecoration(
          color: backgroundColor,
        ),
        child: FutureBuilder(
          future: carregarDados,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      Padding(
                        padding: EdgeInsets.only(bottom: size.height * 0.01),
                        child: const Text(
                          'Data do Agendamento:',
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            child: DateTimeFormField(
                              decoration: const InputDecoration(
                                errorStyle: TextStyle(height: 0),
                                hintStyle: TextStyle(color: Color(0xffADA4A5)),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(top: 17),
                                hintText: 'Data do Agendamento',
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Icon(
                                    Icons.date_range_outlined,
                                    color: Color(0xff7B6F72),
                                  ),
                                ),
                              ),
                              firstDate:
                                  DateTime.now().add(const Duration(days: -7)),
                              initialValue: dataAgendamento,
                              lastDate:
                                  DateTime.now().add(const Duration(days: 365)),
                              initialPickerDateTime: dataAgendamento,
                              autovalidateMode: AutovalidateMode.disabled,
                              dateFormat: dateTimeFormatter,
                              validator: (valuename) {
                                if (valuename == null) {
                                  Util.buildSnackMessage(
                                    'Informe uma data para o agendamento',
                                    context,
                                  );
                                  return '';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  dataAgendamento = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: size.height * 0.01),
                        child: const Text(
                          'Cliente:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Form(
                        child: TextFieldWidget(
                          hintText: 'Cliente',
                          validator: (valuename) {
                            if (valuename.length <= 0) {
                              Util.buildSnackMessage(
                                'Informe o cliente',
                                context,
                              );
                              return '';
                            }
                            return null;
                          },
                          readOnly: true,
                          onTap: () => _abrirPesquisaClientes(),
                          controller: _clienteController,
                          size: size,
                          icon: Icons.person_outlined,
                          password: false,
                          formKey: _clienteKey,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: size.height * 0.01),
                        child: const Text(
                          'Descrição:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Form(
                        child: TextFieldWidget(
                          hintText: 'Descrição',
                          controller: _descricaoController,
                          validator: (valuename) {
                            if (valuename.length <= 0) {
                              Util.buildSnackMessage(
                                'Informe uma descrição',
                                context,
                              );
                              return '';
                            }
                            return null;
                          },
                          multilines: true,
                          size: size,
                          icon: Icons.description,
                          password: false,
                          formKey: _descricaoKey,
                          textInputAction: TextInputAction.newline,
                          keyboardType: TextInputType.multiline,
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
                        text: 'Salvar',
                        backColor: gradient,
                        textColor: const [
                          Colors.white,
                          Colors.white,
                        ],
                        onPressed: () async {
                          if (_clienteKey.currentState!.validate()) {
                            if (_descricaoKey.currentState!.validate()) {
                              _salvar(agendamentoEdicao: agendamentoEdicao)
                                  .then((agendamentoSalvo) {
                                Util.buildSnackMessage(
                                  'Agendamento ${agendamentoEdicao != null ? 'Editado' : 'Inserido'}',
                                  context,
                                  maxHeight: 40,
                                );
                                Navigator.pop(context, agendamentoSalvo);
                              }).onError((error, stackTrace) {
                                Util.buildSnackMessage(
                                  error.toString(),
                                  context,
                                );
                              });
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Future _carregarDados() async {
    if (clienteSugerido != null) {
      idClienteSelecionado = clienteSugerido!.idCliente;
      _clienteController.text = clienteSugerido!.nome ?? '';
    }

    if (dataSugerida != null) {
      final now = DateTime.now();
      dataAgendamento = Util.setHourToDateTime(
          dataSugerida!, now.hour, now.minute, now.second);
    }

    if (agendamentoEdicao != null) {
      _descricaoController.text = agendamentoEdicao!.descricao!;
      idClienteSelecionado = agendamentoEdicao!.cliente!.idCliente;
      _clienteController.text = agendamentoEdicao!.cliente!.nome ?? '';
      dataAgendamento = agendamentoEdicao!.dataAgendamento;
    }
  }

  _abrirPesquisaClientes() {
    try {
      // Pesquisa os clientes cadastrados
      List<SelectedListItem> clientes = [];
      Box<Cliente> box = Hive.box<Cliente>('clientes');

      // Constrói os itens do combobox
      for (var i = 0; i < box.length; i++) {
        SelectedListItem item = SelectedListItem(
          name: '${box.getAt(i)!.nome!} - Conta ${box.getAt(i)!.conta!}',
          value: box.getAt(i)!.idCliente!,
        );
        clientes.add(item);
      }

      clientes.sort((a, b) => a.name.compareTo(b.name));

      DropDownState(
        DropDown(
          dropDownBackgroundColor: backgroundColor,
          bottomSheetTitle: const Text(
            'Pesquisar Cliente',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          data: clientes,
          selectedItems: (value) {
            setState(() {
              _clienteController.text = value[0].name;
              idClienteSelecionado = value[0].value.toString();
            });
          },
          enableMultipleSelection: false,
        ),
      ).showModal(context);
    } catch (e) {
      Util.buildSnackMessage(
        e.toString(),
        context,
      );
    }
  }

  Future<Agendamento> _salvar({Agendamento? agendamentoEdicao}) async {
    var box = Hive.box<Agendamento>('agendamentos');

    var dadosCliente = Hive.box<Cliente>('clientes')
        .values
        .where((element) => element.idCliente == idClienteSelecionado)
        .toList();
    Cliente cliente = dadosCliente[0];

    Agendamento agendamento = Agendamento();

    // Necessário para buscar o ID já salvo
    if (agendamentoEdicao != null) {
      agendamento = agendamentoEdicao;
    }

    agendamento
      ..dataLancamento = DateTime.now()
      ..dataAgendamento = dataAgendamento
      ..cliente = cliente
      ..descricao = _descricaoController.text.trim();

    if (agendamentoEdicao == null) {
      await box.add(agendamento);
    }
    await agendamento.save();

    return agendamento;
  }
}
