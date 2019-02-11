

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
    GameManager.graphics.textureMode(NORMAL);
        
    GameManager.graphics.noStroke();
    
    // front
    GameManager.graphics.beginShape(QUADS);    
    GameManager.graphics.texture(front);
    GameManager.graphics.vertex(1,1,1, 0,0);
    GameManager.graphics.vertex(-1,1,1, 1,0);
    GameManager.graphics.vertex(-1,-1,1, 1,1);
    GameManager.graphics.vertex(1,-1,1, 0,1);
    GameManager.graphics.endShape();
    
    // back
    GameManager.graphics.beginShape(QUADS);    
    GameManager.graphics.texture(back);
    GameManager.graphics.vertex(1,1,-1, 1,0);
    GameManager.graphics.vertex(-1,1,-1, 0,0);
    GameManager.graphics.vertex(-1,-1,-1, 0,1);
    GameManager.graphics.vertex(1,-1,-1, 1,1);
    GameManager.graphics.endShape();
    
    // up
    GameManager.graphics.beginShape(QUADS);    
    GameManager.graphics.texture(up);
    GameManager.graphics.vertex(1,1,1, 0,1);
    GameManager.graphics.vertex(-1,1,1, 1,1);
    GameManager.graphics.vertex(-1,1,-1, 1,0);
    GameManager.graphics.vertex(1,1,-1, 0,0);
    GameManager.graphics.endShape();
    
    // down
    GameManager.graphics.beginShape(QUADS);    
    GameManager.graphics.texture(down);
    GameManager.graphics.vertex(1,-1,1, 0,0);
    GameManager.graphics.vertex(-1,-1,1, 1,0);
    GameManager.graphics.vertex(-1,-1,-1, 1,1);
    GameManager.graphics.vertex(1,-1,-1, 0,1);
    GameManager.graphics.endShape();
    
    // Right
    GameManager.graphics.beginShape(QUADS);    
    GameManager.graphics.texture(right);
    GameManager.graphics.vertex(1,1,1, 1,0);
    GameManager.graphics.vertex(1,1,-1, 0,0);
    GameManager.graphics.vertex(1,-1,-1, 0,1);
    GameManager.graphics.vertex(1,-1,1, 1,1);
    GameManager.graphics.endShape();
    
    // left
    GameManager.graphics.beginShape(QUADS);    
    GameManager.graphics.texture(left);
    GameManager.graphics.vertex(-1,1,1, 0,0);
    GameManager.graphics.vertex(-1,1,-1, 1,0);
    GameManager.graphics.vertex(-1,-1,-1, 1,1);
    GameManager.graphics.vertex(-1,-1,1, 0,1);
    GameManager.graphics.endShape();
    
    
  }
}