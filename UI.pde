


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
      elm.Render();
    }
  }

  void Update() {
    for(UIElement elm : Elements) {
      elm.Update();
    }
  }


  //Canvas Add(UIElement) 
}

abstract class UIElement {
  
  Vector2 Pos;
  Rectangle Rect;

  QueryList<UIElementComponent> Components = new QueryList<UIElementComponent>();

  void Render() { 
    for(UIElementComponent comp : Components) {
      comp.Render();
    }
  }
  void Update() {
    for(UIElementComponent comp : Components) {
      comp.Update();
    }
  }
}

abstract class UIElementComponent {
  UIElement element;

  void Render() { }
  void Update() { }
}

abstract class ResponsiveUIComponent extends UIElementComponent {

  Event OnHover = new Event();
  Event OnLeftClick = new Event();
  Event OnRightClick = new Event();

  void OnHover() { }
  void OnLClick() { }
  void OnRClick() { }
}
