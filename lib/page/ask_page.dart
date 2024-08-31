import 'dart:developer';

import 'package:ai_overthinking/model/content_model.dart';
import 'package:ai_overthinking/page/widget/message_widget.dart';
import 'package:ai_overthinking/provider/content_provider.dart';
import 'package:ai_overthinking/provider/purchase_provider.dart';
import 'package:ai_overthinking/provider/user_provider.dart';
import 'package:ai_overthinking/service/firebase_service.dart';
import 'package:ai_overthinking/service/generative_service.dart';
import 'package:ai_overthinking/utils/env.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:signals/signals_flutter.dart';

class AskPage extends StatefulWidget {
  const AskPage({super.key});

  @override
  State<AskPage> createState() => _AskPageState();
}

class _AskPageState extends State<AskPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFieldFocus = FocusNode();
  // final List<({Image? image, String? text, bool fromUser})> _generatedContent =
  //     <({Image? image, String? text, bool fromUser})>[];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final subscribe = subscriptionProvider.isActive.watch(context);
    final user = userProvider.user.watch(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ai Overthinking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Environment.token.isNotEmpty
                  ? Watch((context) {
                      final generatedContent = contentProvider.content.reversed;
                      return ListView.builder(
                        controller: _scrollController,
                        itemBuilder: (context, idx) {
                          final content = generatedContent.elementAt(idx);
                          return MessageWidget(
                            text: content.text,
                            isFromUser: content.fromUser,
                          );
                        },
                        itemCount: generatedContent.length,
                      );
                    })
                  : ListView(
                      children: const [
                        Text(
                          'No API key found. Please provide an API Key using '
                          "'--dart-define' to set the 'API_KEY' declaration.",
                        ),
                      ],
                    ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 25,
                horizontal: 15,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ShadInputFormField(
                      autofocus: true,
                      controller: _textController,
                      onSubmitted: _sendChatMessage,
                      placeholder: const Text('Overthink about?'),
                    ),
                  ),
                  if (!_loading)
                    ShadButton(
                      onPressed: () async {
                        if (_textController.text.isEmpty) {
                          return;
                        } else {
                          if ((user.value?.quota ?? 0) > 0 ||
                              subscribe.value == true) {
                            _sendChatMessage(_textController.text,
                                quota: user.value?.quota);
                          } else {
                            ShadToaster.of(context).show(
                              const ShadToast(
                                backgroundColor: Colors.red,
                                title: Text('Run Out of Quota',
                                    style: TextStyle(color: Colors.white)),
                                description: Text(
                                  'Please Subscribe to use more',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          }
                        }
                      },
                      icon: const Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Icon(
                          Icons.send,
                          size: 16,
                        ),
                      ),
                      child: const Text('Send'),
                    )
                  else
                    ShadButton(
                      onPressed: () {},
                      icon: const Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: SizedBox.square(
                          dimension: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      child: const Text('Please wait'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(
          milliseconds: 750,
        ),
        curve: Curves.easeOutCirc,
      ),
    );
  }

  Future<void> _sendChatMessage(String message, {int? quota}) async {
    setState(() {
      _loading = true;
    });

    try {
      final question = ContentModel(
          image: null,
          text: message,
          fromUser: true,
          createdAt: DateTime.now());
      contentProvider.content.add(question);
      if (quota != null && quota > 0) {
        FirebaseService().updateUser(quota: quota - 1);
      }
      FirebaseService()
          .createContent(question)
          .then((value) => log("content Added"))
          .catchError((error) => log("Failed to add content: $error"));

      final response = await GenerationService().getText(message);
      final text = response?.text;
      final answer = ContentModel(
          image: null, text: text, fromUser: false, createdAt: DateTime.now());
      contentProvider.content.add(answer);
      FirebaseService()
          .createContent(answer)
          .then((value) => log("content Added"))
          .catchError((error) => log("Failed to add content: $error"));
      if (text == null) {
        _showError('No response from API.');
        return;
      } else {
        contentProvider.contentFromFirebase.refresh();
        setState(() {
          _loading = false;
          _scrollDown();
        });
      }
    } catch (e) {
      _showError(e.toString());
      setState(() {
        _loading = false;
      });
    } finally {
      _textController.clear();
      setState(() {
        _loading = false;
      });
      _textFieldFocus.requestFocus();
    }
  }

  void _showError(String message) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Something went wrong'),
          content: SingleChildScrollView(
            child: SelectableText(message),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            )
          ],
        );
      },
    );
  }
}
