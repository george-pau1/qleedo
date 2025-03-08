// ignore_for_file: avoid_print


import 'package:qleedo/models/base_model.dart';
import 'package:qleedo/models/saints.dart';
import 'package:qleedo/service/webservices_call.dart';
import 'package:qleedo/index.dart';


class SaintsService {
  WebService service = WebService();

  Future<BaseModel> getSaintsList(params) async {
    var urlParams = saintsApi+params;
    Map<String, String> headers = {"accept": "application/json"};
    BaseModel dataModel ;
    final response = await service.getResponse(urlParams, headers);
    //print(".......getState.......$urlParams... response.....first...${response.statusCode}....");
    Map<String, dynamic> jsonData = response; //json.decode(response.body);
    var status = jsonData[statusKey];
    print("..$saintsApi.....getState response....$status....$jsonData....");
    if(status == 200){
        var data = jsonData[dataKey];
        var previousLocal = data[previousKey] ?? "";
        var nextLocal = data[nextKey] ?? "";
        var count = data[countKey] ?? 0;
        print("..$previousLocal....inner paining...6666...$nextLocal......");
        var previousPage = previousLocal != "" ? previousLocal.replaceAll(qleedoAPIUrl+saintsApi,'') : '';
        var nextPage = nextLocal != "" ? nextLocal.replaceAll(qleedoAPIUrl+saintsApi,'') : '';
        var saintsLists = data[reslutsKey] as List;
        print("..$nextPage....ouutter paining.----${saintsLists.length}----.66667868...$saintsLists...$previousPage.......");
        var listData = saintsLists.map((data) => Saints.fromJson(data)).toList();
        print("..$listData.....getState response..44..666....${listData.length}....");
        dataModel =  BaseModel(message: jsonData[messageKey], status: true, data: listData, count: count, previousPage: previousPage, nextPage: nextPage);
    }else{
        dataModel =  BaseModel(message: jsonData[messageKey], status: false, data: [], count: 0, previousPage: '', nextPage: '');
    }
    return dataModel;
  }




  

}
