

class Matrix3 {
  
  
  float m00, m01, m02;
  float m10, m11, m12;
  float m20, m21, m22;
  
  Matrix3(){
  
  }
  
  Matrix3(Vector3 a, Vector3 b, Vector3 c){
    m00 = a.x;  m01 = b.x;  m02 = c.x;
    m10 = a.y;  m11 = b.y;  m12 = c.y;
    m20 = a.z;  m21 = b.z;  m22 = c.z;
  }
  
  Vector3 GetA(){
    return new Vector3(m00, m10, m20);
  }
  Vector3 GetB(){
    return new Vector3(m01, m11, m21);
  }
  Vector3 GetC(){
    return new Vector3(m02, m12, m22);
  }
  
  Vector3 multiply(Vector3 v){
    Vector3 a = GetA().multiply(v.x);
    Vector3 b = GetB().multiply(v.y);
    Vector3 c = GetC().multiply(v.z);
    return a.plus(b).plus(c);
  }
}