


// Canvas: a system for all user interface elements 
class Canvas {
  
  QueryList<UIElement> Elements = new QueryList<UIElement>();
  
  void Draw(){
    UIGraphics.text(frameRate, width / 2,height / 2);
    UIGraphics.image(assets.getTexture("front"), 0, 0, width, height);
    for(UIElement elm : Elements) {
      elm.Draw();
    }
  }


  //Canvas Add(UIElement) 
}

abstract class UIElement {
  
  Vector2 Pos;
  Rectangle Rect;

  void Draw() { }
}

abstract class ResponsiveUIElement extends UIElement {
  void OnHover() { }
  void OnLClick() { }
  void OnRClick() { }
}
