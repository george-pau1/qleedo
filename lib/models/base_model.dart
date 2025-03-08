
class BaseModel {
  final String message;
  final bool status;
  final List<dynamic> data;
  final int count;
  final String previousPage,nextPage;

  BaseModel(
      {
      required this.message,
      required this.status,
      required this.data,
      required this.count,
      required this.previousPage,
      required this.nextPage
      });

  factory BaseModel.initialise() {
    return BaseModel(message: '', status: false,data: [], count: 0, nextPage: "", previousPage: '');
  }

}

class BaseModelObject {
   String message;
   bool status;
   int code;
   final dynamic data;
   int count;
   final String previousPage,nextPage;

  BaseModelObject(
      {
      this.message="",
      this.status =false,
      this.code=0,
      required this.data,
      required this.previousPage,
      required this.nextPage,
      required this.count
      });

        factory BaseModelObject.initialise() {
    return BaseModelObject(message: '', status: false,code : 0,data: {},previousPage: '', nextPage: '',count:0);
  }
}

