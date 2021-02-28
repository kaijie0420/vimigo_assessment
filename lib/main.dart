import 'package:flame/animation.dart' as animation;
import 'package:flame/flame.dart';
import 'package:flame/spritesheet.dart';
import 'package:flutter/material.dart' hide Animation;
import 'package:flame/widgets/animation_widget.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'model/contact_details.dart';
import 'add_contact.dart';
import 'view_contact.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.images.load('animation.png');

  final spriteList1 = List<int>.generate(11, (i) => i)
    .map((e) => _animationSpriteSheet.getSprite(0, e))
    .toList();
  final spriteList2 = List<int>.generate(11, (i) => i)
    .map((e) => _animationSpriteSheet.getSprite(1, e))
    .toList();
  final spriteList3 = List<int>.generate(10, (i) => i)
    .map((e) => _animationSpriteSheet.getSprite(2, e))
    .toList();
  final spriteList = [...spriteList1, ...spriteList2, ...spriteList3];

  _animation = animation.Animation.spriteList(spriteList, stepTime: 0.1);
  runApp(MyApp());
}

animation.Animation _animation;
final _animationSpriteSheet = SpriteSheet(
  imageName: 'animation.png',
  columns: 12,
  rows: 3,
  textureWidth: 170,
  textureHeight: 171,
);

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
        '/addContact': (context) => AddContactPage(),
        '/viewContact': (context) => ViewContactPage(),
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

  Future _getContactDetails() async {
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
    _getContactDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          Builder(builder: (ctx) => 
            IconButton(
              icon: Icon(Icons.add),
              iconSize: 30.0,
              onPressed: () => _toAddContactPage(ctx),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Column(
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
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 90,
              height: 90,
              child: AnimationWidget(animation: _animation),
            ))
        ]
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
    return list.asMap().map((index, item) {
      return MapEntry(
        index, 
        ListTile(
          key: Key("$index"), 
          title: Text("${item.user}"), 
          onTap: () {
            Navigator.pushNamed(
              context, 
              '/viewContact',
              arguments: item,
            );
          },
        ),
      );
    }).values.toList();
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

  _toAddContactPage(BuildContext context) async {
    Scaffold.of(context).hideCurrentSnackBar();
    final addedContact = await Navigator.pushNamed(context, '/addContact');

    if (addedContact != null) {
      setState(() {
        _contactDetails.add(addedContact);
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("New contact added."),
        ));
      });
    }
  }
}
