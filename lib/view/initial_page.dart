import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lancamento_contatos/globals.dart';
import 'package:lancamento_contatos/model/atendimento_model.dart';
import 'package:lancamento_contatos/model/cliente_model.dart';
import 'package:lancamento_contatos/model/usuario_model.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ignore: avoid_unnecessary_containers
      body: Container(
        // ignore: unnecessary_const
        child: const Center(child: const CircularProgressIndicator()),
      ),
    );
  }

  _carregarDados() async {
    // Verifica se o usuário já foi configurado
    await Hive.openBox<Usuario>('usuarios').then((box) async {
      String paginaInicial;

      if (box.isEmpty) {
        paginaInicial = '/login';
      } else {
        usuarioLogado = box.getAt(0)!;
        paginaInicial = '/home';
      }

      await Hive.openBox<Cliente>('clientes').then((value) async {
        await Hive.openBox<Atendimento>('atendimentos').then((value) {
          Navigator.pushReplacementNamed(context, paginaInicial);
        });
      });
    });
  }
}
