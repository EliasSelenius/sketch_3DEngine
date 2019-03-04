

interface Interpolatable<T>{
  T Lerp(T value, float t);
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


String ConcatStringArray(String[] strs) {
  String res = "";
  for(String s : strs) {
    res += s;
  }
  return res;
}


/*
boolean isWrapper(Object o) {
  switch (o.getClass()) {
    case Integer:
      return true;
    case Float:
      return true;
    case Boolean:
      return true;
  }
  return false;
}*/









void Draw_Debug(){
    Game.graphics.pushMatrix();
  
    Vector3 f = new Vector3(0f,0f,1000f);
    Vector3 u = new Vector3(0f,1000f,0f);
    Vector3 r = new Vector3(1000f,0f,0f);
  
    Game.graphics.strokeWeight(1);

    Game.graphics.scale(10);
    Game.graphics.stroke(color(255,0,0));
    Game.graphics.line(0,0,0,r.x, r.y, r.z);
    Game.graphics.stroke(color(0,255,0));
    Game.graphics.line(0,0,0,u.x, u.y, u.z);
    Game.graphics.stroke(color(0,0,255));
    Game.graphics.line(0,0,0,f.x, f.y, f.z);
  
    Game.graphics.scale(.1);
    Game.graphics.stroke(255);
    Game.graphics.line(width,0,0, width, height,0);
    Game.graphics.line(0,height,0,  width, height, 0);
  
    Game.graphics.line(0,height,0 ,0, height, width);
    Game.graphics.line(0,0,width, 0,height, width);

    Game.graphics.popMatrix();
}


