class Reminder {

  final String title;
  final String subtitle;
  final String details;
  final String date;
  final String by;
  final String startTime,endTime;

  Reminder(this.title,this.subtitle,this.details,this.by,this.date,this.startTime,this.endTime);

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
  final String uid;
  final String mailId;
  final String username;
  final String logo;
  final String description;

  Club(this.uid,this.mailId,this.username,this.logo,this.description);
}