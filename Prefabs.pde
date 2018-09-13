
class XMLConverter {
  
  XML NewXML(String Name){
    return parseXML("<" + Name + "></" + Name + ">");
  }
  
  XML GetXML(Object c){
    XML xml = NewXML("Component");
    xml.setString("Type", c.getClass().getName());
    
    //Field[] fields = FindFields(c.getClass(), SerializeField.class);
    //println(fields);
    
    //Constructor constructor = compClass.getConstructor();
    
    //child = xml.addChild()
    return xml;
  }
  
  Object GetObject(XML xml){
    Component comp = null;
    
    //Constructor
    
    return comp;
  }
}

@Target(ElementType.FIELD)
@Retention(RetentionPolicy.RUNTIME)
public @interface SerializeField {
  String value() default "ok";
}


class PrefabManager {

  HashMap<String, Object> Elements = new HashMap<String, Object>();
  
  
  
  void SaveToXML(GameObject obj){    
    XML xml = parseXML("");
    xml.setName(obj.Name);
    
    Component[] comps = (Component[])obj.components.toArray();
    for(Component comp : comps){
      //XML child = xml.addChild(Component);
    }
    
    
    
    saveXML(xml, obj.Name + ".xml");
  }
  void SaveToXML(Scene s){
    
  }
  
  void LoadXML(String n){
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
  
  Object GetObject(String name){
    return Elements.get(name);
  }
}
