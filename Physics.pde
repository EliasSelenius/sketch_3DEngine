


class Physics extends Component { 
  
  // Mass: in kilograms.
  float Mass;
  // centerofMass: units from pivotpoint.
  Vector3 CenterofMass = new Vector3();
  
  Vector3 Velocity = new Vector3();   
  Vector3 AngularVelocity = new Vector3();
  

  public Physics(Float m) {
    Mass = m;
  }
  
  void Update(){
    
    transform.Translate(Velocity.multiply(deltaTime));
    
    transform.Rotate(AngularVelocity.multiply(deltaTime));
    
  }
  
  void addForce(Vector3 f){    
    Velocity.addVec(f.devide(Mass));
  }
  
  void addForceAtPosition(Vector3 f, Vector3 pos){
  
  }
  
  void addTorque(Vector3 angf){
    AngularVelocity.addVec(angf.devide(Mass));
  }
  
  void OnColliderHit(Collider other){
    Velocity.setValue(0);
  }
  
  
}



class sphericallyGravity extends Component{
  
  

  Physics phy;
  
  void Start(){
    
    phy = (Physics)GetComponent(Physics.class);
  }
  
  void Update(){
    float f = G * ((planetMass * phy.Mass) / planetpoint.distanceTo(transform.position));
    Vector3 dir = transform.position.minus(planetpoint);
    dir.Normelize();
    dir = dir.multiply(f);
    phy.addForce(dir);        
  }
}
