

class Camera extends Component {
  
  PImage Buffer;
  int NearClipPlane;
  int FarClipPlane;
  float FieldOfView;
  
  Camera(){
    NearClipPlane = 3;
    FarClipPlane = 100000;
    // FieldOfView: in degrees, must be from 1 to 179.
    FieldOfView = 90;
  }
  
  @Override
  void Start(){
    if(gameObject.scene.MainCamera == null){
      gameObject.scene.MainCamera = this;
    }
  }
  
  @Override  
  void End(){
    if(gameObject.scene.MainCamera == this){
      gameObject.scene.MainCamera = null;
    }
  }
    
  @Override
  void Update(){
    //FieldOfView = 85 + sin(frameCount / 100f) * 85;
  }
  
  @Override
  void LateUpdate(){
    Vector3 forward = transform.Forward();
    Vector3 up = transform.Up();
    ScreenSurface.graphics.camera(transform.position.x, transform.position.y, transform.position.z, 
      forward.x + transform.position.x, 
      forward.y + transform.position.y, 
      forward.z + transform.position.z,
      up.x, up.y, up.z);   
    ScreenSurface.graphics.perspective(radians(FieldOfView), (float)width / (float)height, NearClipPlane, FarClipPlane);
    Buffer = ScreenSurface.graphics.copy();
  }
  
  @Override
  void Render(){
    //c.Render(transform.position.plus(transform.Forward().multiply(100)), new Vector3(1), transform.rotation);
  }
}


class CamFlyMovment extends Component{
  
  InpAxis h, v, r;
  
  OcTreeRenderer tree;
  
  void Start(){
    h = input.GetAxis("Horizontal");
    v = input.GetAxis("Vertical");
    r = input.GetAxis("Roll");
    
    
    //tree = (OcTreeRenderer)gameObject.scene.FindObject("tree").GetComponent(OcTreeRenderer.class);
  }
  
  void Update(){    
      
    float speed = 10;
    if(keyPressed && keyCode == SHIFT){
      speed *= 4;      
    }
      
    // fly movement:
    transform.Translate(transform.Forward().multiply(-v.getValue() * speed));
    transform.Translate(new Vector3(0F,(input.GetKey(' ').Pressed)? 1F : 0F,0F));
    transform.Translate(transform.Right().multiply(-h.getValue() * speed));
    
        // look rotation:    
    transform.Rotate(new Vector3(-input.mouseMove.y, -input.mouseMove.x, r.Value * 2f).devide(100F));
    
    if(input.GetKey('g').Pressed){
      exc.ExecuteLine("exec invokeTest.txt");
      
      //tree.ocTree.Insert(new Physics(10f), transform.position);
      
      //for(int i = 0; i < 50; i++) {
      //  float s = tree.ocTree.Root.cube.Size / 2f;
      //  tree.ocTree.Insert(new Physics(10f), new Vector3(random(-s, s), random(-s, s), random(-s, s)));
      //}
      
    }
    
    
    
    
    
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
    
    transform.LookAt(new Vector3(1F), new Vector3(0F,-1F,0F));
       
  }
}
