import 'package:flutter/material.dart';
import 'package:notesketch/model/notebatches.dart';
import 'package:notesketch/view/components/batch.dart';

class NoteBatchSelector extends StatefulWidget {
  const NoteBatchSelector({super.key, required this.batches, this.onChanged});

  final List<NoteBatch> batches;
  final ValueChanged<int>? onChanged;

  @override
  State<NoteBatchSelector> createState() => _NoteBatchSelectorState();
}

class _NoteBatchSelectorState extends State<NoteBatchSelector> {
  late NoteBatch selectedBatch;

  @override
  void initState() {
    super.initState();
    selectedBatch = widget.batches[0];
    if (widget.onChanged != null) {
      widget.onChanged!(selectedBatch.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButton(
        value: selectedBatch,
        items: widget.batches.map((batch) {
          return DropdownMenuItem(
            value: batch,
            child: NotePageBatch(
              title: batch.title,
              color: batch.color,
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(
            () {
              selectedBatch = value ?? selectedBatch;
            },
          );
          if (widget.onChanged != null) {
            widget.onChanged!(value!.id);
          }
        },
      ),
    );
  }
}
