




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
    WorldGraphics.pushMatrix();
    
    WorldGraphics.translate(position.x, position.y, position.z);    
    WorldGraphics.scale(scale.x, scale.y, scale.z);          
    Vector4 a = rotation.GetAxisAngle();   
    WorldGraphics.rotate(a.w, a.x, a.y, a.z);
    
    if(shader != null){
      WorldGraphics.shader(shader);
    }else{
      WorldGraphics.resetShader();
    }
    
    WorldGraphics.tint(TintColor);
    
    Draw();
    
    WorldGraphics.popMatrix();
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
    WorldGraphics.image(image, 0, 0, 1, 1);    
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
    WorldGraphics.shape(shape);    
  }
} 




class PrimitiveSphere extends RenderObject {
  
  @Override
  void Draw(){
    WorldGraphics.noStroke();
    WorldGraphics.fill(255);
    WorldGraphics.sphere(1);
  }
}