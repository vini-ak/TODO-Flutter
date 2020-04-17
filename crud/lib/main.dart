import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/tarefa.dart';

void main() {
  runApp(new ListaTarefasApp());
}

class ListaTarefasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: "TODO App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple
      ),
      home: new ListaScreen()
    );
  }
}

class ListaScreen extends StatefulWidget {

  var tarefas = new List<Tarefa>();

  ListaScreen() {
    tarefas = [];
    //   tarefas.add(Tarefa("Nome", true));
    //   tarefas.add(Tarefa("Estudar Flutter"));
    //   tarefas.add(Tarefa("Estudar React"));
  }

  @override
  _ListaScreenState createState() => _ListaScreenState();
}

class _ListaScreenState extends State<ListaScreen> {

  var newCtrl = TextEditingController();

  void add() {
    if(newCtrl.text.isNotEmpty) {
      setState(() {
        widget.tarefas.add(
          Tarefa(newCtrl.text)
        );
        newCtrl.clear();
        save();
      });
    }
  }

  void remove(int index) {
    setState(() {
      widget.tarefas.removeAt(index);
      save();
    });
  }

  Future load() async {
    var prefs = await SharedPreferences.getInstance(); // aguarde até que o sharedpreferences esteja pronto
    var data = prefs.getString('data');

    if (data != null) {
      Iterable decoded = jsonDecode(data);
      List<Tarefa> result = decoded.map((x) => Tarefa.fromJson(x)).toList();

      setState(() {
        widget.tarefas = result;
      });
    }
  }

  save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode(widget.tarefas));
  }

  _ListaScreenState() {
    load();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new TextFormField(
          controller: newCtrl,
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: Colors.white, 
            fontSize: 18,),
          decoration: InputDecoration(
            labelText: "Adicionar tarefa...",
            labelStyle: TextStyle(
              color: Colors.white
              ),
           ),
        )
      ),
      body: new ListView.builder(
            itemCount: widget.tarefas.length,
            itemBuilder: (BuildContext context, int index) {
              final tarefa = widget.tarefas[index];
              return Dismissible(
                child: new CheckboxListTile(
                  title: Text(tarefa.titulo),
                  value: tarefa.concluida, 
                  onChanged: (value) {
                    setState(() {
                      tarefa.concluida = value;
                      save();
                    });
                  },
                ),
                key: UniqueKey(),
                background: Container(
                  color: Colors.purple.withOpacity(0.7),
                ),
                onDismissed: (direction) {
                  remove(index);
                },
              );
            }
          ),     
      floatingActionButton: FloatingActionButton(
        onPressed: add,
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurpleAccent,
      ),       
    );
  }
}