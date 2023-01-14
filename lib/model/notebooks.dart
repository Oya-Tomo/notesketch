import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesketch/database/database.dart';

// Immutable Data Classes

@immutable
class NoteBook {
  const NoteBook({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
  });
  final int id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory NoteBook.fromRow({
    required NoteBookRow row,
  }) {
    return NoteBook(
      id: row.id,
      title: row.title,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  NoteBook copyWith({
    int? id,
    int? index,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NoteBook(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// Application StateNotifiers

class NoteBooksStateNotifier extends StateNotifier<List<NoteBook>> {
  NoteBooksStateNotifier() : super([]);
  // final DataBase database = DataBase();

  void fetchAllData() async {
    final rows = await database.select(database.noteBooks).get();
    rows.sort((a, b) => a.index.compareTo(b.index));
    state = rows.map((row) => NoteBook.fromRow(row: row)).toList();
  }

  NoteBook? getNoteBook(int id) {
    for (final noteBook in state) {
      if (noteBook.id == id) {
        return noteBook;
      }
    }
    return null;
  }

  Future<void> createNoteBook(String title) async {
    final currentTime = DateTime.now();
    final noteBookId = await database.into(database.noteBooks).insert(
          NoteBooksCompanion.insert(
            index: state.length,
            title: title,
            createdAt: currentTime,
            updatedAt: currentTime,
          ),
        );
    _add(
      NoteBook(
        id: noteBookId,
        title: title,
        createdAt: currentTime,
        updatedAt: currentTime,
      ),
    );
  }

  // Required : Target notebook has no pages.
  Future<void> deleteNoteBook(int id) async {
    await (database.delete(database.noteBooks)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
    state = state.where((noteBook) => noteBook.id != id).toList();
  }

  Future<void> renameNoteBook(int id, String title) async {
    final currentTime = DateTime.now();
    await (database.update(database.noteBooks)
          ..where((tbl) => tbl.id.equals(id)))
        .write(
      NoteBooksCompanion(
        title: Value(title),
        updatedAt: Value(currentTime),
      ),
    );
    state = [
      for (final book in state)
        if (book.id == id)
          book.copyWith(
            title: title,
            updatedAt: currentTime,
          )
        else
          book,
    ];
  }

  Future<void> reorderNoteBooks(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final book = state[oldIndex];
    _remove(oldIndex);
    _insert(newIndex, book);
    for (int i = 0; i < state.length; i++) {
      await (database.update(database.noteBooks)
            ..where((tbl) => tbl.id.equals(state[i].id)))
          .write(
        NoteBooksCompanion(
          index: Value(i),
        ),
      );
    }
  }

  Future<void> noteBookContentDidUpdate(int id) async {
    final currentTime = DateTime.now();
    await (database.update(database.noteBooks)
          ..where((tbl) => tbl.id.equals(id)))
        .write(
      NoteBooksCompanion(
        updatedAt: Value(currentTime),
      ),
    );
    state = [
      for (final book in state)
        if (book.id == id)
          book.copyWith(
            updatedAt: currentTime,
          )
        else
          book,
    ];
  }

  void _add(NoteBook noteBook) {
    state = [
      ...state,
      noteBook,
    ];
  }

  void _insert(int index, NoteBook noteBook) {
    state = [
      ...state.sublist(0, index),
      noteBook,
      ...state.sublist(index),
    ];
  }

  void _remove(int index) {
    state = [
      ...state.sublist(0, index),
      ...state.sublist(index + 1),
    ];
  }
}

// Make Instance of Application Data Providers

final noteBooksProvider =
    StateNotifierProvider<NoteBooksStateNotifier, List<NoteBook>>(
  (ref) {
    return NoteBooksStateNotifier()..fetchAllData();
  },
);
