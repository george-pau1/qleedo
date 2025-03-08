import 'package:intl/intl.dart';
import 'package:qleedo/index.dart';
import 'package:qleedo/models/Media.dart';

final inputFormat1 = DateFormat("yyyy-MM-dd");

class Events {   
  final Map<String ,EventItem > dates;  
  Events({required this.dates, });  

  factory Events.fromJson(Map<String, dynamic> rowData) {  
    List dateKeys = rowData.keys.toList();
    String dateKey = dateKeys[0];
    EventItem item = EventItem.fromJson(rowData[dateKey]);
    return Events(  
      dates: {dateKey : item},  
    ); 
  }

}



class EventItem {   
  final String id;  
  final String name;
  
  EventItem({required this.id,required this.name,});  

  factory EventItem.fromJson(Map<String, dynamic> rowData) {  
      return EventItem(
        id: rowData[""] ?? "",
        name: rowData[""] ?? "");
  }

}


class EventDetails {   
  final int id;  
  final String name;
  final int festivalId;  
  final String festivalName;
  final String description;
  final String fromDate;
  final String toDate;
  final String occurancePlace;
  final String lattitude;
  final String longittude;
  final List<String> tabList;
  final Map<String, dynamic> mediaDict;


  
  EventDetails( {required this.id,required this.name, required this.festivalId, required this.festivalName, 
  required this.description, required this.fromDate, required this.toDate, required this.occurancePlace, required this.lattitude, 
  required this.longittude,required this.tabList,  required this.mediaDict
  });  

  factory EventDetails.fromJson(Map<String, dynamic> rowData) { 
      DateTime fromdateEvt = DateTime.parse(rowData['from_date']);
      DateTime todateEvt = DateTime.parse(rowData['to_date']);
      Map<String, dynamic> resourcelist = rowData["event_resources"];
      Map<String, dynamic> mediaDict = {};
      var listTab =  resourcelist.keys.map((e) => e).toList();
      var imagesList = resourcelist["images"] ?? [];
      var youtubeList = resourcelist["youtube"] ?? [];
      var videoList = resourcelist["videos"] ?? [] ;
      // var imageList =  (imagesList as List).map((e) => MediaItem.fromJson(e)).toList();
      // var youtubesList =  (youtubeList as List).map((e) => MediaItem.fromJson(e)).toList();
      // var videosList =  (videoList as List).map((e) => MediaItem.fromJson(e)).toList();
      // mediaDict["images"] = imageList;
      // mediaDict["youtube"] = youtubesList;
      // mediaDict["videos"] = videosList;
      

      return EventDetails(
        id: rowData["id"] ?? 0,
        name: rowData["event_name"] ?? "",
        festivalId: rowData["festival_id"] ?? 0,
        festivalName: rowData[""] ?? "",
        description: rowData["event_description"] ?? "",
        fromDate: inputFormat1.format(fromdateEvt),
        toDate: inputFormat1.format(todateEvt),
        occurancePlace: rowData["event_occur_place"] ?? "",
        lattitude: rowData["event_latitude"] ?? "",
        longittude: rowData["event_longitude"] ?? "",
        tabList: listTab,
        mediaDict: mediaDict
        );
  }

  factory EventDetails.initialise() {  
      return EventDetails(
        id:  -1,
        name: "",
        festivalId:  -1,
        festivalName:"",
        description: "",
        fromDate: "",
        toDate: "",
        occurancePlace: "",
        lattitude:  "",
        longittude:  "",
        tabList: [],
        mediaDict: {},
        );
  }

}


