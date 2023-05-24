String toDisplay(DateTime time) {
  return "${time.year}/${time.month}/${time.day} ${time.hour}:${time.minute.toStringAsFixed(0).padLeft(2, "0")}";
}
