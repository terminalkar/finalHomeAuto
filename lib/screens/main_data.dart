import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class fulldataofrooms {
  static var roomidmap = Map();
  static var boardid = Map();
  static var id = Map();
  static var roomidarray = [], boardidarray = [], array = Map();
  static int noofrooms, index, noofboards;
  Future<void> fetchrooms() async {
    final dbref = FirebaseDatabase.instance.reference().child('Users');

    User user = FirebaseAuth.instance.currentUser;
    dbref.child(user.uid).child("info").once().then((snap) {
      Map map = snap.value;

      noofrooms = map["noofrooms"];
      noofboards = map["noofboards"];
    });
    String name, type;
    await dbref.child(user.uid).child("rooms").once().then((snap) {
      roomidarray.clear();
      roomidmap.clear();

      Map room;
      try {
        room = snap.value;
        for (final i in room.keys) {
          Map roomdata = room[i];
          name = roomdata["name"];
          type = roomdata["type"];
          roomidmap.addAll({
            i: {"name": name, "type": type}
          });
          roomidarray.add(i);
        }
      } catch (ex) {
        print("caught");
      }

      //fetching circuit board
      id.clear();
      array.clear();
      try {
        for (final i in room.keys) {
          Map board = room[i]["circuit"];
          var map = new Map();
          var name = [];
          for (final k in board.keys) {
            map.addAll({k: board[k]});
            name.add(k);
          }
          id.addAll({i: map});
          array.addAll({i: name});
        }
      } catch (ex) {
        print("maindata boardid");
      }
    });
    // print(roomidmap);
  }
}
