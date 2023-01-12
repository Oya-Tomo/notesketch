// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $NoteBooksTable extends NoteBooks
    with TableInfo<$NoteBooksTable, NoteBookRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NoteBooksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _indexMeta = const VerificationMeta('index');
  @override
  late final GeneratedColumn<int> index = GeneratedColumn<int>(
      'index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, index, title, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? 'note_books';
  @override
  String get actualTableName => 'note_books';
  @override
  VerificationContext validateIntegrity(Insertable<NoteBookRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('index')) {
      context.handle(
          _indexMeta, index.isAcceptableOrUnknown(data['index']!, _indexMeta));
    } else if (isInserting) {
      context.missing(_indexMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NoteBookRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoteBookRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      index: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}index'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $NoteBooksTable createAlias(String alias) {
    return $NoteBooksTable(attachedDatabase, alias);
  }
}

class NoteBooksCompanion extends UpdateCompanion<NoteBookRow> {
  final Value<int> id;
  final Value<int> index;
  final Value<String> title;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const NoteBooksCompanion({
    this.id = const Value.absent(),
    this.index = const Value.absent(),
    this.title = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  NoteBooksCompanion.insert({
    this.id = const Value.absent(),
    required int index,
    required String title,
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : index = Value(index),
        title = Value(title),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<NoteBookRow> custom({
    Expression<int>? id,
    Expression<int>? index,
    Expression<String>? title,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (index != null) 'index': index,
      if (title != null) 'title': title,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  NoteBooksCompanion copyWith(
      {Value<int>? id,
      Value<int>? index,
      Value<String>? title,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return NoteBooksCompanion(
      id: id ?? this.id,
      index: index ?? this.index,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (index.present) {
      map['index'] = Variable<int>(index.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NoteBooksCompanion(')
          ..write('id: $id, ')
          ..write('index: $index, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $NotePagesTable extends NotePages
    with TableInfo<$NotePagesTable, NotePageRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotePagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _indexMeta = const VerificationMeta('index');
  @override
  late final GeneratedColumn<int> index = GeneratedColumn<int>(
      'index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _noteBookIdMeta =
      const VerificationMeta('noteBookId');
  @override
  late final GeneratedColumn<int> noteBookId = GeneratedColumn<int>(
      'note_book_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES note_books (id)'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, index, noteBookId, title, content, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? 'note_pages';
  @override
  String get actualTableName => 'note_pages';
  @override
  VerificationContext validateIntegrity(Insertable<NotePageRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('index')) {
      context.handle(
          _indexMeta, index.isAcceptableOrUnknown(data['index']!, _indexMeta));
    } else if (isInserting) {
      context.missing(_indexMeta);
    }
    if (data.containsKey('note_book_id')) {
      context.handle(
          _noteBookIdMeta,
          noteBookId.isAcceptableOrUnknown(
              data['note_book_id']!, _noteBookIdMeta));
    } else if (isInserting) {
      context.missing(_noteBookIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotePageRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotePageRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      index: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}index'])!,
      noteBookId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}note_book_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $NotePagesTable createAlias(String alias) {
    return $NotePagesTable(attachedDatabase, alias);
  }
}

class NotePagesCompanion extends UpdateCompanion<NotePageRow> {
  final Value<int> id;
  final Value<int> index;
  final Value<int> noteBookId;
  final Value<String> title;
  final Value<String> content;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const NotePagesCompanion({
    this.id = const Value.absent(),
    this.index = const Value.absent(),
    this.noteBookId = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  NotePagesCompanion.insert({
    this.id = const Value.absent(),
    required int index,
    required int noteBookId,
    required String title,
    required String content,
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : index = Value(index),
        noteBookId = Value(noteBookId),
        title = Value(title),
        content = Value(content),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<NotePageRow> custom({
    Expression<int>? id,
    Expression<int>? index,
    Expression<int>? noteBookId,
    Expression<String>? title,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (index != null) 'index': index,
      if (noteBookId != null) 'note_book_id': noteBookId,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  NotePagesCompanion copyWith(
      {Value<int>? id,
      Value<int>? index,
      Value<int>? noteBookId,
      Value<String>? title,
      Value<String>? content,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return NotePagesCompanion(
      id: id ?? this.id,
      index: index ?? this.index,
      noteBookId: noteBookId ?? this.noteBookId,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (index.present) {
      map['index'] = Variable<int>(index.value);
    }
    if (noteBookId.present) {
      map['note_book_id'] = Variable<int>(noteBookId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotePagesCompanion(')
          ..write('id: $id, ')
          ..write('index: $index, ')
          ..write('noteBookId: $noteBookId, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $NoteBatchesTable extends NoteBatches
    with TableInfo<$NoteBatchesTable, NoteBatchRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NoteBatchesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _indexMeta = const VerificationMeta('index');
  @override
  late final GeneratedColumn<int> index = GeneratedColumn<int>(
      'index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
      'color', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, index, title, color];
  @override
  String get aliasedName => _alias ?? 'note_batches';
  @override
  String get actualTableName => 'note_batches';
  @override
  VerificationContext validateIntegrity(Insertable<NoteBatchRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('index')) {
      context.handle(
          _indexMeta, index.isAcceptableOrUnknown(data['index']!, _indexMeta));
    } else if (isInserting) {
      context.missing(_indexMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NoteBatchRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoteBatchRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      index: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}index'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color'])!,
    );
  }

  @override
  $NoteBatchesTable createAlias(String alias) {
    return $NoteBatchesTable(attachedDatabase, alias);
  }
}

class NoteBatchesCompanion extends UpdateCompanion<NoteBatchRow> {
  final Value<int> id;
  final Value<int> index;
  final Value<String> title;
  final Value<int> color;
  const NoteBatchesCompanion({
    this.id = const Value.absent(),
    this.index = const Value.absent(),
    this.title = const Value.absent(),
    this.color = const Value.absent(),
  });
  NoteBatchesCompanion.insert({
    this.id = const Value.absent(),
    required int index,
    required String title,
    required int color,
  })  : index = Value(index),
        title = Value(title),
        color = Value(color);
  static Insertable<NoteBatchRow> custom({
    Expression<int>? id,
    Expression<int>? index,
    Expression<String>? title,
    Expression<int>? color,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (index != null) 'index': index,
      if (title != null) 'title': title,
      if (color != null) 'color': color,
    });
  }

  NoteBatchesCompanion copyWith(
      {Value<int>? id,
      Value<int>? index,
      Value<String>? title,
      Value<int>? color}) {
    return NoteBatchesCompanion(
      id: id ?? this.id,
      index: index ?? this.index,
      title: title ?? this.title,
      color: color ?? this.color,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (index.present) {
      map['index'] = Variable<int>(index.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NoteBatchesCompanion(')
          ..write('id: $id, ')
          ..write('index: $index, ')
          ..write('title: $title, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }
}

class $NotePageBatchEntriesTable extends NotePageBatchEntries
    with TableInfo<$NotePageBatchEntriesTable, NotePageBatchEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotePageBatchEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _notePageIdMeta =
      const VerificationMeta('notePageId');
  @override
  late final GeneratedColumn<int> notePageId = GeneratedColumn<int>(
      'note_page_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES note_pages (id)'));
  static const VerificationMeta _noteBatchIdMeta =
      const VerificationMeta('noteBatchId');
  @override
  late final GeneratedColumn<int> noteBatchId = GeneratedColumn<int>(
      'note_batch_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES note_batches (id)'));
  @override
  List<GeneratedColumn> get $columns => [notePageId, noteBatchId];
  @override
  String get aliasedName => _alias ?? 'note_page_batch_entries';
  @override
  String get actualTableName => 'note_page_batch_entries';
  @override
  VerificationContext validateIntegrity(Insertable<NotePageBatchEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('note_page_id')) {
      context.handle(
          _notePageIdMeta,
          notePageId.isAcceptableOrUnknown(
              data['note_page_id']!, _notePageIdMeta));
    } else if (isInserting) {
      context.missing(_notePageIdMeta);
    }
    if (data.containsKey('note_batch_id')) {
      context.handle(
          _noteBatchIdMeta,
          noteBatchId.isAcceptableOrUnknown(
              data['note_batch_id']!, _noteBatchIdMeta));
    } else if (isInserting) {
      context.missing(_noteBatchIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  NotePageBatchEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotePageBatchEntry(
      notePageId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}note_page_id'])!,
      noteBatchId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}note_batch_id'])!,
    );
  }

  @override
  $NotePageBatchEntriesTable createAlias(String alias) {
    return $NotePageBatchEntriesTable(attachedDatabase, alias);
  }
}

class NotePageBatchEntriesCompanion
    extends UpdateCompanion<NotePageBatchEntry> {
  final Value<int> notePageId;
  final Value<int> noteBatchId;
  const NotePageBatchEntriesCompanion({
    this.notePageId = const Value.absent(),
    this.noteBatchId = const Value.absent(),
  });
  NotePageBatchEntriesCompanion.insert({
    required int notePageId,
    required int noteBatchId,
  })  : notePageId = Value(notePageId),
        noteBatchId = Value(noteBatchId);
  static Insertable<NotePageBatchEntry> custom({
    Expression<int>? notePageId,
    Expression<int>? noteBatchId,
  }) {
    return RawValuesInsertable({
      if (notePageId != null) 'note_page_id': notePageId,
      if (noteBatchId != null) 'note_batch_id': noteBatchId,
    });
  }

  NotePageBatchEntriesCompanion copyWith(
      {Value<int>? notePageId, Value<int>? noteBatchId}) {
    return NotePageBatchEntriesCompanion(
      notePageId: notePageId ?? this.notePageId,
      noteBatchId: noteBatchId ?? this.noteBatchId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (notePageId.present) {
      map['note_page_id'] = Variable<int>(notePageId.value);
    }
    if (noteBatchId.present) {
      map['note_batch_id'] = Variable<int>(noteBatchId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotePageBatchEntriesCompanion(')
          ..write('notePageId: $notePageId, ')
          ..write('noteBatchId: $noteBatchId')
          ..write(')'))
        .toString();
  }
}

abstract class _$DataBase extends GeneratedDatabase {
  _$DataBase(QueryExecutor e) : super(e);
  late final $NoteBooksTable noteBooks = $NoteBooksTable(this);
  late final $NotePagesTable notePages = $NotePagesTable(this);
  late final $NoteBatchesTable noteBatches = $NoteBatchesTable(this);
  late final $NotePageBatchEntriesTable notePageBatchEntries =
      $NotePageBatchEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [noteBooks, notePages, noteBatches, notePageBatchEntries];
}
