import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class NoteBooksPageState {
  const NoteBooksPageState({
    this.openingNoteBookId,
    this.openingNotePageId,
    required this.drawerPageIndex,
  });
  final int? openingNoteBookId;
  final int? openingNotePageId;
  final int drawerPageIndex;
}

class NoteBooksPageStateNotifier extends StateNotifier<NoteBooksPageState> {
  NoteBooksPageStateNotifier()
      : super(
          const NoteBooksPageState(drawerPageIndex: 0),
        );

  TextEditingController textEditingController = TextEditingController();
  PageController pageController = PageController();

  void openNoteBook(int noteBookId) {
    if (state.openingNoteBookId != noteBookId) {
      textEditingController.text = "";
    }
    state = NoteBooksPageState(
      openingNoteBookId: noteBookId,
      openingNotePageId: state.openingNoteBookId != noteBookId
          ? null
          : state.openingNotePageId,
      drawerPageIndex: state.drawerPageIndex,
    );
  }

  void closeNoteBook() {
    state = NoteBooksPageState(
      openingNoteBookId: null,
      openingNotePageId: state.openingNotePageId,
      drawerPageIndex: state.drawerPageIndex,
    );
  }

  void closeNotePage() {
    state = NoteBooksPageState(
      openingNoteBookId: state.openingNoteBookId,
      openingNotePageId: null,
      drawerPageIndex: state.drawerPageIndex,
    );
  }

  void openNotePage(int notePageId, String content) {
    state = NoteBooksPageState(
      openingNoteBookId: state.openingNoteBookId,
      openingNotePageId: notePageId,
      drawerPageIndex: state.drawerPageIndex,
    );
    textEditingController.text = content;
  }

  void restoreDrawer() {
    pageController = PageController(initialPage: state.drawerPageIndex);
  }

  void setDrawerPageIndex(int index) {
    state = NoteBooksPageState(
      openingNoteBookId: state.openingNoteBookId,
      openingNotePageId: state.openingNotePageId,
      drawerPageIndex: index,
    );
  }

  void switchDrawerNext() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );
  }

  void switchDrawerBack() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );
  }
}

final noteBooksPageStateProvider =
    StateNotifierProvider<NoteBooksPageStateNotifier, NoteBooksPageState>(
  (ref) {
    return NoteBooksPageStateNotifier();
  },
);
