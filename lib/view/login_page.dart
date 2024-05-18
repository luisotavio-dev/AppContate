import 'package:hive/hive.dart';
import 'package:lancamento_contatos/theme.dart';
import 'package:lancamento_contatos/globals.dart';
import 'package:lancamento_contatos/model/usuario_model.dart';
import 'package:lancamento_contatos/view/widgets/app_logo_widget.dart';
import 'package:lancamento_contatos/view/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:lancamento_contatos/view/widgets/text_field_widget.dart';
import 'package:uuid/uuid.dart';

import '../util.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Container(
          height: size.height,
          width: size.width,
          decoration: const BoxDecoration(
            color: backgroundColor,
          ),
          child: SafeArea(
            child: Padding(
              padding: defaultPagePadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Align(
                        child: Text(
                          'Olá, por favor',
                          style: TextStyle(
                            color: const Color(0xff1D1617),
                            fontSize: size.height * 0.02,
                          ),
                        ),
                      ),
                      Align(
                        child: Text(
                          'Identifique-se',
                          style: TextStyle(
                            color: const Color(0xff1D1617),
                            fontSize: size.height * 0.025,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                      Form(
                        child: TextFieldWidget(
                          hintText: 'Seu nome',
                          defaultFocus: true,
                          controller: _nomeController,
                          validator: (valuename) {
                            if (valuename.length <= 0) {
                              Util.buildSnackMessage(
                                'Informe o seu nome',
                                context,
                              );
                              return '';
                            }
                            return null;
                          },
                          size: size,
                          icon: Icons.person_outlined,
                          password: false,
                          formKey: _formKey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ButtonWidget(
                        text: 'Confirmar',
                        backColor: gradient,
                        textColor: const [
                          Colors.white,
                          Colors.white,
                        ],
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _registrarUsuario().then((_) {
                              Navigator.pushReplacementNamed(
                                context,
                                '/home',
                              );
                            }).onError((error, stackTrace) {
                              Util.buildSnackMessage(
                                error.toString(),
                                context,
                              );
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const AppLogoWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future _registrarUsuario() async {
    try {
      var box = Hive.box<Usuario>('usuarios');

      const uuid = Uuid();

      var usuario = Usuario()
        ..nome = _nomeController.text
        ..idUsuario = uuid.v1();

      box.add(usuario);
      usuario.save();
      usuarioLogado = usuario;
    } catch (e) {
      rethrow;
    }
  }
}
