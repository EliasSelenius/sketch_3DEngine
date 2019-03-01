

class Reflect {
  
  // GetMethod(): returns a Method with the given parametertypes(params) from the given object(obj):  
  Method GetMethod(Object obj, String methodName, Class... params) {
    Class<?> c = obj.getClass();
    try{
      return c.getDeclaredMethod(methodName, params);
    } catch(NoSuchMethodException x){
      x.printStackTrace();
    }
    return null;
  }

  Method GetMethodSuper(Object obj, String methodName, Class... params) {
    Class c = obj.getClass();
    while(c != null) {
      Method m = null;
      try {
        m = c.getDeclaredMethod(methodName, params);
      } catch (NoSuchMethodException x) {
        c = c.getSuperclass();
        continue;
      }
      return m;
    }
    return null;
  }
  
  // GetField(): returns a Field object in a Class from given string
  Field GetField(Class c, String name) {
    try {
      return c.getDeclaredField(name);
    } catch (Exception x) {
      x.printStackTrace();
    }
    return null;
  }
  
  // GetField(): returns a Field object in a Class and its super Classes from given string
  Field GetFieldSuper(Class cls, String name) {
    Class c = cls;
    while(c != null) {
      Field f = null;
      try {
        f = c.getDeclaredField(name);
      } catch (NoSuchFieldException x) {
        c = c.getSuperclass();
        continue;
      }
      return f;
    }
    return null;
  }
  
  // GetFields(): returns all the fields in the given Class
  Field[] GetFields(Class c) {
    return c.getDeclaredFields();
  }



  QueryList<Field> GetFieldsFilter(Class c, int modFilter) {
    QueryList<Field> fields = new QueryList<Field>();
    for(Field f : GetFieldsSuper(c)) {
      if(f.getModifiers() == modFilter) {
        fields.add(f);
      }
    }
    return fields;
  }
  
  
  // GetFieldsSuper(): returns all the fields (private|public, static, final) in the given Class and its super Classes 
  Field[] GetFieldsSuper(Class<?> cls) {
    ArrayList<Field> fields = new ArrayList<Field>();
    Class<?> c = cls;
    while(c != null){
      for(Field field : c.getDeclaredFields()){
        fields.add(field);
      }
      c = c.getSuperclass();
    }
    Field[] f = new Field[fields.size()];
    for(int i = 0; i < f.length; i++){
      f[i] = fields.get(i);
    }
    return f;
  }
       
  // GetObject(): returns an object in a object with given name
  Object GetObject(Object obj, String objName) {
    try{
      return GetField(obj.getClass(), objName).get(obj);
    } catch (IllegalAccessException x) {
      x.printStackTrace();
    } catch (NullPointerException x) {
      x.printStackTrace();
    }
    return null;
  }
  
  Object GetObjectSuper(Object obj, String name){
    try{
      return GetFieldSuper(obj.getClass(), name).get(obj);  
    } catch (IllegalAccessException x) {
      x.printStackTrace();
    } catch (NullPointerException x) {
      x.printStackTrace();
    }
    return null;
  }
  
  // GetObjects(): returns all the objects in the given object
  Object[] GetObjects(Object obj) {
    Field[] fields = GetFields(obj.getClass());
    Object[] objs = new Object[fields.length];
    for(int i = 0; i < objs.length; i++) {
      objs[i] = GetObject(obj, fields[i].getName());
    }
    return objs;
  }

  Object[] GetObjectsFilter(Object obj, int modFilter) {
    QueryList<Field> fields = GetFieldsFilter(obj.getClass(), modFilter);
    Object[] objs = new Object[fields.size()];
    for(int i = 0; i < objs.length; i++) {
      try{
        objs[i] = fields.get(i).get(obj);
      } catch (IllegalAccessException e) {
        e.printStackTrace();
      }
    }
    return objs;
  }


  // GetObjectSuper(): returns all objects in the given object and all its super objects
  Object[] GetObjectsSuper(Object obj){
    Field[] fields = GetFieldsSuper(obj.getClass());
    Object[] objs = new Object[fields.length];
    for(int i = 0; i < objs.length; i++) {
      try{
        objs[i] = fields[i].get(obj);
      } catch (IllegalAccessException e) {
        e.printStackTrace();
      }
    }
    return objs;
  }
  
  
  // InvokeMethod(): invokes a Method with the given parameters(params) in the given object(obj):  
  Object InvokeMethod(Object obj, String methodName, Object... params){
    Class[] paramTypes = new Class[params.length];    
    for(int i = 0; i < params.length; i++){
      paramTypes[i] = GetType(params[i]);
    }    
    try{
      return GetMethod(obj, methodName, paramTypes).invoke(obj, params);
    } catch(Exception x){
      x.printStackTrace();
    }
    return null;
  }

  Object InvokeMethodSuper(Object obj, String methodName, Object... params) {
    Class[] paramTypes = new Class[params.length];    
    for(int i = 0; i < params.length; i++){
      paramTypes[i] = GetType(params[i]);
    }    
    try{
      return GetMethodSuper(obj, methodName, paramTypes).invoke(obj, params);
    } catch (Exception x){
      x.printStackTrace();
      //x.getCause().printStackTrace();
    }
    return null;
  }
  


  // GetClass(): gets a Class from given string;
  Class GetClass(String n){
    try{
      return (Class.forName(App.getClass().getName() + "$" + n));
    } catch(ClassNotFoundException w){
      println("Reflect didnt find the class: " + n);
      //w.printStackTrace();
    }
    return null;
  }
  
  // InstantiateObject(): returns a new object from the given type and constructor parameters(params):
  Object InstantiateObject(Class type, Object... params) {
    
    Class[] paramsType = new Class[params.length + 1];
    paramsType[0] = App.getClass();
    for(int i = 0; i < params.length; i++){
      paramsType[i + 1] = GetType(params[i]);
    }
    
    Constructor constructor = null;
    try{
      constructor = type.getDeclaredConstructor(paramsType);
    } catch(Exception e ){
      e.printStackTrace();
    }
    if(constructor == null) { println("the constructor is null in InstantiateObject()"); return null; }
    
    Object object = null;
    try{
      Object[] paro = new Object[params.length + 1];
      paro[0] = App;
      for(int i = 0; i < params.length; i++){
        paro[i + 1] = params[i];
      }
      object = constructor.newInstance(paro);
    } catch (Exception e){
      e.printStackTrace();
    }
    if(object == null) { println("the object is null in InstantiateObject()"); return null; }
    
    return object;
  }

  Class[] GetTypes(Object[] os) {
    Class[] res = new Class[os.length];
    for(int i = 0; i < os.length; i++) {
      res[i] = GetType(os[i]);
    }
    return res;
  }

  Class GetType(Object o) { 
    Class c = o.getClass();
    if (c == Integer.class) {
      return ((Integer)o).TYPE;
    } else if (c == Float.class) {
      return ((Float)o).TYPE;
    } else if (c == Boolean.class) {
      return ((Boolean)o).TYPE;
    }
    
    return c;
  }
  
  // WIP
  //Field[] FindFields(Class<?> classs, Class<? extends Annotation> ann) {
  //    ArrayList<Field> list = new ArrayList<Field>();
  //    Class<?> c = classs;
  //    while (c != null) {
  //        for (Field field : c.getDeclaredFields()) {
  //            if (field.isAnnotationPresent(ann)) {
  //                list.add(field);
  //            }
  //        }
  //        c = c.getSuperclass();
  //    }
  //    return (Field[])list.toArray();
  //}
  
  //Field[] GetObjectsWithAnnotation(Object obj, Class a){
    
  //  for(Field field : obj.getClass().getDeclaredFields()) {
  //    if(field.isAnnotationPresent(a)){
      
  //    }
  //  }
    
  //  return null;
  //}
}
