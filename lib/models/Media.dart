import 'package:amazon_like_filter/props/filter_item_model.dart';
import 'package:amazon_like_filter/props/filter_list_model.dart';
import 'package:qleedo/index.dart';
//import 'package:video_player/video_player.dart';


class Medias {   
  final String objectID;  
  final String code;  
  final String name;
  
  Medias({required this.objectID, required this.code, required this.name});  
  
  factory Medias.fromJson(Map<String, dynamic> rowData) {  

    return Medias(  
      objectID: rowData['objectId'],  
      name: rowData['name'],  
      code: rowData['code'],
    );  
  }


  factory Medias.fromJsonAPI(Map<String, dynamic> rowData) {  
    return Medias(  
      objectID: rowData['id'].toString(),  
      name: rowData['festival'],  
      code: rowData['festival'],
    );  
  }  

  factory Medias.init() {  
    return Medias(  
      objectID: '',  
      name: '',  
      code: '',
    );  
  }
} 

class Media{   
  final int id;  
  final String parentName;  
  final String name;
  final String url;
  
  Media({required this.id, required this.name, required this.url , required this.parentName});  
  
  factory Media.fromJson(Map<String, dynamic> rowData) {  

    var parentData = rowData["prayer"] != null ? rowData["prayer_name"] : rowData["festival"] != null ? rowData["festival_name"] :
                     rowData["sacrament"] != null ? rowData["sacrament_name"] : "";
    var media =  rowData["media"] as List;
    var urlPath = "";
    if(media.isNotEmpty){
      urlPath = "";
      if(media[0]['media_type'] == 5){
        var videoId = media[0]["youtube_url"];
        urlPath = "https://img.youtube.com/vi/$videoId/0.jpg";
      }else{
        urlPath = "$qleedoMediaPath${media[0]['media_url']}";

      }
      
    }                

    return Media(  
      id: rowData['id'] ?? -1,  
      name: rowData['name'] ?? "",  
      parentName: parentData,
      url: urlPath,
    );  
  }

  factory Media.init() {  
    return Media(  
      id: -1,  
      name: '',  
      parentName: '',
      url: ""
    );  
  }
} 


class MediasDetails {   
  final String objectID;  
  final String docName;  
  final String name;
  final String url;
  final String docType;
  final String prayerID;
  final String imageUrl;
   bool isPlaying;
  
  MediasDetails({required this.objectID, required this.docName, required this.name, required this.url, required this.docType, required this.prayerID, required this.imageUrl, required this.isPlaying});  
  
  factory MediasDetails.fromJson(Map<String, dynamic> rowData) {  
    var urlpath = rowData['url'];
    var videoID = rowData['youtubeID'];
    var imageUrl = "https://img.youtube.com/vi/$videoID/0.jpg";
    return MediasDetails(  
      objectID: rowData['objectId'],  
      docName: rowData['docName'] ?? "",  
      name: rowData['name'],
      url: urlpath,
      docType: rowData['docType'],
      prayerID : videoID,
      imageUrl: imageUrl,
      isPlaying :  false
    );  
  }

  factory MediasDetails.fromJsonAPI(Map<String, dynamic> rowData) {  

    var audioPath = rowData['media_url'];
    var youtubeUrl = rowData['youtube_url'];

    var type = rowData['media_type'];
    var imageUrl = "";
    if(type == 5){
        imageUrl = youtubeUrl;
    }else{
        imageUrl = "$qleedoMediaPath$audioPath";
    }
    return MediasDetails(  
      objectID: rowData['media_id'].toString(),  
      docName: "",  
      name: "",
      url: imageUrl,
      docType: type.toString(),
      prayerID : "",
      imageUrl: "",
      isPlaying :  false
    );  
  }    
} 

class MediasResource {   
  final int id;  
  final String url;
  
  MediasResource({required this.id, required this.url,});  
  
  factory MediasResource.fromJson(Map<String, dynamic> rowData) {  

    return MediasResource(  
      id: rowData['media_id'],  
      url: rowData['media_url'],  
    );  
  }


} 


class MediaItem {   
//  final String id;  
 // final String url; 
 // late VideoPlayerController controller;
  
 // MediaItem({required this.id, required this.url,required this.controller});  
  
  // factory MediaItem.fromJson(Map<String, dynamic> rowData) {  

  //   var mediaType = rowData["media_type"];
  //   var mediaPath = "";
  //   if(mediaType == 5){
  //     var  youtubeID= rowData['youtube_url'] ?? "";
  //     mediaPath = youtubeID;
  //   }else{
  //     mediaPath = rowData['media_url'] ?? "";
  //     if(mediaPath != ""){
  //       mediaPath = qleedoMediaPath + mediaPath;
  //     }
  //   }

    
  //   print("...MediaItem......$rowData..");

  //   // return MediaItem(  
  //   //   id: rowData['id'].toString(),  
  //   //   url: mediaPath,
  //   //   controller : VideoPlayerController.networkUrl(Uri.parse(mediaPath))..initialize()
  //   // );  
  // }

 
  // factory MediaItem.init() {  
  //   return MediaItem(  
  //     id: '',  
  //     url: '',
  //     controller : VideoPlayerController.asset("")
  //   );  
  // }
}

class MediaDetails {   
  final int id;  
  final String name;
  final List<String> tabList;
  final Map<String, dynamic> mediaDict;


  
  MediaDetails( {required this.id,required this.name, required this.tabList,  required this.mediaDict
  });  

  factory MediaDetails.fromJson(Map<String, dynamic> rowData) { 
      Map<String, dynamic> resourcelist = rowData["media"];
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
      

      return MediaDetails(
        id: rowData["id"] ?? 0,
        name: rowData["event_name"] ?? "",
        tabList: listTab,
        mediaDict: mediaDict
        );
  }

  factory MediaDetails.initialise() {  
      return MediaDetails(
        id:  -1,
        name: "",
        tabList: [],
        mediaDict: {},
        );
  }

}

class MediaProperties {
  final List<FilterListModel> modelList;

  MediaProperties(
      {required this.modelList,
  });

  factory MediaProperties.empty() {
    return MediaProperties(
      modelList : [],
    );
  }

  factory MediaProperties.fromJson(Map<String, dynamic> jsonData) {
    var dataList = jsonData[dataKey];
    List<FilterListModel> mainList = [];
    var prayerList = dataList[prayerKey];
    var festivalList = dataList[festivalKey];
    var sacramentList = dataList[sacramentKey];

    print("..$prayerList....mainList properties..initial.......$jsonData.....",);
    List<FilterItemModel> commonList = []; 
    for(var data in prayerList){
      commonList.add(FilterItemModel(filterTitle: data["name"], filterKey: data["id"].toString()));
    }
    print("..$commonList....mainList properties..after language.......${commonList.length}.....",);
    mainList.add(FilterListModel(filterOptions:commonList,title: prayerTitle,filterKey: 'prayer',previousApplied: []));
    

    commonList = [];
    for(var data in sacramentList){
      commonList.add(FilterItemModel(filterTitle: data["name"], filterKey: data["id"].toString()));
    }
    mainList.add(FilterListModel(filterOptions:commonList,title: sacramentTitle,filterKey: 'sacrament',previousApplied: []));

    commonList = [];
    for(var data in festivalList){
      commonList.add(FilterItemModel(filterTitle: data["name"], filterKey: data["id"].toString()));
    };
    mainList.add(FilterListModel(filterOptions:commonList,title: festivalTitle,filterKey: 'festival',previousApplied: []));


    print("..${mainList.length}....mainList properties..final...$mainList.....",);
    return MediaProperties(
      modelList : mainList,
    );
  }
}




