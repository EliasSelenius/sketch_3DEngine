
import java.awt.*;


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


class InpAxis{
  Key key1, key2;
  float Value;
  String Name;
  InpAxis(String n, char a, char b){
    Name = n;
    key1 = input.getKey(a);
    key2 = input.getKey(b);
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

class Input{
  
  Key[] keys;
  InpAxis[] Axis;
  
  Vector2 mouseMovment;
  Vector2 mousePos;
  
  MouseMode mouseMode;
  
  Robot robot;
  
  Input(){
    mouseMovment = new Vector2();
    mousePos = new Vector2();
  }
  
  void Init(){
    char[] ch = {' ', 'w', 'a', 's', 'd', 'g', 'e', 'q'};
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
  
  
  void Update(){
   
    //mouseTurn = true;
    //mouseMovment.setValue(0,0);
    //if(!mousePos.InsideOf(new Vector2(0,0), new Vector2(100,100))){
    //  robot.mouseMove(50, 50);
    //  mouseTurn = false;
    //}
    //else if(mouseTurn){
    //  mouseMovment.setValue(pmouseX - mouseX, pmouseY - mouseY);
    //} 
    
    
    mouseMovment.setValue(mouseX - pmouseX, mouseY - pmouseY);
    mousePos.setValue(mouseX, mouseY);
    
    for(int i = 0; i < Axis.length; i++){
      Axis[i].Update();
    }
    for(int i = 0; i < keys.length; i++){
      keys[i].Update();
    }
  }
  
  
  
  Key getKey(char n){
    for(int i = 0; i < keys.length; i++){
      if(keys[i].Name == n){
        return keys[i];
      }
    }
    return null;
  }
  
  InpAxis getAxis(String n){
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
    if(key == input.keys[i].Name){
      input.keys[i].Pressed = true;
    }
  }
}

void keyReleased(){
  for(int i = 0; i < input.keys.length; i++){
    if(key == input.keys[i].Name){
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

void mouseReleased(){

}