

class Log {
  QueryList<LogEntry> entries = new QueryList<LogEntry>();

  void Write(String msg, color c) {
    LogEntry e = new LogEntry(msg, c); 
    entries.add(e);
    OnWrite(e);
  }

  void Write(String msg) {
    Write(msg, Colors.White);
  }

  void Write(Object o, color c) {
    Write((o == null)? "null" : o.toString(), c);
  }

  void Write(Object o) {
    Write(o, Colors.White);
  }

  void OnWrite(LogEntry entry) { };

}

class LogEntry {
  String text;
  color textColor;
  int creationTimeMillis;
  LogEntry(String t, color c) {
    text = t;
    textColor = c;
    creationTimeMillis = millis();
  }
}


class Console extends Log {
  @Override
  void OnWrite(LogEntry e) {
    println(e.text);
  }
}
