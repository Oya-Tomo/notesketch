import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesketch/database/database.dart';
import 'package:notesketch/providers/books_provider.dart';
import 'package:notesketch/providers/models.dart';

class PagesProvider extends AsyncNotifier<List<Page>> {
  @override
  FutureOr<List<Page>> build() {
    return fetchAll();
  }

  Future<List<Page>> fetchAll() async {
    final pages = await database.select(database.pages).get();
    pages.sort((a, b) => a.index.compareTo(b.index));
    return pages.map((row) => Page.fromRow(row)).toList();
  }

  Future<void> addPage(
    int bookId,
    String title,
  ) async {
    await database.into(database.pages).insert(
          PagesCompanion(
            bookId: Value(bookId),
            title: Value(title),
            content: const Value(""),
            index: const Value(0),
            createdAt: Value(DateTime.now()),
            updatedAt: Value(DateTime.now()),
          ),
        );
    state = await AsyncValue.guard(() {
      return fetchAll();
    });
  }

  Future<void> removePage(int id) async {
    await (database.delete(database.pages)..where((tbl) => tbl.id.equals(id)))
        .go();
    state = await AsyncValue.guard(() {
      return fetchAll();
    });
  }

  Future<void> renamePage(int id, String title) async {
    await (database.update(database.pages)..where((tbl) => tbl.id.equals(id)))
        .write(
      PagesCompanion(
        title: Value(title),
        updatedAt: Value(DateTime.now()),
      ),
    );
    state = await AsyncValue.guard(() {
      return fetchAll();
    });
  }

  Future<void> editPage(int id, String content) async {
    await (database.update(database.pages)..where((tbl) => tbl.id.equals(id)))
        .write(
      PagesCompanion(
        content: Value(content),
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
      await (database.update(database.pages)
            ..where((tbl) => tbl.id.equals(entry.value)))
          .write(PagesCompanion(index: Value(entry.key)));
    });
    state = await AsyncValue.guard(() {
      return fetchAll();
    });
  }
}

final pagesProvider = AsyncNotifierProvider<PagesProvider, List<Page>>(() {
  return PagesProvider();
});

final bookPagesProvider = StateProvider((ref) {
  final bookId = ref.watch(currentBookIdProvider);
  return ref.watch(pagesProvider).when(
    data: (pages) {
      return pages.where((page) => page.bookId == bookId).toList();
    },
    error: (error, stack) {
      return null;
    },
    loading: () {
      return null;
    },
  );
});

final currentPageIdProvider = StateProvider<int?>((ref) {
  return null;
});

final currentPageProvider = StateProvider((ref) {
  final pages = ref.watch(bookPagesProvider);
  final id = ref.watch(currentPageIdProvider);
  return pages?.where((page) => page.id == id).firstOrNull;
});
