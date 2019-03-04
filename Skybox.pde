

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
    Game.graphics.textureMode(NORMAL);
        
    Game.graphics.noStroke();
    
    // front
    Game.graphics.beginShape(QUADS);    
    Game.graphics.texture(front);
    Game.graphics.vertex(1,1,1, 0,0);
    Game.graphics.vertex(-1,1,1, 1,0);
    Game.graphics.vertex(-1,-1,1, 1,1);
    Game.graphics.vertex(1,-1,1, 0,1);
    Game.graphics.endShape();
    
    // back
    Game.graphics.beginShape(QUADS);    
    Game.graphics.texture(back);
    Game.graphics.vertex(1,1,-1, 1,0);
    Game.graphics.vertex(-1,1,-1, 0,0);
    Game.graphics.vertex(-1,-1,-1, 0,1);
    Game.graphics.vertex(1,-1,-1, 1,1);
    Game.graphics.endShape();
    
    // up
    Game.graphics.beginShape(QUADS);    
    Game.graphics.texture(up);
    Game.graphics.vertex(1,1,1, 0,1);
    Game.graphics.vertex(-1,1,1, 1,1);
    Game.graphics.vertex(-1,1,-1, 1,0);
    Game.graphics.vertex(1,1,-1, 0,0);
    Game.graphics.endShape();
    
    // down
    Game.graphics.beginShape(QUADS);    
    Game.graphics.texture(down);
    Game.graphics.vertex(1,-1,1, 0,0);
    Game.graphics.vertex(-1,-1,1, 1,0);
    Game.graphics.vertex(-1,-1,-1, 1,1);
    Game.graphics.vertex(1,-1,-1, 0,1);
    Game.graphics.endShape();
    
    // Right
    Game.graphics.beginShape(QUADS);    
    Game.graphics.texture(right);
    Game.graphics.vertex(1,1,1, 1,0);
    Game.graphics.vertex(1,1,-1, 0,0);
    Game.graphics.vertex(1,-1,-1, 0,1);
    Game.graphics.vertex(1,-1,1, 1,1);
    Game.graphics.endShape();
    
    // left
    Game.graphics.beginShape(QUADS);    
    Game.graphics.texture(left);
    Game.graphics.vertex(-1,1,1, 0,0);
    Game.graphics.vertex(-1,1,-1, 1,0);
    Game.graphics.vertex(-1,-1,-1, 1,1);
    Game.graphics.vertex(-1,-1,1, 0,1);
    Game.graphics.endShape();
    
    
  }
}