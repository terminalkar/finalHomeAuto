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
  static Map notation;
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
  static bool changed = false;
  static String uploadedimageurl =
      "https://moonvillageassociation.org/wp-content/uploads/2018/06/default-profile-picture1.jpg";
  Future<void> fetchrooms() async {
    final dbref = FirebaseDatabase.instance.reference().child('Users');

    await FirebaseDatabase.instance
        .reference()
        .child("notation")
        .once()
        .then((value) => notation = value.value);
    User user = FirebaseAuth.instance.currentUser;

    String name, type;

      //flag room
    dbref.child(user.uid).child("rooms").onChildChanged.listen((event){
      if(changed){
        print('chnaged room');
        dbref.child(user.uid).child("info").child("updateFlag").set(1);
      }
  });

      dbref.child(user.uid).child("rooms").onChildAdded.listen((event){
      print('added room');
      dbref.child(user.uid).child("info").child("updateFlag").set(1);
    });

    dbref.child(user.uid).child("rooms").onChildRemoved.listen((event){
    print('removed room');
    dbref.child(user.uid).child("info").child("updateFlag").set(1);
  });
     //flag fav

    dbref.child(user.uid).child("favourites").onChildChanged.listen((event){
      if(changed){
        print('changed fav');
        dbref.child(user.uid).child("info").child("updateFlag").set(1);
      }
    
  });

    dbref.child(user.uid).child("favourites").onChildAdded.listen((event){
    print('added fav');
    dbref.child(user.uid).child("info").child("updateFlag").set(1);
  });


    dbref.child(user.uid).child("favourites").onChildRemoved.listen((event){
    print('removed fav');
    dbref.child(user.uid).child("info").child("updateFlag").set(1);
  });

  
  
    //getting image url
    try {
      await dbref.child(user.uid).child("info").once().then((value) {
        Map map = value.value;
        try {
          if (map['profile'] != null) {
            uploadedimageurl = map['profile'];
          }
        } catch (e) {
          print("exception in profile");
        }
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

  static Future<void> fetchswitchstate() async {
    final dbref = FirebaseDatabase.instance.reference().child('Users');
    User user = FirebaseAuth.instance.currentUser;

    await dbref
        .child(user.uid)
        .child("rooms")
        .child(fulldataofrooms.roomidarray[fulldataofrooms.index])
        .child("circuit")
        .child(fulldataofrooms.boardidarray[fulldataofrooms.boardindex])
        .once()
        .then((snap) {
      Map id = snap.value;
      try {
        boardid[fulldataofrooms.boardidarray[fulldataofrooms.boardindex]] = id;
      } catch (ex) {
        print("Exception in board maindata");
      }
    });
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
    try {
      favroomsarray.clear();
      favroomsarray.add("Select");
      favouriteroomscontents.clear();
    } catch (e) {}
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
    try {
      favouritecontentnamesmap.clear();
      path.clear();
    } catch (e1) {}
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
    try {
      indexlistmap.clear();
      indexlist.clear();
    } catch (e) {}
    Map m1 = new Map();
    //indexlist.clear();
    try {
      final dbref = FirebaseDatabase.instance.reference().child('Users');
      User user = FirebaseAuth.instance.currentUser;
      await dbref.child(user.uid).child("index").once().then((snap) {
        m1 = snap.value;
        indexlistmap = m1;
        for (final k in m1.keys) {
          indexlist.add(k);
        }
      });
    } catch (e) {}
  }

  Future<void> ChangeStatus(int state, int index) async {
    final dbref = FirebaseDatabase.instance.reference().child('Users');
    User user = FirebaseAuth.instance.currentUser;
    if (true) {
      try {
        Map allfav = fulldataofrooms.favouriteroomscontents;
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
          int flagg = 0;
          if (i == 1 || i == 0) continue;
          String s = i.toString();
          var list = s.split(" ");
          for (final i in allfav.keys) {
            if (i != fulldataofrooms.favroomsarray[index + 1] &&
                allfav[i]["val"] == 1) {
              if (allfav[i][list[0] + list[1] + list[2]] == s) {
                print("Commonnnnnnnnnnnnnnnnn");
                flagg = 1;
                break;
              }
            }
          }
          if (flagg == 0) {
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

//   Future<List<String>> solvequery(String s) async {
//     await fetchindex();
//     await fetchfavourites();
//     await fetchfavouritescontentdata();
//     final dbref = FirebaseDatabase.instance.reference().child('Users');
//     User user = FirebaseAuth.instance.currentUser;
//     //String s = "Switch on tubelight 1";
//     List<String> stopwords = ["the", "a", "an", "turn", "switch", "on", "off"];
//     List<String> l = s.split(" ");
//     String key = "";
//     int flag = -1;
//     var favlist = [];
//     String command = '';
//     //
//     /*var word_to_number = <String, num>{
//       'one': 1,
//       'two': 2,
//       'three': 3,
//       'four': 4,
//       'five': 5,
//       'six': {6:"1"},
//       'seven': 7,
//       'eight': 8,
//       'nine': 9,
//       'ten': 10,
//     };*/
//     try {
//       await dbref.child(user.uid).child("favourites").once().then((snap) {
//         for (final k in snap.value.keys) {
//           favlist.add(k);
//         }
//       });
//     } catch (e1) {}
//     print(favlist);
//     if (true) {
//       print("out");
//       for (int i = 0; i < (l.length); i++) {
//         l[i] = l[i].toLowerCase();

//         if (flag == -1) {
//           if (l[i] == "switch" || l[i] == "turn") {
//             command += l[i] + ' ';
//             if (l[i + 1].toLowerCase() == "on" || l[l.length - 1] == "on") {
//               flag = 1;
//               command += 'on' + ' ';
//             } else if (l[i + 1].toLowerCase() == "off" ||
//                 l[l.length - 1] == "off" ||
//                 l[l.length - 1] == "of") {
//               flag = 0;
//               command += 'off' + ' ';
//             }
//           }
//         } else {
//           //remove stop words
//           final dbref = FirebaseDatabase.instance.reference();
//           User user = FirebaseAuth.instance.currentUser;

//           if (stopwords.contains(l[i])) {
//           } else {
//             if (isNumeric(l[i])) {
//               String s = NumberToWord().convert("en-in", int.parse(l[i]));

//               var slist = s.split(" ");
//               s = "";
//               for (int i = 0; i < slist.length; i++) {
//                 s += slist[i];
//               }

//               key += s;

//               print("Converted" + s);
//             } else {
//               String p = l[i];
//               int f = 0;
//               print(notation);
//               for (final k in notation.keys) {
//                 var a = notation[k];
//                 for (final k1 in a.keys) {
//                   if (p == k1) {
//                     p = k;
//                     f = 1;
//                     break;
//                   }
//                 }
//                 if (f == 1) break;
//               }
//               if (f == 1) {
//                 key += p;
//               } else {
//                 key += l[i];
//               }
//             }
//           }
//         }
//         print("final " + key);
//       }
//       print(key);
//       Fluttertoast.showToast(msg: "Running command " + command + key);
//       key = key.trim();
//       // return [flag.toString(), key];
//       print(indexlist);
//       try {
//         String indexpath;
//         print(indexlist.contains(key));
//         if (indexlist.contains(key) != true) {
//           String fav = '';
//           for (int i = 0; i < favlist.length; i++) {
//             if (key == favlist[i].toString().toLowerCase()) {
//               fav = favlist[i];
//               break;
//             }
//           }
//           print(fav + "00000");
//           if (fav.length > 0) {
//             if (s.toLowerCase().contains('on')) {
//               await ChangeStatus(
//                   1, fulldataofrooms.favroomsarray.indexOf(fav) - 1);
//             } else if (s.toLowerCase().contains('off') ||
//                 s.toLowerCase().contains('of')) {
//               await ChangeStatus(
//                   0, fulldataofrooms.favroomsarray.indexOf(fav) - 1);
//             }
//           }
//         }

//         if (indexlist.contains(key) == true) {
//           print("index me toh haiiiiiiiiii");
//           await dbref
//               .child(user.uid)
//               .child("index")
//               .child(key)
//               .once()
//               .then((snap) => indexpath = snap.value);
//           var list = indexpath.split(" ");
//           if (flag == 0) {
//             await linktofav(list[0] + list[1] + list[2]);
//           }
//           await dbref
//               .child(user.uid)
//               .child("rooms")
//               .child(list[0])
//               .child("circuit")
//               .child(list[1])
//               .child(list[2])
//               .child("val")
//               .set(flag);
//           // Fluttertoast.showToast(msg: "done");
//         }
//         print("end");
//       } catch (E) {
//         print("caught in sppech func");
//       }
//     }
//   }
}
