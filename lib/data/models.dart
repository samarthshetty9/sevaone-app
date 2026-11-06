import 'package:flutter/material.dart';

/// A bilingual string. All content that is shown to citizens is `L(en, kn)`.
class L {
  final String en;
  final String kn;
  const L(this.en, this.kn);
}

class Service {
  final String code;
  final L name;
  final L dept;
  final L category;
  final L desc;
  final int fee;
  final int sakalaDays;
  final List<String> docs; // DocType ids
  final bool isScheme;
  final L? benefit;
  final String source; // Service Plus | Sakala
  final IconData icon;
  final bool featured;

  /// Eligibility rule used by the recommender. Null = open to everyone.
  final bool Function(CitizenProfile p)? rule;
  final L? ruleText;

  const Service({
    required this.code,
    required this.name,
    required this.dept,
    required this.category,
    required this.desc,
    this.fee = 0,
    this.sakalaDays = 21,
    this.docs = const [],
    this.isScheme = false,
    this.benefit,
    this.source = 'Service Plus',
    this.icon = Icons.description_outlined,
    this.featured = false,
    this.rule,
    this.ruleText,
  });
}

class CitizenProfile {
  int age;
  String gender; // male | female | other
  int income; // annual, in rupees
  String occupation; // student | farmer | worker | business | homemaker | senior | unemployed
  String category; // general | obc | sc | st | minority
  bool disabled;
  bool bpl;
  bool completed;

  CitizenProfile({
    this.age = 34,
    this.gender = 'female',
    this.income = 180000,
    this.occupation = 'homemaker',
    this.category = 'obc',
    this.disabled = false,
    this.bpl = true,
    this.completed = false,
  });
}

class DocType {
  final String id;
  final L name;
  final L issuer;
  final IconData icon;
  final bool downloadable;
  final String number;
  const DocType(this.id, this.name, this.issuer, this.icon, this.number,
      {this.downloadable = true});
}

enum AppSource { servicePlus, sakala, token }

class TrackStage {
  final L title;
  final L? note;
  final DateTime? at;
  const TrackStage(this.title, {this.note, this.at});
}

class Application {
  final String id;
  final L service;
  final L dept;
  final AppSource source;
  final DateTime submitted;
  final int sakalaDays;
  final List<TrackStage> stages;
  int current; // index in stages
  bool feedbackGiven;

  Application({
    required this.id,
    required this.service,
    required this.dept,
    required this.source,
    required this.submitted,
    required this.sakalaDays,
    required this.stages,
    this.current = 0,
    this.feedbackGiven = false,
  });

  bool get done => current >= stages.length - 1;
  double get progress => (current + 1) / stages.length;
}

class Bill {
  final String id;
  final L provider;
  final String category; // electricity | water | gas | property
  final String consumerNo;
  final L label;
  int amount;
  final DateTime due;
  bool paid;
  DateTime? paidOn;
  String? receipt;

  Bill({
    required this.id,
    required this.provider,
    required this.category,
    required this.consumerNo,
    required this.label,
    required this.amount,
    required this.due,
    this.paid = false,
  });
}

class Centre {
  final String id;
  final String type; // GramaOne | Karnataka One
  final L name;
  final L address;
  final L district;
  final double km;
  final String hours;
  final int crowd; // 0 low, 1 moderate, 2 busy
  final Offset map; // normalised position on the stylised map
  final String phone;
  const Centre(this.id, this.type, this.name, this.address, this.district,
      this.km, this.hours, this.crowd, this.map, this.phone);
}

class AppNotification {
  final String id;
  final L title;
  final L body;
  final DateTime at;
  final String kind; // application | bill | scheme | weather | system
  final String? route;
  bool read;
  AppNotification(this.id, this.title, this.body, this.at, this.kind,
      {this.route, this.read = false});
}

class Grievance {
  final String id;
  final String department;
  final String subject;
  final String details;
  final DateTime at;
  int stage; // 0 registered, 1 assigned, 2 in progress, 3 resolved
  Grievance(this.id, this.department, this.subject, this.details, this.at,
      {this.stage = 0});
}

class FeedbackEntry {
  final String subject;
  final int stars;
  final List<String> tags;
  final String comment;
  final DateTime at;
  FeedbackEntry(this.subject, this.stars, this.tags, this.comment, this.at);
}

class ScannedDoc {
  final String id;
  final L title;
  final String sample; // ration | bill | income
  final String filter;
  final DateTime at;
  Map<String, String>? ocr;
  ScannedDoc(this.id, this.title, this.sample, this.filter, this.at);
}

class WeatherData {
  final String district;
  final int temp;
  final int feels;
  final int humidity;
  final int wind;
  final int rainChance;
  final int aqi;
  final int pm25;
  final int pm10;
  final int uv;
  final String condition; // sunny | cloudy | rain | storm
  final List<int> hourly;
  final List<(int, int, String)> daily;
  const WeatherData({
    required this.district,
    required this.temp,
    required this.feels,
    required this.humidity,
    required this.wind,
    required this.rainChance,
    required this.aqi,
    required this.pm25,
    required this.pm10,
    required this.uv,
    required this.condition,
    required this.hourly,
    required this.daily,
  });
}

class Txn {
  final L title;
  final int amount;
  final String ref;
  final DateTime at;
  Txn(this.title, this.amount, this.ref, this.at);
}

class FamilyMember {
  final String name;
  final String relation;
  FamilyMember(this.name, this.relation);
}
