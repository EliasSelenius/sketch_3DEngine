

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
  
  float length = 4f;

  @Override
  void Render() {
    GameManager.graphics.pushMatrix();
    GameManager.graphics.translate(transform.position.x, transform.position.y, transform.position.z);
    GameManager.graphics.scale(transform.scale.x, transform.scale.y, transform.scale.z);          
    Vector4 a = transform.rotation.GetAxisAngle();   
    GameManager.graphics.rotate(a.w, a.x, a.y, a.z);

    Vector3 f = transform.Forward().multiply(5f);
    Vector3 u = transform.Up().multiply(5f);
    Vector3 r = transform.Right().multiply(5f);

    GameManager.graphics.strokeWeight(4);

    GameManager.graphics.stroke(0,0,255);
    GameManager.graphics.line(0,0,0, 0, 0, length);

    GameManager.graphics.stroke(0,255,0);
    GameManager.graphics.line(0,0,0, 0, length, 0);

    GameManager.graphics.stroke(255,0,0);
    GameManager.graphics.line(0,0,0, length, 0, 0);

    GameManager.graphics.popMatrix();
  }

  @Override
  void Update() {
    float speed = PI / 2f;
    speed *= LogicThread.Time.Delta();
    transform.Rotate(speed, speed, speed);
  }
}
