class UndoRedoManager {
  UndoRedoManager(this.initialValue);

  final initialValue;
  List<dynamic> _undoStack = [];
  List<dynamic> _redoStack = [];

  dynamic get current => canUndo() ? _undoStack.last : initialValue;

  void undo() {
    if (!canUndo()) return;
    _redoStack.add(_undoStack.last);
    _undoStack.removeLast();
  }

  bool canUndo() => _undoStack.length > 0;

  void redo() {
    if (!canRedo()) return;
    _undoStack.add(_redoStack.last);
    _redoStack.removeLast();
  }

  bool canRedo() => _redoStack.length > 0;

  void add(dynamic value) {
    _undoStack.add(value);
    _redoStack.clear();
  }

  void clear() {
    _undoStack.clear();
    _redoStack.clear();
  }
}
