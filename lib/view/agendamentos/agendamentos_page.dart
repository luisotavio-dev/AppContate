import 'package:flutter/material.dart';
import 'package:lancamento_contatos/theme.dart';
import 'package:lancamento_contatos/view/widget/gradient_floating_action_button_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class AgendamentosPage extends StatefulWidget {
  const AgendamentosPage({super.key});

  @override
  State<AgendamentosPage> createState() => _AgendamentosPageState();
}

class _AgendamentosPageState extends State<AgendamentosPage> {
  DateTime hoje = DateTime.now();
  DateTime? diaSelecionado;
  DateTime diaInicial = DateTime.now().add(const Duration(days: -90));
  DateTime diaFinal = DateTime.now().add(const Duration(days: 365));

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
          'Agendamentos',
          style: TextStyle(
            color: const Color(0xff1D1617),
            fontSize: size.height * 0.025,
            fontWeight: FontWeight.bold,
          ),
        ),
        leadingWidth: defaultLeadingPadding,
      ),
      floatingActionButton: GradientFloatingActionButtonWidget(
        icon: Icons.add,
        text: 'Novo Agendamento',
        onTap: () => Navigator.pushNamed(context, '/persistir_agendamento').then(
          (value) {
            if (value == true) {
              setState(() {});
            }
          },
        ),
      ),
      body: Center(
        child: Container(
          height: size.height,
          width: size.width,
          color: backgroundColor,
          padding: defaultPagePadding,
          child: TableCalendar(
            firstDay: diaInicial,
            lastDay: diaFinal,
            focusedDay: hoje,
            locale: 'pt_BR',
            calendarFormat: CalendarFormat.month,
            availableCalendarFormats: const {CalendarFormat.month: 'Month'},
            selectedDayPredicate: (day) {
              return isSameDay(diaSelecionado, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(diaSelecionado, selectedDay)) {
                setState(() {
                  diaSelecionado = selectedDay;
                });
              }
            },
          ),
        ),
      ),
    );
  }
}
