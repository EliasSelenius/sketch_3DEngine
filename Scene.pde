

class Scene extends RenderLayer {

  QueryList<GameObject> gameObjects = new QueryList<GameObject>();
  
  // todo: remove this from here:
  ColliderArray colliderArray = new ColliderArray();
  
  
  void Update(){    
    //colliderArray.Update();
    for(int i = 0; i < gameObjects.size(); i++){      
      gameObjects.get(i).Update();   
    }       
    for(int i = 0; i < gameObjects.size(); i++){      
      gameObjects.get(i).LateUpdate();   
    }  
  }
  
  @Override
  void Render() {
    Game.graphics.lights();
    //Game.graphics.background(0);
    for(int i = 0; i < gameObjects.size(); i++){
      gameObjects.get(i).Render();
    }
  }
  
  GameObject FindObjectWithName(String name) {
    for (GameObject o : gameObjects) {
      if(o.Name.equals(name)) {
        return o;
      }
    }
    return null;
  }
  
  void AddObject(GameObject obj){
    obj.scene = this;
    if(obj.Name == "" || obj.Name == null){
      obj.Name = "GameObjectName";
    }
    gameObjects.add(obj);
    obj.Start();
  }
  
  void RemoveObject(GameObject o){
    o.End();
    gameObjects.remove(o);
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
