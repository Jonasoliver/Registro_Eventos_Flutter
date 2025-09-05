import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Registro de Eventos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        scaffoldBackgroundColor: Colors.blue[50],
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          ),
        ),
      ),
      home: const EventFormPage(),
    );
  }
}

class Event {
  final String date;
  final String time;
  final String description;

  Event({required this.date, required this.time, required this.description});

  Map<String, dynamic> toJson() => {
    'date': date,
    'time': time,
    'description': description,
  };

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    date: json['date'],
    time: json['time'],
    description: json['description'],
  );
}

class EventFormPage extends StatefulWidget {
  const EventFormPage({super.key});

  @override
  State<EventFormPage> createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _descController = TextEditingController();

  List<Event> _events = [];

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _addEvent() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _events.add(
          Event(
            date: _dateController.text,
            time: _timeController.text,
            description: _descController.text,
          ),
        );
        _saveEvents();
        _dateController.clear();
        _timeController.clear();
        _descController.clear();
      });
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/events.json');
  }

  Future<void> _saveEvents() async {
    final file = await _localFile;
    List<Map<String, dynamic>> jsonList = _events
        .map((e) => e.toJson())
        .toList();
    await file.writeAsString(jsonEncode(jsonList));
  }

  Future<void> _loadEvents() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        String contents = await file.readAsString();
        List<dynamic> jsonList = jsonDecode(contents);
        setState(() {
          _events = jsonList.map((e) => Event.fromJson(e)).toList();
        });
      }
    } catch (e) {
      // ignore errors
    }
  }

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Evento'),
        backgroundColor: Colors.blue,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Data (dd/mm/yyyy)',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe a data' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(
                  labelText: 'Hora (hh:mm)',
                  prefixIcon: Icon(Icons.access_time),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe a hora' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  prefixIcon: Icon(Icons.event_note),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Informe a descrição'
                    : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _addEvent,
                icon: const Icon(Icons.save),
                label: const Text('Salvar Evento'),
              ),
              const SizedBox(height: 28),
              Expanded(
                child: _events.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhum evento registrado ainda.',
                          style: TextStyle(color: Colors.black54, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _events.length,
                        itemBuilder: (context, index) {
                          final event = _events[index];
                          return Card(
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: const Icon(
                                Icons.event,
                                color: Colors.blue,
                              ),
                              title: Text(
                                event.description,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text('${event.date} - ${event.time}'),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
