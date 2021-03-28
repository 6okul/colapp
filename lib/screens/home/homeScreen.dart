import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colapp/shared/projectCard.dart';
import 'package:colapp/state/userAuthState.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Container(
//           color: Colors.grey[200],
//           child: Column(
//             children: [
//               ProjectCard(null),
//               ProjectCard(null),
//               ProjectCard(null),
//               ProjectCard(null),
//               ProjectCard(null),
//             ],
//           )),
//     );
//   }
// }

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getDocuments();
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels == 0)
          print('ListView scroll at top');
        else {
          print('ListView scroll at bottom');
          getDocumentsNext(); // Load next documents
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String currentUid =
        Provider.of<UserAuthState>(context, listen: false).getCurrentUser.uid;
    return Center(
      child: listDocument.length != 0
          ? RefreshIndicator(
              child: Container(
                color: Colors.grey[200],
                child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: scrollController,
                  itemCount: listDocument.length,
                  itemBuilder: (context, index) {
                    return ProjectCard(listDocument[index], currentUid);
                  },
                ),
              ),
              onRefresh: getDocuments, // Refresh entire list
            )
          : CircularProgressIndicator(),
    );
  }

  List<Map> listDocument;
  QuerySnapshot collectionState;
  // Fetch first 15 documents
  Future<void> getDocuments() async {
    listDocument = List();
    var collection = FirebaseFirestore.instance
        .collection('projects')
        .orderBy("createdAt", descending: true)
        .limit(15);
    print('getDocuments');
    fetchDocuments(collection);
  }

  // Fetch next 5 documents starting from the last document fetched earlier
  Future<void> getDocumentsNext() async {
    // Get the last visible document
    var lastVisible = collectionState.docs[collectionState.docs.length - 1];
    print('listDocument legnth: ${collectionState.size} last: $lastVisible');

    var collection = FirebaseFirestore.instance
        .collection('projects')
        .orderBy("createdAt", descending: true)
        .startAfterDocument(lastVisible)
        .limit(5);

    fetchDocuments(collection);
  }

  fetchDocuments(Query collection) {
    collection.get().then((value) {
      collectionState =
          value; // store collection state to set where to start next
      value.docs.forEach((element) {
        print('getDocuments ${element.data()}');
        Map project = element.data();
        project["docId"] = element.reference.id;
        setState(() {
          listDocument.add(project);
        });
      });
    });
  }
}
