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

class PersistirClientePage extends StatefulWidget {
  final Cliente? clienteEdicao;
  const PersistirClientePage(this.clienteEdicao, {super.key});

  @override
  State<PersistirClientePage> createState() => _PersistirClientePageState();
}

class _PersistirClientePageState extends State<PersistirClientePage> {
  Cliente? get clienteEdicao => widget.clienteEdicao;

  final _nomeKey = GlobalKey<FormState>();
  final _contaKey = GlobalKey<FormState>();
  final _telefonePrincipalKey = GlobalKey<FormState>();
  final _telefoneAlternativoKey = GlobalKey<FormState>();
  final _observacoesKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _contaController = TextEditingController();
  final _telefonePrincipalController = TextEditingController();
  final _telefoneAlternativoController = TextEditingController();
  final _observacoesController = TextEditingController();

  @override
  void initState() {
    if (clienteEdicao != null) {
      _nomeController.text = clienteEdicao!.nome!;
      _contaController.text = clienteEdicao!.conta!.toString();
      _telefonePrincipalController.text = UtilBrasilFields.obterTelefone(clienteEdicao!.telefone1!);
      _telefoneAlternativoController.text = clienteEdicao!.telefone2 != null && clienteEdicao!.telefone2!.isNotEmpty ? UtilBrasilFields.obterTelefone(clienteEdicao!.telefone2!) : '';
      _observacoesController.text = clienteEdicao!.observacoes ?? '';
    }
    super.initState();
  }

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
          clienteEdicao != null ? 'Editar Cliente' : 'Novo Cliente',
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
                      controller: _nomeController,
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
                      controller: _contaController,
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
                      controller: _telefonePrincipalController,
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
                      controller: _telefoneAlternativoController,
                      validator: (valuename) {
                        return null;
                      },
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
                  Padding(
                    padding: EdgeInsets.only(bottom: size.height * 0.01),
                    child: const Text(
                      'Observações:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Form(
                    child: TextFieldWidget(
                      hintText: 'Observações do Cliente',
                      controller: _observacoesController,
                      validator: (valuename) {
                        return null;
                      },
                      multilines: true,
                      size: size,
                      icon: Icons.chat_outlined,
                      password: false,
                      formKey: _observacoesKey,
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
                          _salvar(clienteEdicao: clienteEdicao).then((clienteSalvo) {
                            Util.buildSnackMessage(
                              'Cliente ${clienteEdicao != null ? 'Editado' : 'Inserido'}',
                              context,
                            );
                            Navigator.pop(context, clienteSalvo);
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

  Future<Cliente> _salvar({Cliente? clienteEdicao}) async {
    Box<Cliente> box = Hive.box<Cliente>('clientes');
    int contaInformada = int.parse(_contaController.text);

    Cliente cliente = Cliente();

    // Caso esteja inserindo
    if (clienteEdicao == null) {
      // Valida se já existe algum cliente cadastrado com essa conta
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
      }

      var uuid = const Uuid();
      cliente
        ..idCliente = uuid.v1()
        ..idUsuario = usuarioLogado.key
        ..dataLancamento = DateTime.now();
    } else {
      cliente = clienteEdicao;
    }

    cliente
      ..nome = _nomeController.text
      ..agencia = 1864
      ..conta = contaInformada
      ..telefone1 = UtilBrasilFields.obterTelefone(
        _telefonePrincipalController.text,
        mascara: false,
      )
      ..telefone2 = _telefoneAlternativoController.text.isNotEmpty
          ? UtilBrasilFields.obterTelefone(
              _telefoneAlternativoController.text,
              mascara: false,
            )
          : ''
      ..observacoes = _observacoesController.text;

    if (clienteEdicao == null) {
      await box.add(cliente);
    }
    await cliente.save();
    return cliente;
  }
}
