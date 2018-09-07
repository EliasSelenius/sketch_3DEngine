

class Scene {

  ArrayList<GameObject> objects = new ArrayList<GameObject>();
  ColliderArray colliderArray = new ColliderArray();
      
  Camera MainCamera;
  
  Skybox skybox;
  
  Scene(){
    skybox = new Skybox();
  }
  
  void Update(){    
    colliderArray.Update();
    for(GameObject be : objects){      
      be.Update();   
      be.LateUpdate();
    }    
    skybox.Queue(MainCamera.transform.position, new Vector3(100), new Quaternion());
    image(MainCamera.Buffer, 0,0);
  }
  
  
  void addObj(GameObject obj){
    obj.scene = this;
    if(obj.Name == "" || obj.Name == null){
      obj.Name = "Object (" + objects.size() + ")";
    }
    objects.add(obj);
    obj.Start();
  }
  
  void RemoveObject(GameObject o){
    o.End();
    objects.remove(o);
  }
  
  // FindObject: returns GameObject with given name.
  GameObject FindObject(String name){
    for(int i = 0; i < objects.size(); i++){
      GameObject o = objects.get(i);
      if(o.Name == name){
        return o;
      }
    }
    return null;
  }
  
  // FindObjects returns all GameObjects with given name.
  ArrayList<GameObject> FindObjects(String Name){
    ArrayList<GameObject> objs = new ArrayList<GameObject>();
    for(GameObject obj : objects){
      if(obj.Name == Name){
        objs.add(obj);
      }
    }
    return objs;
  }
  
  GameObject Instantiate(){
    GameObject o = new GameObject();
    addObj(o);
    return o;
  }
  
  GameObject Instantiate(String name){
    GameObject o = new GameObject();
    o.Name = name;
    addObj(o);
    return o;
  }
  
  GameObject Instantiate(Component... comps){
    GameObject o = new GameObject(comps);
    addObj(o);
    return o;
  }
  
  GameObject Instantiate(String name, Component... comps){
    GameObject o = new GameObject(comps);
    o.Name = name;
    addObj(o);
    return o;
  }
  
  GameObject Instantiate(String name, Vector3 pos, Vector3 scale, Quaternion rot, Component... comps){
    GameObject o = new GameObject(comps);
    o.Name = name;
    o.transform.position = pos;
    o.transform.scale = scale;
    o.transform.rotation = rot;    
    addObj(o);
    return o;
  }

}