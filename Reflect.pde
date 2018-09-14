

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
  
  // GetAllFields(): returns all the fields in the given Class
  Field[] GetAllFields(Class c) {
    return c.getDeclaredFields();
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
  
  // GetAllObjects(): returns all the objects in the given object
  Object[] GetAllObjects(Object obj) {
    Field[] fields = GetAllFields(obj.getClass());
    Object[] objs = new Object[fields.length];
    for(int i = 0; i < objs.length; i++) {
      objs[i] = GetObject(obj, fields[i].getName());
    }
    return objs;
  }
  
  
  // InvokeMethod(): invokes a Method with the given parameters(params) in the given object(obj):  
  void InvokeMethod(Object obj, String methodName, Object... params){
    Class[] paramTypes = new Class[params.length];    
    for(int i = 0; i < params.length; i++){
      paramTypes[i] = params[i].getClass();
    }    
    try{
      GetMethod(obj, methodName, paramTypes).invoke(obj, params);
    } catch(Exception x){
      x.printStackTrace();
    }
  }
  
  // GetClass(): gets a Class from given string;
  Class GetClass(String n){
    try{
      return (Class.forName("sketch_3DEngine$" + n));
    } catch(Exception w){
      w.printStackTrace();
    }
    return null;
  }
  
  // InstantiateObject(): returns a new object from the given type and constructor parameters(params):
  Object InstantiateObject(Class type, Object... params){
    
    Class[] paramsType = new Class[params.length + 1];
    paramsType[0] = this.getClass();
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
      paro[0] = this;
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
