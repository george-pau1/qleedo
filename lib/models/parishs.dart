import 'dart:core';

import 'package:qleedo/index.dart';


class Parishs {
  final int id;  
  final String name;  
  final String address1;
  final String address2;
  final String zipcode;
  final String phoneNo;
  final String latitude;
  final String longitude;
  
  Parishs({required this.id, required this.name, required this.latitude, required this.longitude, required this.address1, required this.address2, required this.zipcode, required this.phoneNo,});  
  
  factory Parishs.fromJson(Map<String, dynamic> rowData) {  

    return Parishs(  
      id: rowData['id'],  
      name: rowData['parish_name'] ?? "",  
      latitude: rowData['latitude'] ?? "" ,
      longitude : rowData['longitude'] ?? "",
      address1: rowData['address1'] ?? "",  
      address2: rowData['address2'] ?? "",
      zipcode : rowData['zip_code'] ?? "",
      phoneNo: rowData['phone_no'] ?? "",  
    );  
  }  
} 



