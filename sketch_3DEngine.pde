

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
// App: this app:
static sketch_3DEngine App;
// Reflect: collection of functions for java.lang.reflect
Reflect Reflect = new Reflect();
// G: the Gravitational constant.
final float G = 6.67f * (pow(10f, -11f));
// variables for a planet.
Vector3 planetpoint = new Vector3(4000f,2000f,0f);
float planetMass = 1500;
//--------------------------


CommandExecutor exc;


class MyTestClass {
  int hey;
  String name = "Hello";
  float height;
  Vector3 vec = new Vector3(23F);

  String GetName() {
    println("MyTestClassGetName");
    return name;
  }
}



void setup() {
  App = this;

  fullScreen(P2D);
  


  //println(assets.GetDataFiles().get(0).getName());


/*  
  XmlConverter xmlc = new XmlConverter();

  xmlc.SaveToXml("MyObj", new GameObject(new Physics(314F), new Camera()));
  xmlc.SaveToXml("MySavedObj", new MyTestClass());

  println(xmlc.ToXml("myFloat", new MyTestClass()));
*/
  
  

  //----init-Inputs-----
  input = new Input();
  input.Init();
  //input.mouseMode = MouseMode.Locked;
  //input.ShowMouse(false);
  //--------------------


  input.OnMouseLeftClick.AddListner(new Function() {
    void Run() {
      println("LeftClick");
    }
  });
  input.OnMouseRightClick.AddListner(new Function() {
    void Run() {
      println("RightClick");
    }
  });

  
  
  //----init-Assets-----  
  assets = new Assets();
  assets.LoadShaders();
  assets.loadModdelAssets("lowPolyDragon", "GalleonBoat", "box", "spaceCraft");
  assets.loadTextureAssets("front", "Skyboxes\\Skybox_front", "Skyboxes\\Skybox_back", "Skyboxes\\Skybox_up", "Skyboxes\\Skybox_down", "Skyboxes\\Skybox_right", "Skyboxes\\Skybox_left");
  // shader loading:
  assets.loadShaderAsset("InvertShader", "vertex.glsl", "fragment.glsl");
  assets.loadShaderAsset("texShader", "texvert.glsl", "texfrag.glsl");
  //--------------------
  
  

  GameManager.InitRenderer(P3D);

  GameManager.ActiveScene = new Scene();
  page = CreatTestUI();
  exc = new CommandExecutor();
  exc.LoadScript();
  


  //----Init-RenderLayers-------
  
  GameManager.Layers.Insert(
    new BackgroundLayer(),
    new ScreenLayer() {
      public void Render() {
        Draw_Debug();
      }
    },
    GameManager.ActiveScene,
    page
  );

  //-----------------------------





  //defScene.Instantiate("tree", new OcTreeRenderer());
  
  GameManager.ActiveScene.Instantiate("cam", new CameraHandler(), new CamFlyMovment());

  GameManager.ActiveScene.Instantiate("aBoat", new MeshRenderer("GalleonBoat"));

  

  //CreateGalaxy();


  LogicThread.LoopEvent.AddListner("Update", GameManager);

  LogicThread.StartLoop();

  GameManager.RenderTime.Start();

  // NOTE: frameRate needs to be set at the end of setup:
  frameRate(200);
} 


UICanvas page;


ThreadLoop LogicThread = new ThreadLoop();


void draw(){
  //----Update-Globals----
  deltaTime = 1f / frameRate;
  //----------------------

  //pointLight(255,100,0, planetpoint.x, planetpoint.y, planetpoint.z);
  //directionalLight(200,200,200, 0,-1,0);
  //ambientLight(100,100,100);
  
  //defScene.Update();
  //page.Update();

  GameManager.Render();

  //println(LogicThread.UpdatesPerSecond());  

  //input.Update();
  
  //println(frameRate);
}