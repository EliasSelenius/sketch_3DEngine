

class Skybox extends RenderObject {
  
  PImage front, back, up, down, right, left;
    
  Skybox(){
    front = assets.getTexture("Skyboxes\\Skybox_front");
    back = assets.getTexture("Skyboxes\\Skybox_back");
    up = assets.getTexture("Skyboxes\\Skybox_up");
    down = assets.getTexture("Skyboxes\\Skybox_down");
    right = assets.getTexture("Skyboxes\\Skybox_right");
    left = assets.getTexture("Skyboxes\\Skybox_left");
    
    //shader = assets.getShader("texShader");
    shader = assets.GetShader("default");
  }
  
  @Override
  void Draw(){
    
    WorldGraphics.textureMode(NORMAL);
        
    WorldGraphics.noStroke();
    
    // front
    WorldGraphics.beginShape(QUADS);    
    WorldGraphics.texture(front);
    WorldGraphics.vertex(1,1,1, 0,0);
    WorldGraphics.vertex(-1,1,1, 1,0);
    WorldGraphics.vertex(-1,-1,1, 1,1);
    WorldGraphics.vertex(1,-1,1, 0,1);
    WorldGraphics.endShape();
    
    // back
    WorldGraphics.beginShape(QUADS);    
    WorldGraphics.texture(back);
    WorldGraphics.vertex(1,1,-1, 1,0);
    WorldGraphics.vertex(-1,1,-1, 0,0);
    WorldGraphics.vertex(-1,-1,-1, 0,1);
    WorldGraphics.vertex(1,-1,-1, 1,1);
    WorldGraphics.endShape();
    
    // up
    WorldGraphics.beginShape(QUADS);    
    WorldGraphics.texture(up);
    WorldGraphics.vertex(1,1,1, 0,1);
    WorldGraphics.vertex(-1,1,1, 1,1);
    WorldGraphics.vertex(-1,1,-1, 1,0);
    WorldGraphics.vertex(1,1,-1, 0,0);
    WorldGraphics.endShape();
    
    // down
    WorldGraphics.beginShape(QUADS);    
    WorldGraphics.texture(down);
    WorldGraphics.vertex(1,-1,1, 0,0);
    WorldGraphics.vertex(-1,-1,1, 1,0);
    WorldGraphics.vertex(-1,-1,-1, 1,1);
    WorldGraphics.vertex(1,-1,-1, 0,1);
    WorldGraphics.endShape();
    
    // Right
    WorldGraphics.beginShape(QUADS);    
    WorldGraphics.texture(right);
    WorldGraphics.vertex(1,1,1, 1,0);
    WorldGraphics.vertex(1,1,-1, 0,0);
    WorldGraphics.vertex(1,-1,-1, 0,1);
    WorldGraphics.vertex(1,-1,1, 1,1);
    WorldGraphics.endShape();
    
    // left
    WorldGraphics.beginShape(QUADS);    
    WorldGraphics.texture(left);
    WorldGraphics.vertex(-1,1,1, 0,0);
    WorldGraphics.vertex(-1,1,-1, 1,0);
    WorldGraphics.vertex(-1,-1,-1, 1,1);
    WorldGraphics.vertex(-1,-1,1, 0,1);
    WorldGraphics.endShape();
    
  }
}