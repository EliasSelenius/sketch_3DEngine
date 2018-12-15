 

class Vector3 implements Interpolatable<Vector3>, IEquatable<Vector3> {

  float x, y, z;
 
  @Override
  String toString() {
    return "x: " + x + " y: " + y + " z: " + z;
  }
  
  Vector3(){
    x = 0;
    y = 0;
    z = 0;
  }
  
  Vector3(Vector3 p){
    setValue(p);
  }
  
  Vector3(Float xPos, Float yPos, Float zPos){  
    x = xPos;
    y = yPos; 
    z = zPos;
  }  
  
  Vector3(Float pos){
    x = pos;
    y = pos; 
    z = pos;
  }
  
  void setValue(Float xyz){
    x = y = z = xyz;
  }
  
  void setValue(Float xp, Float yp, Float zp){
    x = xp;
    y = yp;
    z = zp;
  }
  
  void setValue(Vector3 v){
    x = v.x;
    y = v.y;
    z = v.z;
  }
  
  void addVec(Vector3 v){
    this.x += v.x;
    this.y += v.y;
    this.z += v.z;
  }
  
  Vector3 multiply(Float v){
    return new Vector3(x * v, y * v, z * v);
  }
  
  Vector3 multiply(Vector3 v){
    return new Vector3(x * v.x, y * v.y, z * v.z);
  }
  
  Vector3 devide(Float v){
    return new Vector3(x / v, y / v, z / v);
  }
  
  Vector3 plus(Vector3 v){
    return new Vector3(x + v.x, y + v.y, z + v.z);
  }
  
  Vector3 plus(Float v){
    return new Vector3(x + v, y + v, z + v);
  }
  
  Vector3 minus(Vector3 v){
    return new Vector3(x - v.x, y - v.y, z - v.z); 
  }
  
  Float Dot(Vector3 v){
    return x * v.x + y * v.y + z * v.z;
  }
  Float Dot(Float X, Float Y, Float Z){
    return x * X + y * Y + z * Z;
  }
  Vector3 Cross(Vector3 v){
    return new Vector3(y * v.z - z * v.y,
                       z * v.x - x * v.z,
                       x * v.y - y * v.x);
  }
  
  void OrthoNormalize(Vector3 v) {
    
  }
  
  Float distanceTo(Vector3 v){
    return sqrt(sq(x - v.x) + sq(y - v.y) + sq(z - v.z));
  }
  
  Float Magnitude(){
    return sqrt(sq(x) + sq(y) + sq(z));
  }
  
  Float angleTo(Vector3 v){
    return acos(Dot(v) / (Magnitude() * v.Magnitude()));
  }
  Float angleTo(Float X, Float Y, Float Z){
    return acos(Dot(X,Y,Z) / (Magnitude() * sqrt(sq(X) + sq(Y) + sq(Z))));
  }
  
  Vector3 inverse(){
    return new Vector3(-x, -y, -z);
  }
  
  void Normelize(){
    float m = this.Magnitude();
    this.setValue(x / m, y / m, z / m);
  }
  
  void setRandomNormelizedDirection(){
    x = random(-1, 1);
    y = random(-1, 1);
    z = random(-1, 1);
    Normelize();
  }
  
  // Lerp: interpolates between two vectors
  Vector3 Lerp(Vector3 value, Float t){
    return new Vector3((value.x - x) * t, (value.y - y) * t, (value.z - z) * t);
  }
  
  boolean Equal(Vector3 value){
    return x == value.x && y == value.y && z == value.z;
  }

}

class Vector2 {
  
  float x, y;
  
  Vector2(){
    x = 0;
    y = 0;
  }
  
  Vector2(Float xPos, Float yPos){  
    x = xPos;
    y = yPos;     
  }  
  
  Vector2(Float pos){
    x = pos;
    y = pos;     
  }
  
  void setValue(Float xp, Float yp){
    x = xp;
    y = yp;    
  }
  
  Float Magnitude(){
    return sqrt(sq(x) + sq(y));
  }
  
  Float Dot(Vector2 v){
    return x * v.x + y * v.y;
  }
  Float Dot(float X, float Y){
    return x * X + y * Y;
  }
  Vector2 Cross(){
    return new Vector2(y, -x);
  }
  
  Float angleTo(Vector2 v){
    return acos(Dot(v) / (Magnitude() * v.Magnitude()));
  }
  Float angleTo(Float X, Float Y){
    return acos(Dot(X, Y) / (Magnitude() * (sqrt(sq(X) + sq(Y))))); 
  }
  
  void Normelize(){
    float m = this.Magnitude();
    this.setValue(x / m, y / m);
  }
  
  boolean InsideOf(Vector2 a, Vector2 b){
    return (this.x < b.x && this.y < b.y && a.x < this.x && a.y < this.y)? true : false;
  }

}

class Vector4{
  float x, y, z, w;
  
  Vector4(){
  
  }
  
  Vector4(Float X, Float Y, Float Z, Float W){
    x = X;
    y = Y;
    z = Z;
    w = W;
  }

}
