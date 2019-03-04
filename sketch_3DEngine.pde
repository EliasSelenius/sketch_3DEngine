

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

  boolean hello(float f) {
    return f < 10;
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
  

  Game.Init();

  Game.scene = new Scene();
  Game.ui = CreatTestUI();
  
  //----Init-RenderLayers-------
  /*
  GameManager.Layers.Insert(
    new BackgroundLayer(),
    new RenderLayer() {
      public void Render() {
        Draw_Debug();
      }
    },
    Game.scene,
    page
  );
*/
  //-----------------------------





  //defScene.Instantiate("tree", new OcTreeRenderer());
  
  Game.scene.Instantiate("cam", new CameraHandler(), new CamFlyMovment());

  Game.scene.Instantiate("aBoat", new MeshRenderer("GalleonBoat")).transform.scale.setValue(10);

///*
  Game.scene.Instantiate("RIL", new MeshRenderer("spaceCraft"), 
    new RilComponent(assets.DataPath + "\\Scripts\\TestComponent.ril"),
    new Physics(10));
  //*/


  for(int i = 0; i < 20; i++) {

    ParticleSystem ps = new ParticleSystem(
      new PointEmission(0, 4),
      new Mesh(assets.getMesh("box")),
      .5f,
      6
    );


    Physics p = new Physics(10);
    Transform t = Game.scene.Instantiate(new MeshRenderer("lowPolyDragon"), p, ps ).transform;
    t.Translate(random(300),random(300),random(300));
    t.scale.multiplyEq(4f);

    p.Velocity.setRandomNormelizedDirection();
    p.Velocity.multiplyEq(7f);
  }

  

  //CreateGalaxy();

  //TestStringToObject(); // <-- RilTest

  Game.Start();

  // NOTE: frameRate needs to be set at the end of setup:
  frameRate(200);
} 




void draw(){
  //----Update-Globals----
  deltaTime = 1f / frameRate;
  //----------------------

  //pointLight(255,100,0, planetpoint.x, planetpoint.y, planetpoint.z);
  //directionalLight(200,200,200, 0,-1,0);
  //ambientLight(100,100,100);
  
  //defScene.Update();
  //page.Update();

  Game.Render();

  //println(LogicThread.UpdatesPerSecond());  

  //input.Update();
  
  //println(frameRate);
}