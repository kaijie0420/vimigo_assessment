import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:vimigo_assessment/model/contact_details.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contacts',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Contact List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController controller = new TextEditingController();

  List<ContactDetails> _contactDetails = [];
  List<ContactDetails> _searchResult = [];

  Future getContactDetails() async {
    String data = await rootBundle.loadString('assets/contacts.json');
    final jsonResult = json.decode(data);

    setState(() {
      for (int i = 0; i < jsonResult.length; i++) {
        jsonResult[i]['id'] = i;
        _contactDetails.add(ContactDetails.fromJson(jsonResult[i]));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getContactDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Card(
              child: new ListTile(
                leading: new Icon(Icons.search),
                title: new TextField(
                  controller: controller,
                  decoration: new InputDecoration(
                      hintText: 'Search', border: InputBorder.none),
                  onChanged: onSearchTextChanged,
                ),
              ),
            ),
          ),
          Expanded(child: 
            ReorderableListView(
              onReorder: onReorder,
              children: getContactList(),
            ),
          )
        ],
      )
    );
  }

  onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    setState(() {
      ContactDetails contact = _contactDetails[oldIndex];

      _contactDetails.removeAt(oldIndex);
      _contactDetails.insert(newIndex, contact);
    });
  }

  getContactList() {
    List<ContactDetails> list = [];
    if (_searchResult.length != 0 || controller.text.isNotEmpty) {
      list = _searchResult;
    } else {
      list = _contactDetails;
    }
    return list.map((item) => ListTile(key: Key("${item.id}"), title: Text("${item.user}"), trailing: Icon(Icons.menu),)).toList();
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _contactDetails.forEach((userDetail) {
      if (userDetail.user.toUpperCase().contains(text.toUpperCase())) {
        _searchResult.add(userDetail);
      }
    });

    setState(() {});
  }
}
