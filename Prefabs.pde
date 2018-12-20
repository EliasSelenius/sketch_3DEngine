
class XmlConverter {
  
  XML NewXml(String Name){
    return parseXML("<" + Name + "></" + Name + ">");
  }

  XML NewXml(String Name, String inner) {
    return parseXML("<" + Name + ">" + inner + "</" + Name + ">");
  }

  XML ToXml(String name, Object obj) {
    XML xml = NewXml(name);
    if (obj == null) {
      xml.setContent("null");
      return xml;
    }
    xml.setString("type", obj.getClass().getName());
    QueryList<Field> fields = Reflect.GetFieldsFilter(obj.getClass(), 0);
    Object[] objs = Reflect.GetObjectsFilter(obj, 0);
    for(int i = 0; i < objs.length; i++) {
      Field f = fields.get(i);
      Object o = objs[i];
      if(f.getType().isPrimitive()) {
        xml.addChild(NewXml(f.getName(), o.toString()));
      } else {
        xml.addChild(ToXml(f.getName(), objs[i]));
      }
    }
    return xml;
  }

  void SaveToXml(String name, Object obj) {
    saveXML(ToXml(name, obj), assets.DataPath + "prefabs\\" + name + ".xml");
  }

  Object FromXml(XML xml) {
    return null;
  }
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
