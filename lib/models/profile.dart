import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  String profileUrl;
  String uid;
  String fullName;
  String title;
  String bio;
  String contactNumber;
  List projects;
  int projectsCount;
  List connections;
  int connectionsCount;

  Profile(
      {this.uid,
      this.fullName,
      this.bio,
      this.contactNumber,
      this.projects,
      this.connections});
  Map getProfileMap() {
    return {
      "uid": this.uid,
      "profileUrl": this.profileUrl,
      "fullName": this.fullName,
      "title": this.title,
      "bio": this.bio,
      "contactNumber": this.contactNumber,
      "projects": this.projects,
      "projectsCount": this.projectsCount,
      "connections": this.connectionsCount,
      "connectionsCount": this.connectionsCount
    };
  }
}
