

import 'package:flutter/material.dart';

class User{
  final String objectID;
  final String pushObjectID;
  final String firstName;
  final String lastName;
  final String username;
  final String language;
  final String email;
  final bool isFirstTimeLoading;
  final bool isLogined, isPushEnabled;
  final String  phoneNumber, gender, prayer,parishObjectID,translation, calendar,maritalStatus,form, versifications , church ;


  const User({
    required this.objectID,
    required this.pushObjectID,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.language,
    required this.email,
    required this.isFirstTimeLoading,
    required this.isLogined,
    required this.isPushEnabled,
    required this.phoneNumber,
    required this.gender,
    required this.prayer,
    required this.parishObjectID,
    required this.translation,
    required this.calendar,
    required this.maritalStatus,
    required this.form,
    required this.versifications,
    required this.church,

  });

  static User? fromJson(dynamic json) {
    return json != null
        ?  User(
            objectID: json["objectID"] ?? "",
            pushObjectID: json["pushObjectID"] ?? "",
            firstName: json["firstName"] ?? "",
            lastName: json["lastName"] ?? "",
            username: json["username"] ?? "",
            language: json["language"] ?? "",
            email: json["email"] ?? "",
            isFirstTimeLoading : json["isFirstTimeLoading"],
            isLogined : json["isLogined"],
            isPushEnabled : json["isPushEnabled"],
            phoneNumber: json["phoneNumber"],
            gender: json["gender"],
            prayer: json["prayer"],
            parishObjectID: json["parishObjectID"],
            translation: json["translation"],
            calendar: json["calendar"],
            maritalStatus : json["maritalStatus"],
            form : json["form"],
            versifications : json["versifications"],
            church : json["church"],
            )
        : null;
  }

  dynamic toJson() {
    return {
      "objectID": objectID,
      "pushObjectID": pushObjectID,
      "firstName": firstName,
      "lastName": lastName,
      "username": username,
      "language": language,
      "email": email,
      "isFirstTimeLoading" : isFirstTimeLoading,
      "isLogined" : isLogined,
      "isPushEnabled" : isPushEnabled,
      "phoneNumber": phoneNumber,
      "gender": gender,
      "prayer": prayer,
            "parishObjectID": parishObjectID,
            "translation": translation,
            "calendar": calendar,
            "maritalStatus" : maritalStatus,
            "form" : form,
            "versifications" : versifications,
            "church" : church,
    };
  }

    factory User.fromUser(Map<String, dynamic> listContent) {
    return  User(
        objectID: listContent["objectId"] ?? "",
        pushObjectID: listContent["pushObjectID"] ?? "",
        email : listContent["username"] ?? "",
        username : listContent["username"] ?? "",
        firstName : listContent["firstName"] ?? "",
        lastName: listContent["lastName"] ?? "",
        phoneNumber: listContent["phoneNumber"] ?? "",
        isFirstTimeLoading : true,
        isLogined : true,
        isPushEnabled : listContent["isPushEnabled"]  ?? false,
        gender: listContent["gender"] ?? "",
        language : listContent["language"] ?? "",
        prayer: listContent["prayer"] ?? "",
        maritalStatus : listContent["maritalStatus"] ?? "",
        parishObjectID : listContent["parishObjectID"] ?? "",
        translation : listContent["translation"] ?? "",
        calendar: listContent["calendar"] ?? "",
        form: listContent["form"] ?? "",
        versifications: listContent["versification"] ?? "",
        church : listContent["church"] ?? "",
        );
  }
   
}

class UserModel {
  String objectId, email, firstName, lastName, phoneNumber, gender,language, prayer,parishObjectID,translation, calendar,maritalStatus,form, versifications , church ;

  UserModel(
      {
      required this.objectId,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.phoneNumber,
      required this.gender,
      required this.language,
      required this.prayer,
      required this.maritalStatus,
      required this.translation,
      required this.calendar,
      required this.form,
      required this.versifications,
      required this.church,
      required this.parishObjectID,
      });

  factory UserModel.fromUser(Map<String, dynamic> listContent) {
    return  UserModel(
        objectId: listContent["objectId"],
        email : listContent["username"],
        firstName : listContent["firstName"],
        lastName: listContent["lastName"],
        phoneNumber: listContent["phoneNumber"] ?? "",
        gender: listContent["gender"] ?? "",
        language : listContent["language"] ?? "",
        prayer: listContent["prayer"] ?? "",
        maritalStatus : listContent["maritalStatus"] ?? "",
        translation : listContent["translation"] ?? "",
        calendar: listContent["calendar"] ?? "",
        form: listContent["form"] ?? "",
        versifications: listContent["versification"] ?? "",
        church : listContent["church"] ?? "", 
        parishObjectID: listContent["parishObjectID"] ?? "",
        );
  }

  static UserModel? fromJson(dynamic listContent) {
    return listContent != null
        ?  UserModel(
            objectId: listContent["objectId"],
        email : listContent["username"],
        firstName : listContent["firstName"],
        lastName: listContent["lastName"],
        phoneNumber: listContent["phoneNumber"] ?? "",
        gender: listContent["gender"] ?? "",
        language : listContent["language"] ?? "",
        prayer: listContent["prayer"] ?? "",
        maritalStatus : listContent["maritalStatus"] ?? "",
        translation : listContent["translation"] ?? "",
        calendar: listContent["calendar"] ?? "",
        form: listContent["form"] ?? "",
        versifications: listContent["versification"] ?? "",
        church : listContent["church"] ?? "", 
        parishObjectID: listContent["parishObjectID"] ?? "",
            )
        : null;
  }

  dynamic toJson() {
    return {
      "pushObjectID": objectId,
      "firstName": firstName,
      "lastName": lastName,
      "language": language,
      "email": email,
      "phoneNumber": phoneNumber,
      "gender": gender,
      "prayer": prayer,
      "parishObjectID": parishObjectID,
      "translation": translation,
      "calendar": calendar,
      "maritalStatus" : maritalStatus,
      "form" : form,
      "versifications" : versifications,
      "church" : church,
    };
  }



}