// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:hive/hive.dart';
import 'package:lancamento_contatos/globals.dart';
import 'package:lancamento_contatos/model/atendimento_model.dart';
import 'package:lancamento_contatos/model/cliente_model.dart';
import 'package:lancamento_contatos/model/item_menu_model.dart';
import 'package:lancamento_contatos/model/usuario_model.dart';
import 'package:lancamento_contatos/theme.dart';
import 'package:lancamento_contatos/view/widget/app_logo_widget.dart';
import 'package:lancamento_contatos/view/widget/card_widget.dart';

import '../util.dart';

late int quantClientes;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ItemMenu> itensMenu = [
    ItemMenu(
      icon: Icons.calendar_month_outlined,
      nome: 'Agendamentos',
      onClickRoute: '/agendamentos',
    ),
    ItemMenu(
      icon: Icons.phone_outlined,
      nome: 'Atendimentos',
      onClickRoute: '/atendimentos',
    ),
    ItemMenu(
      icon: Icons.person_outline_rounded,
      nome: 'Clientes',
      badge: 80,
      onClickRoute: '/clientes',
    ),
  ];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      drawer: drawer(),
      body: Center(
        child: Container(
          height: size.height,
          width: size.width,
          decoration: const BoxDecoration(
            color: backgroundColor,
          ),
          child: Stack(
            children: [
              Center(
                child: Opacity(
                  opacity: .5,
                  child: Image.asset(
                    'assets/img/logomarca.png',
                    width: MediaQuery.of(context).size.width / 1.7,
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: defaultPagePadding,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Bem-vindo(a)',
                                    style: TextStyle(
                                      color: const Color(0xff1D1617),
                                      fontSize: size.height * 0.02,
                                    ),
                                  ),
                                  Text(
                                    usuarioLogado.nome!,
                                    style: TextStyle(
                                      color: const Color(0xff1D1617),
                                      fontSize: size.height * 0.025,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () => _scaffoldKey.currentState!.openDrawer(),
                                child: CircleAvatar(
                                  child: Text(usuarioLogado.nome![0].toUpperCase()),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        FutureBuilder(
                          future: _getDados(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, i) {
                                  return CardWidget(
                                    icon: itensMenu[i].icon!,
                                    title: Text(itensMenu[i].nome!),
                                    badge: (itensMenu[i].nome! == 'Clientes') ? quantClientes : itensMenu[i].badge,
                                    onPressed: () => Navigator.pushNamed(
                                      context,
                                      itensMenu[i].onClickRoute!,
                                    ).then((value) {
                                      setState(() {});
                                    }),
                                  );
                                },
                                itemCount: itensMenu.length,
                              );
                            } else {
                              return const Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                        SizedBox(height: size.height * 0.02),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Drawer drawer() {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: const DrawerHeader(
                    decoration: BoxDecoration(color: Colors.white),
                    child: AppLogoWidget(),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.cleaning_services_outlined),
                  iconColor: Theme.of(context).colorScheme.secondary,
                  title: const Text('Limpar Dados'),
                  onTap: () => _limparDados(),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Image.asset(
                'assets/img/logomarca-lmsoftwares.png',
                width: 200,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future _getDados() async {
    quantClientes = 0;

    // Conta quantos clientes já estão cadastrados
    Box box = Hive.box<Cliente>('clientes');
    quantClientes = box.length;
  }

  _limparDados() async {
    await FlutterPlatformAlert.playAlertSound();

    AlertButton clickedButton = await FlutterPlatformAlert.showAlert(
      windowTitle: 'Confirmação',
      text: 'Deseja realmente deletar todos os dados do app? Esta operação não é reversível.',
      alertStyle: AlertButtonStyle.yesNo,
      iconStyle: IconStyle.information,
    );

    if (clickedButton == AlertButton.yesButton) {
      Hive.box<Usuario>('usuarios').clear();
      Hive.box<Cliente>('clientes').clear();
      Hive.box<Atendimento>('atendimentos').clear();

      Util.buildSnackMessage(
        'Dados removidos com sucesso',
        context,
      );

      Navigator.pushReplacementNamed(
        context,
        '/login',
      );
    }
  }
}
