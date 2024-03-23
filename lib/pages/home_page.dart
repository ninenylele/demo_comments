import 'dart:convert';
import '../models/todo_item.dart';
import '../helpers/api_caller.dart';
import '../helpers/dialog_utils.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CommentsItem> _todoItems = [];

  @override
  void initState() {
    super.initState();
    _loadTodoItems();
  }

  Future<void> _loadTodoItems() async {
    try {
      final data = await ApiCaller().get("comments");
      // ข้อมูลที่ได้จาก API นี้จะเป็น JSON array ดังนั้นต้องใช้ List รับค่าจาก jsonDecode()
      List list = jsonDecode(data);
      setState(() {
        _todoItems = list.map((e) => CommentsItem.fromJson(e)).toList();
      });
    } on Exception catch (e) {
      showOkDialog(context: context, title: "Error", message: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Final Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Comments List', style: textTheme.titleMedium),
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: _todoItems.length,
                itemBuilder: (context, index) {
                  final item = _todoItems[index];
                  return Card(
                    child: ListTile(
                        title: Text(item.name),
                        subtitle: Text('ID: ${item.id}'),
                        trailing: Icon(
                            item.body.isNotEmpty ? Icons.check : Icons.close)),
                  );
                },
              ),
            ),
            const SizedBox(height: 24.0),

            // ปุ่มทดสอบ POST API
            ElevatedButton(
              onPressed: _handleApiPost,
              child: const Text('Test POST API'),
            ),

            const SizedBox(height: 8.0),

            // ปุ่มทดสอบ OK Dialog
            ElevatedButton(
              onPressed: _handleShowDialog,
              child: const Text('Show OK Dialog'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleApiPost() async {
    try {
      final data = await ApiCaller().post(
        "comments",
        params: {
          "postId": 98,
          "id": 1,
          "name": "ทดสอบๆๆๆๆๆๆๆๆๆๆๆๆๆๆ",
          "email": "aaaaaaa@dqdqdq.com",
          "body": "qdqdqd",
        },
      );
      // API นี้จะส่งข้อมูลที่เรา post ไป กลับมาเป็น JSON object ดังนั้นต้องใช้ Map รับค่าจาก jsonDecode()
      Map map = jsonDecode(data);
      String text =
          'ส่งข้อมูลสำเร็จ\n\n - postId: ${map['postId']} \n - id: ${map['id']} \n - name: ${map['name']} \n - email: ${map['email']} \n - body: ${map['body']}';
      showOkDialog(context: context, title: "Success", message: text);
    } on Exception catch (e) {
      showOkDialog(context: context, title: "Error", message: e.toString());
    }
  }

  Future<void> _handleShowDialog() async {
    await showOkDialog(
      context: context,
      title: "This is a title",
      message: "This is a message",
    );
  }
}
