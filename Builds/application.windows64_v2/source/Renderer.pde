

void ApplyCameraTransform(PGraphics gr, Transform transform){
  Vector3 forward = transform.Forward();
  Vector3 up = transform.Up();
  gr.camera(transform.position.x, transform.position.y, transform.position.z, 
      forward.x + transform.position.x, 
      forward.y + transform.position.y, 
      forward.z + transform.position.z,
      up.x, up.y, up.z);    
}

void ApplyCameraPerspective(PGraphics gr, Camera cam){
  gr.perspective(radians(cam.FieldOfView), (float)width / (float)height, cam.NearClipPlane, cam.FarClipPlane);
}

class GraphicsRenderer {
  
  ArrayList<RenderLayer> Layers = new ArrayList<RenderLayer>();
    
  PGraphics DisplayBuffer;
  
  GraphicsRenderer() {
    
    DisplayBuffer = createGraphics(width, height, P3D);
    
    Layers.add(new RenderLayer("Background"));
    Layers.add(new RenderLayer("Default"));
    Layers.add(new RenderLayer("UI"));
  }
  
  RenderLayer GetLayer(String name) {
    for(RenderLayer layer : Layers){
      if(layer.Name == name){
        return layer;
      }
    }
    return null;
  }
  
  void Render(){
    DisplayBuffer.beginDraw();
    DisplayBuffer.background(0);
    DisplayBuffer.endDraw();
    for(RenderLayer layer : Layers){
      layer.Render(DisplayBuffer);
    }
    Draw_Debug();
  }
  
  void Draw_Debug(){
    DisplayBuffer.beginDraw();
  
    Vector3 f = new Vector3(0,0,1000);
    Vector3 u = new Vector3(0,1000,0);
    Vector3 r = u.Cross(f);
  
    DisplayBuffer.scale(10);
    DisplayBuffer.stroke(color(255,0,0));
    DisplayBuffer.line(0,0,0,r.x, r.y, r.z);
    DisplayBuffer.stroke(color(0,255,0));
    DisplayBuffer.line(0,0,0,u.x, u.y, u.z);
    DisplayBuffer.stroke(color(0,0,255));
    DisplayBuffer.line(0,0,0,f.x, f.y, f.z);
  
    DisplayBuffer.scale(.1);
    DisplayBuffer.stroke(255);
    DisplayBuffer.line(0,0,0,  width, 0,0);
    DisplayBuffer.line(0,0,0,  0, height,0);
    DisplayBuffer.line(width,0,0, width, height,0);
    DisplayBuffer.line(0,height,0,  width, height, 0);
  
    DisplayBuffer.line(0,0,0, 0,0,width);
    DisplayBuffer.line(0,height,0 ,0, height, width);
    DisplayBuffer.line(0,0,width, 0,height, width);

    DisplayBuffer.endDraw();
  }
  
  PImage Frame(Camera cam){
    ApplyCameraTransform(DisplayBuffer, cam.transform);
    ApplyCameraPerspective(DisplayBuffer, cam);
    return DisplayBuffer.copy();
  }
}


class QueuedObject {
  RenderObject obj;
  Transform transform;
  QueuedObject(RenderObject o, Transform t){
    obj = o; transform = t;
  }
}

class RenderLayer {
  ArrayList<QueuedObject> Queue = new ArrayList<QueuedObject>();
  String Name;
  RenderLayer(String n){
    Name = n;
  }
  void Render(PGraphics gr){
    gr.beginDraw();
    for(QueuedObject qobj : Queue){
      qobj.obj.Render(gr, qobj.transform);
    }
    gr.endDraw();
    Queue.clear();
  }
}


class MeshRenderer extends Component {

  Mesh mesh;
  
  MeshRenderer(String s){
    mesh = new Mesh(assets.getMesh(s));
  }
  
  @Override
  void Update(){
    mesh.Queue(transform);
  }
}



class RenderComponent extends Component {

  RenderObject renderObject;
  
  RenderComponent(RenderObject s){
    renderObject = s;
  }
  
  @Override
  void Update(){
    renderObject.Queue(transform);
  }
}




abstract class RenderObject {
  
  PShader shader;
  color TintColor = color(255, 255);
  RenderLayer Layer;
  
  RenderObject(){
    Layer = Renderer.GetLayer("Default");
  }
  
  void Queue(Vector3 p, Vector3 s, Quaternion r){
    Queue(new Transform(p, s, r));
  }
  
  void Queue(Transform t){
    Layer.Queue.add(new QueuedObject(this, t));
  }
  
  void Render(PGraphics gr, Transform transform){
    Render(gr, transform.position, transform.scale, transform.rotation);
  }
  
  void Render(PGraphics gr, Vector3 position, Vector3 scale, Quaternion rotation){
    gr.pushMatrix();
    
    gr.translate(position.x, position.y, position.z);    
    gr.scale(scale.x, scale.y, scale.z);          
    Vector4 a = rotation.GetAxisAngle();   
    gr.rotate(a.w, a.x, a.y, a.z);
    
    if(shader != null){
      gr.shader(shader);
    }else{
      gr.resetShader();
    }
    
    gr.tint(TintColor);
    
    Draw(gr);
    
    gr.popMatrix();
  }
  
  abstract void Draw(PGraphics gr); 
}



class Sprite extends RenderObject {
  PImage image;
  
  Sprite(PImage img){
    image = img;
  }
  

  void Draw(PGraphics gr){    
    gr.image(image, 0, 0, 1, 1);    
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
  
  void Draw(PGraphics gr){    
    gr.shape(shape);    
  }
} 




class PrimitiveSphere extends RenderObject {
  
  void Draw(PGraphics gr){
    gr.noStroke();
    gr.fill(255);
    gr.sphere(1);
  }
}