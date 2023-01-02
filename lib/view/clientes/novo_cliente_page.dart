import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:lancamento_contatos/colors.dart';
import 'package:lancamento_contatos/globals.dart';
import 'package:lancamento_contatos/model/cliente_model.dart';
import 'package:lancamento_contatos/view/widget/button_widget.dart';
import 'package:lancamento_contatos/view/widget/text_field_widget.dart';
import 'package:uuid/uuid.dart';

import '../../util.dart';

class NovoClientePage extends StatefulWidget {
  const NovoClientePage({super.key});

  @override
  State<NovoClientePage> createState() => _NovoClientePageState();
}

class _NovoClientePageState extends State<NovoClientePage> {
  final _nomeKey = GlobalKey<FormState>();
  final _contaKey = GlobalKey<FormState>();
  final _telefonePrincipalKey = GlobalKey<FormState>();
  final _telefoneAlternativoKey = GlobalKey<FormState>();

  List textfieldsStrings = [
    "", //nome
    "", //conta
    "", //telefone1
    "", //telefone2
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
          'Novo Cliente',
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
                      'Nome:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Form(
                    child: TextFieldWidget(
                      hintText: 'Nome do cliente',
                      defaultFocus: true,
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
                      stringToEdit: 0,
                      onChanged: ((value) {
                        setState(() {
                          textfieldsStrings[0] = value;
                        });
                      }),
                      size: size,
                      icon: Icons.person_outlined,
                      keyboardType: TextInputType.name,
                      password: false,
                      formKey: _nomeKey,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: size.height * 0.01),
                    child: const Text(
                      'Dados da conta:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Form(
                    child: TextFieldWidget(
                      hintText: 'Conta',
                      validator: (valuename) {
                        if (valuename.length <= 0) {
                          Util.buildSnackMessage(
                            'Informe a conta',
                            context,
                          );
                          return '';
                        }
                        return null;
                      },
                      stringToEdit: 1,
                      onChanged: ((value) {
                        setState(() {
                          textfieldsStrings[1] = value;
                        });
                      }),
                      size: size,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      icon: Icons.account_balance_wallet_outlined,
                      password: false,
                      formKey: _contaKey,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: size.height * 0.01),
                    child: const Text(
                      'Telefone Principal:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Form(
                    child: TextFieldWidget(
                      hintText: 'Telefone',
                      validator: (valuename) {
                        if (valuename.length <= 0) {
                          Util.buildSnackMessage(
                            'Informe o telefone principal',
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
                      size: size,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        TelefoneInputFormatter(),
                      ],
                      icon: Icons.phone_outlined,
                      password: false,
                      formKey: _telefonePrincipalKey,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: size.height * 0.01),
                    child: const Text(
                      'Telefone Alternativo:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Form(
                    child: TextFieldWidget(
                      hintText: 'Telefone 2',
                      validator: (valuename) {
                        return null;
                      },
                      stringToEdit: 3,
                      onChanged: ((value) {
                        setState(() {
                          textfieldsStrings[3] = value;
                        });
                      }),
                      size: size,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        TelefoneInputFormatter(),
                      ],
                      icon: Icons.phone_outlined,
                      password: false,
                      formKey: _telefoneAlternativoKey,
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
                    if (_nomeKey.currentState!.validate()) {
                      if (_contaKey.currentState!.validate()) {
                        if (_telefonePrincipalKey.currentState!.validate()) {
                          _salvar().then((_) {
                            Util.buildSnackMessage(
                              'Cliente inserido!',
                              context,
                            );
                            Navigator.pop(context, true);
                          }).onError((error, stackTrace) {
                            Util.buildSnackMessage(
                              error.toString(),
                              context,
                              maxHeight: 35,
                            );
                          });
                        }
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

  Future _salvar() async {
    Box<Cliente> box = Hive.box<Cliente>('clientes');

    // Valida se não há nenhum cliente já cadastrado com essa conta
    int contaInformada = int.parse(textfieldsStrings[1]);

    bool contaJaCadastrada = false;
    String nomeUsuarioRepetido = '';
    for (var i = 0; i < box.length; i++) {
      if (box.getAt(i)!.conta == contaInformada) {
        contaJaCadastrada = true;
        nomeUsuarioRepetido = box.getAt(i)!.nome!;
        i = box.length;
      }
    }

    if (contaJaCadastrada) {
      throw 'O usuário "$nomeUsuarioRepetido" já está cadastrado com esse número de conta.';
    } else {
      var uuid = const Uuid();
      Cliente cliente = Cliente()
        ..idCliente = uuid.v1()
        ..idUsuario = usuarioLogado.key
        ..nome = textfieldsStrings[0]
        ..agencia = 1864
        ..conta = contaInformada
        ..telefone1 = UtilBrasilFields.obterTelefone(textfieldsStrings[2], mascara: false)
        ..telefone2 = textfieldsStrings[3] != null && textfieldsStrings[3] != '' ? UtilBrasilFields.obterTelefone(textfieldsStrings[3], mascara: false) : ''
        ..dataLancamento = DateTime.now();

      await box.add(cliente);
      await cliente.save();
    }
  }
}
