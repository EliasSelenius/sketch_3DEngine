

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
  
  // GetField(): returns a Field object in a Class from given string
  Field GetField(Class c, String name){
    try {
      return c.getDeclaredField(name);
    } catch (Exception x){
      x.printStackTrace();
    }
    return null;
  }
  
  // GetField(): returns a Field object in a Class and its super Classes from given string
  Field GetFieldSuper(Class cls, String name){
    Class c = cls;
    while(c != null){
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
  
  // GetFieldsSuper(): returns all the fields in the given Class and its super Classes
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
    }
    return null;
  }
  
  Object GetObjectSuper(Object obj, String name){
    try{
      return GetFieldSuper(obj.getClass(), name).get(obj);  
    } catch (IllegalAccessException x) {
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
      paramTypes[i] = params[i].getClass();
    }    
    try{
      return GetMethod(obj, methodName, paramTypes).invoke(obj, params);
    } catch(Exception x){
      x.printStackTrace();
    }
    return null;
  }
  
  // GetClass(): gets a Class from given string;
  Class GetClass(String n){
    try{
      return (Class.forName(This.getClass().getName() + "$" + n));
    } catch(Exception w){
      w.printStackTrace();
    }
    return null;
  }
  
  // InstantiateObject(): returns a new object from the given type and constructor parameters(params):
  Object InstantiateObject(Class type, Object... params) {
    
    Class[] paramsType = new Class[params.length + 1];
    paramsType[0] = This.getClass();
    for(int i = 0; i < params.length; i++){
      paramsType[i + 1] = params[i].getClass();
    }
    
    Constructor constructor = null;
    try{
      constructor = type.getDeclaredConstructor(paramsType);
    } catch(Exception e ){
      e.printStackTrace();
    }
    if(constructor == null){System.err.println("the constructor is null in InstantiateObject()"); return null;}
    
    Object object = null;
    try{
      Object[] paro = new Object[params.length + 1];
      paro[0] = This;
      for(int i = 0; i < params.length; i++){
        paro[i + 1] = params[i];
      }
      object = constructor.newInstance(paro);
    } catch (Exception e){
      e.printStackTrace();
    }
    if(object == null){System.err.println("the object is null in InstantiateObject()"); return null;}
    
    return object;
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
