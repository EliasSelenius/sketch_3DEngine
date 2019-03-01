

class Log {
  QueryList<LogEntry> entries = new QueryList<LogEntry>();

  void Write(String msg, Color c) {
    entries.add(new LogEntry(msg, c));
  }

  void Write(String msg) {
    Write(msg, Colors.White);
  }

  abstract void OnWrite(LogEntry entry);

}

class LogEntry {
  String text;
  Color textColor;
  int creationTimeMillis;
  LogEntry(String t, Color c) {
    text = t;
    textColor = c;
    creationTimeMillis = millis();
  }
}


class Console extends Log {
  
}
