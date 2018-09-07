import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.Map; 
import java.lang.annotation.*; 
import java.lang.reflect.Constructor; 
import java.lang.reflect.Field; 
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



//----Global-Variables------
// deltaTime: seconds since last update.
float deltaTime;
// assets: controls loading of all assets.
Assets assets;
// prefabs: controls saving and loading of GameObject.
PrefabManager Prefabs;
// Math: a collection of usefull functions.
MathLib Math = new MathLib();
// defScene: the scene that gets updated.
Scene defScene;
// Renderer: the Rendering Manager.
GraphicsRenderer Renderer;
// G: the Gravitational constant.
final float G = 6.67f * (10^-11);
// variables for a planet.
Vector3 planetpoint = new Vector3(4000,2000,0);
float planetMass = 1500;
//--------------------------


public void setup(){
  
  
  //size(1800, 900, OPENGL);
  
  
  //----init-Inputs-----
  input = new Input();
  input.Init();
  //--------------------
  
  //----init-Assets-----  
  assets = new Assets();
  assets.loadModdelAssets("lowPolyDragon", "GalleonBoat", "box", "spaceCraft");
  assets.loadTextureAssets("front", "Skyboxes\\Skybox_front", "Skyboxes\\Skybox_back", "Skyboxes\\Skybox_up", "Skyboxes\\Skybox_down", "Skyboxes\\Skybox_right", "Skyboxes\\Skybox_left");
  // shader loading:
  assets.loadShaderAsset("InvertShader", "vertex.glsl", "fragment.glsl");
  assets.loadShaderAsset("texShader", "texvert.glsl", "texfrag.glsl");
  //--------------------
  
  //----init-Prefabs----
  Prefabs = new PrefabManager();
  //--------------------

  //----init-Renderer---
  Renderer = new GraphicsRenderer();
  //--------------------
  
  
  //XMLConverter xconv = new XMLConverter();
  //saveXML(xconv.GetXML(new Physics(10f)), "data\\prefabs\\NewTestXML");
  
  //FindFields(sketch_3DEngine.Physics.class, SerializeField.class);


  CreateGalaxy();
} 



public void draw(){
  
  //----Update-Globals----
  deltaTime = 1 / frameRate;
  //----------------------

  
  //pointLight(255,100,0, planetpoint.x, planetpoint.y, planetpoint.z);
  //directionalLight(200,200,200, 0,-1,0);
  //ambientLight(100,100,100);
  
  defScene.Update();
  Renderer.Render();
  
  input.Update();
  
  
}


class AnimCurve {
  
  ArrayList<Vector2> keys = new ArrayList<Vector2>();
  
  public void AddKey(float time, float value){
    
  }
  
  public float Evaluate(float time){
    return 0;
  }
}


//class AnimCurve3 extends AnimCurve {
//  void AddKey(float time, float x, float y, float z)
//}


class Assets{

  ArrayList<ModellAsset> Modells = new ArrayList<ModellAsset>();
  ArrayList<TextureAsset> Textures = new ArrayList<TextureAsset>(); 
  ArrayList<ShaderAsset> Shaders = new ArrayList<ShaderAsset>(); 
  
  public void loadModdelAssets(String... nameList){
    for(int i = 0; i < nameList.length; i++){
      Modells.add(new ModellAsset(nameList[i]));
    }
  }
  
  public void loadTextureAssets(String... nameList){
    for(int i = 0; i < nameList.length; i++){
      Textures.add(new TextureAsset(nameList[i]));
    }
  }
  
  public void loadShaderAsset(String Name, String vert, String frag){
    Shaders.add(new ShaderAsset(Name, vert, frag));
  }
  
  public PShader getShader(String Name){
    for(ShaderAsset shd : Shaders){
      if(shd.name == Name){
        return shd.shader;
      }
    }
    return null;
  }
  
  public PImage getTexture(String n){
    for(TextureAsset tex : Textures){
      if(tex.name == n){
        return tex.tex;
      }
    }
    return null;
  }
  
  public PShape getMesh(String s){
    for(ModellAsset mod : Modells){
      if(mod.name == s){
        return mod.mesh;
      }
    }
    return null;
  }
}

class ShaderAsset{
  PShader shader;
  String name;
  ShaderAsset(String n, String vertex, String fragment){
    name = n;
    shader = loadShader("shaders\\" + fragment, "shaders\\" + vertex);
  }
}

class TextureAsset {
  PImage tex;
  String name;
  TextureAsset(String n){
    name = n;
    tex = loadImage("texture\\" + n + ".png");
  }
}

class ModellAsset {
  PShape mesh;
  String name;
  ModellAsset(String s){
    name = s;
    mesh = loadShape("mesh\\" + s + ".obj");
  }
}


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
  
  public void Start(){
    if(gameObject.scene.MainCamera == null){
      gameObject.scene.MainCamera = this;
    }
  }
  
  public void End(){
    gameObject.scene.MainCamera = null;
  }
  
  public void LateUpdate(){   
    Buffer = Renderer.Frame(this);    
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
  
  public void Update(){
    
    hor += input.mouseMove.x / 100;
    vert += input.mouseMove.y / 100;
    zoom = Math.Clamp(zoom + input.mouseWheel * 10, 10, 100000);
    
    transform.position.x = sin(hor) * zoom;
    transform.position.z = cos(hor) * zoom;
    transform.position.y = sin(vert) * zoom;
    
    transform.LookAt(new Vector3(1), new Vector3(0,-1,0));
       
  }
}
 

class ColliderArray {
  ArrayList<Collider> Colliders = new ArrayList<Collider>();
  
  public void Update(){
    
    for(int i = 0; i < Colliders.size(); i++){
      Collider collider = Colliders.get(i);
      for(int j = 0; j < Colliders.size(); j++){
        Collider other = Colliders.get(j);
        if(collider != other){
          if(collider.isColliding(other)){            
            collider.gameObject.OnColliderHit(other);
          }
        }
      }
    }
  }
  
  public void Cast(Vector3 pos, Vector3 dir){
  
  }
  
  public void Add(Collider c){
    Colliders.add(c);
  }
  public void Remove(Collider c){
    Colliders.remove(c);
  }
}

class ColliderMaterial {
  float Bounciness;
  ColliderMaterial(float b){
    Bounciness = b;
  }
}

abstract class Collider extends Component {
  
  ColliderMaterial Material;
  
  boolean Colliding;

  public final void Start(){
    gameObject.scene.colliderArray.Add(this);
  }
  public final void End(){
    gameObject.scene.colliderArray.Remove(this);
  }
  public final void Update(){
    DebugDraw();
    Colliding = false;
  }
  public void DebugDraw(){}
  
  public void OnColliderHit(Collider other){
    Colliding = true;
    println(this + " on " + gameObject.Name + " collided with " + other + " on " + other.gameObject.Name);
  }
  
  public boolean isColliding(Collider other){
    if(other instanceof SphereCollider){
      return isColliding((SphereCollider)other);
    }else if(other instanceof PointCollider){
      return isColliding((PointCollider)other);
    }else if(other instanceof BoxCollider){
      return isColliding((BoxCollider)other);
    }
    return false;
  }
  
  public abstract boolean isColliding(SphereCollider other);
  public abstract boolean isColliding(PointCollider other);
  public abstract boolean isColliding(BoxCollider other);
  
  
}


class SphereCollider extends Collider {
  float Radius;
  SphereCollider(float r){
    Radius = r;
  }
  
  public void DebugDraw(){
    pushMatrix();
    translate(transform.position.x, transform.position.y, transform.position.z);
    noFill();
    if(Colliding){
      stroke(255,0,0);
    }else{
      stroke(0, 255, 0);
    }
    sphere(Radius);
    popMatrix();
  }
  
  public boolean isColliding(SphereCollider other){
    float dist = other.transform.position.distanceTo(transform.position);
    dist -= Radius + other.Radius;
    if(dist <= 0){
      return true;
    }
    return false;
  }
  public boolean isColliding(PointCollider other){
    float dist = other.transform.position.distanceTo(transform.position);
    dist -= Radius;
    if(dist <= 0){
      return true;
    }
    return false;
  }
  public boolean isColliding(BoxCollider other){return false;}
}


class PointCollider extends Collider {
  public boolean isColliding(SphereCollider other){
    float dist = other.transform.position.distanceTo(transform.position);
    dist -= other.Radius;
    if(dist <= 0){
      return true;
    }
    return false;
  }
  public boolean isColliding(PointCollider other){
    if(transform.position.x == other.transform.position.x && transform.position.y == other.transform.position.y && transform.position.z == other.transform.position.z){
      return true;
    }
    return false;
  }
  public boolean isColliding(BoxCollider other){return false;}
}

class BoxCollider extends Collider {
  public boolean isColliding(SphereCollider other){return false;}
  public boolean isColliding(PointCollider other){return false;}
  public boolean isColliding(BoxCollider other){return false;}
}


abstract class Component {
  GameObject gameObject;
  Transform transform;
  public void LateUpdate(){}
  public void Update(){}
  public void Start(){}
  public void End(){}
  public void OnColliderHit(Collider other){}
  public final Component GetComponent(Class cls) {
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

class Galaxy extends Component {
  int Arms;
  float ArmLength;
  
  Galaxy(int a, float l){
    Arms = a;
    ArmLength = l;
  }
  
  public void Start(){
    Sprite s = new Sprite(assets.getTexture("front"));    
    ParticleSystem p = new ParticleSystem(new GalaxyEmission(this), s, 12f, 20f);
    p.LocalSpace = true;
    p.EndTint = color(255, 0);
    gameObject.AddComponent(p);
  }
  
  // GetCoord: gets the local coordinate position from parameters: arm(0-Arms) and length(0-1). 
  public Vector3 GetCoord(int arm, float Length){
    float dist = ArmLength * Length;
    float angle = ((TAU / Arms) * arm) + (dist / 3.2f);
    return new Vector3(sin(angle) * dist, 0, cos(angle) * dist);
  }
  
  
  public GameObject CreateRandomSector(){
    ParticleSystem p = new ParticleSystem(new SphereEmission(100f), new Sprite(assets.getTexture("front")), 2f, 3f);
    p.LocalSpace = true;
    p.Scaler = 10;
    GameObject o = new GameObject(new SphereCollider(100), p);
    return o;
  }
}


class GalaxyEmission extends EmissionShape {
  Galaxy galaxy;
  GalaxyEmission(Galaxy g){
    galaxy = g;
  }
  public void processParticle(Particle p){  
    p.transform.position.setValue(galaxy.GetCoord((int)random(galaxy.Arms), random(1)));
    p.transform.rotation.SetRandom();
  }
}


public void CreateGalaxy(){
  Scene scene = new Scene();
  
  scene.Instantiate("Camera", new Camera(), new CamFlyMovment());
    

  scene.Instantiate("Galaxy", new Vector3(0), new Vector3(1000), new Quaternion(), new Galaxy(5, 10));
  
  defScene = scene;
}


interface IShape {
  
  public float Volume();
  public float Area();
  public float MaxLengthFromPivot();
  
}

class Sphere implements IShape {
  float Radius;
  Sphere(float r){
    Radius = r;
  } 
  public float Volume() { return (4 / 3) * PI * pow(Radius, 3); }
  public float Area() { return 4 * PI * sq(Radius); }
  public float MaxLengthFromPivot() { return Radius; }
}

class Cube implements IShape {
  float Size;
  Cube(float s){
    Size = s;
  }
  public float Volume() { return pow(Size, 3); }
  public float Area() { return 6 * (Size * Size); }
  public float MaxLengthFromPivot() { return sqrt(sq(Size) * 3) / 2f; }
}

class Cuboid implements IShape {
  float Width, Height, Depth;
  Cuboid(float w, float h, float d){
    Width = w; Height = h; Depth = d;
  }
  public float Volume() { return Width * Height * Depth; }
  public float Area() { return (2 * (Width * Height)) + (2 * (Height * Depth)) + (2 * (Width * Depth)); }
  public float MaxLengthFromPivot() { return sqrt(sq(Width) + sq(Height) + sq(Depth)) / 2f; }
}

class Cylinder implements IShape {
  float Radius, Height;
  Cylinder(float r, float h){
    Radius = r; Height = h;
  }
  public float Volume() { return Height * (TAU * sq(Radius)); }
  public float Area() { return (TAU * sq(Radius)) + (Height * (TAU * Radius)); }
  public float MaxLengthFromPivot() { return sqrt(sq(Height / 2) + sq(Radius)); }
}

class Cone implements IShape {
  float LowerRadius, UpperRadius, Height;
  Cone(float l, float u, float h){
    LowerRadius = l; UpperRadius = u; Height = h;
  }
  public float Volume() { return ((PI * Height) / 3) * (sq(LowerRadius) + (LowerRadius * UpperRadius) + sq(UpperRadius)); }
  public float Area() { System.err.println("Cone does not have a implementation of Area(), 0 is returnd"); return 0; }
  public float MaxLengthFromPivot() { return sqrt(sq(Height / 2) + sq(max(LowerRadius, UpperRadius))); }
}




 


class MathLib {
  
  public float Clamp(float x, float min, float max){
    return (x < min)? min : (x > max)? max : x;
  }
  
  public float SircularClamp(float x, float min, float max){
    if(x > max){
      x = min + (x - max);
    }
    else if(x < min){
      x = max - (min - x); 
    }
    
    return x;
  }
  
  public float VecDist2(float x, float y, float x1, float y1){
    return sqrt(sq(x - x1) + sq(y - y1));
  }
  
  public float VecDist3(float x, float y, float z, float x1, float y1, float z1){
    return sqrt(sq(x - x1) + sq(y - y1) + sq(z - z1));
  }
  
  public Vector3 Vec3(PVector pv){
    return new Vector3(pv.x, pv.y, pv.z);
  }
  
}


class Matrix3 {
  
  
  float m00, m01, m02;
  float m10, m11, m12;
  float m20, m21, m22;
  
  Matrix3(){
  
  }
  
  Matrix3(Vector3 a, Vector3 b, Vector3 c){
    m00 = a.x;  m01 = b.x;  m02 = c.x;
    m10 = a.y;  m11 = b.y;  m12 = c.y;
    m20 = a.z;  m21 = b.z;  m22 = c.z;
  }
  
  public Vector3 GetA(){
    return new Vector3(m00, m10, m20);
  }
  public Vector3 GetB(){
    return new Vector3(m01, m11, m21);
  }
  public Vector3 GetC(){
    return new Vector3(m02, m12, m22);
  }
  
  public Vector3 multiply(Vector3 v){
    Vector3 a = GetA().multiply(v.x);
    Vector3 b = GetB().multiply(v.y);
    Vector3 c = GetC().multiply(v.z);
    return a.plus(b).plus(c);
  }
}
  

class GameObject {
  
  Transform transform; 
  String Name;
  ArrayList<Component> components = new ArrayList<Component>();
  Scene scene;
  
  public void init(){
    transform = new Transform();       
  }
  
  GameObject(){
    init();
  }
  
  GameObject(Component... comps){
    init();
    for(int i = 0; i < comps.length; i++){
      comps[i].gameObject = this;
      comps[i].transform = this.transform;
      components.add(comps[i]);
    }
  }
  
  public void OnColliderHit(Collider other){
    for(int i = 0; i < components.size(); i++){
      components.get(i).OnColliderHit(other);
    }
  }
  

  public void Update(){
    for(Component co : components){
      co.Update();
    }
  }
  
  public void LateUpdate(){
    for(Component co : components){
      co.LateUpdate();
    }
  }
  
  public void Start(){
    for(int i = 0; i < components.size(); i++){
      components.get(i).Start();
    }
  }
  
  public void End(){
    for(Component co : components){
      co.End();
    }
    components = null;
  }
  
  public void AddComponent(Component a){
    a.gameObject = this;
    a.transform = this.transform;
    components.add(a);
    a.Start();
  }  
  
  public final Component GetComponent(Class cls) {
    for(Component comp : components){
      if(cls.isInstance(comp)){
        return comp;
      }
    }
    return null;
  }
  
  

}

interface IOcTreeIndex {
  public Vector3 GetPosition();
}

class OcTree<T extends IOcTreeIndex> {
  
  
  class Node{
    Node[] Children; 
  }
}



class Particle {
  Transform transform;
  Vector3 Velocity;
  Vector3 AngularVelocity;
  
  // LifeTime in seconds.
  float LifeTime;
  // Speed in units per seconds
  float Speed;
  
  Particle(){
    transform = new Transform();
    Velocity = new Vector3();
    AngularVelocity = new Vector3();
    Speed = 10;
  }
  
  public void Update(){
    LifeTime += deltaTime;
    transform.Translate(Velocity.multiply(Speed * deltaTime));
    transform.Rotate(AngularVelocity.multiply(deltaTime));
  }  
}




class ParticleSystem extends Component {
  
  
  // Emission: settings for the start velocity and position.
  EmissionShape Emission;
  // emissionRate: how many particles gets emitted each second.
  float EmissionRate;
  // MaxLifeTime: particles max lifetime in seconds.
  float MaxLifeTime;
  // renderObj: the way all the particles gets renderd.
  RenderObject renderObj;
  // LocalSpace: does the particles simulate in local space or world space.
  boolean LocalSpace = false;
  // Scaler: scales the particles.
  float Scaler = 1;
  
  // StartTint: the start tint color of the RenderObject(Particle).  
  int StartTint = color(255, 255);
  // EndTint: the end tint color of the RenderObject(Particle).
  int EndTint = color(255, 255);
  
  
  
  ParticleSystem(EmissionShape emt, RenderObject renobj, Float rate, Float time){
    Emission = emt;
    renderObj = renobj;
    EmissionRate = rate;
    MaxLifeTime = time;
  }
  
  ArrayList<Particle> particles = new ArrayList<Particle>();
  float particlesQued;
  
  // Draw(): Draws the Particles in its current state, this does not Update the Physics.
  public void Draw(){
  
    pushMatrix();
    if(LocalSpace){
      translate(transform.position.x, transform.position.y, transform.position.z);
      scale(transform.scale.x, transform.scale.y, transform.scale.z);
      Vector4 axisAngle = transform.rotation.GetAxisAngle();
      rotate(axisAngle.w, axisAngle.x, axisAngle.y, axisAngle.z);
    }    
    

    for(int i = 0; i < particles.size(); i++){
      Particle p = particles.get(i);
      float t = p.LifeTime / MaxLifeTime;
      renderObj.TintColor = lerpColor(StartTint, EndTint, t);
      renderObj.Queue(p.transform.position, p.transform.scale.multiply(Scaler), p.transform.rotation);
    }
    
    popMatrix();
  }
  
  // Update(): Updates the Physics of each particle.
  public void Update() {
    // Update Particles. kill particle:
    for(int i = 0; i < particles.size(); i++){
      Particle p = particles.get(i);
      p.Update();
      if(p.LifeTime > MaxLifeTime){
        particles.remove(i);
      }
    }
    
    // create new particles:
    Burst(EmissionRate / frameRate); 
    
    // Draw particles:
    Draw();
  }
  
  // Burst(): instantly spawns the number of particles specified. 
  public void Burst(float burstNum){
    particlesQued += burstNum;
    for(int i = 0; i < floor(particlesQued); i++){
      NewParticle();
    }
    particlesQued -= floor(particlesQued);
  }
  
  // NewParticle(): spawns a new Particle in the system.
  public void NewParticle(){   
    Particle p = Emission.NewParticle();
    if(!LocalSpace){
      p.transform.position.addVec(transform.position);     
    }    
    particles.add(p);
  }
  
}






// class EmissionShape: used by a ParticleSystem to know the start location and velocity of a particle.
abstract class EmissionShape{
  float StartMinVelocity = 0f;
  float StartMaxVelocity = 0f;  
  public final Particle NewParticle(){
    Particle p = new Particle();    
    processParticle(p);    
    return p; 
  }
  public abstract void processParticle(Particle p);
}
 
class PointEmission extends EmissionShape {  
  PointEmission(float min, float max){
    StartMinVelocity = min;
    StartMaxVelocity = max;
  }
  public void processParticle(Particle p){
    p.Velocity.setRandomNormelizedDirection();
    p.Velocity = p.Velocity.multiply(random(StartMinVelocity, StartMaxVelocity));    
  }
}

class SphereEmission extends EmissionShape {  
  float radius;
  SphereEmission(float r){
    radius = r;
  }
  SphereEmission(float minvel, float maxvel, float r){
    StartMinVelocity = minvel;
    StartMaxVelocity = maxvel;
    radius = r;
  }
  public void processParticle(Particle p){
    Vector3 dir = new Vector3();
    dir.setRandomNormelizedDirection();      
    p.transform.position.setValue(dir.multiply(random(0f, radius)));
    p.Velocity.setValue(dir.multiply(random(StartMinVelocity, StartMaxVelocity)));
  }
}

class ConeEmission extends EmissionShape{
  ConeEmission(){
  
  }
  public void processParticle(Particle p){
    p.Velocity.setValue(1,1,1);
    Vector2 t = new Vector2(p.Velocity.x, p.Velocity.y);
    t.Normelize();
    float theta = (t.Magnitude() / p.Velocity.z) * 45;
    
    //println(theta);
  }
}



class Physics extends Component { 
  
  // Mass: in kilograms.
  float Mass;
  // centerofMass: units from pivotpoint.
  Vector3 CenterofMass = new Vector3();
  
  Vector3 Velocity = new Vector3();   
  Vector3 AngularVelocity = new Vector3();
  

  public Physics(Float m) {
    Mass = m;
  }
  
  public void Update(){
    
    transform.Translate(Velocity.multiply(deltaTime));
    
    transform.Rotate(AngularVelocity.multiply(deltaTime));
    
  }
  
  public void addForce(Vector3 f){    
    Velocity.addVec(f.devide(Mass));
  }
  
  public void addForceAtPosition(Vector3 f, Vector3 pos){
  
  }
  
  public void addTorque(Vector3 angf){
    AngularVelocity.addVec(angf.devide(Mass));
  }
  
  public void OnColliderHit(Collider other){
    Velocity.setValue(0);
  }
  
  
}



class sphericallyGravity extends Component{
  
  

  Physics phy;
  
  public void Start(){
    
    phy = (Physics)GetComponent(Physics.class);
  }
  
  public void Update(){
    float f = G * ((planetMass * phy.Mass) / planetpoint.distanceTo(transform.position));
    Vector3 dir = transform.position.minus(planetpoint);
    dir.Normelize();
    dir = dir.multiply(f);
    phy.addForce(dir);        
  }
}







class XMLConverter {
  
  public XML NewXML(String Name){
    return parseXML("<" + Name + "></" + Name + ">");
  }
  
  public XML GetXML(Object c){
    XML xml = NewXML("Component");
    xml.setString("Type", c.getClass().getName());
    
    //Field[] fields = FindFields(c.getClass(), SerializeField.class);
    //println(fields);
    
    //Constructor constructor = compClass.getConstructor();
    
    //child = xml.addChild()
    return xml;
  }
  
  public Object GetObject(XML xml){
    Component comp = null;
    
    //Constructor
    
    return comp;
  }
}

//@Target(ElementType.FIELD)
//@interface SerializeField {

//}


class PrefabManager {

  HashMap<String, Object> Elements = new HashMap<String, Object>();
  
  
  
  public void SaveToXML(GameObject obj){    
    XML xml = parseXML("");
    xml.setName(obj.Name);
    
    Component[] comps = (Component[])obj.components.toArray();
    for(Component comp : comps){
      //XML child = xml.addChild(Component);
    }
    
    
    
    saveXML(xml, obj.Name + ".xml");
  }
  public void SaveToXML(Scene s){
    
  }
  
  public void LoadXML(String n){
    XML xmlFile = loadXML(n + ".xml");
    
    XML[] xmlComps = xmlFile.getChildren("Component");
    Component[] Comps = new Component[xmlComps.length];
    
    for(int i = 0; i < xmlComps.length; i++){
      try{
        
        
      }catch(Exception e){
        
      }
      
    }
    
    GameObject obj = new GameObject();
  }
  
  public Object GetObject(String name){
    return Elements.get(name);
  }
}

class Quaternion {
  float x, y, z, w;
  
  
  Quaternion(){
    x = y = z = 0.0f;
    w = 1.0f;
  }
  
  public void setValue(Quaternion q){
    x = q.x;
    y = q.y;
    z = q.z;
    w = q.w;
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
  
  Quaternion(Quaternion q){
    setValue(q);
  }
  
  public void setRandomRotation(){
  
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
  
  public void SetRandom(){
    SetEuler(new Vector3(random(TAU), random(TAU), random(TAU)));
  }
  
  public void addQuat(Quaternion q){
    x += q.x;
    y += q.y;
    z += q.z;
    w += q.w;
  }
}


public void ApplyCameraTransform(PGraphics gr, Transform transform){
  Vector3 forward = transform.Forward();
  Vector3 up = transform.Up();
  gr.camera(transform.position.x, transform.position.y, transform.position.z, 
      forward.x + transform.position.x, 
      forward.y + transform.position.y, 
      forward.z + transform.position.z,
      up.x, up.y, up.z);    
}

public void ApplyCameraPerspective(PGraphics gr, Camera cam){
  gr.perspective(radians(cam.FieldOfView), (float)width / (float)height, cam.NearClipPlane, cam.FarClipPlane);
}

class GraphicsRenderer {
  
  ArrayList<RenderLayer> Layers = new ArrayList<RenderLayer>();
    
  PGraphics DisplayBuffer;
  
  GraphicsRenderer() {
    
    DisplayBuffer = createGraphics(width, height, P3D);
    
    Layers.add(new RenderLayer("Background"));
    Layers.add(new RenderLayer("Default"));
    Layers.add(new RenderLayer("UI"));
  }
  
  public RenderLayer GetLayer(String name) {
    for(RenderLayer layer : Layers){
      if(layer.Name == name){
        return layer;
      }
    }
    return null;
  }
  
  public void Render(){
    DisplayBuffer.beginDraw();
    DisplayBuffer.background(0);
    DisplayBuffer.endDraw();
    for(RenderLayer layer : Layers){
      layer.Render(DisplayBuffer);
    }
    Draw_Debug();
  }
  
  public void Draw_Debug(){
    DisplayBuffer.beginDraw();
  
    Vector3 f = new Vector3(0,0,1000);
    Vector3 u = new Vector3(0,1000,0);
    Vector3 r = u.Cross(f);
  
    DisplayBuffer.scale(10);
    DisplayBuffer.stroke(color(255,0,0));
    DisplayBuffer.line(0,0,0,r.x, r.y, r.z);
    DisplayBuffer.stroke(color(0,255,0));
    DisplayBuffer.line(0,0,0,u.x, u.y, u.z);
    DisplayBuffer.stroke(color(0,0,255));
    DisplayBuffer.line(0,0,0,f.x, f.y, f.z);
  
    DisplayBuffer.scale(.1f);
    DisplayBuffer.stroke(255);
    DisplayBuffer.line(0,0,0,  width, 0,0);
    DisplayBuffer.line(0,0,0,  0, height,0);
    DisplayBuffer.line(width,0,0, width, height,0);
    DisplayBuffer.line(0,height,0,  width, height, 0);
  
    DisplayBuffer.line(0,0,0, 0,0,width);
    DisplayBuffer.line(0,height,0 ,0, height, width);
    DisplayBuffer.line(0,0,width, 0,height, width);

    DisplayBuffer.endDraw();
  }
  
  public PImage Frame(Camera cam){
    ApplyCameraTransform(DisplayBuffer, cam.transform);
    ApplyCameraPerspective(DisplayBuffer, cam);
    return DisplayBuffer.copy();
  }
}


class QueuedObject {
  RenderObject obj;
  Transform transform;
  QueuedObject(RenderObject o, Transform t){
    obj = o; transform = t;
  }
}

class RenderLayer {
  ArrayList<QueuedObject> Queue = new ArrayList<QueuedObject>();
  String Name;
  RenderLayer(String n){
    Name = n;
  }
  public void Render(PGraphics gr){
    gr.beginDraw();
    for(QueuedObject qobj : Queue){
      qobj.obj.Render(gr, qobj.transform);
    }
    gr.endDraw();
    Queue.clear();
  }
}


class MeshRenderer extends Component {

  Mesh mesh;
  
  MeshRenderer(String s){
    mesh = new Mesh(assets.getMesh(s));
  }
  
  public @Override
  void Update(){
    mesh.Queue(transform);
  }
}



class RenderComponent extends Component {

  RenderObject renderObject;
  
  RenderComponent(RenderObject s){
    renderObject = s;
  }
  
  public @Override
  void Update(){
    renderObject.Queue(transform);
  }
}




abstract class RenderObject {
  
  PShader shader;
  int TintColor = color(255, 255);
  RenderLayer Layer;
  
  RenderObject(){
    Layer = Renderer.GetLayer("Default");
  }
  
  public void Queue(Vector3 p, Vector3 s, Quaternion r){
    Queue(new Transform(p, s, r));
  }
  
  public void Queue(Transform t){
    Layer.Queue.add(new QueuedObject(this, t));
  }
  
  public void Render(PGraphics gr, Transform transform){
    Render(gr, transform.position, transform.scale, transform.rotation);
  }
  
  public void Render(PGraphics gr, Vector3 position, Vector3 scale, Quaternion rotation){
    gr.pushMatrix();
    
    gr.translate(position.x, position.y, position.z);    
    gr.scale(scale.x, scale.y, scale.z);          
    Vector4 a = rotation.GetAxisAngle();   
    gr.rotate(a.w, a.x, a.y, a.z);
    
    if(shader != null){
      gr.shader(shader);
    }else{
      gr.resetShader();
    }
    
    gr.tint(TintColor);
    
    Draw(gr);
    
    gr.popMatrix();
  }
  
  public abstract void Draw(PGraphics gr); 
}



class Sprite extends RenderObject {
  PImage image;
  
  Sprite(PImage img){
    image = img;
  }
  

  public void Draw(PGraphics gr){    
    gr.image(image, 0, 0, 1, 1);    
  }
}




class Mesh extends RenderObject {
  PShape shape;
  
  Mesh(PShape shp){
    shape = shp;
  }
  
  public ArrayList<Vector3> Vertexes(){
    ArrayList<Vector3> verts = new ArrayList<Vector3>();
    
    for(int i = 0; i < shape.getChildCount(); i++){
      for(int j = 0; j < shape.getChild(i).getVertexCount(); j++){
        PVector v = shape.getChild(i).getVertex(j);
        if(verts.contains(v)){
          continue;
        } 
        verts.add(Math.Vec3(v));
      }
    }
    return verts;
  }
  
  public float MaxLengthFromPivot(){
    float m = 0;
    ArrayList<Vector3> verts = Vertexes();
    for(Vector3 v : verts){
      float vm = v.Magnitude();
      if(vm > m) { m = vm; }
    }
    return m;
  }
  
  public void Draw(PGraphics gr){    
    gr.shape(shape);    
  }
} 




class PrimitiveSphere extends RenderObject {
  
  public void Draw(PGraphics gr){
    gr.noStroke();
    gr.fill(255);
    gr.sphere(1);
  }
}


class Scene {

  ArrayList<GameObject> objects = new ArrayList<GameObject>();
  ColliderArray colliderArray = new ColliderArray();
      
  Camera MainCamera;
  
  Skybox skybox;
  
  Scene(){
    skybox = new Skybox();
  }
  
  public void Update(){    
    colliderArray.Update();
    for(GameObject be : objects){      
      be.Update();   
      be.LateUpdate();
    }    
    skybox.Queue(MainCamera.transform.position, new Vector3(100), new Quaternion());
    image(MainCamera.Buffer, 0,0);
  }
  
  
  public void addObj(GameObject obj){
    obj.scene = this;
    if(obj.Name == "" || obj.Name == null){
      obj.Name = "Object (" + objects.size() + ")";
    }
    objects.add(obj);
    obj.Start();
  }
  
  public void RemoveObject(GameObject o){
    o.End();
    objects.remove(o);
  }
  
  // FindObject: returns GameObject with given name.
  public GameObject FindObject(String name){
    for(int i = 0; i < objects.size(); i++){
      GameObject o = objects.get(i);
      if(o.Name == name){
        return o;
      }
    }
    return null;
  }
  
  // FindObjects returns all GameObjects with given name.
  public ArrayList<GameObject> FindObjects(String Name){
    ArrayList<GameObject> objs = new ArrayList<GameObject>();
    for(GameObject obj : objects){
      if(obj.Name == Name){
        objs.add(obj);
      }
    }
    return objs;
  }
  
  public GameObject Instantiate(){
    GameObject o = new GameObject();
    addObj(o);
    return o;
  }
  
  public GameObject Instantiate(String name){
    GameObject o = new GameObject();
    o.Name = name;
    addObj(o);
    return o;
  }
  
  public GameObject Instantiate(Component... comps){
    GameObject o = new GameObject(comps);
    addObj(o);
    return o;
  }
  
  public GameObject Instantiate(String name, Component... comps){
    GameObject o = new GameObject(comps);
    o.Name = name;
    addObj(o);
    return o;
  }
  
  public GameObject Instantiate(String name, Vector3 pos, Vector3 scale, Quaternion rot, Component... comps){
    GameObject o = new GameObject(comps);
    o.Name = name;
    o.transform.position = pos;
    o.transform.scale = scale;
    o.transform.rotation = rot;    
    addObj(o);
    return o;
  }

}


public GameObject CreateShip(){
  ParticleSystem p = new ParticleSystem(new PointEmission(2, 7), new Sprite(assets.getTexture("front")), 30f, 10f);
  MeshRenderer mr = new MeshRenderer("GalleonBoat");
  float m = mr.mesh.MaxLengthFromPivot();
  GameObject o = new GameObject(new SphereCollider(m), new Physics(1f), new SpaceShip(), p, mr);
  o.Name = "PlayerShip";
  o.transform.position.y = 200;

  return o;
}


class SpaceShip extends Component {
  public float G(){return 0;}
  InpAxis h, v, r;
  Physics p;
  float camZoom = 20;
  float Force = 5;
  
  public void Start(){
    h = input.getAxis("Horizontal");
    v = input.getAxis("Vertical");
    r = input.getAxis("Roll");
    p = (Physics)GetComponent(Physics.class);
    
    input.mouseMode = MouseMode.Locked;
  }
  
  
  public void Update(){
    //p.addTorque(new Vector3(-input.mouseMove.y / 1500f, input.mouseMove.x / 1500f, -r.Value / 20f));    
    //p.addForce(transform.Forward().multiply(v.Value * Force).plus(transform.Right().multiply(-h.Value * Force)));
    
    camZoom += input.mouseWheel;
    
    //gameObject.scene.camera.transform.position = transform.position.plus(transform.Forward().multiply(camZoom).plus(transform.Up().multiply(10)));
    
    Quaternion q = new Quaternion();
    q.SetEuler(new Vector3(0, PI, PI));
    //gameObject.scene.camera.transform.rotation = transform.rotation.multiply(q);
    
    if(input.getKey('f').Pressed){
      p.Velocity.setValue(0);
      p.AngularVelocity.setValue(0);
    }
  }
}


class Skybox extends RenderObject {
  
  PImage front, back, up, down, right, left;
    
  Skybox(){
    front = assets.getTexture("Skyboxes\\Skybox_front");
    back = assets.getTexture("Skyboxes\\Skybox_back");
    up = assets.getTexture("Skyboxes\\Skybox_up");
    down = assets.getTexture("Skyboxes\\Skybox_down");
    right = assets.getTexture("Skyboxes\\Skybox_right");
    left = assets.getTexture("Skyboxes\\Skybox_left");
    
    Layer = Renderer.GetLayer("Background");
    
    shader = assets.getShader("texShader");
  }
  
  public @Override
  void Draw(PGraphics gr){
    
    gr.textureMode(NORMAL);
        
    gr.noStroke();
    
    // front
    gr.beginShape(QUADS);    
    gr.texture(front);
    gr.vertex(1,1,1, 0,0);
    gr.vertex(-1,1,1, 1,0);
    gr.vertex(-1,-1,1, 1,1);
    gr.vertex(1,-1,1, 0,1);
    gr.endShape();
    
    // back
    gr.beginShape(QUADS);    
    gr.texture(back);
    gr.vertex(1,1,-1, 1,0);
    gr.vertex(-1,1,-1, 0,0);
    gr.vertex(-1,-1,-1, 0,1);
    gr.vertex(1,-1,-1, 1,1);
    gr.endShape();
    
    // up
    gr.beginShape(QUADS);    
    gr.texture(up);
    gr.vertex(1,1,1, 0,1);
    gr.vertex(-1,1,1, 1,1);
    gr.vertex(-1,1,-1, 1,0);
    gr.vertex(1,1,-1, 0,0);
    gr.endShape();
    
    // down
    gr.beginShape(QUADS);    
    gr.texture(down);
    gr.vertex(1,-1,1, 0,0);
    gr.vertex(-1,-1,1, 1,0);
    gr.vertex(-1,-1,-1, 1,1);
    gr.vertex(1,-1,-1, 0,1);
    gr.endShape();
    
    // Right
    gr.beginShape(QUADS);    
    gr.texture(right);
    gr.vertex(1,1,1, 1,0);
    gr.vertex(1,1,-1, 0,0);
    gr.vertex(1,-1,-1, 0,1);
    gr.vertex(1,-1,1, 1,1);
    gr.endShape();
    
    // left
    gr.beginShape(QUADS);    
    gr.texture(left);
    gr.vertex(-1,1,1, 0,0);
    gr.vertex(-1,1,-1, 1,0);
    gr.vertex(-1,-1,-1, 1,1);
    gr.vertex(-1,-1,1, 0,1);
    gr.endShape();
    
  }
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
  Transform(Vector3 p, Vector3 s, Quaternion r){
    position = new Vector3(p);
    scale = new Vector3(s);
    rotation = new Quaternion(r);
  }
  
  
  public void setValue(Transform t){
    position.setValue(t.position);
    scale.setValue(t.scale);
    rotation.setValue(t.rotation);
  }
  
  public void Translate(Vector3 v){
    position.addVec(v);
  }
  
  public void Rotate(Vector3 eul){       
    Quaternion q = new Quaternion();
    q.SetEuler(eul);
    rotation = rotation.multiply(q);
  }
  
  public void RotateAround(Vector3 eul, Vector3 point){
  
  }
  
  public void LookAt(Vector3 pos, Vector3 up){
    Vector3 f = pos;
    Vector3 u = up;
    Vector3 r = f.Cross(u);
    rotation.w = sqrt(1f + r.x + u.y + f.z) * .5f;
    float recip = 1f / (4f * rotation.w);
    rotation.x = (u.z - f.y) * recip;
    rotation.y = (f.x - r.z) * recip;
    rotation.z = (r.y - u.x) * recip;
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


class Canvas {
  
  ArrayList<UIElement> Elements = new ArrayList<UIElement>();
  
  public void Update(){
    pushMatrix();
    
    //Vector4 a = defScene.camera.transform.rotation.GetAxisAngle();
    //Vector3 p = defScene.camera.transform.position;
    //p = p.plus(defScene.camera.transform.Forward().multiply(99));
    //translate(p.x, p.y, p.z);
    //rotate(a.w, a.x, a.y, a.z);
    
    text(frameRate, width / 2,height / 2);
    image(assets.getTexture("front"), 0, 0, width, height);
    for(int i = 0; i < Elements.size(); i++){
      Elements.get(i).Update();
    }  
    popMatrix();
  }
}

abstract class UIElement{
  
  public abstract void Update();
}
 

class Vector3 implements Interpolatable<Vector3>, IEquatable<Vector3> {

  float x, y, z;
 

  
  Vector3(){
    x = 0;
    y = 0;
    z = 0;
  }
  
  Vector3(Vector3 p){
    setValue(p);
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
  
  public void setValue(float xyz){
    x = y = z = xyz;
  }
  
  public void setValue(float xp, float yp, float zp){
    x = xp;
    y = yp;
    z = zp;
  }
  
  public void setValue(Vector3 v){
    x = v.x;
    y = v.y;
    z = v.z;
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
  
  public Vector3 minus(Vector3 v){
    return new Vector3(x - v.x, y - v.y, z - v.z); 
  }
  
  public float Dot(Vector3 v){
    return x * v.x + y * v.y + z * v.z;
  }
  public float Dot(float X, float Y, float Z){
    return x * X + y * Y + z * Z;
  }
  public Vector3 Cross(Vector3 v){
    return new Vector3(y * v.z - z * v.y,
                       z * v.x - x * v.z,
                       x * v.y - y * v.x);
  }
  
  public void OrthoNormalize(Vector3 v) {
    
  }
  
  public float distanceTo(Vector3 v){
    return sqrt(sq(x - v.x) + sq(y - v.y) + sq(z - v.z));
  }
  
  public float Magnitude(){
    return sqrt(sq(x) + sq(y) + sq(z));
  }
  
  public float angleTo(Vector3 v){
    return acos(Dot(v) / (Magnitude() * v.Magnitude()));
  }
  public float angleTo(float X, float Y, float Z){
    return acos(Dot(X,Y,Z) / (Magnitude() * sqrt(sq(X) + sq(Y) + sq(Z))));
  }
  
  public Vector3 inverse(){
    return new Vector3(-x, -y, -z);
  }
  
  public void Normelize(){
    float m = this.Magnitude();
    this.setValue(x / m, y / m, z / m);
  }
  
  public void setRandomNormelizedDirection(){
    x = random(-1, 1);
    y = random(-1, 1);
    z = random(-1, 1);
    Normelize();
  }
  
  // Lerp: interpolates between two vectors
  public Vector3 Lerp(Vector3 value, float t){
    return new Vector3((value.x - x) * t, (value.y - y) * t, (value.z - z) * t);
  }
  
  public boolean Equal(Vector3 value){
    return x == value.x && y == value.y && z == value.z;
  }

}

class Vector2 {
  
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
  
  public float Magnitude(){
    return sqrt(sq(x) + sq(y));
  }
  
  public float Dot(Vector2 v){
    return x * v.x + y * v.y;
  }
  public float Dot(float X, float Y){
    return x * X + y * Y;
  }
  public Vector2 Cross(){
    return new Vector2(y, -x);
  }
  
  public float angleTo(Vector2 v){
    return acos(Dot(v) / (Magnitude() * v.Magnitude()));
  }
  public float angleTo(float X, float Y){
    return acos(Dot(X, Y) / (Magnitude() * (sqrt(sq(X) + sq(Y))))); 
  }
  
  public void Normelize(){
    float m = this.Magnitude();
    this.setValue(x / m, y / m);
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




interface Interpolatable<T>{
  public T Lerp(T value, float t);
}

interface IEquatable<T>{
  public boolean Equal(T value);
}



public Object InstantiateObject(Class type, Object... params){
  
  Class[] paramsType = new Class[params.length + 1];
  paramsType[0] = this.getClass();
  for(int i = 0; i < params.length; i++){
    paramsType[i + 1] = params[i].getClass();
  }
  
  Constructor constructor = null;
  try{
    constructor = type.getDeclaredConstructor(paramsType);
  } catch(Exception e ){
    e.printStackTrace();
  }
  if(constructor == null){System.err.println("the constructor is null in InstantiateObject()"); return null;}
  
  Object object = null;
  try{
    Object[] paro = new Object[params.length + 1];
    paro[0] = this;
    for(int i = 0; i < params.length; i++){
      paro[i + 1] = params[i];
    }
    object = constructor.newInstance(paro);
  } catch (Exception e){
    e.printStackTrace();
  }
  if(object == null){System.err.println("the object is null in InstantiateObject()"); return null;}
  
  return object;
}


public static Field[] FindFields(Class<?> classs, Class<? extends Annotation> ann) {
    ArrayList<Field> list = new ArrayList<Field>();
    Class<?> c = classs;
    while (c != null) {
        for (Field field : c.getDeclaredFields()) {
            if (field.isAnnotationPresent(ann)) {
                list.add(field);
            }
        }
        c = c.getSuperclass();
    }
    return (Field[])list.toArray();
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

class Input {
  
  Key[] keys;
  InpAxis[] Axis;
  
  Vector2 mouseMove;
  Vector2 mousePos;
  float mouseWheel;
  MouseMode mouseMode;
  
  Robot robot;
  
  Input(){
    mouseMove = new Vector2();
    mousePos = new Vector2();
    mouseMode = MouseMode.Free;
  }
  
  public void Init(){
    char[] ch = {' ', 'w', 'a', 's', 'd', 'g', 'e', 'q', 'f'};
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
  
  public void ShowMouse(boolean o){
    if(o){
      cursor();
    }else{
      noCursor();
    }
  }
  
  
  public void Update(){
    
    mouseWheel = 0;

    float centerX = width / 2f, centerY = height / 2f;
    
    switch(mouseMode){
      case Free:
        mouseMove.setValue(mouseX - pmouseX, mouseY - pmouseY);
        break;
      case Locked:
        robot.mouseMove((int)centerX + frame.getX(),(int)centerY + frame.getY());
        mouseMove.setValue(0,0);
        mouseMove.setValue(mouseX - centerX, mouseY - centerY);        
        break;
    }
    

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
    char k = input.keys[i].Name;
    if(key == Character.toUpperCase(k) || key == Character.toLowerCase(k)){
      input.keys[i].Pressed = true;
    }
  }
}

public void keyReleased(){
  for(int i = 0; i < input.keys.length; i++){
    char k = input.keys[i].Name;
    if(key == Character.toUpperCase(k) || key == Character.toLowerCase(k)){
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

public void mouseMoved(){
  
  
}

public void mouseReleased(){

}

public void mouseWheel(MouseEvent event) {
  input.mouseWheel = event.getCount();
}
  public void settings() {  fullScreen(P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "sketch_3DEngine" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
