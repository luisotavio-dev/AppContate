import 'package:date_field/date_field.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lancamento_contatos/theme.dart';
import 'package:lancamento_contatos/globals.dart';
import 'package:lancamento_contatos/model/atendimento_model.dart';
import 'package:lancamento_contatos/model/cliente_model.dart';
import 'package:lancamento_contatos/view/widget/button_widget.dart';
import 'package:lancamento_contatos/view/widget/text_field_widget.dart';

import '../../util.dart';

class NovoAtendimentoPage extends StatefulWidget {
  final Cliente? clienteSugerido;
  const NovoAtendimentoPage(this.clienteSugerido, {super.key});

  @override
  State<NovoAtendimentoPage> createState() => _NovoAtendimentoPageState();
}

class _NovoAtendimentoPageState extends State<NovoAtendimentoPage> {
  Cliente? get clienteSugerido => widget.clienteSugerido;

  String? idClienteSelecionado;
  final _clienteController = TextEditingController();
  DateTime? dataLancamento = DateTime.now();
  final _descricaoController = TextEditingController();
  bool atendeu = false;

  final _clienteKey = GlobalKey<FormState>();
  final _descricaoKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (clienteSugerido != null) {
        setState(() {
          idClienteSelecionado = clienteSugerido!.idCliente;
          _clienteController.text = clienteSugerido!.nome ?? '';
        });
      }
    });

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
          'Novo Atendimento',
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
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.only(bottom: size.height * 0.01),
                  child: const Text(
                    'Data de Lançamento:',
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
                          hintText: 'Data de Lançamento',
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Icon(
                              Icons.date_range_outlined,
                              color: Color(0xff7B6F72),
                            ),
                          ),
                        ),
                        firstDate: DateTime.now().add(const Duration(days: -7)),
                        initialValue: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        initialDate: DateTime.now(),
                        autovalidateMode: AutovalidateMode.disabled,
                        dateFormat: dateTimeFormatter,
                        validator: (valuename) {
                          if (valuename == null) {
                            Util.buildSnackMessage(
                              'Informe uma data de lançamento',
                              context,
                            );
                            return '';
                          }
                          return null;
                        },
                        onDateSelected: (value) {
                          setState(() {
                            dataLancamento = value;
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
                Padding(
                  padding: EdgeInsets.only(bottom: size.height * 0.02),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: CheckboxListTile(
                      value: atendeu,
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Atendeu'),
                      onChanged: (bool? value) {
                        setState(() {
                          atendeu = value!;
                        });
                      },
                    ),
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
                        _salvar().then((_) {
                          Util.buildSnackMessage(
                            'Atendimento inserido!',
                            context,
                          );
                          Navigator.pop(context, true);
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
        ),
      ),
    );
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

  Future _salvar() async {
    var box = Hive.box<Atendimento>('atendimentos');

    var dadosCliente = Hive.box<Cliente>('clientes').values.where((element) => element.idCliente == idClienteSelecionado).toList();
    Cliente cliente = dadosCliente[0];

    Atendimento atendimento = Atendimento()
      ..dataLancamento = dataLancamento
      ..cliente = cliente
      ..idUsuario = usuarioLogado.idUsuario!
      ..descricao = _descricaoController.text.trim()
      ..atendeu = atendeu;

    await box.add(atendimento);
    await atendimento.save();
  }
}
