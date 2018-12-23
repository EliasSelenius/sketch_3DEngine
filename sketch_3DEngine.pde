

import java.util.Map;
import java.lang.annotation.*;
import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.awt.*;
import java.io.*;



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
// WorldGraphics: the PGraphics object that RenderObjects gets drawn to.
PGraphics WorldGraphics;
// UIGraphics: the PGraphics object that UI is rendered to.
PGraphics UIGraphics;
// This: this app:
sketch_3DEngine This = this;
// Reflect: collection of functions for java.lang.reflect
Reflect Reflect = new Reflect();
// G: the Gravitational constant.
final float G = 6.67 * (pow(10, -11));
// variables for a planet.
Vector3 planetpoint = new Vector3(4000F,2000F,0F);
float planetMass = 1500;
//--------------------------


CommandExecutor exc;


class MyTestClass {
  int hey;
  String name = "Hello";
  float height;
  Vector3 vec = new Vector3(23F);
}


void setup() {
  
  fullScreen(P3D);

  //println(assets.GetDataFiles().get(0).getName());


/*  
  XmlConverter xmlc = new XmlConverter();

  xmlc.SaveToXml("MyObj", new GameObject(new Physics(314F), new Camera()));
  xmlc.SaveToXml("MySavedObj", new MyTestClass());

  println(xmlc.ToXml("myFloat", new MyTestClass()));
*/
  
  QueryList<Object> list = new QueryList<Object>();
  list.Insert("Hello World", new Transform(), 123, 34f, new Physics(7F), 12F, "djaw", new Transform(), new Vector3());
  println(list);
  println("res: " + list.Where(
    Its.OfType(Transform.class)
  ));

  WorldGraphics = createGraphics(width, height, P3D);
  UIGraphics = createGraphics(width, height, P3D);
  

  //----init-Inputs-----
  input = new Input();
  input.Init();
  //--------------------
  

  

  
  //----init-Assets-----  
  assets = new Assets();
  assets.LoadShaders();
  assets.loadModdelAssets("lowPolyDragon", "GalleonBoat", "box", "spaceCraft");
  assets.loadTextureAssets("front", "Skyboxes\\Skybox_front", "Skyboxes\\Skybox_back", "Skyboxes\\Skybox_up", "Skyboxes\\Skybox_down", "Skyboxes\\Skybox_right", "Skyboxes\\Skybox_left");
  // shader loading:
  assets.loadShaderAsset("InvertShader", "vertex.glsl", "fragment.glsl");
  assets.loadShaderAsset("texShader", "texvert.glsl", "texfrag.glsl");
  //--------------------
  
  


  
  //----init-Prefabs----
  Prefabs = new PrefabManager();
  //--------------------


  defScene = new Scene();
  
  //defScene.Instantiate("tree", new OcTreeRenderer());
  
  defScene.Instantiate("cam", new Camera(), new CamFlyMovment());

  defScene.Instantiate("aBoat", new MeshRenderer("GalleonBoat"));


  exc = new CommandExecutor();
  exc.LoadScript();
  
  
  //XMLConverter xconv = new XMLConverter();
  //saveXML(xconv.GetXML(new Physics(10f)), "data\\prefabs\\NewTestXML");
  
  //CreateGalaxy();

  
} 



void draw(){
  
  //----Update-Globals----
  deltaTime = 1 / frameRate;
  //----------------------

  //pointLight(255,100,0, planetpoint.x, planetpoint.y, planetpoint.z);
  //directionalLight(200,200,200, 0,-1,0);
  //ambientLight(100,100,100);
  
  defScene.Update();
  defScene.Render();
  
  image(WorldGraphics, 0, 0);
  image(UIGraphics, 0, 0);
  
  input.Update();
  
  //println(frameRate);
}


