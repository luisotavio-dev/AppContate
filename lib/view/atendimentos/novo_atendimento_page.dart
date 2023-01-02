import 'package:date_field/date_field.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:lancamento_contatos/colors.dart';
import 'package:lancamento_contatos/globals.dart';
import 'package:lancamento_contatos/model/atendimento_model.dart';
import 'package:lancamento_contatos/model/cliente_model.dart';
import 'package:lancamento_contatos/view/widget/button_widget.dart';
import 'package:lancamento_contatos/view/widget/text_field_widget.dart';

import '../../util.dart';

class NovoAtendimentoPage extends StatefulWidget {
  const NovoAtendimentoPage({super.key});

  @override
  State<NovoAtendimentoPage> createState() => _NovoAtendimentoPageState();
}

class _NovoAtendimentoPageState extends State<NovoAtendimentoPage> {
  final _clienteController = TextEditingController();
  final _clienteKey = GlobalKey<FormState>();
  final _descricaoKey = GlobalKey<FormState>();
  bool atendeu = false;

  List textfieldsStrings = [
    null, //dataLancamento
    "", //cliente
    "", //descricao
    false, //atendeu
    // "", //confirmPassword
  ];

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
          'Novo Atendimento',
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
        decoration: const BoxDecoration(
          color: Color(0xFFfafafa),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 25.0, top: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                          firstDate: DateTime.now(),
                          initialValue: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                          initialDate: DateTime.now(),
                          autovalidateMode: AutovalidateMode.disabled,
                          dateFormat: DateFormat('dd/MM/yyyy HH:mm'),
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
                          onDateSelected: (DateTime value) {
                            setState(() {
                              textfieldsStrings[0] = value;
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
                      stringToEdit: 1,
                      readOnly: true,
                      onTap: () => _abrirPesquisaClientes(),
                      controller: _clienteController,
                      onChanged: ((value) {
                        setState(() {
                          textfieldsStrings[1] = value;
                        });
                      }),
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
                      stringToEdit: 2,
                      onChanged: ((value) {
                        setState(() {
                          textfieldsStrings[2] = value;
                        });
                      }),
                      multilines: true,
                      size: size,
                      icon: Icons.description,
                      password: false,
                      formKey: _descricaoKey,
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
                        value: textfieldsStrings[3] as bool,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Atendeu'),
                        onChanged: (bool? value) {
                          setState(() {
                            textfieldsStrings[3] = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
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
          name: box.getAt(i)!.nome!,
          value: box.getAt(i)!.idCliente!,
        );
        clientes.add(item);
      }

      DropDownState(
        DropDown(
          dropDownBackgroundColor: const Color(0xFFfafafa),
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
              textfieldsStrings[1] = value[0].value;
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

    Cliente cliente = Cliente()
      ..nome = _clienteController.text
      ..idCliente = textfieldsStrings[1];

    Atendimento atendimento = Atendimento()
      ..dataLancamento = textfieldsStrings[0] ?? DateTime.now()
      ..cliente = cliente
      ..idUsuario = usuarioLogado.idUsuario!
      ..descricao = textfieldsStrings[2]
      ..atendeu = textfieldsStrings[3] as bool;

    await box.add(atendimento);
    await atendimento.save();
  }
}
