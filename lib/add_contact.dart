import 'package:flutter/material.dart';
import 'package:vimigo_assessment/model/contact_details.dart';

class AddContactPage extends StatefulWidget {
  @override
  _AddContactState createState() => new _AddContactState();
}

class _AddContactState extends State<AddContactPage> {
  TextEditingController _userController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Contact'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: TextFormField(
                controller: _userController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  return value.isEmpty ? 'Please input name.' : null;
                }
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  return value.isEmpty ? 'Please input phone.' : null;
                }
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text('Submit'),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      Navigator.pop(context, new ContactDetails(user: _userController.text, phone: _phoneController.text));
                    }
                  },
                ),
              ),
            ),
          ]
        )
      )
    );
  }
}