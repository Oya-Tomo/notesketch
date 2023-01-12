import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesketch/database/database.dart';
import 'package:notesketch/model/notebatches.dart';

@immutable
class NotePage {
  const NotePage({
    required this.id,
    required this.title,
    required this.content,
    required this.batches,
    required this.createdAt,
    required this.updatedAt,
  });
  final int id;
  final String title;
  final String content;
  final List<NoteBatch> batches;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory NotePage.fromRow({
    required NotePageRow row,
  }) {
    return NotePage(
      id: row.id,
      title: row.title,
      content: row.content,
      batches: const [],
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  NotePage copyWith({
    int? id,
    String? title,
    String? content,
    List<NoteBatch>? batches,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotePage(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      batches: batches ?? this.batches,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class NotePagesStateNotifier extends StateNotifier<List<NotePage>> {
  NotePagesStateNotifier() : super([]);
  final DataBase _database = DataBase();

  NotePage? getNotePage(int id) {
    for (final page in state) {
      if (page.id == id) {
        return page;
      }
    }
    return null;
  }

  void openNoteBook(int id) async {
    final rowPages = await (_database.select(_database.notePages)
          ..where((t) => t.noteBookId.equals(id)))
        .get();
    final rowBatches = await (_database.select(_database.noteBatches)).get();
    final rowEntries = await (_database.select(_database.notePageBatchEntries)
          ..where(
            (t) => t.notePageId.isIn(
              rowPages.map((row) => row.id).toList(),
            ),
          ))
        .get();

    rowPages.sort((a, b) => a.index.compareTo(b.index));

    state = rowPages.map((rowPage) {
      final filteredEntries =
          rowEntries.where((entry) => entry.notePageId == rowPage.id).toList();
      final filteredBatches = [];
      for (final entry in filteredEntries) {
        filteredBatches
            .addAll(rowBatches.where((batch) => batch.id == entry.noteBatchId));
      }

      final page = NotePage.fromRow(row: rowPage).copyWith(
        batches: filteredBatches
            .map((batch) => NoteBatch.fromRow(row: batch))
            .toList(),
      );

      return page;
    }).toList();
  }

  Future<void> createNotePage(int noteBookId, String title) async {
    final currentTime = DateTime.now();
    final notePageId = await _database.into(_database.notePages).insert(
          NotePagesCompanion.insert(
            index: state.length,
            noteBookId: noteBookId,
            title: title,
            content: "",
            createdAt: currentTime,
            updatedAt: currentTime,
          ),
        );
    _add(
      NotePage(
        id: notePageId,
        title: title,
        content: "",
        batches: const [],
        createdAt: currentTime,
        updatedAt: currentTime,
      ),
    );
  }

  Future<void> deleteNoteBookPages(int noteBookId, bool clearState) async {
    final pageIds = (await (_database.select(_database.notePages)
              ..where((tbl) => tbl.noteBookId.equals(noteBookId)))
            .get())
        .map((page) => page.id)
        .toList();
    await (_database.delete(_database.notePageBatchEntries)
          ..where((tbl) => tbl.notePageId.isIn(pageIds)))
        .go();
    await (_database.delete(_database.notePages)
          ..where((tbl) => tbl.noteBookId.equals(noteBookId)))
        .go();
    if (clearState) {
      state = [];
    }
  }

  Future<void> deleteNotePage(int id) async {
    await (_database.delete(_database.notePageBatchEntries)
          ..where((tbl) => tbl.notePageId.equals(id)))
        .go();
    await (_database.delete(_database.notePages)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
    state = state.where((notePage) => notePage.id != id).toList();
  }

  Future<void> renameNotePage(int id, String title) async {
    final currentTime = DateTime.now();
    await (_database.update(_database.notePages)
          ..where((tbl) => tbl.id.equals(id)))
        .write(
      NotePagesCompanion(
        title: Value(title),
        updatedAt: Value(currentTime),
      ),
    );
    state = [
      for (final page in state)
        if (page.id == id)
          page.copyWith(
            title: title,
            updatedAt: currentTime,
          )
        else
          page,
    ];
  }

  Future<void> reorderNotePages(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final page = state[oldIndex];
    _remove(oldIndex);
    _insert(newIndex, page);
    for (int i = 0; i < state.length; i++) {
      await (_database.update(_database.notePages)
            ..where((tbl) => tbl.id.equals(state[i].id)))
          .write(
        NotePagesCompanion(
          index: Value(i),
        ),
      );
    }
  }

  Future<void> addNotePageBatch(int id, int batchId) async {
    await (_database.into(_database.notePageBatchEntries).insert(
          NotePageBatchEntriesCompanion.insert(
            notePageId: id,
            noteBatchId: batchId,
          ),
        ));

    final batch = await (_database.select(_database.noteBatches)
          ..where((tbl) => tbl.id.equals(batchId)))
        .getSingle();

    state = [
      for (final page in state)
        if (page.id == id)
          page.copyWith(
            batches: [
              ...page.batches,
              NoteBatch.fromRow(row: batch),
            ],
          )
        else
          page,
    ];
  }

  Future<void> deleteNotePageBatch(int id, int batchId) async {
    await (_database.delete(_database.notePageBatchEntries)
          ..where((tbl) =>
              tbl.notePageId.equals(id) & tbl.noteBatchId.equals(batchId)))
        .go();

    state = [
      for (final page in state)
        if (page.id == id)
          page.copyWith(
            batches:
                page.batches.where((batch) => batch.id != batchId).toList(),
          )
        else
          page,
    ];
  }

  Future<void> deleteAllNotePageBatches(int batchId) async {
    // only delete batches in state
    state = state
        .map(
          (page) => page.copyWith(
            batches:
                page.batches.where((batch) => batch.id != batchId).toList(),
          ),
        )
        .toList();
  }

  void _add(NotePage notePage) {
    state = [
      ...state,
      notePage,
    ];
  }

  void _insert(int index, NotePage notePage) {
    state = [
      ...state.sublist(0, index),
      notePage,
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

final notePagesProvider =
    StateNotifierProvider<NotePagesStateNotifier, List<NotePage>>(
  (ref) {
    return NotePagesStateNotifier();
  },
);
