import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:home_automation_app/screens/fav.dart';
import 'package:number_to_words/number_to_words.dart';
//import 'package:numbers_to_words/numbers_to_words.dart';

class fulldataofrooms {
  static var indexlistmap = Map();
  static var roomidmap = Map();
  static var boardid = Map();
  static var id = Map();
  static var roomidarray = [], boardidarray = [], array = Map();
  static int index;
  static bool fetched = true;
  static var switches = Map();
  static var boardindex, indexlist = [];
  static List<String> favroomsarray = [];
  static var favouriteroomscontents = Map();
  static var favouritecontentnamesmap = Map();
  static var path = Map();
  static String profilename = "default";
  static String uploadedimageurl =
      "https://moonvillageassociation.org/wp-content/uploads/2018/06/default-profile-picture1.jpg";
  Future<void> fetchrooms() async {
    final dbref = FirebaseDatabase.instance.reference().child('Users');

    User user = FirebaseAuth.instance.currentUser;

    String name, type;

    //getting name

    //getting image url
    try {
      await dbref.child(user.uid).child("info").once().then((value) {
        Map map = value.value;
        try {
          if (map['profile'] != null) {
            uploadedimageurl = value.value;
          }
        } catch (e) {}
        try {
          profilename = map['Name'];
        } catch (e) {}
      });
    } catch (ex) {
      print("exception in profile url");
    }

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
          if (id[i].length > 1) {
            favroomsarray.add(i);

            favouriteroomscontents.addAll({i: id[i]});
          } else {
            dbref
                .child(user.uid)
                .child("favourites")
                .child(i.toString())
                .remove();
          }
        }
        // Fluttertoast.showToast(msg: favouriteroomscontents.length.toString());
      } catch (ex) {
        print("Exception in fav maindata");
      }
    });
  }

  Future<void> fetchfavouritescontentdata() async {
    final dbref = FirebaseDatabase.instance.reference().child('Users');
    User user = FirebaseAuth.instance.currentUser;
    favouritecontentnamesmap.clear();
    path.clear();
    try {
      for (final i in favouriteroomscontents.keys) {
        Map m = favouriteroomscontents[i];
        var dummy = [];

        for (final j in m.keys) {
          if (j.toString() == "val") continue;
          String s = m[j].toString();
          var list = s.split(" ");

          //logic
          await dbref
              .child(user.uid)
              .child("rooms")
              .child(list[0])
              .child("circuit")
              .child(list[1])
              .child(list[2])
              .once()
              .then((value) {
            Map map = value.value;
            dummy.add(map["name"]);
            path.addAll({map["name"]: j});
          });
        }
        favouritecontentnamesmap.addAll({i: dummy});
      }
    } catch (Ex) {
      print("EXception in favourite content");
    }
  }

  static Future<void> linktofav(String name) async {
    final dbref = FirebaseDatabase.instance.reference().child('Users');
    User user = FirebaseAuth.instance.currentUser;
    try {
      for (final i in favouriteroomscontents.keys) {
        Map m = favouriteroomscontents[i];
        if (m['val'] == 1 && m.keys.contains(name)) {
          m['val'] = 0;
          favouriteroomscontents[i] = m;
          try {
            await dbref
                .child(user.uid)
                .child("favourites")
                .child(i.toString())
                .child("val")
                .set(0);
          } catch (e) {
            print("not link");
          }
        }
      }
    } catch (e) {}
  }

   Future<void> roomdelete(String room) async {
    await fetchfavourites();
    await fetchindex();
    //await fetchfavouritescontentdata();

    var localmap = Map();
    var localmapforfav = Map();
    for (final i in indexlistmap.keys) {
      String s = indexlistmap[i];
      if (!s.startsWith(room)) {
        localmap.addAll({i: s});
      }
    }
    final dbref = FirebaseDatabase.instance.reference().child('Users');
    User user = FirebaseAuth.instance.currentUser;
    await dbref.child(user.uid).child("index").set(localmap);
    indexlistmap = localmap;

    //fav
    for (final i in favouriteroomscontents.keys) {
      var mapp = favouriteroomscontents[i];
      var a = Map();
      for (final k in mapp.keys) {
        String s = k.toString();
        if (!s.startsWith(room)) {
          a.addAll({k: mapp[k]});
        }
      }
      localmapforfav.addAll({i: a});
    }
    await dbref.child(user.uid).child("favourites").set(localmapforfav);
  }

  Future<void> fetchindex() async {
    indexlistmap.clear();
    indexlist.clear();
    Map m1 = new Map();
    //indexlist.clear();

    final dbref = FirebaseDatabase.instance.reference().child('Users');
    User user = FirebaseAuth.instance.currentUser;
    await dbref.child(user.uid).child("index").once().then((snap) {
      m1 = snap.value;
      indexlistmap = m1;
      for (final k in m1.keys) {
        indexlist.add(k);
      }
    });
  }

  Future<void> ChangeStatus(int state, int index) async {
    final dbref = FirebaseDatabase.instance.reference().child('Users');
    User user = FirebaseAuth.instance.currentUser;
    if (true) {
      try {
        Map m = fulldataofrooms
            .favouriteroomscontents[fulldataofrooms.favroomsarray[index + 1]];

        fulldataofrooms.favouriteroomscontents[
            fulldataofrooms.favroomsarray[index + 1]]["val"] = state;
        await dbref
            .child(user.uid)
            .child("favourites")
            .child(fulldataofrooms.favroomsarray[index + 1])
            .child("val")
            .set(state);

        for (final i in m.values) {
          if (i == 1 || i == 0) continue;
          String s = i.toString();
          var list = s.split(" ");
          // Fluttertoast.showToast(msg: list.toString());

          await dbref
              .child(user.uid)
              .child("rooms")
              .child(list[0])
              .child("circuit")
              .child(list[1])
              .child(list[2])
              .child("val")
              .set(state);
        }
      } catch (Ex) {
        print("exception");
      }
    }
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  Future<List<String>> solvequery(String s) async {
    await fetchindex();
    await fetchfavourites();
    await fetchfavouritescontentdata();
    final dbref = FirebaseDatabase.instance.reference().child('Users');
    User user = FirebaseAuth.instance.currentUser;
    //String s = "Switch on tubelight 1";
    List<String> stopwords = ["the", "a", "an", "turn", "switch", "on", "off"];
    List<String> l = s.split(" ");
    String key = "";
    int flag = -1;
    var favlist = [];

    //
    /*var word_to_number = <String, num>{
      'one': 1,
      'two': 2,
      'three': 3,
      'four': 4,
      'five': 5,
      'six': 6,
      'seven': 7,
      'eight': 8,
      'nine': 9,
      'ten': 10,
    };*/

    await dbref.child(user.uid).child("favourites").once().then((snap) {
      for (final k in snap.value.keys) {
        favlist.add(k);
      }
    });
    String fav = '';
    for (int i = 0; i < favlist.length; i++) {
      if (s.toLowerCase().contains(favlist[i].toString().toLowerCase())) {
        fav = favlist[i];
        break;
      }
    }
    if (fav.length > 0) {
      if (s.toLowerCase().contains('on')) {
        await ChangeStatus(1, fulldataofrooms.favroomsarray.indexOf(fav) - 1);
      } else if (s.toLowerCase().contains('off') ||
          s.toLowerCase().contains('of')) {
        await ChangeStatus(0, fulldataofrooms.favroomsarray.indexOf(fav) - 1);
      }
    } else {
      print("out");
      for (int i = 0; i < (l.length); i++) {
        l[i] = l[i].toLowerCase();

        if (flag == -1) {
          if (l[i] == "switch" || l[i] == "turn") {
            if (l[i + 1].toLowerCase() == "on" || l[l.length - 1] == "on") {
              flag = 1;
            } else if (l[i + 1].toLowerCase() == "off" ||
                l[l.length - 1] == "off" ||
                l[l.length - 1] == "of") {
              flag = 0;
            }
          }
        } else {
          //remove stop words
          Map notation = {
            'one': ['on', 'oon', 'none'],
            'two': ['to', 'tu', 'too', 'tuu'],
            'three': ['tree'],
            'four': ['for', 'foor', 'or', 'fore'],
            'five': ['fiv', 'hive', 'fi'],
            'six': ['sin'],
            'seven': ['seaven'],
          };
          if (stopwords.contains(l[i])) {
          } else {
            if (isNumeric(l[i])) {
              String s = NumberToWord().convert("en-in", int.parse(l[i]));

              var slist = s.split(" ");
              s = "";
              for (int i = 0; i < slist.length; i++) {
                s += slist[i];
              }

              key += s;
              print("Converted" + s);
            } else {
              String p = l[i];
              int f = 0;
              for (final k in notation.keys) {
                var a = notation[k];
                for (int i = 0; i < a.length; i++) {
                  if (p.startsWith(a[i])) {
                    p = k;
                    f = 1;
                    break;
                  }
                }
                if (f == 1) break;
              }
              if (f == 1) {
                key += p;
              } else {
                key += l[i];
              }
            }
          }
        }
        print("final " + key);
      }
      print(key);
      key = key.trim();
      // return [flag.toString(), key];
      print(indexlist);
      try {
        String indexpath;
        print(indexlist.contains(key));

        if (indexlist.contains(key) == true) {
          print("index me toh haiiiiiiiiii");
          await dbref
              .child(user.uid)
              .child("index")
              .child(key)
              .once()
              .then((snap) => indexpath = snap.value);
          var list = indexpath.split(" ");
          if (flag == 0) {
            await linktofav(list[0] + list[1] + list[2]);
          }
          await dbref
              .child(user.uid)
              .child("rooms")
              .child(list[0])
              .child("circuit")
              .child(list[1])
              .child(list[2])
              .child("val")
              .set(flag);
          // Fluttertoast.showToast(msg: "done");
        }
        print("end");
      } catch (E) {
        print("caught in sppech func");
      }
    }
  }
}
