import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class UserFormPAge extends StatefulWidget {
  @override
  _UserFormPAgeState createState() => _UserFormPAgeState();
}

class _UserFormPAgeState extends State<UserFormPAge> {
  List<String> vehicleModels = [
    'Jupiter (All Series)',
    'Scooty Pep +',
    'Wego',
    'Ntorq',
    'Apache (All Series)',
    'Star City +',
    'Sport',
    'Redeon',
    'Victor',
    'XL 100 (All Series)',
    'Other Model'
  ];

  List<String> dealersAll = [
    'Kolhapur (KR TVS)',
    'Kolhapur (Mai TVS)',
    'Sangli (Pore\'s TVS)',
    'Miraj (AK TVS)',
    'Ichalkaranji (Borgave TVS)',
    'Satara (Hem TVS)',
    'Karad (Mangharam TVS)',
    'Chiplun (Joshi\'s TVS)',
    'Ratnagiri (RK TVS)',
    'Kudal (Next Drive TVS)',
  ];

  String _selectedLocation;
  String _selectedDealer;
  String dropdownValue = 'Choose';
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerSureName = TextEditingController();
  final TextEditingController _controllerContactNo = TextEditingController();
  final TextEditingController _controllerVehicleRegNumber =
      TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _controllerOthersText = TextEditingController();
  String radioItemHolder = 'One';
  String serviceType;
  String _date;
  String _month;
  String _year;
  String _minuteS;
  String _hourS;
  String amOrpm;
  bool _loaderState = false;
  String name, surName, phone;
  final _formKey = GlobalKey<FormState>();
  String timeValue;
  String chekWithCurrent;
  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        name = prefs.getString('name');
        surName = prefs.getString('surname');
        phone = prefs.getString('phone');
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('TVS appoinment form'),
        ),
        body: name != null
            ? ModalProgressHUD(
                inAsyncCall: _loaderState,
                child: Container(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: double.infinity,
                              child: Image.asset(
                                'assets/tv_motor.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          _widgetSizedBox(15.0),
                          _widgetTitleText("TVS Service Appointment Form", 20.0,
                              null, FontWeight.bold),
                          _widgetSizedBox(25.0),
                          _widgetTitleText("TVS सर्विस अपॉइंटमेंट फॉर्म ", 15.0,
                              null, FontWeight.bold),
                          _widgetSizedBox(20.0),
                          _widgetTitleText(
                              "* Required ", 13.0, Colors.red, FontWeight.bold),
                          _widgetSizedBox(25.0),
                          _widgetTitleText("Name (नाव ) *", 18.0, Colors.black,
                              FontWeight.normal),
                          _widgetSizedBox(10.0),
                          _widgetTExtField(_controllerName, TextInputType.text),
                          _widgetSizedBox(25.0),
                          _widgetTitleText("Surname (आडनाव ) *", 18.0,
                              Colors.black, FontWeight.normal),
                          _widgetSizedBox(10.0),
                          _widgetTExtField(
                              _controllerSureName, TextInputType.text),
                          _widgetSizedBox(25.0),
                          _widgetTitleText("Contact No (संपर्क) *", 18.0,
                              Colors.black, FontWeight.normal),
                          _widgetSizedBox(10.0),
                          _widgetTExtField(
                              _controllerContactNo, TextInputType.phone),
                          _widgetSizedBox(25.0),
                          _widgetTitleText(
                              "Vehicle Reg. Number (गाडीचा रजि. नंबर ) *",
                              18.0,
                              Colors.black,
                              FontWeight.normal),
                          _widgetSizedBox(10.0),
                          _widgetTExtField(
                              _controllerVehicleRegNumber, TextInputType.text),
                          _widgetSizedBox(25.0),
                          _widgetTitleText("Vehicle Model (गाडीचे मॉडेल ) *",
                              18.0, Colors.black, FontWeight.normal),
                          // _widgetSizedBox(25.0),
                          _widgetVehicleRegDropDown(),
                          _widgetSizedBox(25.0),
                          _widgetTitleText("Service Type ( सर्विसचा प्रकार ) *",
                              18.0, Colors.black, FontWeight.normal),
                          _widgetSizedBox(10.0),
                          RadioButtonGroup(
                              labels: <String>[
                                "Free Service",
                                "Paid Service",
                                "Other",
                              ],
                              onSelected: (String selected) {
                                setState(() {
                                  serviceType = selected;
                                });
                              }),
                          _widgetSizedBox(25.0),

                          serviceType == 'Other'
                              ? _widgetTExtField(
                                  _controllerOthersText, TextInputType.text)
                              : Container(),
                          _widgetSizedBox(25.0),
                          _widgetTitleText(
                              "Nearest TVS Dealer (जवळचे TVS डीलरशिप ) *",
                              18.0,
                              Colors.black,
                              FontWeight.normal),

                          _widgetDealerDropDown(),
                          _widgetSizedBox(25.0),
                          _widgetTitleText(
                              "Appointment Date (अँपॉईंटमेंट तारीख ) *",
                              18.0,
                              Colors.black,
                              FontWeight.normal),

                          _buildYearWidget(),
                          _widgetSizedBox(20.0),
                          _widgetTitleText(
                              "Appointment Time (अँपॉईंटमेंट वेळ ) *",
                              18.0,
                              Colors.black,
                              FontWeight.normal),

                          // _builTimeWidget(),
                          _time12HourWidget(),

                          _widgetSizedBox(20.0),

                          Center(
                            child: SizedBox(
                              height: 40.0,
                              child: RaisedButton(
                                elevation: 6.0,
                                color: Colors.blue,
                                child: Text(
                                  "SUBMIT",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState.validate() &&
                                      serviceType != null &&
                                      _selectedLocation != null &&
                                      _selectedDealer != null &&
                                      _date != null &&
                                      _hourS != null &&
                                      timeValue != null) {
                                    setState(() {
                                      _loaderState = true;
                                    });

                                    if (chekWithCurrent ==
                                        '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}') {
                                      _showSnackbar(
                                          "Current day appoinment can't be taken");
                                    } else {
                                      Firestore.instance
                                          .collection('reservation')
                                          .where('customer_name',
                                              isEqualTo: name)
                                          .where('customer_phone',
                                              isEqualTo: phone)
                                          .where('customer_surname',
                                              isEqualTo: surName)
                                          .where('date',
                                              isEqualTo:
                                                  "$_date/$_month/$_year")
                                          .getDocuments()
                                          .then((docs) {
                                        if (docs.documents.length > 4) {
                                          _showSnackbar(
                                              "Appoinment Quota filled on this day");
                                        } else {
                                          submitData();
                                        }
                                      });
                                    }
                                  } else {
                                    _showSnackbar('All field value required');
                                  }
                                },
                              ),
                            ),
                          ),
                          _widgetSizedBox(20.0),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }

  _time12HourWidget() {
    final format = DateFormat("h:mm a");
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: DateTimeField(
        format: format,
        validator: (value) {
          if (value.toString().length <= 0) {
            return 'Time is required';
          }
          return null;
        },
        decoration: InputDecoration(labelText: "\tHour/Minute"),
        onShowPicker: (BuildContext context, DateTime currentValue) async {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
          );
          return DateTimeField.convert(time);
        },
        onChanged: (value) {
          // if (value == null) {
          //   setState(() {
          //     timeValue = null;
          //   });
          // }
          if (value != null) {
            var hours = value.hour;
            var am = true;
            if (hours > 12) {
              am = false;
              hours -= 12;
            } else if (hours == 12) {
              am = false;
            } else if (hours == 0) {
              hours = 12;
            }

            setState(() {
              _hourS = hours.toString();
              _minuteS = value.minute.toString();
              am ? amOrpm = "am" : amOrpm = "pm";

              timeValue = _hourS + ":" + _minuteS + "\t" + amOrpm;
            });
          }

          //print(timeValue);

          // setState(() {
          //   _hourS=value.hour.toString();
          //   _minuteS=value.minute.toString();
          // });

          // print(hours);
          // print(am);
        },
      ),
    );
  }

  submitData() {
    Firestore.instance.collection('reservation').add({
      'name': _controllerName.text,
      'surname': _controllerSureName.text,
      'contact_no': _controllerContactNo.text,
      'vehicle_reg_no': _controllerVehicleRegNumber.text,
      'vehicle_model': _selectedLocation,
      'service_type': serviceType,
      'other_service_name':
          serviceType == 'Other' ? _controllerOthersText.text : '',
      'nearest_dealer': _selectedDealer,
      'date': "$_date/$_month/$_year",
      'time': timeValue,
      'customer_name': name,
      'customer_phone': phone,
      'customer_surname': surName,
      'appointment_created_date':DateTime.now().day.toString()+"/"+DateTime.now().month.toString()+"/"+
      DateTime.now().year.toString()
    }).then((onValue) {
      if (onValue != null) {
        _showSnackbar('Thank you for your appointment');
        _controllerName.clear();
        _controllerContactNo.clear();
        _controllerOthersText.clear();
        _controllerSureName.clear();
        _controllerVehicleRegNumber.clear();
        _controllerOthersText.clear();
        _selectedDealer = null;
        _date = null;
        _month = null;
        _year = null;
        // _hourS = null;
        // _minuteS = null;
        _selectedLocation = null;
       // serviceType = null;
      } else {
        _showSnackbar('Appointment failed try again');
      }
    });
  }

  _widgetVehicleRegDropDown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: DropdownButton(
        hint: Text('Choose'), // Not necessary for Option 1
        value: _selectedLocation,
        onChanged: (newValue) {
          setState(() {
            _selectedLocation = newValue;
          });
        },
        items: vehicleModels.map((location) {
          return DropdownMenuItem(
            child: new Text(location),
            value: location,
          );
        }).toList(),
      ),
    );
  }

  _widgetDealerDropDown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: DropdownButton(
        hint: Text('Choose'), // Not necessary for Option 1
        value: _selectedDealer,
        onChanged: (newValue) {
          setState(() {
            _selectedDealer = newValue;
          });
        },
        items: dealersAll.map((location) {
          return DropdownMenuItem(
            child: new Text(location),
            value: location,
          );
        }).toList(),
      ),
    );
  }

  _widgetTExtField(controllerSet, textType) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        autofocus: false,
        keyboardType: textType,
        validator: (value) {
          if (value.isEmpty) {
            return 'This is a required question';
          }
          return null;
        },
        controller: controllerSet,
        decoration: InputDecoration(hintText: 'Your answer'),
      ),
    );
  }

  _widgetSizedBox(heightValue) {
    return SizedBox(
      height: heightValue,
    );
  }

  _widgetTitleText(String value, fontSize, colors, fontWeights) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Text(
          value,
          style: TextStyle(
              fontSize: fontSize, fontWeight: fontWeights, color: colors),
        ));
  }

  _buildYearWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: GestureDetector(
        // color: Colors.white,

        onTap: () {
          DatePicker.showDatePicker(context,
              theme: DatePickerTheme(
                containerHeight: 210.0,
              ),
              showTitleActions: true,
              minTime: DateTime(2000, 1, 1),
              maxTime: DateTime(2050, 12, 31), onConfirm: (date) {
            //  print('confirm $date');
            chekWithCurrent = '${date.year}-${date.month}-${date.day}';

            _date = date.day.toString();
            _month = date.month.toString();
            _year = date.year.toString();
            setState(() {});
          }, currentTime: DateTime.now(), locale: LocaleType.en);
        },
        child: Container(
          alignment: Alignment.center,
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 20.0),
                          child: Text(
                            _date != null
                                ? " $_date/$_month/$_year"
                                : "\tDD//MM/YYYY",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

 

  void _showSnackbar(String message) {
    setState(() {
      _loaderState = false;
    });
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
    ));
  }
}
