import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:home_automation_app/screens/fav.dart';

class fulldataofrooms {
  static var roomidmap = Map();
  static var boardid = Map();
  static var id = Map();
  static var roomidarray = [], boardidarray = [], array = Map();
  static int index;
  static var switches = Map();
  static var boardindex;
  static List<String> favroomsarray = [];
  static var favouriteroomscontents = Map();
  Future<void> fetchrooms() async {
    final dbref = FirebaseDatabase.instance.reference().child('Users');

    User user = FirebaseAuth.instance.currentUser;

    String name, type;
    try {
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
    } catch (ex) {
      print("no rooms maindata");
    }
  }

  Future<void> fetchboards() async {
    final dbref = FirebaseDatabase.instance.reference().child('Users');
    User user = FirebaseAuth.instance.currentUser;
    boardid.clear();
    boardidarray.clear();
    await dbref
        .child(user.uid)
        .child("rooms")
        .child(fulldataofrooms.roomidarray[fulldataofrooms.index])
        .child("circuit")
        .once()
        .then((snap) {
      Map id = snap.value;
      try {
        for (final i in id.keys) {
          boardid.addAll({i: id[i]});
          boardidarray.add(i);
        }
      } catch (ex) {
        print("Exception in board maindata");
      }
    });
  }

  Future<void> fetchfavourites() async {
    favroomsarray.clear();
    favroomsarray.add("Select");
    favouriteroomscontents.clear();
    final dbref = FirebaseDatabase.instance.reference().child('Users');
    User user = FirebaseAuth.instance.currentUser;

    await dbref.child(user.uid).child("favourites").once().then((snap) {
      Map id = snap.value;
      try {
        for (final i in id.keys) {
          print("fetchfavourites");
          print(i);
          favroomsarray.add(i);
          favouriteroomscontents.addAll(id[i]);
          print(id[i]);
        }
      } catch (ex) {
        print("Exception in fav maindata");
      }
    });
  }

  Future<void> displayfav() async {
    for (int i = 1; i < favroomsarray.length; i++) {}
  }
}
