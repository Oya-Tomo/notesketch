import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesketch/database/database.dart';

@immutable
class NoteBatch {
  const NoteBatch({
    required this.id,
    required this.title,
    required this.color,
  });

  factory NoteBatch.fromRow({required NoteBatchRow row}) {
    return NoteBatch(
      id: row.id,
      title: row.title,
      color: row.color,
    );
  }

  final int id;
  final String title;
  final int color;

  NoteBatch copyWith({
    int? id,
    String? title,
    int? color,
  }) {
    return NoteBatch(
      id: id ?? this.id,
      title: title ?? this.title,
      color: color ?? this.color,
    );
  }
}

class NoteBatchesStateNotifier extends StateNotifier<List<NoteBatch>> {
  NoteBatchesStateNotifier() : super([]);
  final DataBase _database = DataBase();
  void fetchData() async {
    final rows = (await _database.select(_database.noteBatches).get())
      ..sort((a, b) => a.index.compareTo(b.index));
    state = rows.map((row) => NoteBatch.fromRow(row: row)).toList();
  }

  NoteBatch? getNoteBatch(int id) {
    for (final batch in state) {
      if (batch.id == id) {
        return batch;
      }
    }
    return null;
  }

  Future<void> createNoteBatch(String title, Color color) async {
    final batchId = await (_database.into(_database.noteBatches).insert(
          NoteBatchesCompanion.insert(
            index: state.length,
            title: title,
            color: color.value,
          ),
        ));
    state = [
      ...state,
      NoteBatch(id: batchId, title: title, color: color.value)
    ];
  }

  Future<void> editNoteBatch(int id, String title, Color color) async {
    await (_database.update(_database.noteBatches)
          ..where((tbl) => tbl.id.equals(id)))
        .write(
      NoteBatchesCompanion(
        title: Value(title),
        color: Value(color.value),
      ),
    );

    state = [
      for (final batch in state)
        if (batch.id == id)
          batch.copyWith(title: title, color: color.value)
        else
          batch,
    ];
  }

  Future<void> deleteNoteBatch(int id) async {
    await (_database.delete(_database.notePageBatchEntries)
          ..where((tbl) => tbl.noteBatchId.equals(id)))
        .go();
    await (_database.delete(_database.noteBatches)
          ..where((tbl) => tbl.id.equals(id)))
        .go();

    state = state.where((batch) => batch.id != id).toList();
  }

  Future<void> reorderNoteBatches(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final batch = state[oldIndex];
    _remove(oldIndex);
    _insert(newIndex, batch);
    for (int i = 0; i < state.length; i++) {
      await (_database.update(_database.noteBatches)
            ..where((tbl) => tbl.id.equals(state[i].id)))
          .write(
        NoteBatchesCompanion(
          index: Value(i),
        ),
      );
    }
  }

  void _insert(int index, NoteBatch noteBatch) {
    state = [
      ...state.sublist(0, index),
      noteBatch,
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

final noteBatchesProvider =
    StateNotifierProvider<NoteBatchesStateNotifier, List<NoteBatch>>(
  (ref) {
    return NoteBatchesStateNotifier()..fetchData();
  },
);
