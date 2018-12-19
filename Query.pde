

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

}