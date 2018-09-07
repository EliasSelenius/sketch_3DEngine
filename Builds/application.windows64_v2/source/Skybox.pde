

class Skybox extends RenderObject {
  
  PImage front, back, up, down, right, left;
    
  Skybox(){
    front = assets.getTexture("Skyboxes\\Skybox_front");
    back = assets.getTexture("Skyboxes\\Skybox_back");
    up = assets.getTexture("Skyboxes\\Skybox_up");
    down = assets.getTexture("Skyboxes\\Skybox_down");
    right = assets.getTexture("Skyboxes\\Skybox_right");
    left = assets.getTexture("Skyboxes\\Skybox_left");
    
    Layer = Renderer.GetLayer("Background");
    
    shader = assets.getShader("texShader");
  }
  
  @Override
  void Draw(PGraphics gr){
    
    gr.textureMode(NORMAL);
        
    gr.noStroke();
    
    // front
    gr.beginShape(QUADS);    
    gr.texture(front);
    gr.vertex(1,1,1, 0,0);
    gr.vertex(-1,1,1, 1,0);
    gr.vertex(-1,-1,1, 1,1);
    gr.vertex(1,-1,1, 0,1);
    gr.endShape();
    
    // back
    gr.beginShape(QUADS);    
    gr.texture(back);
    gr.vertex(1,1,-1, 1,0);
    gr.vertex(-1,1,-1, 0,0);
    gr.vertex(-1,-1,-1, 0,1);
    gr.vertex(1,-1,-1, 1,1);
    gr.endShape();
    
    // up
    gr.beginShape(QUADS);    
    gr.texture(up);
    gr.vertex(1,1,1, 0,1);
    gr.vertex(-1,1,1, 1,1);
    gr.vertex(-1,1,-1, 1,0);
    gr.vertex(1,1,-1, 0,0);
    gr.endShape();
    
    // down
    gr.beginShape(QUADS);    
    gr.texture(down);
    gr.vertex(1,-1,1, 0,0);
    gr.vertex(-1,-1,1, 1,0);
    gr.vertex(-1,-1,-1, 1,1);
    gr.vertex(1,-1,-1, 0,1);
    gr.endShape();
    
    // Right
    gr.beginShape(QUADS);    
    gr.texture(right);
    gr.vertex(1,1,1, 1,0);
    gr.vertex(1,1,-1, 0,0);
    gr.vertex(1,-1,-1, 0,1);
    gr.vertex(1,-1,1, 1,1);
    gr.endShape();
    
    // left
    gr.beginShape(QUADS);    
    gr.texture(left);
    gr.vertex(-1,1,1, 0,0);
    gr.vertex(-1,1,-1, 1,0);
    gr.vertex(-1,-1,-1, 1,1);
    gr.vertex(-1,-1,1, 0,1);
    gr.endShape();
    
  }
}