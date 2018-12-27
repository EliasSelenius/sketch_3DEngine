  

class GameObject {
  
  Transform transform; 
  String Name;
  ArrayList<Component> components = new ArrayList<Component>();
  Scene scene;
  
  
  void init(){
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
  
  void OnColliderHit(Collider other){
    for(int i = 0; i < components.size(); i++){
      components.get(i).OnColliderHit(other);
    }
  }
  

  void Update(){
    for(Component co : components){
      co.Update();
    }
  }
  
  void LateUpdate(){
    for(Component co : components){
      co.LateUpdate();
    }
  }
  
  void Render(){
    for(Component co : components){
      co.Render();
    }
  }
  
  void Start(){
    for(int i = 0; i < components.size(); i++){
      components.get(i).Start();
    }
  }
  
  void End(){
    for(Component co : components){
      co.End();
    }
    components = null;
  }
  
  void AddComponent(Component a){
    a.gameObject = this;
    a.transform = this.transform;
    components.add(a);
    a.Start();
  }  
  
  final Component GetComponent(Class cls) {
    for(Component comp : components){
      if(cls.isInstance(comp)){
        return comp;
      }
    }
    return null;
  }
}
