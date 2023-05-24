import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesketch/extension/markdown/editing_controller.dart';
import 'package:notesketch/providers/books_provider.dart';
import 'package:notesketch/providers/pages_provider.dart';
import 'package:notesketch/utils/time_format.dart';

final editorController = StateProvider((ref) {
  return MdHighLightTextEditingController();
});

final drawerPageController = StateProvider((ref) {
  return PageController(initialPage: ref.watch(drawerPageIndexProvider));
});

final drawerPageIndexProvider = StateProvider((ref) => 0);

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NoteSketch"),
        shadowColor: Colors.black.withAlpha(100),
      ),
      drawer: pageDrawer(),
      body: pageBody(),
    );
  }

  Widget pageBody() {
    return Consumer(
      builder: (context, ref, child) {
        final currentBook = ref.watch(currentBookProvider);
        final currentPage = ref.watch(currentPageProvider);
        return currentPage == null || currentBook == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_back_ios,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      Text(
                        "select the book",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                ],
              )
            : Column(
                children: [
                  SizedBox(
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(36, 24, 24, 24),
                          child: Icon(Icons.auto_stories),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${currentBook.title} /",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  currentPage.title,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: PopupMenuButton(
                            shadowColor: Colors.black.withAlpha(0),
                            position: PopupMenuPosition.under,
                            icon: const Icon(Icons.info),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("created"),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          toDisplay(currentPage.updatedAt)),
                                    ),
                                    const Text("updated"),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          toDisplay(currentPage.createdAt)),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: IconButton(
                            onPressed: () async {
                              final content = ref
                                  .read(editorController.notifier)
                                  .state
                                  .text;
                              await ref
                                  .read(pagesProvider.notifier)
                                  .editPage(currentPage.id, content);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("saved"),
                                  duration: Duration(seconds: 1),
                                ));
                              }
                            },
                            icon: const Icon(Icons.save),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 25, 25, 25),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextField(
                          controller:
                              ref.watch(editorController.notifier).state,
                          maxLines: null,
                          expands: true,
                          autofocus: false,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                          strutStyle: const StrutStyle(
                            fontSize: 20,
                          ),
                          cursorHeight: 20,
                          decoration: const InputDecoration(
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
      },
    );
  }

  Widget pageDrawer() {
    return Consumer(
      builder: (context, ref, child) {
        return Drawer(
          child: PageView(
            controller: ref.watch(drawerPageController.notifier).state,
            children: [
              booksList(context),
              pagesList(context),
            ],
            onPageChanged: (value) {
              ref
                  .read(drawerPageIndexProvider.notifier)
                  .update((state) => value);
            },
          ),
        );
      },
    );
  }

  Widget booksList(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final books = ref.watch(booksProvider);
      return Column(
        children: [
          DrawerHeader(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/images/icon.png",
                  width: 108,
                  height: 108,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Notesketch",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Text(
                      "by oya-tomo",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            textColor: Theme.of(context).colorScheme.primary,
            iconColor: Theme.of(context).colorScheme.primary,
            leading: const Icon(Icons.add),
            title: const Text("create book"),
            onTap: () async {
              showAddBookDialog(context);
            },
          ),
          Expanded(
            child: books.when(
              data: (books) {
                return ReorderableListView(
                  children: books.map((book) {
                    return ListTile(
                      key: GlobalKey(),
                      leading: const Icon(Icons.menu_book),
                      title: Text(book.title),
                      trailing: PopupMenuButton(
                        icon: const Icon(Icons.more_horiz),
                        onSelected: (value) async {
                          if (value == "rename") {
                            showRenameBookDialog(context, book.id);
                          } else if (value == "delete") {
                            showRemoveBookDialog(context, book.id);
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
                            .read(currentBookIdProvider.notifier)
                            .update((state) => book.id);
                        ref.read(drawerPageController.notifier).state.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.decelerate,
                            );
                      },
                    );
                  }).toList(),
                  onReorder: (oldIndex, newIndex) async {
                    final ids = books.map((book) => book.id).toList();
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final item = ids.removeAt(oldIndex);
                    ids.insert(newIndex, item);
                    await ref.read(booksProvider.notifier).order(ids);
                  },
                );
              },
              error: (error, stack) {
                return const Text("error !!");
              },
              loading: () {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                  ],
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget pagesList(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final currentBook = ref.watch(currentBookProvider);
        final bookPages = ref.watch(bookPagesProvider);
        return currentBook == null
            ? Column(
                children: [
                  DrawerHeader(
                    child: Row(
                      children: [
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "select book",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        )),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                ref
                                    .read(drawerPageController.notifier)
                                    .state
                                    .previousPage(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.decelerate);
                              },
                              icon: const Icon(Icons.arrow_back),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  DrawerHeader(
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 24, horizontal: 18),
                          child: Icon(Icons.menu_book),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  currentBook.title,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                              Text(
                                toDisplay(currentBook.updatedAt),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                      color: Colors.grey,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                ref
                                    .read(drawerPageController.notifier)
                                    .state
                                    .previousPage(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.decelerate);
                              },
                              icon: const Icon(Icons.arrow_back),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    textColor: Theme.of(context).colorScheme.primary,
                    iconColor: Theme.of(context).colorScheme.primary,
                    leading: const Icon(Icons.add),
                    title: const Text("create page"),
                    onTap: () async {
                      showAddPageDialog(context);
                    },
                  ),
                  Expanded(
                    child: bookPages == null
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                            ],
                          )
                        : ReorderableListView(
                            children: bookPages.map((page) {
                              return ListTile(
                                key: GlobalKey(),
                                leading: const Icon(Icons.auto_stories),
                                title: Text(page.title),
                                trailing: PopupMenuButton(
                                  icon: const Icon(Icons.more_horiz),
                                  onSelected: (value) {
                                    if (value == "rename") {
                                      showRenamePageDialog(context, page.id);
                                    } else if (value == "delete") {
                                      showRemovePageDialog(context, page.id);
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
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  ref
                                      .read(currentPageIdProvider.notifier)
                                      .update((state) => page.id);
                                  ref
                                      .read(editorController.notifier)
                                      .state
                                      .text = page.content;
                                  Navigator.pop(context);
                                },
                              );
                            }).toList(),
                            onReorder: (oldIndex, newIndex) async {
                              final ids =
                                  bookPages.map((page) => page.id).toList();
                              if (oldIndex < newIndex) {
                                newIndex -= 1;
                              }
                              final item = ids.removeAt(oldIndex);
                              ids.insert(newIndex, item);
                              await ref.read(pagesProvider.notifier).order(ids);
                            },
                          ),
                  )
                ],
              );
      },
    );
  }

  void showAddBookDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final nameTextController = TextEditingController();
        return Consumer(builder: (context, ref, child) {
          return AlertDialog(
            title: const Text("create book"),
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
                        .read(booksProvider.notifier)
                        .addBook(nameTextController.text);
                  }
                },
              ),
            ],
          );
        });
      },
    );
  }

  void showAddPageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final nameTextController = TextEditingController();
        return Consumer(builder: (context, ref, child) {
          final currentBook = ref.watch(currentBookProvider);
          return AlertDialog(
            title: const Text("create page"),
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
                        .read(pagesProvider.notifier)
                        .addPage(currentBook!.id, nameTextController.text);
                  }
                },
              ),
            ],
          );
        });
      },
    );
  }

  void showRenameBookDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) {
        final nameTextController = TextEditingController();
        return Consumer(builder: (context, ref, child) {
          return AlertDialog(
            title: const Text("rename book"),
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
                        .read(booksProvider.notifier)
                        .renameBook(id, nameTextController.text);
                  }
                },
              ),
            ],
          );
        });
      },
    );
  }

  void showRenamePageDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) {
        final nameTextController = TextEditingController();
        return Consumer(builder: (context, ref, child) {
          return AlertDialog(
            title: const Text("rename page"),
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
                        .read(pagesProvider.notifier)
                        .renamePage(id, nameTextController.text);
                  }
                },
              ),
            ],
          );
        });
      },
    );
  }

  void showRemoveBookDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer(builder: (context, ref, build) {
          return AlertDialog(
            title: const Text("delete book"),
            content: const Text("The book is\npermanently deleted.\nIs it OK?"),
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
                  Navigator.pop(context);
                  await ref.read(booksProvider.notifier).removeBook(id);
                },
              ),
            ],
          );
        });
      },
    );
  }

  void showRemovePageDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer(builder: (context, ref, build) {
          return AlertDialog(
            title: const Text("delete page"),
            content: const Text("The page is\npermanently deleted.\nIs it OK?"),
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
                  Navigator.pop(context);
                  await ref.read(pagesProvider.notifier).removePage(id);
                },
              ),
            ],
          );
        });
      },
    );
  }
}
