// ignore_for_file: avoid_print


import 'package:qleedo/models/Media.dart';
import 'package:qleedo/models/base_model.dart';
import 'package:qleedo/service/webservices_call.dart';
import 'package:qleedo/index.dart';


class MediaService {
  WebService service = WebService();

  Future<BaseModel> getFestivalList() async {
    var urlParameters = mediaFestivalUrl;
    Map<String, String> headers = {"accept": "application/json"};
    BaseModel dataModel ;
    final response = await service.getResponse(urlParameters, headers);
    //print(".......getState.......$urlParameters... response.....first...${response.statusCode}....");
    Map<String, dynamic> jsonData = response; //json.decode(response.body);
    print("..$urlParameters.....getState response.....$jsonData....");
    var status = jsonData[statusKey];
    if(status == 200){
        var data = jsonData[dataKey];
        var previousLocal =data[previousKey];
        var nextLocal = data[nextKey];
        var count = data[countKey] ?? 0;
        var previousPage = previousLocal != null ? previousLocal.replace(qleedoAPIUrl+urlParameters,'') : '';
        var nextPage = nextLocal != null ? nextLocal.replace(qleedoAPIUrl+urlParameters,'') : '';

        var festList = data[dataKey];
        var list = (festList as List).map((data) => Medias.fromJsonAPI(data)).toList();
        //print("..$stateData.....getState response.....${stateList.length}....");
        dataModel =  BaseModel(message: jsonData[messageKey], status: true, data: list, count: count, previousPage: previousPage, nextPage: nextPage);
    }else{
        dataModel =  BaseModel(message: jsonData[messageKey], status: false, data: [],count: 0, previousPage: '', nextPage: '');
    }
    return dataModel;
  }

   Future<BaseModel> getMediaListByName(String typeID, String typeName) async {
    var urlParameters = '$mediaResourceUrl?id=$typeID&type=$typeName';
    print(".........media details url....$urlParameters..");
    Map<String, String> headers = {"Content-Type": "application/json"};
    BaseModel dataModel ;
    final response = await service.getResponse(urlParameters, headers);
    Map<String, dynamic> jsonData = response; //json.decode(response.body);
    print("..$urlParameters.....getState response.....$jsonData....");
    //var status = jsonData[statusKey];
    var mediaList = jsonData[reslutsKey];
    if(mediaList != null){
        /*var previousLocal =data[previousKey];
        var nextLocal = data[nextKey];
        var count = data[countKey] ?? 0;
        var previousPage = previousLocal != null ? previousLocal.replace(qleedoAPIUrl+urlParameters,'') : '';
        var nextPage = nextLocal != null ? nextLocal.replace(qleedoAPIUrl+urlParameters,'') : '';
        var mediaList = data[reslutsKey];
        var list = (mediaList as List).map((data) => MediasDetails.fromJsonAPI(data)).toList();*/
        //print("..$stateData.....getState response.....${stateList.length}....");
        var list = (mediaList as List).map((data) => MediasDetails.fromJsonAPI(data)).toList();
        dataModel =  BaseModel(message: "Success", status: true, data: list,count: 0, previousPage: '', nextPage: '');
    }else{
        dataModel =  BaseModel(message: "Failed", status: false, data: [], count: 0, previousPage: '', nextPage: '');
    }
    return dataModel;
  }

  Future<BaseModelObject> getMediaCategory() async {
    Map<String, String> headers = {"accept": "application/json"};
    BaseModelObject dataModel ;
    final response = await service.getResponse(groupedMediaList, headers);
   //print(".......getState.......$groupedMediaList... response.....first...${response.statusCode}....");
    Map<String, dynamic> jsonData = response; //json.decode(response.body);
    print("......getState response.....$jsonData....");
    var status = jsonData[statusKey];
    if(status == 200){
        var data = jsonData[dataKey];
        dataModel =  BaseModelObject(message: jsonData[messageKey], status: true, data: data, count: 0, previousPage: '', nextPage: '');
    }else{
        dataModel =  BaseModelObject(message: jsonData[messageKey], status: false, data: {}, count: 0, previousPage: '', nextPage: '');
    }
    return dataModel;
  }

  

}
