import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesketch/model/notebatches.dart';
import 'package:notesketch/model/notebooks.dart';
import 'package:notesketch/model/notepages.dart';
import 'package:notesketch/view/color_themes.dart';
import 'package:notesketch/view/components/batch.dart';
import 'package:notesketch/view/components/batch_selector.dart';
import 'package:notesketch/view/components/gradient_button.dart';
import 'package:notesketch/view/components/gradient_divider.dart';
import 'package:notesketch/view/notebatch_page.dart';
import 'package:notesketch/view/utils.dart';
import 'package:notesketch/view_model/notebooks_page_model.dart';

class NoteBooksPage extends StatelessWidget {
  const NoteBooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notesketch"),
      ),
      drawer: Consumer(builder: (context, ref, child) {
        final noteBooksPageState =
            ref.watch(noteBooksPageStateProvider.notifier)..restoreDrawer();
        return Drawer(
          child: PageView(
            key: GlobalKey(),
            controller: noteBooksPageState.pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              noteBookList(),
              notePageList(),
            ],
            onPageChanged: (value) {
              ref
                  .read(noteBooksPageStateProvider.notifier)
                  .setDrawerPageIndex(value);
            },
          ),
        );
      }),
      body: pageEditBody(),
    );
  }

  Consumer pageEditBody() {
    return Consumer(
      builder: (context, ref, child) {
        final noteBooksPageState = ref.watch(noteBooksPageStateProvider);
        final noteBatches = ref.watch(noteBatchesProvider);
        ref.watch(notePagesProvider);
        if (noteBooksPageState.openingNotePageId != null) {
          final openingNotePage = ref
              .watch(notePagesProvider.notifier)
              .getNotePage(noteBooksPageState.openingNotePageId!)!;
          return Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 10, 10, 10),
                ),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Icon(Icons.description),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                openingNotePage.title,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              SizedBox(
                                height: 30,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: noteBatches
                                            .where((batch) => openingNotePage
                                                .batchesId
                                                .contains(batch.id))
                                            .map((batch) {
                                          return Center(
                                            child: NotePageBatch(
                                              title: batch.title,
                                              color: batch.color,
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: IconButton(
                          icon: const Icon(Icons.save),
                          onPressed: () {
                            ref.read(notePagesProvider.notifier).saveNotePage(
                                  openingNotePage.id,
                                  ref
                                      .watch(
                                          noteBooksPageStateProvider.notifier)
                                      .textEditingController
                                      .text,
                                );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: ref
                      .watch(noteBooksPageStateProvider.notifier)
                      .textEditingController,
                  maxLines: null,
                  expands: true,
                  autofocus: false,
                ),
              ),
            ],
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Center(
                child: Text("Please open any page."),
              ),
            ],
          );
        }
      },
    );
  }

  Widget noteBookList() {
    return Consumer(builder: (context, ref, child) {
      final noteBooks = ref.watch(noteBooksProvider);

      return Column(
        children: [
          DrawerHeader(
              child: Center(
            child: Row(
              children: [
                Image.asset(
                  "assets/images/icon.png",
                  width: 108,
                  height: 108,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "NoteSketch",
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      "by Oya-Tomo",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
          ListTile(
            leading: const Icon(Icons.arrow_forward),
            title: const Text("Go to page list"),
            onTap: () {
              ref.read(noteBooksPageStateProvider.notifier).switchDrawerNext();
            },
          ),
          const GradientDivider(gradient: gradient),
          Container(
            padding: const EdgeInsets.all(10),
            child: GradientButton(
              onPressed: () {
                showCreateNoteBookDialog(context);
              },
              borderRadius: BorderRadius.circular(100),
              gradient: gradient,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.add),
                  Text('Create notebook'),
                ],
              ),
            ),
          ),
          Expanded(
            child: ReorderableListView(
                children: noteBooks.map((noteBook) {
                  return ListTile(
                    key: GlobalKey(),
                    leading: const Icon(Icons.menu_book),
                    title: Text(noteBook.title),
                    subtitle:
                        Text("updated : ${formatDateTime(noteBook.updatedAt)}"),
                    trailing: PopupMenuButton(
                      icon: const Icon(Icons.more_horiz),
                      onSelected: (value) {
                        if (value == "rename") {
                          showRenameNoteBookDialog(context, noteBook.id);
                        } else {
                          showDeleteNoteBookDialog(context, noteBook.id);
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: "rename",
                          child: Text("rename"),
                        ),
                        PopupMenuItem(
                          value: "delete",
                          child: Text(
                            "delete",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      ref
                          .read(notePagesProvider.notifier)
                          .openNoteBook(noteBook.id);
                      ref
                          .read(noteBooksPageStateProvider.notifier)
                          .openNoteBook(noteBook.id);
                      ref
                          .read(noteBooksPageStateProvider.notifier)
                          .switchDrawerNext();
                    },
                    selected: ref
                            .watch(noteBooksPageStateProvider)
                            .openingNoteBookId ==
                        noteBook.id,
                    selectedColor: Colors.white,
                    selectedTileColor: Colors.black12,
                  );
                }).toList(),
                onReorder: (oldIndex, newIndex) {
                  ref
                      .read(noteBooksProvider.notifier)
                      .reorderNoteBooks(oldIndex, newIndex);
                }),
          ),
        ],
      );
    });
  }

  void showCreateNoteBookDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final nameTextController = TextEditingController();
        return Consumer(builder: (context, ref, child) {
          return AlertDialog(
            title: const Text("create notebook"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameTextController,
                  maxLength: 40,
                  maxLines: 1,
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text("cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text("continue"),
                onPressed: () async {
                  if (nameTextController.text == "") {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("empty name !!"),
                      duration: Duration(seconds: 3),
                    ));
                  } else {
                    Navigator.pop(context);
                    await ref
                        .read(noteBooksProvider.notifier)
                        .createNoteBook(nameTextController.text);
                  }
                },
              ),
            ],
          );
        });
      },
    );
  }

  void showRenameNoteBookDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) {
        final nameTextController = TextEditingController();
        return Consumer(builder: (context, ref, child) {
          return AlertDialog(
            title: const Text("rename notebook"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameTextController,
                  maxLength: 40,
                  maxLines: 1,
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text("cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text("continue"),
                onPressed: () {
                  if (nameTextController.text == "") {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("empty name !!"),
                      duration: Duration(seconds: 3),
                    ));
                  } else {
                    Navigator.pop(context);
                    ref
                        .read(noteBooksProvider.notifier)
                        .renameNoteBook(id, nameTextController.text);
                  }
                },
              ),
            ],
          );
        });
      },
    );
  }

  void showDeleteNoteBookDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer(builder: (context, ref, build) {
          final noteBooksPageState = ref.watch(noteBooksPageStateProvider);
          return AlertDialog(
            title: const Text("delete notebook"),
            content:
                const Text("The notebook is\npermanently deleted.\nIs it OK?"),
            actions: [
              TextButton(
                child: const Text("cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text("continue"),
                onPressed: () {
                  Navigator.pop(context);
                  if (noteBooksPageState.openingNoteBookId == id) {
                    ref
                        .read(noteBooksPageStateProvider.notifier)
                        .closeNoteBook();
                    ref
                        .read(noteBooksPageStateProvider.notifier)
                        .closeNotePage();
                    ref
                        .read(notePagesProvider.notifier)
                        .deleteNoteBookPages(id, true);
                  } else {
                    ref
                        .read(notePagesProvider.notifier)
                        .deleteNoteBookPages(id, false);
                  }
                  ref.read(noteBooksProvider.notifier).deleteNoteBook(id);
                },
              ),
            ],
          );
        });
      },
    );
  }

  Widget notePageList() {
    return Consumer(builder: (context, ref, child) {
      final notePages = ref.watch(notePagesProvider);
      final noteBatches = ref.watch(noteBatchesProvider);
      final notePageState = ref.watch(noteBooksPageStateProvider);
      if (notePageState.openingNoteBookId != null) {
        final openingNoteBook =
            ref.watch(noteBooksProvider.notifier).getNoteBook(
                  notePageState.openingNoteBookId!,
                );
        return Column(
          children: [
            DrawerHeader(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.menu_book),
                        ),
                        Text(
                          openingNoteBook!.title,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                    Text(
                      "updated : ${formatDateTime(openingNoteBook.updatedAt)}",
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                        "created : ${formatDateTime(openingNoteBook.createdAt)}",
                        style: const TextStyle(fontSize: 12))
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.arrow_back),
              title: const Text("Go to book list"),
              onTap: () {
                ref
                    .read(noteBooksPageStateProvider.notifier)
                    .switchDrawerBack();
              },
            ),
            ListTile(
              leading: const Icon(Icons.arrow_forward),
              title: const Text("Go to batch list"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NoteBatchPage(),
                  ),
                );
              },
            ),
            const GradientDivider(gradient: gradient),
            Container(
              padding: const EdgeInsets.all(10),
              child: GradientButton(
                onPressed: () {
                  showCreateNotePageDialog(context, openingNoteBook.id);
                },
                borderRadius: BorderRadius.circular(100),
                gradient: gradient,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.add),
                    Text('Create page'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ReorderableListView(
                onReorder: (int oldIndex, int newIndex) {
                  ref
                      .read(notePagesProvider.notifier)
                      .reorderNotePages(oldIndex, newIndex);
                },
                children: notePages.map((notePage) {
                  final filterdBatches = noteBatches
                      .where((batch) => notePage.batchesId.contains(batch.id));
                  return ListTile(
                    key: GlobalKey(),
                    leading: const Icon(Icons.description),
                    title: Text(notePage.title),
                    subtitle: filterdBatches.isNotEmpty
                        ? SizedBox(
                            height: 30,
                            child: Row(
                              children: [
                                Expanded(
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: filterdBatches.map((batch) {
                                      return Center(
                                        child: NotePageBatch(
                                          title: batch.title,
                                          color: batch.color,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const Text(
                            "no batches...",
                            style: TextStyle(
                              color: Colors.white38,
                            ),
                          ),
                    trailing: PopupMenuButton(
                      icon: const Icon(Icons.more_horiz),
                      onSelected: (value) {
                        if (value == "add batch") {
                          if (noteBatches.length != notePage.batchesId.length) {
                            showAddNotePageBatchDialog(context, notePage.id);
                          }
                        } else if (value == "delete batch") {
                          if (notePage.batchesId.isNotEmpty) {
                            showDeleteNotePageBatchDialog(context, notePage.id);
                          }
                        } else if (value == "rename") {
                          showRenameNotePageDialog(context, notePage.id);
                        } else {
                          showDeleteNotePageDialog(context, notePage.id);
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: "add batch",
                          child: Text("add batch"),
                        ),
                        PopupMenuItem(
                          value: "delete batch",
                          child: Text("delete batch"),
                        ),
                        PopupMenuItem(
                          value: "rename",
                          child: Text("rename"),
                        ),
                        PopupMenuItem(
                          value: "delete",
                          child: Text(
                            "delete",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      ref
                          .read(noteBooksPageStateProvider.notifier)
                          .openNotePage(notePage.id, notePage.content);
                    },
                    selected: notePageState.openingNotePageId == notePage.id,
                    selectedColor: Colors.white,
                    selectedTileColor: Colors.black12,
                  );
                }).toList(),
              ),
            ),
          ],
        );
      } else {
        return Column(
          children: [
            const DrawerHeader(
              child: Center(
                child: Text("no pages"),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.arrow_back),
              title: const Text("Go to book list"),
              onTap: () {
                ref
                    .read(noteBooksPageStateProvider.notifier)
                    .switchDrawerBack();
              },
            ),
          ],
        );
      }
    });
  }

  void showCreateNotePageDialog(BuildContext context, int noteBookId) {
    showDialog(
      context: context,
      builder: (context) {
        final nameTextController = TextEditingController();
        return Consumer(builder: (context, ref, child) {
          return AlertDialog(
            title: const Text("create notepage"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameTextController,
                  maxLength: 40,
                  maxLines: 1,
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text("cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text("continue"),
                onPressed: () async {
                  if (nameTextController.text == "") {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("empty name !!"),
                      duration: Duration(seconds: 3),
                    ));
                  } else {
                    Navigator.pop(context);
                    await ref
                        .read(notePagesProvider.notifier)
                        .createNotePage(noteBookId, nameTextController.text);
                  }
                },
              ),
            ],
          );
        });
      },
    );
  }

  void showRenameNotePageDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) {
        final nameTextController = TextEditingController();
        return Consumer(builder: (context, ref, child) {
          return AlertDialog(
            title: const Text("rename notepage"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameTextController,
                  maxLength: 40,
                  maxLines: 1,
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text("cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text("continue"),
                onPressed: () {
                  if (nameTextController.text == "") {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("empty name !!"),
                      duration: Duration(seconds: 3),
                    ));
                  } else {
                    Navigator.pop(context);
                    ref
                        .read(notePagesProvider.notifier)
                        .renameNotePage(id, nameTextController.text);
                  }
                },
              ),
            ],
          );
        });
      },
    );
  }

  void showDeleteNotePageDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer(builder: (context, ref, build) {
          final noteBooksPageState = ref.watch(noteBooksPageStateProvider);
          return AlertDialog(
            title: const Text("delete notepage"),
            content:
                const Text("The notepage is\npermanently deleted.\nIs it OK?"),
            actions: [
              TextButton(
                child: const Text("cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text("continue"),
                onPressed: () {
                  Navigator.pop(context);
                  if (noteBooksPageState.openingNotePageId == id) {
                    ref
                        .read(noteBooksPageStateProvider.notifier)
                        .closeNotePage();
                  }
                  ref.read(notePagesProvider.notifier).deleteNotePage(id);
                },
              ),
            ],
          );
        });
      },
    );
  }

  void showAddNotePageBatchDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final notePage =
                ref.read(notePagesProvider.notifier).getNotePage(id)!;
            final noteBatches = ref
                .watch(noteBatchesProvider)
                .where((batch) => !notePage.batchesId.contains(batch.id))
                .toList();
            int? selectedValue;
            return AlertDialog(
              title: const Text("Add Batch"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  NoteBatchSelector(
                    batches: noteBatches,
                    onChanged: (value) {
                      selectedValue = value;
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("cancel"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (selectedValue != null) {
                      ref
                          .read(notePagesProvider.notifier)
                          .addNotePageBatch(id, selectedValue!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("select anyone !!"),
                        duration: Duration(seconds: 3),
                      ));
                    }
                  },
                  child: const Text("continue"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showDeleteNotePageBatchDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final notePage =
                ref.read(notePagesProvider.notifier).getNotePage(id)!;
            final noteBatches = ref
                .watch(noteBatchesProvider)
                .where((batch) => notePage.batchesId.contains(batch.id))
                .toList();
            int? selectedValue;
            return AlertDialog(
              title: const Text("Delete Batch"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  NoteBatchSelector(
                    batches: noteBatches,
                    onChanged: (value) {
                      selectedValue = value;
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("cancel"),
                ),
                TextButton(
                  onPressed: () {
                    if (selectedValue != null) {
                      Navigator.pop(context);
                      ref
                          .read(notePagesProvider.notifier)
                          .deleteNotePageBatch(id, selectedValue!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("select anyone"),
                        duration: Duration(seconds: 3),
                      ));
                    }
                  },
                  child: const Text("continue"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
