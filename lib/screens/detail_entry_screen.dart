import 'package:challenge_flutter/utils/constants.dart';
import 'package:challenge_flutter/utils/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class DetailEntryScreen extends StatefulWidget {
  final String dataEntry;

  const DetailEntryScreen({Key? key, required this.dataEntry})
      : super(key: key);

  @override
  _DetailEntryScreenState createState() => _DetailEntryScreenState();
}

class _DetailEntryScreenState extends State<DetailEntryScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _moodController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _moodFocus = FocusNode();
  final FocusNode _textFocus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final CollectionReference _entriesCollection = _firestore
      .collection('users')
      .doc(_auth.currentUser!.uid)
      .collection('entries');

  Future<Map<String, dynamic>?> _salvaEntry() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _entriesCollection.doc(widget.dataEntry).update({
          'title': _titleController.text,
          'mood': _moodController.text,
          'text': _textController.text,
        });
        return {'success': true};
      } catch (e) {
        return {'success': false, 'error': 'Errore nel salvataggio'};
      }
    }
  }

  Future<void> _initForm() async {
    final _docEntryFuture = await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('entries')
        .doc(widget.dataEntry)
        .get();
    final data = _docEntryFuture.data();
    _textController.text = data!['text'] as String;
    _titleController.text = data['title'] as String;
    _moodController.text = data['mood'] as String;
  }

  @override
  void initState() {
    super.initState();
    _initForm();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _moodController.dispose();
    _textController.dispose();
    _moodFocus.dispose();
    _textFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentThemeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entry'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                cursorColor: currentThemeData.primaryColor,
                controller: _titleController,
                onFieldSubmitted: (_) => _moodFocus.requestFocus(),
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Inserisci un titolo';
                  }
                  return null;
                },
              ),
              kSized10H,
              TextFormField(
                cursorColor: currentThemeData.primaryColor,
                controller: _moodController,
                focusNode: _moodFocus,
                onFieldSubmitted: (_) => _textFocus.requestFocus(),
                decoration: const InputDecoration(
                  labelText: 'Mood',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Inserisci un mood';
                  }
                  return null;
                },
              ),
              kSized10H,
              TextFormField(
                cursorColor: currentThemeData.primaryColor,
                controller: _textController,
                focusNode: _textFocus,
                maxLength: 300,
                maxLines: 3,
                decoration: const InputDecoration(hintText: 'Text'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Inserisci un testo';
                  }
                  return null;
                },
              ),
              kSized10H,
              CustomButton(
                text: 'Salva',
                onPressed: () async {
                  final result = await _salvaEntry();
                  Navigator.of(context).pop();
                  if (!(result!['success'] as bool)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result['error'] as String)));
                  }
                },
                backgroundColor: currentThemeData.primaryColor,
                textColor: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
