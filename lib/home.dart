import 'package:flutter/material.dart';
import 'message.dart';
import 'package:intl/intl.dart';
import 'generated/l10n.dart';
import 'ai.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _textController = TextEditingController();
  List<Message> _messages = <Message>[]; // Инициализация переменной _messages пустым списком
  final fsconnect = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    get_dialogue().then((value) {
      setState(() {
        _messages = value;
      });
    });
  }

  Future<List<Message>> get_dialogue() async {
    var data = await fsconnect.collection("dialogue").orderBy("date").get();
    List<Message> ms = <Message>[];
    for (var i in data.docs) {
      ms.add(Message(
        text: i.data()["text"],
        isSend: i.data()["isSend"],
        date: i.data()["date"],
      ));
    }
    return ms;
  }

  Future<void> _senderMessage(String question) async {
    String answer = await AI().getAnswer(question);
    _textController.clear();
    var dialogue = fsconnect.collection('dialogue');
    var currentDate = DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());

    setState(() {
      _messages.insert(0, Message(text: question, isSend: true, date: currentDate));
      _messages.insert(0, Message(text: answer, isSend: false, date: currentDate));
    });

    // Сохраняем вопрос
    dialogue.add({'text': question, 'isSend': true, 'date': currentDate});
    // Сохраняем ответ
    dialogue.add({'text': answer, 'isSend': false, 'date': currentDate});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(S.of(context).title),
        centerTitle: true,
        backgroundColor: Theme.of(context).cardColor,
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (_, int index) => _getItem(_messages[index]),
            ),
          ),
          Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: S.of(context).sendHint,
                  ),
                  onSubmitted: _senderMessage,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => _senderMessage(_textController.text),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getItem(Message message) {
    return Container(
      color: message.isSend ? Colors.tealAccent : Colors.limeAccent,
      margin: message.isSend
          ? const EdgeInsets.fromLTRB(80, 8, 4, 4)
          : const EdgeInsets.fromLTRB(4, 8, 80, 4),
      child: message.isSend
          ? _getMyListTile(message)
          : _getAssistentListTile(message),
    );
  }

  ListTile _getMyListTile(Message message) {
    return ListTile(
      leading: const Icon(Icons.face),
      title: Text(message.text),
      subtitle: Text(message.date),
    );
  }

  ListTile _getAssistentListTile(Message message) {
    return ListTile(
      leading: const Icon(Icons.smart_toy),
      title: Text(message.text),
      subtitle: Text(message.date),
    );
  }
}
