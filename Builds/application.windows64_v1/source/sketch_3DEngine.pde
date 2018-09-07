import processing.opengl.*;

Scene defScene = new Scene();

Assets meshAssets;

void setup(){
  fullScreen(OPENGL);
  
  //----init-Inputs-----
  input = new Input();
  input.Init();
  //--------------------
  
  //----init-Assets-----
  String[] meshNames = {"lowPolyDragon", "GalleonBoat", "box", "spaceCraft"};
  meshAssets = new Assets(meshNames);
  //--------------------

  GameObject o = new GameObject(new Component[]{new MeshRenderer("GalleonBoat"), new Physics(500)});
  o.transform.position = new Vector3(0,-500,0);
  o.transform.scale = new Vector3(100,100,100);

  GameObject or = new GameObject(new Component[]{new MeshRenderer("spaceCraft"), new Rotate(), new Physics(100)});
  or.transform.position = new Vector3(700,30,0);
  or.transform.scale = new Vector3(40); 

  defScene.addObj(o);
  defScene.addObj(or);
  
  
  for(int i = 0; i < 100; i++){
    GameObject op = defScene.Instantiate("box");
    float s = random(40, 100);
    op.transform.scale.setValue(s, s, s);
    Physics p = new Physics(100);
    Vector3 r = new Vector3(random(-1,1),random(0,1),random(-1,1));
    Quaternion q = new Quaternion();
    q.SetEuler(new Vector3(random(-.01f, .01f),random(-.01f, .01f),random(-.01f, .01f)));
    p.Torque = q;
    r.Normelize();
    p.Velocity = r.multiply(random(1,3));
    op.transform.position = r.multiply(100);
    op.addComponent(p);   
  }
  
  //init a camera obj
  GameObject cam = new GameObject(new Component[]{new CamFlyMovment()});
  cam.transform.position.setValue(900,900,900);
  defScene.addObj(cam);

  camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), 0, 0, 0, 0, 1, 0);
  
  
  
} 


void draw(){
  background(0);  
  lights();

  defScene.Draw_Scene();
  input.Update();
  Draw_Debug();
}