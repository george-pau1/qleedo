import 'package:amazon_like_filter/props/filter_item_model.dart';
import 'package:amazon_like_filter/props/filter_list_model.dart';
import 'package:qleedo/index.dart';

class PrayerToday {
  final int id;
  final String name;
  final String hour;
  final String day; 
  final String properties;

  PrayerToday(
      {required this.id,
      required this.name,
      required this.hour,
      required this.day,
      required this.properties,
});

  factory PrayerToday.fromJson(Map<String, dynamic> json) {

    return PrayerToday(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      hour: json['hour'] ?? "",
      day: json['day'] ?? "",
      properties: json['properties'] ?? "",
    );
  }
}

class Prayers {
  final int id;
  final String name;
  final String properties;

  Prayers(
      {required this.id,
      required this.name,
      required this.properties,
});

  factory Prayers.fromJson(Map<String, dynamic> json) {

    return Prayers(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      properties: json['properties'] ?? "",
    );
  }
}

class Property {
  final int id;
  final String name;

  Property(
      {required this.id,
      required this.name,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'] ?? 0,
      name: json['Name'] ?? "",
    );
  }
}

class PrayerProperties {
  final List<FilterListModel> modelList;

  PrayerProperties(
      {required this.modelList,
  });

  factory PrayerProperties.empty() {
    return PrayerProperties(
      modelList : [],
    );
  }

  factory PrayerProperties.fromJson(Map<String, dynamic> jsonData) {
    var dataList = jsonData[dataKey];
    List<FilterListModel> mainList = [];
    var languageList = dataList[languageKey];
    var collectionList = dataList[collectionKey];
    var translationList = dataList[translationsKey];
    var hoursList = dataList[hoursKey];
    var daysList = dataList[daysKey];
    print("..$languageList....mainList properties..initial.......$jsonData.....",);
    List<FilterItemModel> commonList = []; 
    for(var data in languageList){
      commonList.add(FilterItemModel(filterTitle: data["name"], filterKey: data["id"].toString()));
    }
    print("..$commonList....mainList properties..after language.......${commonList.length}.....",);
    mainList.add(FilterListModel(filterOptions:commonList,title: languageTitle,filterKey: 'language',previousApplied: []));
    
    commonList = [];
    for(var data in collectionList){
      commonList.add(FilterItemModel(filterTitle: data["name"], filterKey: data["id"].toString()));
    };
    mainList.add(FilterListModel(filterOptions:commonList,title: collectionTitle,filterKey: 'collection',previousApplied: []));

    commonList = [];
    for(var data in translationList){
      commonList.add(FilterItemModel(filterTitle: data["name"], filterKey: data["id"].toString()));
    }
    mainList.add(FilterListModel(filterOptions:commonList,title: translationTitle,filterKey: 'translation',previousApplied: []));


    commonList = [];
    for(var data in daysList){
      commonList.add(FilterItemModel(filterTitle: data["name"], filterKey: data["id"].toString()));
    }
    mainList.add(FilterListModel(filterOptions:commonList,title: daysTitle,filterKey: 'days',previousApplied: []));

    commonList = [];
    for(var data in hoursList){
      commonList.add(FilterItemModel(filterTitle: data["name"], filterKey: data["id"].toString()));
    }
    mainList.add(FilterListModel(filterOptions:commonList,title: hoursTitle,filterKey: 'hours',previousApplied: []));


    print("..${mainList.length}....mainList properties..final...$mainList.....",);
    return PrayerProperties(
      modelList : mainList,
    );
  }
}



/*class PrayerProperties {
  final List<dynamic> properties;
  final List<Property> language;
  final List<Property> translation;
  final List<Property> collection;

  PrayerProperties(
      {required this.properties,
      required this.language, required this.translation,required this.collection,
  });

  factory PrayerProperties.fromJson(Map<String, dynamic> jsonData) {
    var dataList = jsonData[dataKey];
    var languageList = dataList[languageKey];
    var collectionList = dataList[collectionKey];
    var translationList = dataList[translationsKey];
    var langlist = (languageList as List).map((data) => Property.fromJson(data)).toList();
    var traslist = (translationList as List).map((data) => Property.fromJson(data)).toList();
    var collList = (collectionList as List).map((data) => Property.fromJson(data)).toList();
    var propertiesList  = [];
    if(langlist.isNotEmpty){
      propertiesList.add(languageKey);
    }

    if(traslist.isNotEmpty){
      propertiesList.add(translationsKey);
    }

    if(collectionList.isNotEmpty){
      propertiesList.add(collectionKey);
    }

    return PrayerProperties(
      properties : propertiesList,
      language: langlist,
      translation : traslist,
      collection : collList
    );
  }
}*/

class Audio{
  final int id;
  final String  url; 

  Audio(
      {required this.id,
      required this.url,});

  factory Audio.fromJson(Map<String, dynamic> json) {
    var mediaUrl = json["media_url"] ?? "";
    if(mediaUrl != ""){
      mediaUrl = qleedoMediaPath + mediaUrl;
    }
    return Audio(
      id: json["id"], 
      url: mediaUrl
      );
  }

}


class PrayerDetails {
  final int id;
  final String name;
  final String htmlUrl;
  final List<Audio> audio;

  PrayerDetails(
      {required this.id,
      required this.name,
      required this.htmlUrl,
      required this.audio
  });

  factory PrayerDetails.empty() {
    return PrayerDetails(id: 0, name: "", htmlUrl: "", audio: []);
  }

  factory PrayerDetails.fromJson(Map<String, dynamic> json) {
    print("..$json..PrayerDeta....first.");
    var audiodata = json["prayer_audios"];
    var audioList = (audiodata as List).map((data) => Audio.fromJson(data)).toList();
    var htmlUrl = json['content_path'];
    if(htmlUrl != ""){
      htmlUrl = "$qleedoMediaPath$htmlUrl";
    }
    print("..$json..PrayerDeta.....$audiodata....ils......$htmlUrl..");
    return PrayerDetails(
      id: json['id'],
      name: json['prayer']['name'],
      htmlUrl: htmlUrl,
      audio: audioList,
    );
  }


}





class Prayer {
  final String objectID;
  final String name;
  final String prayerUrl;
  final String season;
  final String form;
  final String language;

  Prayer(
      {required this.objectID,
      required this.name,
      required this.prayerUrl,
      required this.season,
      required this.form,
      required this.language});

  factory Prayer.fromJsonHomePage(Map<String, dynamic> json) {
    var dataJSOn = json['result'];
    var rowData = dataJSOn[0];

    return Prayer(
      objectID: rowData['objectId'],
      name: rowData['Name'],
      prayerUrl: rowData['Prayer']['url'],
      season: '',
      form: '',
      language: ''
    );
  }

  factory Prayer.fromJson(Map<String, dynamic> json) {
    var prayerUrl = json['Prayer']["url"];

    return Prayer(
      objectID: json['objectId'],
      name: json['Name'],
      prayerUrl: prayerUrl,
      season: json['Season'] ?? "",
      form: json['Form'],
      language: json['Language'],
    );
  }
}

class SuitableDays {
  final String dayID;
  final String name;
  final String code;

  SuitableDays({required this.dayID, required this.name, required this.code});

  factory SuitableDays.fromJsonHomePage(Map<String, dynamic> json) {
    var dataJSOn = json['result'];
    var rowData = dataJSOn[0];

    return SuitableDays(
      dayID: rowData['objectId'],
      name: rowData['Name'],
      code: rowData['Prayer']['url'],
    );
  }
}

/*Condition we need to add for prayer label 

Suitable 

Season

Translation

Versions*/

class PrayerSet {
  final String objectID;
  final int timeIn24hr;
  final String prayersetCode;
  final String code;
  final String name;

  PrayerSet(
      {required this.objectID,
      required this.timeIn24hr,
      required this.prayersetCode,
      required this.code,
      required this.name});

  factory PrayerSet.fromJson(Map<String, dynamic> rowData) {
    return PrayerSet(
      objectID: rowData['objectId'],
      name: rowData['name'],
      prayersetCode: rowData['prayersetCode'],
      timeIn24hr: rowData['timeIn24hr'],
      code: rowData['code'],
    );
  }
}

class PrayerCollection {
  final String objectID;
  final String groupID;
  final String collectionID;
  final String code;
  final String name;

  PrayerCollection(
      {required this.objectID, required this.groupID, required this.collectionID, required this.code, required this.name});

  factory PrayerCollection.fromJson(Map<String, dynamic> rowData) {
    return PrayerCollection(
      objectID: rowData['objectId'],
      name: rowData['name'],
      groupID: rowData['grpId'],
      collectionID: rowData['prayerCollectionId'],
      code: rowData['code'],
    );
  }
}
