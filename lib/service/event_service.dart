// ignore_for_file: avoid_print


import 'package:qleedo/models/Media.dart';
import 'package:qleedo/models/base_model.dart';
import 'package:qleedo/service/webservices_call.dart';
import 'package:qleedo/index.dart';


class EventService {
  WebService service = WebService();

  Future<BaseModel> getEventList() async {
    var urlParameters = eventList;
    Map<String, String> headers = {"accept": "application/json"};
    BaseModel dataModel ;
    final response = await service.getResponse(eventList, headers);
    //print(".......getState.......$urlParameters... response.....first...${response.statusCode}....");
    Map<String, dynamic> jsonData = response; //json.decode(response.body);
    print("..$urlParameters.....getState response.....$jsonData....");
    var status = jsonData[statusKey];
    if(status == 200){
        var data = jsonData[dataKey];
        var previousLocal =data[previousKey];
        var nextLocal = data[nextKey];
        var count = data[countKey] ?? 0;
        var previousPage = previousLocal != null ? previousLocal.replace(qleedoAPIUrl+eventList,'') : '';
        var nextPage = nextLocal != null ? nextLocal.replace(qleedoAPIUrl+eventList,'') : '';
        var festList = data[reslutsKey];
        var list = (festList as List).map((data) => Medias.fromJsonAPI(data)).toList();
        //print("..$stateData.....getState response.....${stateList.length}....");
        dataModel =  BaseModel(message: jsonData[messageKey], status: true, data: list, previousPage: previousPage,nextPage: nextPage,count: count);
    }else{
        dataModel =  BaseModel(message: jsonData[messageKey], status: false, data: [], previousPage: '', nextPage: '',count: 0);
    }
    return dataModel;
  }

   Future<BaseModel> getMediaListByName(String festivalName) async {
    var urlParameters = '$mediaApi$mediaByFest$festivalName';
    Map<String, String> headers = {"Content-Type": "application/json"};
    BaseModel dataModel ;
    final response = await service.getResponse(urlParameters, headers);
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
        var mediaList = data[reslutsKey];
        var list = (mediaList as List).map((data) => MediasDetails.fromJsonAPI(data)).toList();
        //print("..$stateData.....getState response.....${stateList.length}....");
        dataModel =  BaseModel(message: jsonData[messageKey], status: true, data: list,count: count, previousPage: previousPage, nextPage: nextPage);
    }else{
        dataModel =  BaseModel(message: jsonData[messageKey], status: false, data: [], count: 0, previousPage: '', nextPage: '');
    }
    return dataModel;
  }



  

}
