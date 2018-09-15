

class Assets{

  ArrayList<ModellAsset> Modells = new ArrayList<ModellAsset>();
  ArrayList<TextureAsset> Textures = new ArrayList<TextureAsset>(); 
  ArrayList<ShaderAsset> Shaders = new ArrayList<ShaderAsset>(); 
  
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
  
  PShader getShader(String Name){
    for(ShaderAsset shd : Shaders){
      if(shd.name == Name){
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

class ShaderAsset{
  PShader shader;
  String name;
  ShaderAsset(String n, String vertex, String fragment){
    name = n;
    shader = loadShader("shaders\\" + fragment, "shaders\\" + vertex);
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
