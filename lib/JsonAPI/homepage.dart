import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sqlite/JsonAPI/User.dart';
import 'package:sqlite/JsonAPI/post.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<User>? users;
  List<Postarticle>? posts;
  TextEditingController postIdController = TextEditingController();
  String postTitle = "";
  String postBody = "";

  Future<void> fetchUsers() async {
    final responseUsers =
        await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users"));

    if (responseUsers.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(responseUsers.body);
      setState(() {
        users = jsonList.map((json) => User.fromJson(json)).toList();
      });
    }
  }

  Future<void> fetchPosts(int postId) async {
    final responsePosts = await http.get(
        Uri.parse("https://jsonplaceholder.typicode.com/posts/$postId"));

    if (responsePosts.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(responsePosts.body);
      setState(() {
        postTitle = json["title"];
        postBody = json["body"];
      });
    } else {
      setState(() {
        postTitle = 'Post not found';
        postBody = "";
      });
    }
  }

  void deleteUser(int index) {
    setState(() {
      users?.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Sheet 5.7.2 HTTP-Client"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: postIdController,
                    decoration: const InputDecoration(
                      labelText: "Enter ID",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    int postId = int.tryParse(postIdController.text) ?? 0;
                    if (postId > 0) {
                      fetchPosts(postId);
                    }
                    postIdController.clear();
                  },
                  child: const Text("Push me if you understand Latin"),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Title:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(postTitle),
                const SizedBox(height: 8),
                const Text(
                  "Body:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(postBody),
              ],
            ),
          ),
          Expanded(
            child: users != null
                ? ListView.builder(
                    itemCount: users!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(users![index].name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(thickness: 2, endIndent: 70),
                              Text("Username: ${users![index].username}"),
                              Text("Email: ${users![index].email}"),
                              const Divider(thickness: 2, endIndent: 70),
                              Text("Street: ${users![index].street}"),
                              Text("Suite: ${users![index].suite}"),
                              Text("City: ${users![index].city}"),
                              Text("Zipcode: ${users![index].zipcode}"),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              deleteUser(index);
                            },
                          ),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ],
      ),
      floatingActionButton: ElevatedButton(
        onPressed: fetchUsers,
        child: const Text("Load User"),
      ),
    );
  }
}
