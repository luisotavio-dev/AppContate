import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lancamento_contatos/theme.dart';
import 'package:lancamento_contatos/model/agendamento_model.dart';
import 'package:lancamento_contatos/view/agendamentos/agendamentos_page.dart';
import 'package:lancamento_contatos/view/agendamentos/detalhes_agendamento_page.dart';
import 'package:lancamento_contatos/view/agendamentos/persistir_agendamento_page.dart';
import 'package:lancamento_contatos/view/atendimentos/atendimentos_page.dart';
import 'package:lancamento_contatos/view/atendimentos/detalhes_atendimento_page.dart';
import 'package:lancamento_contatos/view/atendimentos/persistir_atendimento_page.dart';

import 'package:lancamento_contatos/view/clientes/clientes_page.dart';
import 'package:lancamento_contatos/view/clientes/detalhes_cliente_page.dart';
import 'package:lancamento_contatos/view/clientes/persistir_cliente_page.dart';
import 'package:lancamento_contatos/view/home_page.dart';
import 'package:lancamento_contatos/view/initial_page.dart';
import 'package:lancamento_contatos/view/login_page.dart';

import 'package:lancamento_contatos/model/usuario_model.dart';
import 'package:lancamento_contatos/model/cliente_model.dart';
import 'package:lancamento_contatos/model/atendimento_model.dart';

// ignore: prefer_typing_uninitialized_variables
String? paginaInicial;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Adicionar também no método de Limpar Dados
  Hive.registerAdapter<Usuario>(UsuarioAdapter());
  Hive.registerAdapter<Cliente>(ClienteAdapter());
  Hive.registerAdapter<Atendimento>(AtendimentoAdapter());
  Hive.registerAdapter<Agendamento>(AgendamentoAdapter());
  await Hive.initFlutter();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contate',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0),
          ),
          child: child!,
        );
      },
      supportedLocales: const [Locale('pt', 'BR')],
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: primaryColor,
        textTheme: GoogleFonts.interTextTheme(),
      ),
      initialRoute: paginaInicial,
      onGenerateRoute: (RouteSettings settings) {
        var routes = <String, WidgetBuilder>{
          '/': (context) => const InitialPage(),
          '/login': (context) => const LoginPage(),
          '/home': (context) => const HomePage(),
          '/clientes': (context) => const ClientesPage(),
          "/detalhes_cliente": (context) => DetalhesClientePage(settings.arguments as Cliente),
          "/persistir_cliente": (context) => PersistirClientePage(settings.arguments as Cliente?),
          '/atendimentos': (context) => AtendimentosPage(settings.arguments as Cliente?),
          '/detalhes_atendimento': (context) => DetalhesAtendimentoPage(settings.arguments as Atendimento),
          '/persistir_atendimento': (context) =>
              NovoAtendimentoPage(settings.arguments as ParametrosPersistirAtendimento),
          '/agendamentos': (context) => const AgendamentosPage(),
          '/detalhes_agendamento': (context) => DetalhesAgendamentoPage(settings.arguments as Agendamento),
          '/persistir_agendamento': (context) =>
              PersistirAgendamentoPage(settings.arguments as ParametrosPersistirAgendamento),
        };
        WidgetBuilder builder = routes[settings.name]!;
        return MaterialPageRoute(
          builder: (context) => builder(context),
          settings: settings,
        );
      },
    );
  }
}
