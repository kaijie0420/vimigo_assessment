import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'model/contact_details.dart';

class ViewContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ContactDetails contact = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Details'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            _getRow('Name', contact.user),
            SizedBox(height: 20),
            _getRow('Phone', contact.phone),
            SizedBox(height: 20),
            _getRow('Check In', _formatCheckIn(contact.checkIn)),
          ]
        ),
      )
    );
  }

  Container _getRow(String label, String value) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18
            ),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
      decoration: BoxDecoration(
        border: Border(bottom: 
          BorderSide(
            width: 1,
            color: Colors.grey 
          )
        )
      ),
    );
  }

  String _formatCheckIn(String checkIn) {
    final inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    final inputDate = inputFormat.parse(checkIn);

    var outputFormat = DateFormat('d MMM y hh:mm a');
    return outputFormat.format(inputDate);
  }

}