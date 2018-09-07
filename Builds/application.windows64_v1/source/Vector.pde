

class Vector3{

  float x, y, z;
 

  
  Vector3(){
    x = 0;
    y = 0;
    z = 0;
  }
  
  Vector3(float xPos, float yPos, float zPos){  
    x = xPos;
    y = yPos; 
    z = zPos;
  }  
  
  Vector3(float pos){
    x = pos;
    y = pos; 
    z = pos;
  }
  
  void setValue(float xp, float yp, float zp){
    x = xp;
    y = yp;
    z = zp;
  }
  
  void addVec(Vector3 v){
    this.x += v.x;
    this.y += v.y;
    this.z += v.z;
  }
  
  Vector3 multiply(float v){
    return new Vector3(x * v, y * v, z * v);
  }
  
  Vector3 multiply(Vector3 v){
    return new Vector3(x * v.x, y * v.y, z * v.z);
  }
  
  Vector3 devide(float v){
    return new Vector3(x / v, y / v, z / v);
  }
  
  Vector3 plus(Vector3 v){
    return new Vector3(x + v.x, y + v.y, z + v.z);
  }
  
  Vector3 plus(float v){
    return new Vector3(x + v, y + v, z + v);
  }
  
  float distanceTo(Vector3 v){
    return sqrt(sq(x - v.x) + sq(y - v.y) + sq(z - v.z));
  }
  
  float Magnitude(){
    return sqrt(sq(x) + sq(y) + sq(z));
  }
  
  
  Vector3 inverted(){
    return new Vector3(-x, -y, -z);
  }
  
  void Normelize(){
    float m = this.Magnitude();
    this.setValue(x / m, y / m, z / m);
  }

}

class Vector2{
  
  float x, y;
  
  Vector2(){
    x = 0;
    y = 0;
  }
  
  Vector2(float xPos, float yPos){  
    x = xPos;
    y = yPos;     
  }  
  
  Vector2(float pos){
    x = pos;
    y = pos;     
  }
  
  void setValue(float xp, float yp){
    x = xp;
    y = yp;    
  }
  
  
  boolean InsideOf(Vector2 a, Vector2 b){
    return (this.x < b.x && this.y < b.y && a.x < this.x && a.y < this.y)? true : false;
  }

}

class Vector4{
  float x, y, z, w;
  
  Vector4(){
  
  }
  
  Vector4(float X, float Y, float Z, float W){
    x = X;
    y = Y;
    z = Z;
    w = W;
  }

}