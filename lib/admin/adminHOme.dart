import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:tvs_service/admin/adverTiseMent.dart';

import 'package:tvs_service/firestore/firestoreMain.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Home"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _showDeletionDialouge(context);
            },
          )
        ],
      ),
      drawer: Drawer(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: 200.0,
                  child: Image.asset(
                    'assets/tv_motor.png',
                    fit: BoxFit.fill,
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.branding_watermark,
                    color: Colors.black,
                  ),
                  title: Text(
                    "Banner Add",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => AadvertiseMent()));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.exit_to_app,
                    color: Colors.black,
                  ),
                  title: Text(
                    "Log Out",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    FireStoreFunction().logout().then((user) {
                      if (user == null) {
                        Navigator.of(context)
                            .pushReplacementNamed('/landingPage');
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('reservation').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  rows: snapshot.data.documents
                      .map(
                        ((element) => DataRow(
                              cells: <DataCell>[
                                DataCell(SelectableText(element[
                                    "customer_name"])), //Extracting from Map element the value
                                DataCell(SelectableText(
                                    element["customer_surname"])),
                                DataCell(Text(element["customer_phone"])),

                                DataCell(SelectableText(element[
                                    "name"])), //Extracting from Map element the value
                                DataCell(SelectableText(element["surname"])),
                                DataCell(SelectableText(element["contact_no"])),

                                DataCell(SelectableText(element[
                                    "date"])), 
                                     DataCell(SelectableText(element[
                                    "appointment_created_date"])), //Extracting from Map element the value
                                DataCell(SelectableText(element["time"])),
                                DataCell(
                                    SelectableText(element["service_type"])),

                                element["service_type"] == 'Other'
                                    ? DataCell(SelectableText(
                                        element["other_service_name"]))
                                    : DataCell(SelectableText('N/A')),

                                DataCell(SelectableText(element[
                                    "nearest_dealer"])), //Extracting from Map element the value
                                DataCell(
                                    SelectableText(element["vehicle_model"])),
                                DataCell(
                                    SelectableText(element["vehicle_reg_no"])),
                              ],
                            )),
                      )
                      .toList(),
                  columns: <DataColumn>[
                    DataColumn(
                      label: Text('Customer Name'),
                    ),
                    DataColumn(
                      label: Text('Customer Surname'),
                    ),
                    DataColumn(
                      label: Text('Customer Contact No'),
                    ),
                    DataColumn(
                      label: Text('Appointment Name'),
                    ),
                    DataColumn(
                      label: Text('Appointment Surname'),
                    ),
                    DataColumn(
                      label: Text('Appointment Contact No'),
                    ),
                    DataColumn(
                      label: Text('Appointment Date'),
                    ),
                    DataColumn(
                      label: Text('Appointment Created Date'),
                    ),
                    DataColumn(
                      label: Text('Appointment Time'),
                    ),
                    DataColumn(
                      label: Text('Service Type'),
                    ),
                    DataColumn(
                      label: Text('Other Service'),
                    ),
                    DataColumn(
                      label: Text('Nearest Dealer'),
                    ),
                    DataColumn(
                      label: Text('Vehicle Model'),
                    ),
                    DataColumn(
                      label: Text('Vehicle Regitration No'),
                    ),
                  ],
                ),
              );

              // return ListView.builder(

              //   //scrollDirection:Axis.vertical,

              //   itemCount: snapshot.data.documents.length,
              //   itemBuilder: (BuildContext context, int index) {
              //     var data=snapshot.data.documents[index];
              //     // return ListTile(
              //     //   title: Text(data['customer_name']),
              //     //   subtitle: Text(data['service_type']),
              //     //   onTap: (){
              //     //     Navigator.of(context).push(MaterialPageRoute(
              //     //       builder: (BuildContext context)=>ServiceDetails(data.documentID)
              //     //     ));
              //     //   },

              //     // );

              //     return SingleChildScrollView(
              //       scrollDirection: Axis.vertical,
              //                       child: SingleChildScrollView(
              //         scrollDirection: Axis.horizontal,
              //                         child: DataTable(rows: <DataRow>[
              //           DataRow(cells: <DataCell>[
              //             DataCell(Text(data['customer_name'])),
              //             DataCell(Text(data['customer_surname'])),
              //             DataCell(Text(data['customer_phone']))

              //           ]

              //           )
              //         ], columns: <DataColumn>[
              //           DataColumn(
              //             label: Text('Customer Name'),
              //           ),
              //            DataColumn(
              //             label: Text('Customer Surname'),
              //           ),
              //            DataColumn(
              //             label: Text('Customer Contact No'),
              //           ),
              //         ],

              //         ),
              //       ),
              //     );
              //   },

              // );

//            return DataTable(columns: <DataColumn>[
//              DataColumn(label: Text("name")),
//                DataColumn(label: Text("Service Type")),
//            ], rows: <DataRow>[
//              DataRow(cells: <DataCell>[
//              DataCell(
// Text(snapshot.data.documents[index])
//              )
//              ]

//              )

//            ],

//             );
            },
          ),
        ),
      ),
    );
  }

  Future _showDeletionDialouge( context) {
    return showDialog(
      builder: (context) {
        return AlertDialog(
          title: Text('Delete all reservation'),
          actions: <Widget>[
            FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            FlatButton(
                child: Text('delete'),
                onPressed: () {
                  Firestore.instance
                      .collection('reservation')
                      .getDocuments()
                      .then((snapshot) {
                    for (DocumentSnapshot ds in snapshot.documents) {
                      ds.reference.delete();
                    }
                  }).then((onValue) {
                    Navigator.of(context).pop();
                  });
                }),
          ],
        );
      },
      context: context,
    );
  }
}
//Appointment Created Date