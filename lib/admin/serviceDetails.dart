import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ServiceDetails extends StatefulWidget {
  final docId;
  ServiceDetails(this.docId);
  @override
  _ServiceDetailsState createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Details'),
      ),
      body: Container(
          child: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('reservation')
            .document(widget.docId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _buildItemText("Customer Name: \t", snapshot.data['customer_name']),
                 _buildItemText("Customer Surname: \t", snapshot.data['customer_surname']),
                  _buildItemText("Customer Contact No: \t", snapshot.data['customer_phone']),
                   _buildItemText("Reservation Name: \t", snapshot.data['name']), 
                    _buildItemText("Reservation Surname: \t", snapshot.data['surname']),
                    _buildItemText("Reservation Contact No: \t", snapshot.data['contact_no']),
                   
                   
                    _buildItemText("Reservation Date: \t", snapshot.data['date']),
                    _buildItemText("Reservation Time: \t", snapshot.data['time']+"\tminutes"),
                    _buildItemText("Service Type: \t", snapshot.data['service_type']),
                    snapshot.data['service_type']=='Other'?
                    _buildItemText("Other Service Type: \t", snapshot.data['other_service_name']):Container(),
                  
                  
                     _buildItemText("Nearest Dealer: \t", snapshot.data['nearest_dealer']),
                    _buildItemText("Vehicle Model: \t", snapshot.data['vehicle_model']),   
                    _buildItemText("Vehicle Regitration No: \t", snapshot.data['vehicle_reg_no']), 
              ],
            ),
          );
        },
      )),
    );
  }

  _buildItemText(titleValue,textValue){
    return Card(
          child: ListTile(
        title: Text('$titleValue:  $textValue',style: TextStyle(fontSize: 18.0),),

      ),
    );
  }
}
