// ignore_for_file: unused_field, prefer_final_fields, unnecessary_this, prefer_collection_literals, unnecessary_null_comparison, unused_import

import 'package:flutter/scheduler.dart';

class Note {
  int id;
  String title;
  String description;
  String date;
  int priority;

  Note(this.title, this.date, this.priority, this.description) : id = -1;
  Note.withId(this.id, this.title, this.date, this.priority, this.description);

  /*int get id => _id;
  String get title => title;
  String get description => _description;
  int get priority => priority;
  String get date => date;*/

  /*set title(String newTitle) {
    if (newTitle.length < 255) {
      this.title = newTitle;
    }
  }

  set descriotion(String newDescription) {
    if (newDescription.length < 255) {
      this.description = newDescription;
    }
  }

  set priority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 2) {
      this.priority = newPriority;
    }
  }

  set date(String newDate) {
    if (newDate.length < 255) {
      this.date = newDate;
    }
  }*/

  //convert note object into map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['title'] = title;
    map['description'] = description;
    map['priority'] = priority;
    map['date'] = date;

    return map;
  }

  //extract a note object from a map object

  factory Note.fromMapObject(Map<String, dynamic> map) {
    return Note.withId(map['id'], map['title'], map['date'], map['priority'],
        map['description']);
  }
}
