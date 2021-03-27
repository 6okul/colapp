import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colapp/screens/find/profileTile.dart';
import 'package:flutter/material.dart';

class FindScreen extends StatefulWidget {
  @override
  _FindScreenState createState() => _FindScreenState();
}

class _FindScreenState extends State<FindScreen> {
  List<Widget> searchResult = [];
  TextEditingController searchcontroller = new TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//           child: Row(
//             children: [
//               Expanded(
//                   flex: 5,
//                   child: TextField(
//                     controller: searchcontroller,
//                     decoration: InputDecoration(
//                       hintText: "Search",
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10)),
//                     ),
//                   )),
//               Expanded(
//                   flex: 1,
//                   child: IconButton(
//                       onPressed: () async {
//                         if (searchcontroller.text.length > 0) {
//                           await FirebaseFirestore.instance
//                               .collection("users")
//                               .where('fullname',
//                                   isGreaterThanOrEqualTo:
//                                       searchcontroller.text.trim())
//                               .get()
//                               .then((value) {
//                             List<Widget> result = [];
//                             value.docs.map((e) {
//                               Map<String, dynamic> profile;
//                               profile = e.data();
//                               result.add(ProfileTile(profile));
//                             });
//                             setState(() {
//                               searchResult = result;
//                             });
//                           });
//                         }
//                       },
//                       icon: Icon(
//                         Icons.search,
//                       )))
//             ],
//           ),
//         ),
//         if (searchResult.length > 0) ...searchResult
//       ],
//     );
//   }
// }

  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              padding: EdgeInsets.only(right: 20),
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  name = searchcontroller.text.trim();
                });
              })
        ],
        backgroundColor: Colors.black,
        title: TextField(
          textCapitalization: TextCapitalization.words,
          style: TextStyle(color: Colors.white),
          controller: searchcontroller,
          cursorColor: Colors.white,
          decoration: InputDecoration(
              hintStyle: TextStyle(color: Colors.grey), hintText: 'Search'),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: (name != "" && name != null)
            ? FirebaseFirestore.instance
                .collection('users')
                .where("fullName", isGreaterThanOrEqualTo: name)
                .snapshots()
            : FirebaseFirestore.instance.collection("featured").snapshots(),
        builder: (context, snapshot) {
          return (snapshot.connectionState == ConnectionState.waiting)
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot profile = snapshot.data.docs[index];
                    return ProfileTile(profile.data());
                  },
                );
        },
      ),
    );
  }
}
