

abstract class Func<T> {
  abstract boolean Invoke(T element);
}

class Funcs {
    Func Eq(Object... values) {
        return new EqualsOperator(values);
    }
    Func Lt(Comparable o) {
        return new LessOperator(o);
    }
    Func Gt(Comparable o) {
        return new GreaterOperator(o);
    }
} 
Funcs Funcs = new Funcs();



class EqualsOperator<T> extends Func<T> {

    Object[] Values;

    EqualsOperator(Object... values) {
        Values = values;
    }

    @Override
    boolean Invoke(T element) {
        for(Object val : Values) {
            if(element.equals(val)) {
                return true;
            }
        }
        return false;
    }
}


class LessOperator<T> extends Func<T> {
    Comparable<T> obj;
    LessOperator(Comparable<T> o) {
        obj = o;
    }
    @Override
    boolean Invoke(T element) {
        return obj.compareTo(element) > 0;
    }
}

class GreaterOperator<T> extends Func<T> {
    Comparable<T> obj;
    GreaterOperator(Comparable<T> o) {
        obj = o;
    }
    @Override
    boolean Invoke(T element) {
        return obj.compareTo(element) < 0;
    }
}