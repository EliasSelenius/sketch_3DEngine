


abstract class Query<T> {

  final QueryList<T> From(QueryList<T> list) {
    QueryList<T> res = new QueryList<T>();
    for(T t : list) {
      if(Where(t)) {
        res.add(t);
      }
    }
    return res;
  }

  abstract boolean Where(T arg);

}










class QueryList<T> extends ArrayList<T> {

  QueryList<T> Where(BoolOperator<T> func) {
    QueryList<T> res = new QueryList<T>();
    for(T t : this) {
      if(func.Evaluate(t)) {
        res.add(t);
      }
    }
    return res;
  }

  QueryList<T> Where(ObjFuncArg1<Boolean, T> func) {
    QueryList<T> res = new QueryList<T>();
    for(T t : this) {
      if(func.Invoke(t)) {
        res.add(t);
      }
    }
    return res;
  }

  QueryList<?> Select(String field) {
    QueryList<Object> res = new QueryList<Object>();
    for(T t : this) {
      res.add(Reflect.GetObjectSuper(t, field));
    }
    return res;
  }

  QueryList<T> Insert(T... values) {
    for(T t : values) {
      add(t);
    }
    return this;
  }

  void ForEach(VoidFuncArg1<T> func) {
    for(T t : this) {
      func.Invoke(t);
    }
  }

}