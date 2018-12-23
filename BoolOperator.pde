

abstract class BoolOperator<T> {
    final boolean Evaluate(T element) {
        boolean thisResult = evaluate(element);
        if(thisResult) {
            for(BoolOperator opr : ands) {
                if(!opr.Evaluate(element)) {
                    return false;
                }
            }
        }
        return thisResult;
    }
    abstract boolean evaluate(T element);

    ArrayList<BoolOperator> ands = new ArrayList<BoolOperator>();

    BoolOperator<T> And(BoolOperator<T> opr) {
        ands.add(opr);
        return this;
    } 
}

class Is {
    BoolOperator Equal(Object... values) {
        return new EqualsOperator(values);
    }
    BoolOperator LessThan(Comparable o) {
        return new LessOperator(o);
    }
    BoolOperator GreaterThan(Comparable o) {
        return new GreaterOperator(o);
    }
    BoolOperator Null() {
        return new IsNullOperation();
    }
    BoolOperator NotNull() {
        return new IsNotNullOperation();
    }
    BoolOperator OfType(Class type) {
        return new OfTypeOperation(type);
    }
} 
Is Its = new Is();



class EqualsOperator<T> extends BoolOperator<T> {

    Object[] Values;

    EqualsOperator(Object... values) {
        Values = values;
    }

    @Override
    boolean evaluate(T element) {
        for(Object val : Values) {
            if(val.equals(element)) {
                return true;
            }
        }
        return false;
    }
}


class LessOperator<T> extends BoolOperator<T> {
    Comparable<T> obj;
    LessOperator(Comparable<T> o) {
        obj = o;
    }
    @Override
    boolean evaluate(T element) {
        return obj.compareTo(element) > 0;
    }
}

class GreaterOperator<T> extends BoolOperator<T> {
    Comparable<T> obj;
    GreaterOperator(Comparable<T> o) {
        obj = o;
    }
    @Override
    boolean evaluate(T element) {
        return obj.compareTo(element) < 0;
    }
}


class IsNullOperation<T> extends BoolOperator<T> {
    @Override
    boolean evaluate(T element) {
        return element == null;
    }
}
class IsNotNullOperation<T> extends BoolOperator<T> {
    @Override
    boolean evaluate(T element) {
        return element != null;
    }
}


class OfTypeOperation<T> extends BoolOperator<T> {
    Class Type;
    OfTypeOperation(Class type) {
        Type = type;
    }
    @Override
    boolean evaluate(T element) {
        return Type.isInstance(element);
    }
}