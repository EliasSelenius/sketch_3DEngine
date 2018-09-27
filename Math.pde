

class MathLib {
  
  float Clamp(float x, float min, float max){
    return (x < min)? min : (x > max)? max : x;
  }
  
  float SircularClamp(float x, float min, float max){
    if(x > max){
      x = min + (x - max);
    }
    else if(x < min){
      x = max - (min - x); 
    }
    
    return x;
  }
  
  float VecDist2(float x, float y, float x1, float y1){
    return sqrt(sq(x - x1) + sq(y - y1));
  }
  
  float VecDist3(float x, float y, float z, float x1, float y1, float z1){
    return sqrt(sq(x - x1) + sq(y - y1) + sq(z - z1));
  }
  
  Vector3 Vec3(PVector pv){
    return new Vector3(pv.x, pv.y, pv.z);
  }
  
  float Normelized(float v){
    return v / abs(v);
  }
  
}
