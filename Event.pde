



class ThreadLoop extends Thread {

  Event StartEvent = new Event();
  Event LoopEvent = new Event();
  Event EndEvent = new Event();

  boolean Active = false;

  int UpdateCount;
  int StartTime; 

  ThreadLoop() { }


  float UpdatesPerSecond() {
    return UpdateCount / (float)(RunningTimeMillis() / 1000f);
  }

  int RunningTimeMillis() {
    return millis() - StartTime;
  }

  float DeltaTime() { 
    return 1f / UpdatesPerSecond();
  }

  void StartLoop() {
    Active = true;
    UpdateCount = 0;
    StartTime = millis();
    start();
  }

  void EndLoop() {
    Active = false;
  }

  @Override
  public void run() {
    if(StartEvent != null) {
      StartEvent.Run();
    }
    while(Active) {
      UpdateCount++;
      LoopEvent.Run();
    }
    if(EndEvent != null) {
      EndEvent.Run();
    }
  }

}



class Event extends Function {
  QueryList<Func> Methods = new QueryList<Func>();

  Event(Func... funcs) {
    for(Func func : funcs) {
      Methods.add(func);
    }
  }

  void AddListner(String name, Object obj) {
    Methods.add(new FuncPointer(name, obj));
  }

  void AddListner(Func func) {
    Methods.add(func);
  }

  void RemoveListner(Func func) {
    Methods.remove(func);
  }

  void Run() {
    for(Func func : Methods) {
      func.Invoke();
    }
  }
}



// Func: base class for a function
abstract class Func { 
  abstract Object Invoke(Object... args);
  void InvokeInThread(Object... args) {
    new Thread() {
      @Override
      public void run() {
        Invoke();
      }
    }.start();
  }
}

abstract class Function<T> extends Func {
  @Override
  final T Invoke(Object... args) {
    return (T)Reflect.InvokeMethod(this, "Run", args);
  }
  final T InvokeMethod(String methodName, Object... args) {
    return (T)Reflect.InvokeMethod(this, methodName, args);
  }
}


class FuncPointer extends Func {
  String name;
  Object object;
  FuncPointer(String n, Object o) {
    name = n; object = o;
  }
  @Override
  Object Invoke(Object... params) {
    return Reflect.InvokeMethod(object, name, params);
  }
}

