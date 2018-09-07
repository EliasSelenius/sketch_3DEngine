

class GameObject{
  
  Transform transform; 

  ArrayList<Component> components = new ArrayList<Component>();
  
  void init(){
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
  
  
  void Update(){
    for(Component co : components){
      co.Update();
    }
  
  }
  
  void addComponent(Component a){
    a.gameObject = this;
    a.transform = this.transform;
    components.add(a);
    a.Start();
  }
  
  
  
}