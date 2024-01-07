import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lancamento_contatos/util.dart';
import 'package:lancamento_contatos/globals.dart';
import 'package:lancamento_contatos/model/agendamento_model.dart';
import 'package:lancamento_contatos/theme.dart';
import 'package:lancamento_contatos/view/agendamentos/persistir_agendamento_page.dart';
import 'package:lancamento_contatos/view/widget/card_widget.dart';
import 'package:lancamento_contatos/view/widget/gradient_floating_action_button_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class AgendamentosPage extends StatefulWidget {
  const AgendamentosPage({super.key});

  @override
  State<AgendamentosPage> createState() => _AgendamentosPageState();
}

class _AgendamentosPageState extends State<AgendamentosPage> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final DateTime _today = DateTime.now();

  late final ValueNotifier<List<Agendamento>> _selectedEvents;
  List<Agendamento> _allEvents = <Agendamento>[];

  late Future<List<Agendamento>> _getEventsFuture;

  @override
  void initState() {
    super.initState();
    _getEventsFuture = getEvents();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  Future<List<Agendamento>> getEvents({bool apenasAtualizar = false}) async {
    List<Agendamento> events =
        Hive.box<Agendamento>('agendamentos').values.toList();
    setState(() {
      _allEvents = events;
      _selectedDay = _focusedDay;
      if (apenasAtualizar) {
        _selectedEvents.value = _getEventsForDay(_selectedDay!);
      } else {
        _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
      }
    });

    return events;
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
        onTap: () {
          ParametrosPersistirAgendamento parametros =
              ParametrosPersistirAgendamento()..dataSugerida = _selectedDay!;

          Navigator.pushNamed(
            context,
            '/persistir_agendamento',
            arguments: parametros,
          ).then((value) {
            if (value != null) {
              _getEventsFuture = getEvents(apenasAtualizar: true);
            }
          });
        },
      ),
      body: Container(
        color: backgroundColor,
        padding: defaultPagePadding,
        height: size.height,
        width: size.width,
        child: calendario(),
      ),
    );
  }

  Widget calendario() {
    return FutureBuilder<List<Agendamento>>(
      future: _getEventsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return Column(
              children: [
                TableCalendar(
                  currentDay: DateTime.now(),
                  locale: 'pt_BR',
                  calendarFormat: _calendarFormat,
                  eventLoader: _getEventsForDay,
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  firstDay:
                      DateTime(_today.year, _today.month - 12, _today.day),
                  lastDay: DateTime(_today.year, _today.month + 12, _today.day),
                  calendarStyle: CalendarStyle(
                    weekendTextStyle: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                    holidayTextStyle: const TextStyle(color: Colors.deepOrange),
                    canMarkersOverflow: false,
                    markerDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor,
                    ),
                    todayDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.deepOrange.withOpacity(.2),
                    ),
                    todayTextStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    selectedDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor.withOpacity(.2),
                    ),
                    selectedTextStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    leftChevronIcon: Icon(
                      Icons.arrow_back_ios,
                      size: 15,
                      color: primaryColor,
                    ),
                    rightChevronIcon: Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                      color: primaryColor,
                    ),
                    titleTextStyle: TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                    ),
                    formatButtonVisible: false,
                  ),
                  onDaySelected: _onDaySelected,
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: ValueListenableBuilder<List<Agendamento>>(
                    valueListenable: _selectedEvents,
                    builder: (context, eventos, _) {
                      if (eventos.isEmpty) {
                        return const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.event,
                              size: 40,
                              color: Colors.black87,
                            ),
                            SizedBox(height: 10),
                            Text('Nenhum agendamento encontrado.'),
                          ],
                        );
                      }

                      return ListView.builder(
                        itemCount: eventos.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          Agendamento agendamento = eventos[index];

                          return CardWidget(
                            title: Container(
                              margin: const EdgeInsets.only(right: 15),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            agendamento.cliente!.nome!,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Conta: ${agendamento.cliente!.conta!}',
                                            style: const TextStyle(
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        dateTimeFormatter.format(
                                            agendamento.dataAgendamento!),
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Text(agendamento.descricao!),
                                ],
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/detalhes_agendamento',
                                arguments: agendamento,
                              ).then((value) {
                                _getEventsFuture =
                                    getEvents(apenasAtualizar: true);
                              });
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text(snapshot.error.toString()));
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        // _rangeStart = null; // Important to clean those
        // _rangeEnd = null;
        // _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  List<Agendamento> _getEventsForDay(DateTime day) {
    List<Agendamento> todayEvents = <Agendamento>[];

    for (Agendamento event in _allEvents) {
      bool sameDate = DateOnlyCompare(event.dataAgendamento!).isSameDate(day);
      sameDate ? todayEvents.add(event) : null;
    }

    return todayEvents;
  }
}
