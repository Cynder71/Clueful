import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/SelectClothesScreen.dart';
import 'package:flutter_app/pages/event.dart';
import 'package:flutter_app/pages/select_outfit_screen.dart';
import 'package:flutter_app/pages/wardrobe_screen.dart';
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

  Map<DateTime, List<Event>> events = {};

  late final ValueNotifier<List<Event>> _selectedEvents;
  

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay){
    if(!isSameDay(_selectedDay, selectedDay)){
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedEvents.value = _getEventsForDay(selectedDay);
      });
    }
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




  @override
  void initState(){
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
  }

  List<Event> _getEventsForDay(DateTime? day){
    return events[day]?? [];
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
            eventLoader: _getEventsForDay,
            ),

            const SizedBox(height: 8.0),
            Expanded(
              child: ValueListenableBuilder<List<Event>>(
                valueListenable: _selectedEvents, builder : (context, value, _) {
                  return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index){
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(12)
                        ),
                        child : ListTile(
                          onTap: ()=> print(""),
                          title: Text('${value[index ]}')
                        ),
                      );
                    }
                  );
                } 
              ),
            ),         
        ],
      ),
    );
  }
}