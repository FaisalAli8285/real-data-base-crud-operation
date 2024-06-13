import 'package:firebase_crudoperations/roundbutton.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final addPostControlle = TextEditingController();
  final dataBaseReference = FirebaseDatabase.instance.ref("Post");
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Post"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            SizedBox(
              height: 80,
            ),
            TextFormField(
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  addPostControlle.text = value;
                });
              },
            ),
            SizedBox(
              height: 80,
            ),
            RoundButton(
                loading: loading,
                title: "Add",
                onTap: () {
                  setState(() {
                    loading = true;
                  });
                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  dataBaseReference.child(id).set({
                    "title": addPostControlle.text,
                    "id": id,
                  }).then((value) {
                    setState(() {
                      loading = false;
                    });
                    print("succesfull");
                  }).onError((error, stackTrace) {
                    setState(() {
                      loading = false;
                    });
                    print(error.toString());
                  });
                })
          ],
        ),
      ),
    );
  }
}
