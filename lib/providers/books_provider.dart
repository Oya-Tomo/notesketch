import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesketch/database/database.dart';
import 'package:notesketch/providers/models.dart';

class BooksNotifier extends AsyncNotifier<List<Book>> {
  @override
  FutureOr<List<Book>> build() {
    return fetchAll();
  }

  Future<List<Book>> fetchAll() async {
    final books = await database.select(database.books).get();
    books.sort((a, b) => a.index.compareTo(b.index));
    return books.map((row) => Book.fromRow(row)).toList();
  }

  Future<void> addBook(String title) async {
    await database.into(database.books).insert(
          BooksCompanion(
            title: Value(title),
            index: const Value(0),
            createdAt: Value(DateTime.now()),
            updatedAt: Value(DateTime.now()),
          ),
        );
    state = await AsyncValue.guard(() {
      return fetchAll();
    });
  }

  Future<void> removeBook(int id) async {
    await (database.delete(database.books)..where((tbl) => tbl.id.equals(id)))
        .go();
    state = await AsyncValue.guard(() {
      return fetchAll();
    });
  }

  Future<void> renameBook(int id, String title) async {
    await (database.update(database.books)..where((tbl) => tbl.id.equals(id)))
        .write(
      BooksCompanion(
        title: Value(title),
        updatedAt: Value(DateTime.now()),
      ),
    );
    state = await AsyncValue.guard(() {
      return fetchAll();
    });
  }

  Future<void> order(List<int> orderedId) async {
    state = const AsyncValue.loading();
    await Future.forEach(orderedId.asMap().entries, (entry) async {
      await (database.update(database.books)
            ..where((tbl) => tbl.id.equals(entry.value)))
          .write(BooksCompanion(index: Value(entry.key)));
    });
    state = await AsyncValue.guard(() {
      return fetchAll();
    });
  }
}

final booksProvider = AsyncNotifierProvider<BooksNotifier, List<Book>>(() {
  return BooksNotifier();
});

final currentBookIdProvider = StateProvider<int?>((ref) {
  return null;
});

final currentBookProvider = StateProvider<Book?>((ref) {
  final books = ref.watch(booksProvider);
  final id = ref.watch(currentBookIdProvider);
  return books.when(
    data: (books) {
      return books.where((book) => book.id == id).firstOrNull;
    },
    error: (err, stack) => null,
    loading: () => null,
  );
});
