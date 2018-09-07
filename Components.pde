

abstract class Component {
  GameObject gameObject;
  Transform transform;
  void LateUpdate(){}
  void Update(){}
  void Render(){}
  void Start(){}
  void End(){}
  void OnColliderHit(Collider other){}
  final Component GetComponent(Class cls) {
    for(Component comp : gameObject.components){
      if(cls.isInstance(comp)){
        return comp;
      }
    }
    return null;
  }  
}



class DebugComponent extends Component{
  
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
    
    
    
    if(input.getKey('f').Pressed){
      physics.addForce(transform.Forward().multiply(10));      
    }   
    

    //transform.Rotate(new Vector3(0,.01,0));
    
    //step += .1f;
    //transform.rotation.SetEuler(new Vector3(step,step, step));
    
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