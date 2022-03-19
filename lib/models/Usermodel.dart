class myUser{
  int ? type;
  String ? uid;
  String ? email;
  String ? mobile;
  String ? school;
  String ? subject;
  String ? firstname;
  String ? lastname;
  List ? classes;

  myUser({
    this.firstname,
    this.lastname,
    this.type,
    this.email,
    this.classes,
    this.school,
    this.mobile,
    this.subject,
    this.uid
});

  MAPTOUSER(Map map){
    email=map['email'];
    mobile=map['mobile'];
    school=map['school'];
    subject=map['subject'];
    type=map['type'];
    firstname=map['firstname'];
    lastname=map['lastname'];
    classes=map['classes'];
    uid=map[uid];
  }
}