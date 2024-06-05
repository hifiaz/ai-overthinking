import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void toastError(context, {String? message}) {
  ShadToaster.of(context).show(
    ShadToast(
      backgroundColor: Colors.red,
      title: const Text('Something went wrong',
          style: TextStyle(color: Colors.white)),
      description: Text(
        message ?? 'Unknown error',
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );
}
