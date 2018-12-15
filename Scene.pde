//skybox.Queue(MainCamera.transform.position, new Vector3(100), new Quaternion());

class Scene {

  
  ArrayList<ObjectLayer> Layers = new ArrayList<ObjectLayer>();
  
  ColliderArray colliderArray = new ColliderArray();
      
  Camera MainCamera;
  
  
  Scene(){        
    Layers.add(new BackgroundLayer(this));
    Layers.add(new DefaultLayer(this));
    Layers.add(new ObjectLayer(this, "UI"));    
  }
  
  void Update(){    
    colliderArray.Update();
    for(ObjectLayer be : Layers){      
      be.Update();   
    }        
    
  }
  
  void Render(){
    DisplayBuffer.beginDraw();
    DisplayBuffer.background(0);
    DisplayBuffer.endDraw();
    for(int i = 0; i < Layers.size(); i++){
      Layers.get(i).Render();
    }
  }
  
  ObjectLayer FindLayer(String name){
    for(ObjectLayer l : Layers){
      if(l.Name == name){
        return l;
      }
    }
    return null;
  }
  
  
  void AddObject(GameObject obj, String layerName){
    obj.scene = this;
    ObjectLayer layer = FindLayer(layerName);
    if(obj.Name == "" || obj.Name == null){
      obj.Name = layer.Name + " GameObject Nr." + layer.gameObjects.size() + 1;
    }
    layer.gameObjects.add(obj);
    obj.Start();
  }
  
  void AddObject(GameObject obj){
    AddObject(obj, "Default");
  }
  
  
  
  void RemoveObject(GameObject o){
    o.End();
    for(ObjectLayer l : Layers){
      l.gameObjects.remove(o);
    }
  }
  
  // FindObject: returns GameObject with given name.
  GameObject FindObject(String name){    
    for(ObjectLayer l : Layers){
      for(GameObject o : l.gameObjects){
        if(o.Name == name){
          return o;
        }
      }
    }
    return null;
  }
  
  // FindObjects returns all GameObjects with given name.
  ArrayList<GameObject> FindObjects(String name){
    ArrayList<GameObject> objs = new ArrayList<GameObject>();
    for(ObjectLayer l : Layers){
      for(GameObject o : l.gameObjects){
        if(o.Name == name){
          objs.add(o);
        }
      }
    }
    return objs;
  }
  
  GameObject Instantiate(){
    GameObject o = new GameObject();
    AddObject(o);
    println("init");
    return o;
  }
  
  GameObject Instantiate(String name){
    GameObject o = new GameObject();
    o.Name = name;
    AddObject(o);
    return o;
  }
  
  GameObject Instantiate(Component... comps){
    GameObject o = new GameObject(comps);
    AddObject(o);
    return o;
  }
  
  GameObject Instantiate(String name, Component... comps){
    GameObject o = new GameObject(comps);
    o.Name = name;
    AddObject(o);
    return o;
  }
  
  GameObject Instantiate(String name, Vector3 pos, Vector3 scale, Quaternion rot, Component... comps){
    GameObject o = new GameObject(comps);
    o.Name = name;
    o.transform.position.setValue(pos);
    o.transform.scale.setValue(scale);
    o.transform.rotation.setValue(rot);    
    AddObject(o);
    return o;
  }

}


class ObjectLayer {
  String Name;
  ArrayList<GameObject> gameObjects = new ArrayList<GameObject>();
  Scene scene;
  ObjectLayer(Scene sc, String name){
    scene = sc; Name = name;
  }
  void Update(){
    for(int i = 0; i < gameObjects.size(); i++){
      gameObjects.get(i).Update();
    }
    for(int i = 0; i < gameObjects.size(); i++){
      gameObjects.get(i).LateUpdate();
    }
  }
  final void Render(){
    DisplayBuffer.beginDraw();
    Draw();
    DisplayBuffer.endDraw();
  }
  void Draw(){
    DisplayBuffer.lights();
    for(int i = 0; i < gameObjects.size(); i++){
      gameObjects.get(i).Render();
    }
  }
}

class BackgroundLayer extends ObjectLayer {
  
  Skybox skybox = new Skybox();
  
  BackgroundLayer(Scene scene){
    super(scene, "Background");
  }
  
  @Override
  void Draw(){
    super.Draw();
    skybox.Render(scene.MainCamera.transform.position, new Vector3(1000f), new Quaternion());
  }
}

class DefaultLayer extends ObjectLayer {
  DefaultLayer(Scene s){
    super(s, "Default");
  }
  
  @Override
  void Draw(){
    super.Draw();
    Draw_Debug();
  }
}
