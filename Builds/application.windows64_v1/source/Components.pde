

abstract class Component {
  GameObject gameObject;
  Transform transform;
  void Update(){}
  void Start(){}
  final Component GetComponent(Class cls){
    for(Component comp : gameObject.components){
      if(cls.isInstance(comp)){
        return comp;
      }
    }
    return null;
  }
}

class MeshRenderer extends Component {

  int priority;
  
  PShape mesh;
  
  
  MeshRenderer(String s){
    mesh = meshAssets.getMesh(s);
  }
  
  void Start(){}
  
  void Update(){
    pushMatrix();
    
    translate(transform.position.x, transform.position.y, transform.position.z);
    
    scale(transform.scale.x, transform.scale.y, transform.scale.z);
          
    Vector4 a = transform.rotation.GetAxisAngle();   
    rotate(a.w, a.x, a.y, a.z);

    shape(mesh);
    
    popMatrix();
  }

}



class sphericallyGravity extends Component{
  
  Vector3 planetpoint;
  int planetMass = 100;
  
  int mass = 10;
  
  sphericallyGravity(){
    planetpoint = new Vector3(700,0,0);
  }
  
  void Update(){
    
  }
}



class CamFlyMovment extends Component{
  
  InpAxis h, v, r;
  
  void Start(){
    h = input.getAxis("Horizontal");
    v = input.getAxis("Vertical");
    r = input.getAxis("Roll");
  }
  
  void Update(){
    
    // obj transform applyed to cam:
    //Vector3 forward = transform.Forward();
    //Vector3 up = transform.Up();
    //camera(transform.position.x, transform.position.y, transform.position.z, 
    //  forward.x + transform.position.x, 
    //  forward.y + transform.position.y, 
    //  forward.z + transform.position.z,
    //  up.x, up.y, up.z);
    defScene.camera.transform = transform;
      
    // fly movement:
    transform.Translate(transform.Forward().multiply(-v.getValue() * 10));
    transform.Translate(new Vector3(0,(input.getKey(' ').Pressed)? 1 : 0,0));
    transform.Translate(transform.Right().multiply(-h.getValue() * 10));
    
    // look rotation:    
    transform.Rotate(new Vector3(-input.mouseMovment.y, -input.mouseMovment.x, r.Value * 2f).devide(100));
    
    
  }
}

class Physics extends Component{
  Vector3 Velocity = new Vector3();
  Quaternion Torque = new Quaternion();
  float Mass;
  
  Physics(float m) {
    Mass = m;
  }
  
  void Update(){
    transform.position.addVec(Velocity);
    transform.rotation = transform.rotation.multiply(Torque);
    
  }
  
  void addForce(Vector3 f){    
    Velocity.addVec(f.devide(Mass));
  }
  
  void addTorque(Quaternion q){
    Torque.multiply(q);
  }
}





class Rotate extends Component{
  
  Physics physics;
  Key g;
  
  void Start(){
    
    physics = (Physics)GetComponent(Physics.class);
    g = input.getKey('g');
    
    
    
    //transform.rotation.SetEuler(new Vector3(QUARTER_PI,QUARTER_PI, QUARTER_PI));

    
  }
  
  float step;
  
  void Update(){
    
    Vector3 tmp = new Vector3();
    tmp = transform.Forward();
    
    tmp = tmp.multiply(100);
    tmp.addVec(transform.position);
    
    Vector3 tmmp = new Vector3();
    tmmp = transform.Right();
    
    tmmp = tmmp.multiply(100);
    tmmp.addVec(transform.position);
    
    Vector3 up = new Vector3();
    up = transform.Up();
    up = up.multiply(100);
    up.addVec(transform.position);
    
    stroke(0,0,255);
    line(transform.position.x, transform.position.y, transform.position.z, tmp.x, tmp.y, tmp.z);
    stroke(255,0,0);
    line(transform.position.x, transform.position.y, transform.position.z, tmmp.x, tmmp.y, tmmp.z);
    stroke(0, 255, 0);
    line(transform.position.x, transform.position.y, transform.position.z, up.x, up.y, up.z);
    
    //if(input.getKey('e').Pressed){
    //  physics.addForce(transform.Forward().multiply(10));
    //}   
    

    //transform.Rotate(new Vector3(0,.01,0));

    ///transform.rotation.SetEuler(new Vector3(0 ,step,step ));
    
    //Vector3 axisAngle = new Vector3(1, 0, 1);
    //axisAngle.Normelize();
    //Vector3 start = axisAngle.multiply(100);    
    //Vector3 end = start.inverted();
    //start.addVec(transform.position);
    //end.addVec(transform.position);
    //stroke(255);
    //line(end.x, end.y, end.z, start.x, start.y, start.z);
    //transform.rotation.SetAxisAngle(step, axisAngle);
   
  }
}