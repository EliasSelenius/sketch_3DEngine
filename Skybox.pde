

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
    ScreenSurface.graphics.textureMode(NORMAL);
        
    ScreenSurface.graphics.noStroke();
    
    // front
    ScreenSurface.graphics.beginShape(QUADS);    
    ScreenSurface.graphics.texture(front);
    ScreenSurface.graphics.vertex(1,1,1, 0,0);
    ScreenSurface.graphics.vertex(-1,1,1, 1,0);
    ScreenSurface.graphics.vertex(-1,-1,1, 1,1);
    ScreenSurface.graphics.vertex(1,-1,1, 0,1);
    ScreenSurface.graphics.endShape();
    
    // back
    ScreenSurface.graphics.beginShape(QUADS);    
    ScreenSurface.graphics.texture(back);
    ScreenSurface.graphics.vertex(1,1,-1, 1,0);
    ScreenSurface.graphics.vertex(-1,1,-1, 0,0);
    ScreenSurface.graphics.vertex(-1,-1,-1, 0,1);
    ScreenSurface.graphics.vertex(1,-1,-1, 1,1);
    ScreenSurface.graphics.endShape();
    
    // up
    ScreenSurface.graphics.beginShape(QUADS);    
    ScreenSurface.graphics.texture(up);
    ScreenSurface.graphics.vertex(1,1,1, 0,1);
    ScreenSurface.graphics.vertex(-1,1,1, 1,1);
    ScreenSurface.graphics.vertex(-1,1,-1, 1,0);
    ScreenSurface.graphics.vertex(1,1,-1, 0,0);
    ScreenSurface.graphics.endShape();
    
    // down
    ScreenSurface.graphics.beginShape(QUADS);    
    ScreenSurface.graphics.texture(down);
    ScreenSurface.graphics.vertex(1,-1,1, 0,0);
    ScreenSurface.graphics.vertex(-1,-1,1, 1,0);
    ScreenSurface.graphics.vertex(-1,-1,-1, 1,1);
    ScreenSurface.graphics.vertex(1,-1,-1, 0,1);
    ScreenSurface.graphics.endShape();
    
    // Right
    ScreenSurface.graphics.beginShape(QUADS);    
    ScreenSurface.graphics.texture(right);
    ScreenSurface.graphics.vertex(1,1,1, 1,0);
    ScreenSurface.graphics.vertex(1,1,-1, 0,0);
    ScreenSurface.graphics.vertex(1,-1,-1, 0,1);
    ScreenSurface.graphics.vertex(1,-1,1, 1,1);
    ScreenSurface.graphics.endShape();
    
    // left
    ScreenSurface.graphics.beginShape(QUADS);    
    ScreenSurface.graphics.texture(left);
    ScreenSurface.graphics.vertex(-1,1,1, 0,0);
    ScreenSurface.graphics.vertex(-1,1,-1, 1,0);
    ScreenSurface.graphics.vertex(-1,-1,-1, 1,1);
    ScreenSurface.graphics.vertex(-1,-1,1, 0,1);
    ScreenSurface.graphics.endShape();
    
    
  }
}