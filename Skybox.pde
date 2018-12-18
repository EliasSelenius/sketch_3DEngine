

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
    
    DisplayBuffer.textureMode(NORMAL);
        
    DisplayBuffer.noStroke();
    
    // front
    DisplayBuffer.beginShape(QUADS);    
    DisplayBuffer.texture(front);
    DisplayBuffer.vertex(1,1,1, 0,0);
    DisplayBuffer.vertex(-1,1,1, 1,0);
    DisplayBuffer.vertex(-1,-1,1, 1,1);
    DisplayBuffer.vertex(1,-1,1, 0,1);
    DisplayBuffer.endShape();
    
    // back
    DisplayBuffer.beginShape(QUADS);    
    DisplayBuffer.texture(back);
    DisplayBuffer.vertex(1,1,-1, 1,0);
    DisplayBuffer.vertex(-1,1,-1, 0,0);
    DisplayBuffer.vertex(-1,-1,-1, 0,1);
    DisplayBuffer.vertex(1,-1,-1, 1,1);
    DisplayBuffer.endShape();
    
    // up
    DisplayBuffer.beginShape(QUADS);    
    DisplayBuffer.texture(up);
    DisplayBuffer.vertex(1,1,1, 0,1);
    DisplayBuffer.vertex(-1,1,1, 1,1);
    DisplayBuffer.vertex(-1,1,-1, 1,0);
    DisplayBuffer.vertex(1,1,-1, 0,0);
    DisplayBuffer.endShape();
    
    // down
    DisplayBuffer.beginShape(QUADS);    
    DisplayBuffer.texture(down);
    DisplayBuffer.vertex(1,-1,1, 0,0);
    DisplayBuffer.vertex(-1,-1,1, 1,0);
    DisplayBuffer.vertex(-1,-1,-1, 1,1);
    DisplayBuffer.vertex(1,-1,-1, 0,1);
    DisplayBuffer.endShape();
    
    // Right
    DisplayBuffer.beginShape(QUADS);    
    DisplayBuffer.texture(right);
    DisplayBuffer.vertex(1,1,1, 1,0);
    DisplayBuffer.vertex(1,1,-1, 0,0);
    DisplayBuffer.vertex(1,-1,-1, 0,1);
    DisplayBuffer.vertex(1,-1,1, 1,1);
    DisplayBuffer.endShape();
    
    // left
    DisplayBuffer.beginShape(QUADS);    
    DisplayBuffer.texture(left);
    DisplayBuffer.vertex(-1,1,1, 0,0);
    DisplayBuffer.vertex(-1,1,-1, 1,0);
    DisplayBuffer.vertex(-1,-1,-1, 1,1);
    DisplayBuffer.vertex(-1,-1,1, 0,1);
    DisplayBuffer.endShape();
    
  }
}