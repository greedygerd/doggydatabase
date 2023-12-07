import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sqlite/JsonAPI/post.dart';
import 'package:http/http.dart' as http;

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  List<Postarticle>? posts;

  Future<void> fetchPosts() async {
    final responsePosts = await http
        .get(Uri.parse("https://jsonplaceholder.typicode.com/posts/"));

    if (responsePosts.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(responsePosts.body);
      setState(() {
        posts = jsonList.map((json) => Postarticle.fromJson(json)).toList();
      });
    }
  }

  void deletePosts(int index) {
    setState(() {
      posts?.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Task Sheet 5.7.2 HTTP-Client")),
      body: posts != null
          ? ListView.builder(
              itemCount: posts!.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(posts![index].id.toString()),
                    ),
                    title: Text(posts![index].title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${posts![index].body}"),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        deletePosts(index);
                      },
                    ),
                  ),
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: ElevatedButton(
        onPressed: fetchPosts,
        child: const Text("Load Posts"),
      ),
    );
  }
}
