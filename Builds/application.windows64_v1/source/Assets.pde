

class Assets{

  ArrayList<Modell> Modells = new ArrayList<Modell>();
  Assets(String[] nameList){
    for(int i = 0; i < nameList.length; i++){
      Modells.add(new Modell(nameList[i]));
    }
  }
  
  PShape getMesh(String s){
    for(Modell mod : Modells){
      if(mod.name == s){
        return mod.mesh;
      }
    }
    return null;
  }
}

class Modell{
  PShape mesh;
  String name;
  Modell(String s){
    name = s;
    mesh = loadShape(s + ".obj");
  }
}