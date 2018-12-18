

class Assets {

  

  ArrayList<ModellAsset> Modells = new ArrayList<ModellAsset>();
  ArrayList<TextureAsset> Textures = new ArrayList<TextureAsset>(); 
  ArrayList<ShaderAsset> Shaders = new ArrayList<ShaderAsset>(); 


  void LoadShaders() {
    File file = new File(sketchPath() + "\\data\\shaders");
    for(String s : file.list(new FileExtensionFilter(".shader"))) {
      Shaders.add(new ShaderAsset(s));
      println(s);
    }
  }




  void loadModdelAssets(String... nameList){
    for(int i = 0; i < nameList.length; i++){
      Modells.add(new ModellAsset(nameList[i]));
    }
  }
  
  void loadTextureAssets(String... nameList){
    for(int i = 0; i < nameList.length; i++){
      Textures.add(new TextureAsset(nameList[i]));
    }
  }
  
  void loadShaderAsset(String Name, String vert, String frag){
    Shaders.add(new ShaderAsset(Name, vert, frag));
  }
  
  PShader GetShader(String name){
    for(ShaderAsset shd : Shaders){
      if(shd.Name.equals(name)) {
        return shd.shader;
      }
    }
    return null;
  }
  
  PImage getTexture(String n){
    for(TextureAsset tex : Textures){
      if(tex.name == n){
        return tex.tex;
      }
    }
    return null;
  }
  
  PShape getMesh(String s){
    for(ModellAsset mod : Modells){
      if(mod.name == s){
        return mod.mesh;
      }
    }
    return null;
  }
}

class ShaderAsset {
  
  PShader shader;
  String Name;
  String[] Source;

  ShaderAsset(String n, String vertex, String fragment){
    Name = n;
    shader = loadShader("shaders\\" + fragment, "shaders\\" + vertex);
  }


  ShaderAsset(String n) {
    Name = n.substring(0, n.indexOf('.'));
    println(Name);
    Source = loadStrings("shaders\\" + n);
    
    shader = new PShader(This, GetArea("vert"), GetArea("frag"));
    
  }


  String[] GetArea(String name) {
    ArrayList<String> area = new ArrayList<String>();
    boolean read = false;
    for(int i = 0; i < Source.length; i++) {
      String line = Source[i];
      if(read) {
        if (line.equals("end:" + name)) {
          return area.toArray(new String[area.size()]);
        }
        area.add(line);
      } else {
        if (line.equals("start:" + name)) {
          read = true;
        }
      }
    }
    return null;
  }

}

class TextureAsset {
  PImage tex;
  String name;
  TextureAsset(String n){
    name = n;
    tex = loadImage("texture\\" + n + ".png");
  }
}

class ModellAsset {
  PShape mesh;
  String name;
  ModellAsset(String s){
    name = s;
    mesh = loadShape("mesh\\" + s + ".obj");
  }
}
