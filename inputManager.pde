


class Key{
  char Name;
  boolean Pressed;
  boolean Released;
  Key(char n){
    Name = n;
  }
  void Update(){
    Released = false;
  }
}


class InpAxis {
  Key key1, key2;
  float Value;
  String Name;
  InpAxis(String n, char a, char b){
    Name = n;
    key1 = input.GetKey(a);
    key2 = input.GetKey(b);
  }
  
  void Update(){
    if(key1.Pressed){
      Value += .1f;
    }
    if(key2.Pressed){
      Value -= .1f;
    }
    if(key1.Pressed == false && key2.Pressed == false && Value != 0){
      //if(Value < 0){
      //  Value += .1f;
      //}else{
      //  Value -= .1f;
      //}
      Value = 0;
    }
    Value = Math.Clamp(Value, -1, 1);
  }
  
  float getValue(){
    return Value;
  }
}

enum MouseMode{
  Locked,
  Free,
}

class Input {
  
  Key[] keys;
  InpAxis[] Axis;
  
  Vector2 mouseMove;
  Vector2 mousePos;
  float mouseWheel;
  MouseMode mouseMode;
  
  Robot robot;
  
  Input(){
    mouseMove = new Vector2();
    mousePos = new Vector2();
    mouseMode = MouseMode.Free;
  }
  
  void Init(){
    char[] ch = {' ', 'w', 'a', 's', 'd', 'g', 'e', 'q', 'f', 'r'};
    keys = new Key[ch.length];
    for(int i = 0; i < ch.length; i++){
      keys[i] = new Key(ch[i]);
    }
    Axis = new InpAxis[]{new InpAxis("Vertical", 's', 'w'), new InpAxis("Horizontal", 'd', 'a'), new InpAxis("Roll", 'q', 'e')};
    
    try{
      robot = new Robot();
    }catch(AWTException e){
      e.printStackTrace();
    }
  }
  
  void ShowMouse(boolean o){
    if(o){
      cursor();
    }else{
      noCursor();
    }
  }
  
  
  void Update(){
    
    mouseWheel = 0;

    float centerX = width / 2f, centerY = height / 2f;
    
    switch(mouseMode){
      case Free:
        mouseMove.setValue((float)(mouseX - pmouseX), (float)(mouseY - pmouseY));
        break;
      case Locked:
        robot.mouseMove((int)centerX + frame.getX(),(int)centerY + frame.getY());
        mouseMove.setValue(0f,0f);
        mouseMove.setValue(mouseX - centerX, mouseY - centerY);        
        break;
    }
    

    mousePos.setValue((float)mouseX, (float)mouseY);
    
    for(int i = 0; i < Axis.length; i++){
      Axis[i].Update();
    }
    for(int i = 0; i < keys.length; i++){
      keys[i].Update();
    }
  }

  Key GetKey(char n){
    for(int i = 0; i < keys.length; i++){
      if(keys[i].Name == n){
        return keys[i];
      }
    }
    return null;
  }
  
  InpAxis GetAxis(String n){
    for(int i = 0; i < Axis.length; i++){
      if(Axis[i].Name == n){
        return Axis[i];
      }
    }
    return null;
  }
} 
Input input;


void keyPressed(){
  for(int i = 0; i < input.keys.length; i++){
    char k = input.keys[i].Name;
    if(key == Character.toUpperCase(k) || key == Character.toLowerCase(k)){
      input.keys[i].Pressed = true;
    }
  }
}

void keyReleased(){
  for(int i = 0; i < input.keys.length; i++){
    char k = input.keys[i].Name;
    if(key == Character.toUpperCase(k) || key == Character.toLowerCase(k)){
      input.keys[i].Pressed = false;
      input.keys[i].Released = true;
    }
  }
}

void mousePressed(){
  switch (mouseButton){
    case LEFT:
      break;
    case RIGHT: 
      break;
    case CENTER:
      break;
  }
}

void mouseMoved(){
  
  
}

void mouseReleased(){

}

void mouseWheel(MouseEvent event) {
  input.mouseWheel = event.getCount();
}
