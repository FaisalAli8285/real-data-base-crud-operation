import 'package:firebase_crudoperations/add_post_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class StreamPostScreen extends StatefulWidget {
  const StreamPostScreen({super.key});

  @override
  State<StreamPostScreen> createState() => _StreamPostScreenState();
}

class _StreamPostScreenState extends State<StreamPostScreen> {
  final searchController = TextEditingController();

  final textEditingController = TextEditingController();
  final reference = FirebaseDatabase.instance.ref("Post");
  List _completeList = [];
  List _filteredList = [];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post Screen"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _filterList(value);
                });
              },
            ),
            Expanded(
              child: StreamBuilder(
                  stream: reference.onValue,
                  builder: (((context, AsyncSnapshot<DatabaseEvent> snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    } else {
                      Map<dynamic, dynamic> map =
                          snapshot.data!.snapshot.value as dynamic;

                      _completeList = map.values.toList();
                      _filteredList = _completeList;

                      if (searchController.text.isNotEmpty) {
                        _filterList(searchController.text);
                      }
                      return ListView.builder(
                          itemCount: _filteredList.length,
                          itemBuilder: ((context, index) {
                            final title =
                                _filteredList[index]["title"].toString();
                            return Column(
                              children: [
                                ListTile(
                                  leading: Text(_filteredList[index]["title"] ??
                                      'No Title'),
                                  subtitle: Text(_filteredList[index]["id"] ??
                                      'No Sub Title'),
                                  trailing:
                                      PopupMenuButton(itemBuilder: ((context) {
                                    return [
                                      PopupMenuItem(
                                          child: ListTile(
                                        onTap: () {
                                          Navigator.pop(context);
                                          showMydialogueBox(
                                              title,
                                              _filteredList[index]["id"]
                                                  .toString());
                                        },
                                        leading: Text("Edit"),
                                        trailing: Icon(Icons.edit),
                                      )),
                                      PopupMenuItem(
                                          child: ListTile(
                                        onTap: () {
                                          Navigator.pop(context);
                                          reference
                                              .child(_filteredList[index]["id"]
                                                  .toString())
                                              .remove()
                                              .then((_) {
                                            print("Delete success");
                                          }).catchError((error) {
                                            print(error.toString());
                                          });
                                        },
                                        leading: Text("delte"),
                                        trailing: Icon(Icons.delete),
                                      )),
                                    ];
                                  })),
                                )
                              ],
                            );
                          }));
                    }
                  }))),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddPostScreen(),
              ));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _filterList(String query) {
    _filteredList = _completeList
        .where((post) => post["title"]
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();
  }

  void showMydialogueBox(String title, String id) {
    textEditingController.text = title;
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: Text("Update"),
            content: Container(
              child: TextField(
                controller: textEditingController,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  reference.child(id).update({
                    "title": textEditingController.text.toLowerCase()
                  }).then((value) {
                    print("success");
                  }).onError((error, stackTrace) {
                    print(error.toString());
                  });
                },
                child: Text("Update"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("cancel"),
              )
            ],
          );
        }));
  }
}
