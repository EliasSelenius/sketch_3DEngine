




class MeshRenderer extends Component {

  Mesh mesh;
  
  MeshRenderer(String s){
    mesh = new Mesh(assets.getMesh(s));
  }
  
  @Override
  void Render(){
    mesh.Render(transform);
  }
}



class RenderComponent extends Component {

  RenderObject renderObject;
  
  RenderComponent(RenderObject s){
    renderObject = s;
  }
  
  @Override
  void Render(){
    renderObject.Render(transform);
  }
}




abstract class RenderObject {
  
  PShader shader;
  color TintColor = color(255, 255);
    
  void Render(Transform transform){
    Render(transform.position, transform.scale, transform.rotation);
  }
  
  void Render(Vector3 position, Vector3 scale, Quaternion rotation){
    GameManager.graphics.pushMatrix();
    
    GameManager.graphics.translate(position.x, position.y, position.z);    
    GameManager.graphics.scale(scale.x, scale.y, scale.z);          
    Vector4 a = rotation.GetAxisAngle();   
    GameManager.graphics.rotate(a.w, a.x, a.y, a.z);
    
    if(shader != null){
      GameManager.graphics.shader(shader);
    }else{
      GameManager.graphics.resetShader();
    }
    
    GameManager.graphics.tint(TintColor);
    
    Draw();
    
    GameManager.graphics.popMatrix();
  }
  
  abstract void Draw(); 
}



class Sprite extends RenderObject {
  PImage image;
  
  Sprite(PImage img){
    image = img;
  }
  
  @Override
  void Draw(){    
    GameManager.graphics.image(image, 0, 0, 1, 1);    
  }
}




class Mesh extends RenderObject {
  PShape shape;
  
  Mesh(PShape shp){
    shape = shp;
  }
  
  ArrayList<Vector3> Vertexes(){
    ArrayList<Vector3> verts = new ArrayList<Vector3>();
    
    for(int i = 0; i < shape.getChildCount(); i++){
      for(int j = 0; j < shape.getChild(i).getVertexCount(); j++){
        PVector v = shape.getChild(i).getVertex(j);
        if(verts.contains(v)){
          continue;
        } 
        verts.add(Math.Vec3(v));
      }
    }
    return verts;
  }
  
  float MaxLengthFromPivot(){
    float m = 0;
    ArrayList<Vector3> verts = Vertexes();
    for(Vector3 v : verts){
      float vm = v.Magnitude();
      if(vm > m) { m = vm; }
    }
    return m;
  }
  
  @Override
  void Draw(){    
    GameManager.graphics.shape(shape);    
  }
} 


class DebugRenderObject extends RenderObject {
  @Override
  void Draw() {
    
  }
}


class PrimitiveSphere extends RenderObject {
  
  @Override
  void Draw(){
    GameManager.graphics.noStroke();
    GameManager.graphics.fill(255);
    GameManager.graphics.sphere(1);
  }
}




// -----COLORS:------ //

Colors Colors = new Colors();
class Colors {
  color Red = color(255, 0, 0);
  color Green = color(0, 255, 0);
  color Blue = color(0, 0, 255);
  color White = color(255);
  color Black = color(0);
}