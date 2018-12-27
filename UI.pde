


// Canvas: a system for all user interface elements 
class Canvas extends ScreenLayer {
  
  QueryList<UIElement> Elements = new QueryList<UIElement>();
  
  Canvas() {
    //super(P2D);
  }

  @Override
  void Render(){
    ScreenSurface.graphics.camera();
    ScreenSurface.graphics.perspective();
    ScreenSurface.graphics.text("Hello World " + frameRate, width / 2,height / 2);
    ScreenSurface.graphics.image(assets.getTexture("front"), 0, 0, 100, 100);
    //ScreenSurface.graphics.shape(assets.getMesh("box"), width / 2, height / 2, 100, 100);
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
