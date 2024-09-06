import 'package:ai_overthinking/model/content_model.dart';
import 'package:ai_overthinking/page/widget/message_widget.dart';
import 'package:ai_overthinking/service/generative_service.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final ContentModel item;
  const DetailPage({super.key, required this.item});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late ContentModel answer;
  bool isLoading = true;
  @override
  void initState() {
    generateAnswer();
    super.initState();
  }

  void generateAnswer() async {
    final response = await GenerationService().getText(widget.item.text!);
    final text = response?.text;
    answer = ContentModel(
        image: null, text: text, fromUser: false, createdAt: DateTime.now());
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MessageWidget(
                text: widget.item.text,
                isFromUser: widget.item.fromUser,
              ),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : MessageWidget(
                      text: answer.text,
                      isFromUser: answer.fromUser,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
