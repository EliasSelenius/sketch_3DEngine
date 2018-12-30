


class Event {
  QueryList<Func> Methods = new QueryList<Func>();

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
