

interface Interpolatable<T>{
  T Lerp(T value, Float t);
}

interface IEquatable<T>{
  boolean Equal(T value);
}


class FileExtensionFilter implements FilenameFilter {
  
  String[] extensions;

  FileExtensionFilter(String... exts) {
    extensions = exts;
  }

  @Override
  boolean accept(File dir, String name) {
    for(String s : extensions) {
      if (name.endsWith(s)) {
        return true;
      }
    }
    return false;
  }
}


enum operators {
  equal,
  less,
  greater,
  lessEqual,
  greaterEqual
}






boolean ExsistInArray(Object obj, Object[] array) {
  for(Object o : array) {
    if(obj == o) {
      return true;
    }
  }
  return false;
}



ArrayList<Object> ExcludeIndices(Object[] array, Integer... indices) {
  ArrayList<Object> a = new ArrayList<Object>();
  for(int i = 0; i < array.length; i++) {
    // Check if the current index should be excluded
    if(!ExsistInArray(i, (Object[])indices)) {
      a.add(array[i]);
    }
  }
  return a;
}


void Draw_Debug(){
    ScreenSurface.graphics.pushMatrix();
  
    Vector3 f = new Vector3(0f,0f,1000f);
    Vector3 u = new Vector3(0f,1000f,0f);
    Vector3 r = new Vector3(1000f,0f,0f);
  
    ScreenSurface.graphics.scale(10);
    ScreenSurface.graphics.stroke(color(255,0,0));
    ScreenSurface.graphics.line(0,0,0,r.x, r.y, r.z);
    ScreenSurface.graphics.stroke(color(0,255,0));
    ScreenSurface.graphics.line(0,0,0,u.x, u.y, u.z);
    ScreenSurface.graphics.stroke(color(0,0,255));
    ScreenSurface.graphics.line(0,0,0,f.x, f.y, f.z);
  
    ScreenSurface.graphics.scale(.1);
    ScreenSurface.graphics.stroke(255);
    ScreenSurface.graphics.line(0,0,0,  width, 0,0);
    ScreenSurface.graphics.line(0,0,0,  0, height,0);
    ScreenSurface.graphics.line(width,0,0, width, height,0);
    ScreenSurface.graphics.line(0,height,0,  width, height, 0);
  
    ScreenSurface.graphics.line(0,0,0, 0,0,width);
    ScreenSurface.graphics.line(0,height,0 ,0, height, width);
    ScreenSurface.graphics.line(0,0,width, 0,height, width);

    ScreenSurface.graphics.popMatrix();
}


