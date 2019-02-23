


abstract class Query<T> {

  final QueryList<T> From(QueryList<T> list) {
    QueryList<T> res = new QueryList<T>();
    for(T t : list) {
      if(Where(t)) {
        res.add(t);
      }
    }

    for(int i = 0; i < res.size(); i++) {
      T index = res.get(i);
      for(T t : res) {

      }
    }
    return res;
  }

  abstract boolean Where(T arg);
  abstract boolean OrderBy(T last, T next);

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

  QueryList<T> Where(Func func) {
    QueryList<T> res = new QueryList<T>();
    for(T t : this) {
      if((boolean)func.Invoke(t)) {
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

  void ForEach(Func func) {
    for(int i = 0; i < size(); i++) {
      func.Invoke(get(i), i);
    }
  }

  QueryList<T> OrderBy(String field) {
    return null;
  }

  void SwapIndex(int i, int j) {
    T t = get(i);
    set(i, get(j));
    set(j, t);
  }


}