import 'dart:core';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:qleedo/index.dart';

final inputFormat1 = DateFormat("yyyy-MM-dd");

/*class Saints {   
  final String objectID;  
  final String imageUrl;  
  final String description;
  final String id;
  final String name;
  final String period;
  final DateTime feastDate;
  
  Saints({required this.objectID, required this.imageUrl, required this.description, required this.id, required this.name,required this.period, required this.feastDate});  
  
  factory Saints.fromJson(Map<String, dynamic> rowData) {  
    var feastDateStr = rowData['Feast_Date'] ?? "";
    DateTime feastYearUpdated = new DateTime(1770,1,1,0,0,0);
    if(feastDateStr != ""){
      DateTime feastisodate = DateTime.parse(rowData['Feast_Date']['iso']);
       feastYearUpdated = new DateTime(DateTime.now().year, feastisodate.month,feastisodate.day, 0, 0, 0);    
    }  

    return Saints(  
      objectID: rowData['objectId'],  
      name: rowData['name'],  
      imageUrl: rowData['image']["url"],
      description: rowData['description'],
      id: rowData['saint_id'],
      period : rowData["period"] ?? "",
      feastDate: feastYearUpdated ,
    );  
  }

  factory Saints.fromJsonAPI(Map<String, dynamic> rowData) {  
    print("..fromJsonAPI........$rowData...");
    var siantsImgPath = qleedoMediaPath+rowData['media'][0]["media_url"];
    var feastDateStr = rowData["feast_date"] ?? "";
    /*DateTime feastYearUpdated = new DateTime(1770,1,1,0,0,0);
    if(feastDateStr != ""){
      DateTime feastisodate = DateTime.parse(feastDateStr);
       feastYearUpdated = new DateTime(DateTime.now().year, feastisodate.month,feastisodate.day, 0, 0, 0);    
    } */
    print("..$siantsImgPath....saints api.....$feastDateStr...");
    return Saints(  
      objectID: rowData['id'].toString(),  
      name: rowData['saint_name'] ?? "",  
      imageUrl: siantsImgPath,
      description: rowData['description'] ?? "",
      id: rowData['id'].toString(),
      period : rowData["period"] ?? "",
      feastDate: DateTime.now(),
    );  
  }

  factory Saints.initialise() {
    return Saints(objectID: "-1", description: "", id: "", imageUrl: "", name: "", period: "", feastDate: DateTime.now());
  }  
} */

class Saints {   
  final int id;  
  final String name;  
  final String feastDate;
  final String imageUrl;
  final String description;
  final String period;


  Saints(
      {required this.id,
      required this.name,
      required this.feastDate,
      required this.imageUrl,
      required this.description,
      required this.period
});

  factory Saints.empty() {
    return Saints(id: -1, name: "", feastDate: "", imageUrl: "", description: "", period: "");
  }

  factory Saints.fromJson(Map<String, dynamic> json) {
    var mediaUrl = json['saintimages'] ?? "";
    if(mediaUrl.isNotEmpty ){
      var data = mediaUrl[0]["media_url"];
      mediaUrl = qleedoMediaPath+data;
    }

    return Saints(
      id: json['id'] ?? 0,
      name: json['saint_name'] ?? "",
      feastDate: json['feast_date'] ?? "",
      imageUrl: mediaUrl,
      description: json['description'] ?? "",
      period : json['period'] ?? "",
    );
  }
}

