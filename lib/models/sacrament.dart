
import 'package:qleedo/index.dart';
import 'package:amazon_like_filter/props/filter_item_model.dart';
import 'package:amazon_like_filter/props/filter_list_model.dart';
import 'package:qleedo/models/prayer.dart';

class SacramentDetails {
  final int id;
  final String name;
  final String htmlUrl;
  final List<Audio> audio;

  SacramentDetails(
      {required this.id,
      required this.name,
      required this.htmlUrl,
      required this.audio
  });

  factory SacramentDetails.empty() {
    return SacramentDetails(id: 0, name: "", htmlUrl: "", audio: []);
  }

  factory SacramentDetails.fromJson(Map<String, dynamic> json) {
    print("..$json..PrayerDeta....first.");
    var audiodata = json["sacrament_audio"];
    var audioList = (audiodata as List).map((data) => Audio.fromJson(data)).toList();
    var htmlUrl = json['content_path'];
    if(htmlUrl != ""){
      htmlUrl = "$qleedoMediaPath$htmlUrl";
    }
    print("..$json..PrayerDeta.....$audiodata....ils......$htmlUrl..");
    return SacramentDetails(
      id: json['id'],
      name: "",
      htmlUrl: htmlUrl,
      audio: audioList,
    );
  }


}

class Sacraments {
  final int id;
  final String name;
  final String properties;

  Sacraments(
      {required this.id,
      required this.name,
      required this.properties,
});

  factory Sacraments.fromJson(Map<String, dynamic> json) {

    return Sacraments(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      properties: json['properties'] ?? "",
    );
  }
}



class SacramentProperties {
  final List<FilterListModel> modelList;

  SacramentProperties(
      {required this.modelList,
  });

  factory SacramentProperties.empty() {
    return SacramentProperties(
      modelList : [],
    );
  }

  factory SacramentProperties.fromJson(Map<String, dynamic> jsonData) {
    var dataList = jsonData[dataKey];
    List<FilterListModel> mainList = [];
    var languageList = dataList[languageKey];
    var sacramentList = dataList[sacramentTypesKey];

    print("..$languageList....mainList properties..initial.......$jsonData.....",);
    List<FilterItemModel> commonList = []; 
    for(var data in languageList){
      commonList.add(FilterItemModel(filterTitle: data["name"], filterKey: data["id"].toString()));
    }
    print("..$commonList....mainList properties..after language.......${commonList.length}.....",);
    mainList.add(FilterListModel(filterOptions:commonList,title: languageTitle,filterKey: 'language',previousApplied: []));
    
    commonList = [];
    for(var data in sacramentList){
      commonList.add(FilterItemModel(filterTitle: data["name"], filterKey: data["id"].toString()));
    };
    mainList.add(FilterListModel(filterOptions:commonList,title: sacramentTypeTitle,filterKey: 'type',previousApplied: []));

    


    print("..${mainList.length}....mainList properties..final...$mainList.....",);
    return SacramentProperties(
      modelList : mainList,
    );
  }
}


class SacramentsOld {   
  final String objectID;  
  final String language;  
  final String collection;
  final String sacramentUrl;
  final String name;
  
  SacramentsOld({required this.objectID, required this.language, required this.collection, required this.sacramentUrl, required this.name});  
  
  factory SacramentsOld.fromJson(Map<String, dynamic> rowData) {  

    var sacramentUrl = rowData['Sacrament']["url"];
    return SacramentsOld(  
      objectID: rowData['objectId'],  
      name: rowData['Name'],  
      sacramentUrl: sacramentUrl,
      collection: rowData['Collection'],
      language: rowData['Language'],
    );  
  }  

  factory SacramentsOld.fromJsonSacrament(Map<String, dynamic> rowData) {  
    return SacramentsOld(  
      objectID: rowData['objectId'],  
      name: rowData['name'],  
      sacramentUrl: '',
      collection: rowData['code'],
      language: ''
    );  
  }

  factory SacramentsOld.fromJsonSacramentList(Map<String, dynamic> rowData) {  
    var sacramentUrl = rowData['Sacrament']["url"];
    return SacramentsOld(  
      objectID: rowData['objectId'],  
      name: rowData['Name'],  
      sacramentUrl: sacramentUrl, 
      collection: rowData['Collection'],
      language: rowData['Language']
    );  
  }
} 
