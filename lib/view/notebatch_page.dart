import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesketch/model/notebatches.dart';
import 'package:notesketch/model/notepages.dart';
import 'package:notesketch/view/components/batch.dart';
import 'package:notesketch/view/components/color_slider.dart';

class NoteBatchPage extends StatelessWidget {
  const NoteBatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Notesketch - Batch List"),
        actions: [
          Consumer(builder: (context, ref, child) {
            return IconButton(
              onPressed: () {
                showCreateNoteBatchDialog(context);
              },
              icon: const Icon(Icons.add),
            );
          }),
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final noteBatches = ref.watch(noteBatchesProvider);
          return ReorderableListView(
            children: noteBatches.map((batch) {
              return ListTile(
                key: GlobalKey(),
                leading: NotePageBatch(
                  title: batch.title,
                  color: batch.color,
                ),
                title: Text(batch.title),
                subtitle: Text(
                    "r: ${Color(batch.color).red}   g: ${Color(batch.color).green}   b: ${Color(batch.color).blue}"),
                trailing: PopupMenuButton(
                  icon: const Icon(Icons.more_horiz),
                  onSelected: (value) {
                    if (value == "Edit") {
                      showEditNoteBatchDialog(context, batch.id);
                    } else {
                      showDeleteNoteBatchDialog(context, batch.id);
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: "Edit",
                      child: Text("Edit"),
                    ),
                    PopupMenuItem(
                      value: "Delete",
                      child: Text(
                        "Delete",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onReorder: (oldIndex, newIndex) {
              ref
                  .read(noteBatchesProvider.notifier)
                  .reorderNoteBatches(oldIndex, newIndex);
            },
          );
        },
      ),
    );
  }

  void showCreateNoteBatchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer(builder: (context, ref, child) {
          final nameTextController = TextEditingController();
          Color selectedColor = const Color.fromARGB(255, 50, 150, 120);
          return AlertDialog(
            title: const Text("Create Batch"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameTextController,
                  maxLength: 20,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    labelText: "Title",
                    hintText: "20 characters or less",
                  ),
                ),
                const Text("Color"),
                ColorSlider(
                  initialColor: selectedColor,
                  onChanged: (value) {
                    selectedColor = value;
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  if (nameTextController.text.isNotEmpty) {
                    Navigator.pop(context);
                    ref.read(noteBatchesProvider.notifier).createNoteBatch(
                          nameTextController.text,
                          selectedColor,
                        );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Empty name !!"),
                      duration: Duration(seconds: 3),
                    ));
                  }
                },
                child: const Text("Continue"),
              ),
            ],
          );
        });
      },
    );
  }

  void showEditNoteBatchDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final batch =
                ref.watch(noteBatchesProvider.notifier).getNoteBatch(id)!;
            final TextEditingController nameTextController =
                TextEditingController(text: batch.title);
            Color selectedColor = Color(batch.color);
            return AlertDialog(
              title: const Text("Edit Batch"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameTextController,
                    maxLength: 20,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      labelText: "Title",
                      hintText: "20 characters or less",
                    ),
                  ),
                  const Text("Color"),
                  ColorSlider(
                    initialColor: selectedColor,
                    onChanged: (value) {
                      selectedColor = value;
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    if (nameTextController.text.isNotEmpty) {
                      Navigator.pop(context);
                      ref.read(noteBatchesProvider.notifier).editNoteBatch(
                            id,
                            nameTextController.text,
                            selectedColor,
                          );
                    }
                  },
                  child: const Text("Continue"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showDeleteNoteBatchDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final batch =
                ref.watch(noteBatchesProvider.notifier).getNoteBatch(id)!;
            return AlertDialog(
              title: const Text("Delete Batch"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child:
                        NotePageBatch(title: batch.title, color: batch.color),
                  ),
                  const Text("This batch will\nbe permanently deleted.")
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ref
                        .read(notePagesProvider.notifier)
                        .deleteAllNotePageBatches(id);
                    ref.read(noteBatchesProvider.notifier).deleteNoteBatch(id);
                  },
                  child: const Text("Continue"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
