

class Quaternion{
  float x, y, z, w;
  
  
  Quaternion(){
    x = y = z = 0.0f;
    w = 1.0f;
  }
  
  
  Vector3 Forward(){
    return new Vector3(2 * (x*z + w*y),
                       2 * (y*z - w*x),
                       1 - 2 * (x*x + y*y));
  } 
  Vector3 Right(){
    return new Vector3(1 - 2 * (y*y + z*z),
                       2 * (x*y + w*z),
                       2 * (x*z - w*y));
  }
  Vector3 Up(){
    return new Vector3(2 * (x*y - w*z),
                       1 - 2 * (x*x + z*z),
                       2 * (y*z + w*x));
  }
  
  
  Quaternion(float X, float Y, float Z, float W){
    x = X;
    y = Y;
    z = Z;
    w = W;
  }
  
  
  void Normelize(){
    float norme = sqrt(sq(w) + sq(x) + sq(y) + sq(z));
    if(norme == 0.0f){
      x = y = z = 0.0f;
      w = 1.0f;
    }else{
      float recip = 1.0 / norme;
      w *= recip;
      x *= recip;
      y *= recip;
      z *= recip;
    }
  }
  
  
  
  Vector4 GetAxisAngle(){
    Vector4 a = new Vector4();
    if(w > 1){
      this.Normelize();
    }
    float s = sqrt(1 - w * w);
    a.w = 2.0f * acos(w);
    if(s < 0.001f){
      a.x = x;
      a.y = y;
      a.z = z;
    }else{
      a.x = x / s;
      a.y = y / s;
      a.z = z / s;
    }
    return a;
  }
  
  
  Vector3 GetEuler(){
    Vector3 eul = new Vector3();
    
    float sinr = +2.0 * (w * x + y * z);
    float cosr = +1.0 - 2.0 * (x * x + y * y);
    eul.x = atan2(sinr, cosr);
    
    float sinp = +2.0 * (w * y - z * x);
    if(abs(sinp) >= 1){
      eul.y = java.lang.Math.copySign(PI / 2, sinp);
    }else{
      eul.y = asin(sinp);
    }
    
    
    float siny = +2.0 * (w * z + x * y);
    float cosy = +1.0 - 2.0 * (y * y + z * z);  
    eul.z = atan2(siny, cosy);
    
    return eul;
  }
  
  void SetEuler(Vector3 eul){
    
    float cy = cos(eul.z * .5f);
    float sy = sin(eul.z * .5f);
    float cr = cos(eul.x * .5f);
    float sr = sin(eul.x * .5f);
    float cp = cos(eul.y * .5f);
    float sp = sin(eul.y * .5f);
    
    w = cy * cr * cp + sy * sr * sp;
    x = cy * sr * cp - sy * cr * sp;
    y = cy * cr * sp + sy * sr * cp;
    z = sy * cr * cp - cy * sr * sp;
  }
  
  
  
  Quaternion multiply(Quaternion q){
    float nw = w * q.w - (x * q.x + y * q.y + z * q.z);
    
    float nx = w*q.x + q.w*x + y*q.z - z*q.y;
    float ny = w*q.y + q.w*y + z*q.x - x*q.z;
    float nz = w*q.z + q.w*z + x*q.y - y*q.x;
    
    return new Quaternion(nx, ny, nz, nw); 
  }
  
  
  void SetAxisAngle(float angle, Vector3 axis){
    float omega, s, c;
    //int i;
    
    s = axis.Magnitude();
    
    if(abs(s) > Float.MIN_VALUE){
      c = 1.0f / s;
      
      axis.x *= c;
      axis.y *= c;
      axis.z *= c;
      
      omega = -0.5f * angle;      
      s = (float)sin(omega);
      
      x = s * axis.x;
      y = s * axis.y;
      z = s * axis.z;
      w = (float)cos(omega);
      
    }else{
      x = y = z = 0.0f;
      w = 1.0f;
    }
    Normelize();    
  }
  
  
  void addQuat(Quaternion q){
    x += q.x;
    y += q.y;
    z += q.z;
    w += q.w;
  }
}