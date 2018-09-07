


// Canvas: a system for all user interface elements 
class Canvas extends RenderObject {
  
  ArrayList<UIElement> Elements = new ArrayList<UIElement>();
  
  @Override
  void Draw(){

    DisplayBuffer.text(frameRate, width / 2,height / 2);
    DisplayBuffer.image(assets.getTexture("front"), 0, 0, width, height);
    for(int i = 0; i < Elements.size(); i++){
      Elements.get(i).Update();
    }
  }
}

abstract class UIElement{
  
  abstract void Update();
}
