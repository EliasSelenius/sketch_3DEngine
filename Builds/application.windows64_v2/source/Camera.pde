

class Camera extends Component {
  
  PImage Buffer;
  int NearClipPlane;
  int FarClipPlane;
  float FieldOfView;
  
  Camera(){
    NearClipPlane = 3;
    FarClipPlane = 10000;
    FieldOfView = 70;
  }
  
  void Start(){
    if(gameObject.scene.MainCamera == null){
      gameObject.scene.MainCamera = this;
    }
  }
  
  void End(){
    gameObject.scene.MainCamera = null;
  }
  
  void LateUpdate(){   
    Buffer = Renderer.Frame(this);    
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
      
    float speed = 10;
    if(keyPressed && keyCode == SHIFT){
      speed *= 4;      
    }
      
    // fly movement:
    transform.Translate(transform.Forward().multiply(-v.getValue() * speed));
    transform.Translate(new Vector3(0,(input.getKey(' ').Pressed)? 1 : 0,0));
    transform.Translate(transform.Right().multiply(-h.getValue() * speed));
    
    // look rotation:    
    transform.Rotate(new Vector3(-input.mouseMove.y, -input.mouseMove.x, r.Value * 2f).devide(100));
    
    
    
    //spotLight(0,255,0, transform.position.x, transform.position.y, transform.position.z, 0, -1, 0, 60, 600);
    
  }
}


class CameraOrbit extends Component {
 
  float zoom, hor, vert;
  
  void Update(){
    
    hor += input.mouseMove.x / 100;
    vert += input.mouseMove.y / 100;
    zoom = Math.Clamp(zoom + input.mouseWheel * 10, 10, 100000);
    
    transform.position.x = sin(hor) * zoom;
    transform.position.z = cos(hor) * zoom;
    transform.position.y = sin(vert) * zoom;
    
    transform.LookAt(new Vector3(1), new Vector3(0,-1,0));
       
  }
}