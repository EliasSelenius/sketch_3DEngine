 

class ColliderArray {
  ArrayList<Collider> Colliders = new ArrayList<Collider>();
  
  void Update(){
    
    for(int i = 0; i < Colliders.size(); i++){
      Collider collider = Colliders.get(i);
      for(int j = 0; j < Colliders.size(); j++){
        Collider other = Colliders.get(j);
        if(collider != other){
          if(collider.isColliding(other)){            
            collider.gameObject.OnColliderHit(other);
          }
        }
      }
    }
  }
  
  void Cast(Vector3 pos, Vector3 dir){
  
  }
  
  void Add(Collider c){
    Colliders.add(c);
  }
  void Remove(Collider c){
    Colliders.remove(c);
  }
}

class ColliderMaterial {
  float Bounciness;
  ColliderMaterial(float b){
    Bounciness = b;
  }
}

abstract class Collider extends Component {
  
  ColliderMaterial Material;
  
  boolean Colliding;

  @Override
  final void Start(){
    gameObject.scene.colliderArray.Add(this);
  }
  @Override
  final void End(){
    gameObject.scene.colliderArray.Remove(this);
  }
  @Override
  final void Update(){
    Colliding = false;
  }
  @Override
  final void Render(){
    DebugDraw();
  }
  void DebugDraw(){}
  
  @Override
  void OnColliderHit(Collider other){
    Colliding = true;
    println(this + " on " + gameObject.Name + " collided with " + other + " on " + other.gameObject.Name);
  }
  
  boolean isColliding(Collider other){
    if(other instanceof SphereCollider){
      return isColliding((SphereCollider)other);
    }else if(other instanceof PointCollider){
      return isColliding((PointCollider)other);
    }else if(other instanceof BoxCollider){
      return isColliding((BoxCollider)other);
    }
    return false;
  }
  
  abstract boolean isColliding(SphereCollider other);
  abstract boolean isColliding(PointCollider other);
  abstract boolean isColliding(BoxCollider other);
  
  
}


class SphereCollider extends Collider {
  float Radius;
  SphereCollider(float r){
    Radius = r;
  }
  
  void DebugDraw(){
    DisplayBuffer.pushMatrix();
    DisplayBuffer.translate(transform.position.x, transform.position.y, transform.position.z);
    DisplayBuffer.noFill();
    if(Colliding){
      DisplayBuffer.stroke(255,0,0);
    }else{
      DisplayBuffer.stroke(0, 255, 0);
    }
    DisplayBuffer.sphere(Radius);
    DisplayBuffer.popMatrix();
  }
  
  boolean isColliding(SphereCollider other){
    float dist = other.transform.position.distanceTo(transform.position);
    dist -= Radius + other.Radius;
    if(dist <= 0){
      return true;
    }
    return false;
  }
  boolean isColliding(PointCollider other){
    float dist = other.transform.position.distanceTo(transform.position);
    dist -= Radius;
    if(dist <= 0){
      return true;
    }
    return false;
  }
  boolean isColliding(BoxCollider other){return false;}
}


class PointCollider extends Collider {
  boolean isColliding(SphereCollider other){
    float dist = other.transform.position.distanceTo(transform.position);
    dist -= other.Radius;
    if(dist <= 0){
      return true;
    }
    return false;
  }
  boolean isColliding(PointCollider other){
    if(transform.position.x == other.transform.position.x && transform.position.y == other.transform.position.y && transform.position.z == other.transform.position.z){
      return true;
    }
    return false;
  }
  boolean isColliding(BoxCollider other){return false;}
}

class BoxCollider extends Collider {
  boolean isColliding(SphereCollider other){return false;}
  boolean isColliding(PointCollider other){return false;}
  boolean isColliding(BoxCollider other){return false;}
}
