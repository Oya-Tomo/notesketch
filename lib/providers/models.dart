import 'package:flutter/material.dart';
import 'package:notesketch/database/database.dart';

@immutable
class Book {
  final int id;
  final String title;
  final int index;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Book({
    required this.id,
    required this.title,
    required this.index,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Book.fromRow(BookRow row) {
    return Book(
      id: row.id,
      title: row.title,
      index: row.index,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  factory Book.fromJson(int id, Map<String, dynamic> data) {
    return Book(
      id: id,
      title: data["title"] ?? "",
      index: data["index"] ?? 0,
      createdAt: data["createdAt"] ?? DateTime.now(),
      updatedAt: data["updatedAt"] ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "index": index,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }
}

@immutable
class Page {
  final int id;
  final int bookId;
  final String title;
  final String content;
  final int index;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Page({
    required this.id,
    required this.bookId,
    required this.title,
    required this.content,
    required this.index,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Page.fromRow(PageRow row) {
    return Page(
      id: row.id,
      bookId: row.bookId,
      title: row.title,
      content: row.content,
      index: row.index,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  factory Page.fromJson(int id, Map<String, dynamic> data) {
    return Page(
      id: id,
      bookId: data["bookId"] ?? 0,
      title: data["title"] ?? "",
      content: data["content"] ?? "",
      index: data["index"] ?? 0,
      createdAt: data["createdAt"] ?? DateTime.now(),
      updatedAt: data["updatedAt"] ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "bookId": bookId,
      "content": content,
      "index": index,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }
}
