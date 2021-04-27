import 'dart:io';

import 'package:challenge_flutter/entry/entry_model.dart';
import 'package:challenge_flutter/qod/qod_api.dart';
import 'package:challenge_flutter/qod/qod_model.dart';
import 'package:challenge_flutter/screens/detail_entry_screen.dart';
import 'package:challenge_flutter/screens/welcome_screen.dart';
import 'package:challenge_flutter/utils/constants.dart';
import 'package:challenge_flutter/utils/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final futureQod = getQuoteOfDay();

class HomeScreen extends StatefulWidget {
  static const String id = 'homeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CollectionReference _entriesCollection = _firestore
      .collection('users')
      .doc(_auth.currentUser!.uid)
      .collection('entries');

  final Stream<QuerySnapshot> _snapEntries = _firestore
      .collection('users')
      .doc(_auth.currentUser!.uid)
      .collection('entries')
      .snapshots();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _moodController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _moodFocus = FocusNode();
  final FocusNode _textFocus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _logoutUser(BuildContext context) async {
    await _auth.signOut();
    await Navigator.of(context).pushReplacementNamed(WelcomeScreen.id);
  }

  void showModalCustom(BuildContext context) {
    const _cornerRadius = 10.0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(_cornerRadius),
          topRight: Radius.circular(_cornerRadius),
        ),
      ),
      builder: (context) {
        final currentThemeData = Theme.of(context);
        return Container(
          height: 334,
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(_cornerRadius),
              topRight: Radius.circular(_cornerRadius),
            ),
            color: Colors.white,
          ),
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
        );
      },
    );
  }

  Future<Map<String, dynamic>?> _salvaEntry() async {
    if (_formKey.currentState!.validate()) {
      try {
        final id = Timestamp.now().millisecondsSinceEpoch;
        await _entriesCollection.doc(id.toString()).set({
          'title': _titleController.text,
          'mood': _moodController.text,
          'text': _textController.text,
          'data': Timestamp.now().millisecondsSinceEpoch,
        });
        return {'success': true};
      } catch (e) {
        return {'success': false, 'error': 'Errore nel salvataggio'};
      }
    }
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
    return WillPopScope(
      onWillPop: () async {
        if (Platform.isAndroid) {
          SystemNavigator.pop(animated: true);
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        drawer: Drawer(
          child: Container(
            height: 100,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: currentThemeData.primaryColor,
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Text(
                    'Login come:',
                    style: kTitleStyle.copyWith(color: Colors.white),
                  ),
                  kSized10H,
                  Text(
                    _auth.currentUser!.email!,
                    style: kFont16Bold,
                  ),
                  const Spacer(),
                  CustomButton(
                    text: 'Logout',
                    backgroundColor: Colors.white,
                    onPressed: () => _logoutUser(context),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Quote of the day',
                style: kTitleStyle,
              ),
              kSized10H,
              FutureBuilder<Map<String, dynamic>>(
                future: futureQod,
                builder: (context, qod) {
                  if (!qod.hasData) {
                    return Column(
                      children: [
                        const Text('Sto caricando...'),
                        kSized10H,
                        LinearProgressIndicator(
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              currentThemeData.primaryColor),
                        ),
                      ],
                    );
                  }
                  final quoteJson = qod.data!['contents']['quotes'][0]
                      as Map<String, dynamic>;
                  final quote = QodModel.fromJson(quoteJson);
                  return Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text('Author: ${quote.author}'),
                            ],
                          ),
                          kSized10H,
                          Text(
                            '"${quote.text}"',
                            style: kFont14Bold,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
              kSized40H,
              const Text(
                'My Entries',
                style: kTitleStyle,
              ),
              kSized10H,
              StreamBuilder<QuerySnapshot>(
                stream: _snapEntries,
                builder: (context, entries) {
                  if (!entries.hasData) {
                    return const Center(
                        child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text('No entries for now'),
                    ));
                  }
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: entries.data!.docs.length,
                    itemBuilder: (context, index) {
                      final entryMap = entries.data!.docs[index];
                      final entry = EntryModel.fromMap(entryMap.data());
                      return InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DetailEntryScreen(
                                dataEntry: entryMap.data()['data'].toString()),
                          ),
                        ),
                        child: Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text('Data: ${entry.data}'),
                                  ],
                                ),
                                kSized10H,
                                Text(
                                  '"${entry.text}"',
                                  style: kFont14Bold,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showModalCustom(context),
          backgroundColor: currentThemeData.primaryColor,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
