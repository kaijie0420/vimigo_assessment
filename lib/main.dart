import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:vimigo_assessment/model/contact_details.dart';
import 'package:vimigo_assessment/add_contact.dart';

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
      routes: {
        // '/': (context) => _login,
        '/addContact': (context) => AddContactPage(),
      },
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
  TextEditingController _searchController = new TextEditingController();

  List<ContactDetails> _contactDetails = [];
  List<ContactDetails> _searchResult = [];

  Future getContactDetails() async {
    String data = await rootBundle.loadString('assets/contacts.json');
    final jsonResult = json.decode(data);

    setState(() {
      for (Map contact in jsonResult) {
          _contactDetails.add(ContactDetails.fromJson(contact));
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
            padding: EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                leading: Icon(Icons.search),
                title: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search', border: InputBorder.none
                  ),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final addedContact = await Navigator.pushNamed(context, '/addContact');

          if (addedContact != null) {
            setState(() {
              _contactDetails.add(addedContact);
            });
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
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
    if (_searchResult.length != 0 || _searchController.text.isNotEmpty) {
      list = _searchResult;
    } else {
      list = _contactDetails;
    }
    return list.asMap().map((index, item) => MapEntry(index, ListTile(key: Key("$index"), title: Text("${item.user}"), trailing: Icon(Icons.menu)))).values.toList();
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
