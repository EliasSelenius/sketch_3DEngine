


class Event {
  QueryList<Func> Methods = new QueryList<Func>();

  Event(Func... funcs) {
    for(Func func : funcs) {
      Methods.add(func);
    }
  }

  void AddListner(String name, Object obj) {
    Methods.add(new MethodPointer(name, obj));
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



// Func: base interface for a function
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
  final T Invoke(String methodName, Object... args) {
    return (T)Reflect.InvokeMethod(this, methodName, args);
  }
}


class MethodPointer extends Func {
  String name;
  Object object;
  MethodPointer(String n, Object o) {
    name = n; object = o;
  }
  @Override
  Object Invoke(Object... params) {
    return Reflect.InvokeMethod(object, name, params);
  }
}

