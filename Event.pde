



class ThreadLoop extends Thread {

  Func startFunc;
  Func loopFunc;
  Func endFunc;

  boolean Active = true;

  ThreadLoop(Func l) {
    loopFunc = l;
  }

  ThreadLoop(Func s, Func l) {
    startFunc = s; loopFunc = l;
  }

  ThreadLoop(Func s, Func l, Func e) {
    startFunc = s; loopFunc = l; endFunc = e;
  }

  @Override
  public void run() {
    if(startFunc != null) {
      startFunc.Invoke();
    }
    while(Active) {
      loopFunc.Invoke();
    }
    if(endFunc != null) {
      endFunc.Invoke();
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

