

class Scene{

  ArrayList<GameObject> objects = new ArrayList<GameObject>();
  
  Camera camera = new Camera();
  Canvas UI = new Canvas();
  
  void Draw_Scene(){
    camera.Update();
    UI.Update();
    for(GameObject be : objects){
      be.Update();
    }  
  }
  
  void addObj(GameObject obj){
    objects.add(obj);
  }
  
  GameObject Instantiate(String mesh){
    GameObject o = new GameObject(new Component[]{new MeshRenderer(mesh)});
    addObj(o);
    return o;
  }

}


class Camera{
  Transform transform;
  Camera(){
    transform = new Transform();
  }
  
  void Update(){
    // obj transform applyed to cam:
    Vector3 forward = transform.Forward();
    Vector3 up = transform.Up();
    camera(transform.position.x, transform.position.y, transform.position.z, 
      forward.x + transform.position.x, 
      forward.y + transform.position.y, 
      forward.z + transform.position.z,
      up.x, up.y, up.z);
  }
}


void Draw_Debug(){

  pushMatrix();
  
  scale(10);
  stroke(color(255,0,0));
  line(0,0,0,1000,0,0);
  stroke(color(0,255,0));
  line(0,0,0,0,1000,0);
  stroke(color(0,0,255));
  line(0,0,0,0,0,1000);

  popMatrix();

}