import 'package:flutter/material.dart';
import '../models/note.dart';
import '../data/shared_prefs.dart';
import '../data/sql_helper.dart';
import './notes.dart';

class NoteScreen extends StatefulWidget {
  final Note note;
  final bool isNew;

  const NoteScreen(this.note, this.isNew, {super.key});

  @override
  State createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  int settingColor = 0xff1976D2;
  double fontSize = 16;
  SPSettings settings = SPSettings();
  SqlHelper helper = SqlHelper();
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtNotes = TextEditingController();
  final TextEditingController txtDate = TextEditingController();

  @override
  void initState() {
    settings.init().then((_) {
      setState(() {
        settingColor = settings.getColor();
        fontSize = settings.getFontSize();
      });
    });
    if (!widget.isNew) {
      txtName.text = widget.note.name;
      txtNotes.text = widget.note.notes;
      txtDate.text = widget.note.date;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            widget.isNew ? const Text('Insert Note') : const Text('Edit Note'),
        backgroundColor: Color(settingColor),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            NoteText('Name', txtName, fontSize),
            NoteText('Description', txtNotes, fontSize),
            NoteText('Date', txtDate, fontSize),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(settingColor),
        onPressed: () {
          //save Note
          widget.note.name = txtName.text;
          widget.note.notes = txtNotes.text;
          widget.note.date = txtDate.text;
          widget.note.position = 0;
          if (widget.isNew) {
            helper.insertNote(widget.note);
          } else {
            helper.updateNote(widget.note);
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const NotesScreen()),
          );
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}

class NoteText extends StatelessWidget {
  final String description;
  final TextEditingController controller;
  final double textSize;

  const NoteText(this.description, this.controller, this.textSize, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: TextField(
        controller: controller,
        style: TextStyle(
          fontSize: textSize,
        ),
        decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            hintText: description),
      ),
    );
  }
}
