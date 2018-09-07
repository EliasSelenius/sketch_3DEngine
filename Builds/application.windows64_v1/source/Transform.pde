

class Transform{
  
  Vector3 position;
  Vector3 scale;
  Quaternion rotation;


  Transform(){
    position = new Vector3();
    scale = new Vector3(1);
    rotation = new Quaternion();
  }
  
  void Translate(Vector3 v){
    position.addVec(v);
  }
  
  void Rotate(Vector3 eul){       
    Quaternion q = new Quaternion();
    q.SetEuler(eul);
    rotation = rotation.multiply(q);
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