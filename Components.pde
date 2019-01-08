

abstract class Component {
  GameObject gameObject;
  Transform transform;
  void LateUpdate(){}
  void Update(){}
  void Render(){}
  void Start(){}
  void End(){}
  // todo: OnColliderHit shuold be an EventListner
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
    ScreenSurface.graphics.pushMatrix();
    ScreenSurface.graphics.translate(transform.position.x, transform.position.y, transform.position.z);
    ScreenSurface.graphics.sphere(100);
    ScreenSurface.graphics.popMatrix();
  }
}
