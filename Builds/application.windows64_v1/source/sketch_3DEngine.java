import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.opengl.*; 
import java.awt.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class sketch_3DEngine extends PApplet {



Scene defScene = new Scene();

Assets meshAssets;

public void setup(){
  
  
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

  camera(width/2.0f, height/2.0f, (height/2.0f) / tan(PI*30.0f / 180.0f), 0, 0, 0, 0, 1, 0);
  
  
  
} 


public void draw(){
  background(0);  
  lights();

  defScene.Draw_Scene();
  input.Update();
  Draw_Debug();
}


class Assets{

  ArrayList<Modell> Modells = new ArrayList<Modell>();
  Assets(String[] nameList){
    for(int i = 0; i < nameList.length; i++){
      Modells.add(new Modell(nameList[i]));
    }
  }
  
  public PShape getMesh(String s){
    for(Modell mod : Modells){
      if(mod.name == s){
        return mod.mesh;
      }
    }
    return null;
  }
}

class Modell{
  PShape mesh;
  String name;
  Modell(String s){
    name = s;
    mesh = loadShape(s + ".obj");
  }
}


abstract class Component {
  GameObject gameObject;
  Transform transform;
  public void Update(){}
  public void Start(){}
  public final Component GetComponent(Class cls){
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
  
  public void Start(){}
  
  public void Update(){
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
  
  public void Update(){
    
  }
}



class CamFlyMovment extends Component{
  
  InpAxis h, v, r;
  
  public void Start(){
    h = input.getAxis("Horizontal");
    v = input.getAxis("Vertical");
    r = input.getAxis("Roll");
  }
  
  public void Update(){
    
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
  
  public void Update(){
    transform.position.addVec(Velocity);
    transform.rotation = transform.rotation.multiply(Torque);
    
  }
  
  public void addForce(Vector3 f){    
    Velocity.addVec(f.devide(Mass));
  }
  
  public void addTorque(Quaternion q){
    Torque.multiply(q);
  }
}





class Rotate extends Component{
  
  Physics physics;
  Key g;
  
  public void Start(){
    
    physics = (Physics)GetComponent(Physics.class);
    g = input.getKey('g');
    
    
    
    //transform.rotation.SetEuler(new Vector3(QUARTER_PI,QUARTER_PI, QUARTER_PI));

    
  }
  
  float step;
  
  public void Update(){
    
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


static class Math{
  
  public static float Clamp(float x, float min, float max){
    return (x < min)? min : (x > max)? max : x;
  }
  
  public static float SircularClamp(float x, float min, float max){
    if(x > max){
      x = min + (x - max);
    }
    else if(x < min){
      x = max - (min - x); 
    }
    
    return x;
  }
  
  
}


class GameObject{
  
  Transform transform; 

  ArrayList<Component> components = new ArrayList<Component>();
  
  public void init(){
    transform = new Transform();
    
  }
  
  
  GameObject(){
    init();
  }
  
  GameObject(Component[] comps){
    init();
    for(int i = 0; i < comps.length; i++){
      comps[i].gameObject = this;
      comps[i].transform = this.transform;
      components.add(comps[i]);
    }
    for(Component comp : components){
      comp.Start();
    }
  }
  
  
  public void Update(){
    for(Component co : components){
      co.Update();
    }
  
  }
  
  public void addComponent(Component a){
    a.gameObject = this;
    a.transform = this.transform;
    components.add(a);
    a.Start();
  }
  
  
  
}


class Quaternion{
  float x, y, z, w;
  
  
  Quaternion(){
    x = y = z = 0.0f;
    w = 1.0f;
  }
  
  
  public Vector3 Forward(){
    return new Vector3(2 * (x*z + w*y),
                       2 * (y*z - w*x),
                       1 - 2 * (x*x + y*y));
  } 
  public Vector3 Right(){
    return new Vector3(1 - 2 * (y*y + z*z),
                       2 * (x*y + w*z),
                       2 * (x*z - w*y));
  }
  public Vector3 Up(){
    return new Vector3(2 * (x*y - w*z),
                       1 - 2 * (x*x + z*z),
                       2 * (y*z + w*x));
  }
  
  
  Quaternion(float X, float Y, float Z, float W){
    x = X;
    y = Y;
    z = Z;
    w = W;
  }
  
  
  public void Normelize(){
    float norme = sqrt(sq(w) + sq(x) + sq(y) + sq(z));
    if(norme == 0.0f){
      x = y = z = 0.0f;
      w = 1.0f;
    }else{
      float recip = 1.0f / norme;
      w *= recip;
      x *= recip;
      y *= recip;
      z *= recip;
    }
  }
  
  
  
  public Vector4 GetAxisAngle(){
    Vector4 a = new Vector4();
    if(w > 1){
      this.Normelize();
    }
    float s = sqrt(1 - w * w);
    a.w = 2.0f * acos(w);
    if(s < 0.001f){
      a.x = x;
      a.y = y;
      a.z = z;
    }else{
      a.x = x / s;
      a.y = y / s;
      a.z = z / s;
    }
    return a;
  }
  
  
  public Vector3 GetEuler(){
    Vector3 eul = new Vector3();
    
    float sinr = +2.0f * (w * x + y * z);
    float cosr = +1.0f - 2.0f * (x * x + y * y);
    eul.x = atan2(sinr, cosr);
    
    float sinp = +2.0f * (w * y - z * x);
    if(abs(sinp) >= 1){
      eul.y = java.lang.Math.copySign(PI / 2, sinp);
    }else{
      eul.y = asin(sinp);
    }
    
    
    float siny = +2.0f * (w * z + x * y);
    float cosy = +1.0f - 2.0f * (y * y + z * z);  
    eul.z = atan2(siny, cosy);
    
    return eul;
  }
  
  public void SetEuler(Vector3 eul){
    
    float cy = cos(eul.z * .5f);
    float sy = sin(eul.z * .5f);
    float cr = cos(eul.x * .5f);
    float sr = sin(eul.x * .5f);
    float cp = cos(eul.y * .5f);
    float sp = sin(eul.y * .5f);
    
    w = cy * cr * cp + sy * sr * sp;
    x = cy * sr * cp - sy * cr * sp;
    y = cy * cr * sp + sy * sr * cp;
    z = sy * cr * cp - cy * sr * sp;
  }
  
  
  
  public Quaternion multiply(Quaternion q){
    float nw = w * q.w - (x * q.x + y * q.y + z * q.z);
    
    float nx = w*q.x + q.w*x + y*q.z - z*q.y;
    float ny = w*q.y + q.w*y + z*q.x - x*q.z;
    float nz = w*q.z + q.w*z + x*q.y - y*q.x;
    
    return new Quaternion(nx, ny, nz, nw); 
  }
  
  
  public void SetAxisAngle(float angle, Vector3 axis){
    float omega, s, c;
    //int i;
    
    s = axis.Magnitude();
    
    if(abs(s) > Float.MIN_VALUE){
      c = 1.0f / s;
      
      axis.x *= c;
      axis.y *= c;
      axis.z *= c;
      
      omega = -0.5f * angle;      
      s = (float)sin(omega);
      
      x = s * axis.x;
      y = s * axis.y;
      z = s * axis.z;
      w = (float)cos(omega);
      
    }else{
      x = y = z = 0.0f;
      w = 1.0f;
    }
    Normelize();    
  }
  
  
  public void addQuat(Quaternion q){
    x += q.x;
    y += q.y;
    z += q.z;
    w += q.w;
  }
}


static class Renderer{

}


class Scene{

  ArrayList<GameObject> objects = new ArrayList<GameObject>();
  
  Camera camera = new Camera();
  Canvas UI = new Canvas();
  
  public void Draw_Scene(){
    camera.Update();
    UI.Update();
    for(GameObject be : objects){
      be.Update();
    }  
  }
  
  public void addObj(GameObject obj){
    objects.add(obj);
  }
  
  public GameObject Instantiate(String mesh){
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
  
  public void Update(){
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


public void Draw_Debug(){

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


class Transform{
  
  Vector3 position;
  Vector3 scale;
  Quaternion rotation;


  Transform(){
    position = new Vector3();
    scale = new Vector3(1);
    rotation = new Quaternion();
  }
  
  public void Translate(Vector3 v){
    position.addVec(v);
  }
  
  public void Rotate(Vector3 eul){       
    Quaternion q = new Quaternion();
    q.SetEuler(eul);
    rotation = rotation.multiply(q);
  }
  
  public Vector3 Forward(){               
    return rotation.Forward();    
  } 
  public Vector3 Right(){
    return rotation.Right();
  } 
  public Vector3 Up(){
    return rotation.Up();
  }
  
}


class Canvas{
  
  ArrayList<UIElement> Elements = new ArrayList<UIElement>();
  
  public void Update(){
    pushMatrix();
    Vector3 a = defScene.camera.transform.rotation.GetEuler();
    
    translate(defScene.camera.transform.position.x, defScene.camera.transform.position.y, defScene.camera.transform.position.z - 100);
    rotateY(a.y);
    //rotate(a.w, a.x, a.y, a.z);
    text(frameRate, width / 2,height / 2);
    for(int i = 0; i < Elements.size(); i++){
      Elements.get(i).Update();
    }  
    popMatrix();
  }
}

abstract class UIElement{
  
  public abstract void Update();
}


class Vector3{

  float x, y, z;
 

  
  Vector3(){
    x = 0;
    y = 0;
    z = 0;
  }
  
  Vector3(float xPos, float yPos, float zPos){  
    x = xPos;
    y = yPos; 
    z = zPos;
  }  
  
  Vector3(float pos){
    x = pos;
    y = pos; 
    z = pos;
  }
  
  public void setValue(float xp, float yp, float zp){
    x = xp;
    y = yp;
    z = zp;
  }
  
  public void addVec(Vector3 v){
    this.x += v.x;
    this.y += v.y;
    this.z += v.z;
  }
  
  public Vector3 multiply(float v){
    return new Vector3(x * v, y * v, z * v);
  }
  
  public Vector3 multiply(Vector3 v){
    return new Vector3(x * v.x, y * v.y, z * v.z);
  }
  
  public Vector3 devide(float v){
    return new Vector3(x / v, y / v, z / v);
  }
  
  public Vector3 plus(Vector3 v){
    return new Vector3(x + v.x, y + v.y, z + v.z);
  }
  
  public Vector3 plus(float v){
    return new Vector3(x + v, y + v, z + v);
  }
  
  public float distanceTo(Vector3 v){
    return sqrt(sq(x - v.x) + sq(y - v.y) + sq(z - v.z));
  }
  
  public float Magnitude(){
    return sqrt(sq(x) + sq(y) + sq(z));
  }
  
  
  public Vector3 inverted(){
    return new Vector3(-x, -y, -z);
  }
  
  public void Normelize(){
    float m = this.Magnitude();
    this.setValue(x / m, y / m, z / m);
  }

}

class Vector2{
  
  float x, y;
  
  Vector2(){
    x = 0;
    y = 0;
  }
  
  Vector2(float xPos, float yPos){  
    x = xPos;
    y = yPos;     
  }  
  
  Vector2(float pos){
    x = pos;
    y = pos;     
  }
  
  public void setValue(float xp, float yp){
    x = xp;
    y = yp;    
  }
  
  
  public boolean InsideOf(Vector2 a, Vector2 b){
    return (this.x < b.x && this.y < b.y && a.x < this.x && a.y < this.y)? true : false;
  }

}

class Vector4{
  float x, y, z, w;
  
  Vector4(){
  
  }
  
  Vector4(float X, float Y, float Z, float W){
    x = X;
    y = Y;
    z = Z;
    w = W;
  }

}




class Key{
  char Name;
  boolean Pressed;
  boolean Released;
  Key(char n){
    Name = n;
  }
  public void Update(){
    Released = false;
  }
}


class InpAxis{
  Key key1, key2;
  float Value;
  String Name;
  InpAxis(String n, char a, char b){
    Name = n;
    key1 = input.getKey(a);
    key2 = input.getKey(b);
  }
  
  public void Update(){
    if(key1.Pressed){
      Value += .1f;
    }
    if(key2.Pressed){
      Value -= .1f;
    }
    if(key1.Pressed == false && key2.Pressed == false && Value != 0){
      //if(Value < 0){
      //  Value += .1f;
      //}else{
      //  Value -= .1f;
      //}
      Value = 0;
    }
    Value = Math.Clamp(Value, -1, 1);
  }
  
  public float getValue(){
    return Value;
  }
}

enum MouseMode{
  Locked,
  Free,
}

class Input{
  
  Key[] keys;
  InpAxis[] Axis;
  
  Vector2 mouseMovment;
  Vector2 mousePos;
  
  MouseMode mouseMode;
  
  Robot robot;
  
  Input(){
    mouseMovment = new Vector2();
    mousePos = new Vector2();
  }
  
  public void Init(){
    char[] ch = {' ', 'w', 'a', 's', 'd', 'g', 'e', 'q'};
    keys = new Key[ch.length];
    for(int i = 0; i < ch.length; i++){
      keys[i] = new Key(ch[i]);
    }
    Axis = new InpAxis[]{new InpAxis("Vertical", 's', 'w'), new InpAxis("Horizontal", 'd', 'a'), new InpAxis("Roll", 'q', 'e')};
    
    try{
      robot = new Robot();
    }catch(AWTException e){
      e.printStackTrace();
    }
  }
  
  
  public void Update(){
   
    //mouseTurn = true;
    //mouseMovment.setValue(0,0);
    //if(!mousePos.InsideOf(new Vector2(0,0), new Vector2(100,100))){
    //  robot.mouseMove(50, 50);
    //  mouseTurn = false;
    //}
    //else if(mouseTurn){
    //  mouseMovment.setValue(pmouseX - mouseX, pmouseY - mouseY);
    //} 
    
    
    mouseMovment.setValue(mouseX - pmouseX, mouseY - pmouseY);
    mousePos.setValue(mouseX, mouseY);
    
    for(int i = 0; i < Axis.length; i++){
      Axis[i].Update();
    }
    for(int i = 0; i < keys.length; i++){
      keys[i].Update();
    }
  }
  
  
  
  public Key getKey(char n){
    for(int i = 0; i < keys.length; i++){
      if(keys[i].Name == n){
        return keys[i];
      }
    }
    return null;
  }
  
  public InpAxis getAxis(String n){
    for(int i = 0; i < Axis.length; i++){
      if(Axis[i].Name == n){
        return Axis[i];
      }
    }
    return null;
  }
} 
Input input;


public void keyPressed(){
  for(int i = 0; i < input.keys.length; i++){
    if(key == input.keys[i].Name){
      input.keys[i].Pressed = true;
    }
  }
}

public void keyReleased(){
  for(int i = 0; i < input.keys.length; i++){
    if(key == input.keys[i].Name){
      input.keys[i].Pressed = false;
      input.keys[i].Released = true;
    }
  }
}

public void mousePressed(){
  switch (mouseButton){
    case LEFT:
      break;
    case RIGHT:
      break;
    case CENTER:
      break;
  }
}

public void mouseReleased(){

}
  public void settings() {  fullScreen(OPENGL); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "sketch_3DEngine" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
