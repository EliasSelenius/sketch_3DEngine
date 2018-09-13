

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
  
  @Override
  void Render(){
    DisplayBuffer.pushMatrix();
    DisplayBuffer.translate(transform.position.x, transform.position.y, transform.position.z);
    DisplayBuffer.sphere(100);
    DisplayBuffer.popMatrix();
  }
}
