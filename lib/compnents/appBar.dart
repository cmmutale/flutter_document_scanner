import 'package:flutter/material.dart';

AppBar appBar(String pageTitle) {
  return AppBar(
    title: Text(pageTitle),
    actions: [IconButton(onPressed: () {}, icon: Icon(Icons.save))],
  );
}
