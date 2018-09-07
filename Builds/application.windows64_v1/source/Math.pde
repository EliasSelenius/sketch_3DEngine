

static class Math{
  
  static float Clamp(float x, float min, float max){
    return (x < min)? min : (x > max)? max : x;
  }
  
  static float SircularClamp(float x, float min, float max){
    if(x > max){
      x = min + (x - max);
    }
    else if(x < min){
      x = max - (min - x); 
    }
    
    return x;
  }
  
  
}