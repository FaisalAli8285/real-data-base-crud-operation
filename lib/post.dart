import 'package:firebase_crudoperations/add_post_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final searchController = TextEditingController();
  final textEditingController = TextEditingController();
  final reference = FirebaseDatabase.instance.ref("Post");
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
                setState(() {});
              },
            ),
            Expanded(
              child: FirebaseAnimatedList(
                  query: reference,
                  itemBuilder: (Context, snapshot, Animation, Index) {
                    String title = snapshot.child("title").value.toString();
                    if (searchController.text.isEmpty) {
                      return ListTile(
                        title: Text(snapshot.child("title").value.toString()),
                        subtitle: Text(snapshot.child("id").value.toString()),
                        trailing: PopupMenuButton(itemBuilder: ((context) {
                          return [
                            PopupMenuItem(
                                child: ListTile(
                              leading: Icon(Icons.edit),
                              title: Text("Edit"),
                              onTap: () {
                                Navigator.pop(context);
                                showMyDialogue(title,
                                    snapshot.child("id").value.toString());
                              },
                            )),
                            PopupMenuItem(
                                child: ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                reference
                                    .child(
                                        snapshot.child("id").value.toString())
                                    .remove();
                              },
                              leading: Icon(Icons.delete),
                              title: Text("delete"),
                            )),
                          ];
                        })),
                      );
                    } else if (title
                        .toLowerCase()
                        .contains(searchController.text.toLowerCase())) {
                      return ListTile(
                        title: Text(snapshot.child("title").value.toString()),
                        subtitle: Text(snapshot.child("id").value.toString()),
                        trailing: PopupMenuButton(itemBuilder: ((context) {
                          return [
                            PopupMenuItem(
                                child: ListTile(
                              leading: Icon(Icons.edit),
                              title: Text("Edit"),
                              onTap: () {
                                Navigator.pop(context);
                                showMyDialogue(title,
                                    snapshot.child("id").value.toString());
                              },
                            )),
                            PopupMenuItem(
                                child: ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                reference
                                    .child(
                                        snapshot.child("id").value.toString())
                                    .remove();
                              },
                              leading: Icon(Icons.delete),
                              title: Text("delete"),
                            )),
                          ];
                        })),
                      );
                    } else {
                      return Container();
                    }
                  }),
            )
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

  void showMyDialogue(String title1, String id) {
    textEditingController.text = title1;
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
                    reference.child(id).update(
                        {"title": textEditingController.text.toString()});
                  },
                  child: Text("Update")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"))
            ],
          );
        }));
  }
}
