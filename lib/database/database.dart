import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

part 'database.g.dart';

@UseRowClass(NoteBookRow)
class NoteBooks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get index => integer()();
  TextColumn get title => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class NoteBookRow {
  int id;
  int index;
  String title;
  DateTime createdAt;
  DateTime updatedAt;
  NoteBookRow({
    required this.id,
    required this.index,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
  });
}

@UseRowClass(NotePageRow)
class NotePages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get index => integer()();
  IntColumn get noteBookId => integer().references(NoteBooks, #id)();
  TextColumn get title => text()();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class NotePageRow {
  int id;
  int index;
  int noteBookId;
  String title;
  String content;
  DateTime createdAt;
  DateTime updatedAt;
  NotePageRow({
    required this.id,
    required this.index,
    required this.noteBookId,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });
}

@UseRowClass(NoteBatchRow)
class NoteBatches extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get index => integer()();
  TextColumn get title => text()();
  IntColumn get color => integer()();
}

class NoteBatchRow {
  int id;
  int index;
  String title;
  int color;
  NoteBatchRow({
    required this.id,
    required this.index,
    required this.title,
    required this.color,
  });
}

@UseRowClass(NotePageBatchEntry)
class NotePageBatchEntries extends Table {
  IntColumn get notePageId => integer().references(NotePages, #id)();
  IntColumn get noteBatchId => integer().references(NoteBatches, #id)();
}

class NotePageBatchEntry {
  int notePageId;
  int noteBatchId;
  NotePageBatchEntry({
    required this.notePageId,
    required this.noteBatchId,
  });
}

@DriftDatabase(
    tables: [NoteBooks, NotePages, NoteBatches, NotePageBatchEntries])
class DataBase extends _$DataBase {
  DataBase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  void test() {}
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'database.sqlite'));
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    return NativeDatabase.createInBackground(file);
  });
}

final database = DataBase();
