

class Transform{
  
  Vector3 position;
  Vector3 scale;
  Quaternion rotation;


  Transform() {
    position = new Vector3();
    scale = new Vector3(1f);
    rotation = new Quaternion();
  }
  Transform(Vector3 p, Vector3 s, Quaternion r){
    position = new Vector3(p);
    scale = new Vector3(s);
    rotation = new Quaternion(r);
  }
  
  
  void setValue(Transform t){
    position.setValue(t.position);
    scale.setValue(t.scale);
    rotation.setValue(t.rotation);
  }
  
  void Translate(Vector3 v){
    position.addVec(v);
  }
  
  void Rotate(Vector3 eul){       
    Quaternion q = new Quaternion();
    q.SetEuler(eul);
    rotation = rotation.multiply(q);
  }
  
  void RotateAround(Vector3 eul, Vector3 point){
  
  }
  
  void LookAt(Vector3 pos, Vector3 up){
    Vector3 f = pos;
    Vector3 u = up;
    Vector3 r = f.Cross(u);
    rotation.w = sqrt(1f + r.x + u.y + f.z) * .5f;
    float recip = 1f / (4f * rotation.w);
    rotation.x = (u.z - f.y) * recip;
    rotation.y = (f.x - r.z) * recip;
    rotation.z = (r.y - u.x) * recip;
  }
  
  Vector3 Forward(){               
    return rotation.Forward();    
  } 
  Vector3 Right(){
    return rotation.Right();
  } 
  Vector3 Up(){
    return rotation.Up();
  }
  
}
