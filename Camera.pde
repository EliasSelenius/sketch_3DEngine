
class Camera {
  
  Transform transform = new Transform();
  
  PImage Buffer;

  int NearClipPlane;
  int FarClipPlane;
  float FieldOfView;


  Camera() {
    NearClipPlane = 3;
    FarClipPlane = 100000;
    // FieldOfView: in degrees, must be from 1 to 179.
    FieldOfView = 90;
  }

  void ApplySettings() {
    Vector3 forward = transform.Forward();
    Vector3 up = transform.Up();
    GameManager.graphics.camera(transform.position.x, transform.position.y, transform.position.z, 
      forward.x + transform.position.x, 
      forward.y + transform.position.y, 
      forward.z + transform.position.z,
      up.x, up.y, up.z);   
    GameManager.graphics.perspective(radians(FieldOfView), (float)width / (float)height, NearClipPlane, FarClipPlane);
    Buffer = GameManager.graphics.copy();
  }
}


class CameraHandler extends Component {
  Camera cam;
  @Override
  void Start() {
    cam = GameManager.MainCamera;
    cam.transform = transform;
  }
}

class CamFlyMovment extends Component {
  
  InpAxis h, v, r;
  
  OcTreeRenderer tree;
  
  void Start(){
    h = input.GetAxis("Horizontal");
    v = input.GetAxis("Vertical");
    r = input.GetAxis("Roll");
    
    
    //tree = (OcTreeRenderer)gameObject.scene.FindObject("tree").GetComponent(OcTreeRenderer.class);
  }

  int timesGpressed = 0;
  
  void Update(){    
      
    float speed = 10f;
    if(keyPressed && keyCode == SHIFT){
      speed *= 4f;      
    }
      
    float d = LogicThread.Time.Delta(); 

    // fly movement:
    transform.Translate(transform.Forward().multiply(-v.getValue() * speed).multiply(d));
    transform.Translate(transform.Up().multiply(((input.GetKey(' ').Pressed)? -1F : 0F) * speed).multiply(d));
    transform.Translate(transform.Right().multiply(-h.getValue() * speed).multiply(d));
    
    // look rotation:    
    transform.Rotate(new Vector3(-input.mouseMove.y, -input.mouseMove.x, r.Value * 2f).multiply(d));

    println("Pos: " + transform.position + " Delta: " + d);

    //transform.Translate(1f * d, 1f * d, 1f * d);

    //println(input.mouseMove);

    //println(transform.position);
    
    //println(LogicThread.Time.Delta());

    //println(new Vector3(-input.mouseMove.y, -input.mouseMove.x, r.Value * 2f).multiply(d));


    if(input.GetKey('g').Released){
      
      timesGpressed++;
      println("timesGpressed: "+timesGpressed);

      GameObject cube = gameObject.scene.Instantiate("TestCube", new MeshRenderer("box"), new DebugComponent());
      cube.transform.position.setValue(transform.position);

      
      //exc.ExecuteLine("exec invokeTest.txt");
      
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
