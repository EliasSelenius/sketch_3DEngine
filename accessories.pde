import java.lang.reflect.Constructor;
import java.lang.reflect.Field;


interface Interpolatable<T>{
  T Lerp(T value, float t);
}

interface IEquatable<T>{
  boolean Equal(T value);
}



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


Field[] FindFields(Class<?> classs, Class<? extends Annotation> ann) {
    ArrayList<Field> list = new ArrayList<Field>();
    Class<?> c = classs;
    while (c != null) {
        for (Field field : c.getDeclaredFields()) {
            if (field.isAnnotationPresent(ann)) {
                list.add(field);
            }
        }
        c = c.getSuperclass();
    }
    return (Field[])list.toArray();
}



void Draw_Debug(){
    DisplayBuffer.pushMatrix();
  
    Vector3 f = new Vector3(0,0,1000);
    Vector3 u = new Vector3(0,1000,0);
    Vector3 r = new Vector3(1000,0,0);
  
    DisplayBuffer.scale(10);
    DisplayBuffer.stroke(color(255,0,0));
    DisplayBuffer.line(0,0,0,r.x, r.y, r.z);
    DisplayBuffer.stroke(color(0,255,0));
    DisplayBuffer.line(0,0,0,u.x, u.y, u.z);
    DisplayBuffer.stroke(color(0,0,255));
    DisplayBuffer.line(0,0,0,f.x, f.y, f.z);
  
    DisplayBuffer.scale(.1);
    DisplayBuffer.stroke(255);
    DisplayBuffer.line(0,0,0,  width, 0,0);
    DisplayBuffer.line(0,0,0,  0, height,0);
    DisplayBuffer.line(width,0,0, width, height,0);
    DisplayBuffer.line(0,height,0,  width, height, 0);
  
    DisplayBuffer.line(0,0,0, 0,0,width);
    DisplayBuffer.line(0,height,0 ,0, height, width);
    DisplayBuffer.line(0,0,width, 0,height, width);

    DisplayBuffer.popMatrix();
}
