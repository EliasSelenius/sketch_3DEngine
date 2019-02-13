

interface Interpolatable<T>{
  T Lerp(T value, float t);
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


int StringDifference(String x, String y) {
  int[][] dp = new int[x.length() + 1][y.length() + 1];

  for (int i = 0; i <= x.length(); i++) {
    for (int j = 0; j <= y.length(); j++) {
      if (i == 0) {
        dp[i][j] = j;
      }
      else if (j == 0) {
        dp[i][j] = i;
      }
      else {
        dp[i][j] = min(dp[i - 1][j - 1] 
          + costOfSubstitution(x.charAt(i - 1), y.charAt(j - 1)), 
          dp[i - 1][j] + 1, 
          dp[i][j - 1] + 1);
      }
    }
  }

  return dp[x.length()][y.length()];
}


int costOfSubstitution(char a, char b) {
  return a == b ? 0 : 1;
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
    GameManager.graphics.pushMatrix();
  
    Vector3 f = new Vector3(0f,0f,1000f);
    Vector3 u = new Vector3(0f,1000f,0f);
    Vector3 r = new Vector3(1000f,0f,0f);
  
    GameManager.graphics.strokeWeight(1);

    GameManager.graphics.scale(10);
    GameManager.graphics.stroke(color(255,0,0));
    GameManager.graphics.line(0,0,0,r.x, r.y, r.z);
    GameManager.graphics.stroke(color(0,255,0));
    GameManager.graphics.line(0,0,0,u.x, u.y, u.z);
    GameManager.graphics.stroke(color(0,0,255));
    GameManager.graphics.line(0,0,0,f.x, f.y, f.z);
  
    GameManager.graphics.scale(.1);
    GameManager.graphics.stroke(255);
    GameManager.graphics.line(0,0,0,  width, 0,0);
    GameManager.graphics.line(0,0,0,  0, height,0);
    GameManager.graphics.line(width,0,0, width, height,0);
    GameManager.graphics.line(0,height,0,  width, height, 0);
  
    GameManager.graphics.line(0,0,0, 0,0,width);
    GameManager.graphics.line(0,height,0 ,0, height, width);
    GameManager.graphics.line(0,0,width, 0,height, width);

    GameManager.graphics.popMatrix();
}


