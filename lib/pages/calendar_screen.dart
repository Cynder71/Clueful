import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/event.dart';
import 'package:flutter_app/pages/select_outfit_screen.dart';
import 'package:flutter_app/pages/view_date_outfit_details.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/Outfit.dart';


class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Set<DateTime> _outfitDates = {};
  Set<String> _outfitsIds = {};

  Map<DateTime, List<Event>> events = {};

  late final ValueNotifier<List<Event>> _selectedEvents;

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay){
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  void _selectOutfitForDate() {
    if (_selectedDay == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, selecione um dia no calendário primeiro.'))
      );
      return;
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SelectOutfitScreen(
                onSelect: (Outfit outfit) {
                  _createDateOutfit(_selectedDay!, outfit);
                }
            )
        )
    );
  }

  void _createDateOutfit(DateTime date, Outfit outfit) {
    FirebaseFirestore.instance.collection('dateOutfits').add({
      'date': date.toIso8601String(),
      'outfitId': outfit.id,
    }).then((docRef) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Outfit agendado para ${date.toIso8601String()}'))
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao agendar outfit: $error'))
      );
    });
  }

  void _loadOutfitDatesAndIds() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('dateOutfits').get();
      Set<DateTime> loadedDates = {};
      Set<String> loadedIds = {};
      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>?;
        if (data != null && data['date'] is String && data['outfitId'] is String) {
          DateTime date = DateTime.parse(data['date']);
          loadedDates.add(date);
          loadedIds.add(data['outfitId']);
        }
      }
      setState(() {
        _outfitDates = loadedDates;
        _outfitsIds = loadedIds;
      });
      print('Loaded outfit dates: $_outfitDates');
    } catch (error) {
      print('Error loading outfit dates: $error');
    }
  }

  void _viewOutfitForDate(DateTime date) {
    FirebaseFirestore.instance
        .collection('dateOutfits')
        .where('date', isEqualTo: date.toIso8601String())
        .limit(1)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        var doc = snapshot.docs.first;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewDateOutfitScreen(dateOutfitId: doc.id),
          ),
        );
      }
    });
  }


  @override
  void initState(){
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier([]);
    _loadOutfitDatesAndIds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 241, 221, 207),
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            'Calendário',
            style: GoogleFonts.cinzelDecorative(
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 241, 221, 207),
      floatingActionButton: FloatingActionButton(
        onPressed: _selectOutfitForDate,
        child:const Icon(Icons.add),
      ),
      body: content(),
    );
  }

  Widget content(){
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          TableCalendar(
            rowHeight: 50,
            headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true),
            availableGestures: AvailableGestures.all,
            selectedDayPredicate: (day)=>isSameDay(day, _focusedDay),
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2024,07,03),
            lastDay: DateTime.utc(2030,01,01),
            onDaySelected: _onDaySelected,
            eventLoader: (day) {
              return _outfitDates.contains(day) ? [true] : [];
            },
            calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isNotEmpty) {
                    return Positioned(bottom: 1,
                        child: Container(
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue
                          ),
                          width: 5,
                          height: 5,
                        )
                    );
                  }
                  return null;
                }
            ),
          ),

          const SizedBox(height: 8.0),
          if (_outfitDates.contains(_selectedDay))
            ElevatedButton(
              onPressed: () {
                if (_selectedDay != null) {
                _viewOutfitForDate(_selectedDay!);
                }
              },
              child: const Text('Ver Outfit'),
            ),
        ],
      ),
    );
  }
}