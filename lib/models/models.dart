import 'package:flutter/material.dart';
import 'package:scheduler/bridges/constants.dart';

class Remainder {

  final String title;
  final String details;
  final String date;
  final String by;
  final String startTime,endTime;

  Remainder(this.title,this.details,this.by,this.date,this.startTime,this.endTime);

}

class FeedItem {
  final String title;
  final String by;
  final String poster;
  final String description;
  final String link;

  FeedItem(this.title,this.by,this.poster,this.description,this.link);
}

class Club {
  final String mailId;
  final String name;
  final String logo;
  final String description;

  Club(this.mailId,this.name,this.logo,this.description);
}