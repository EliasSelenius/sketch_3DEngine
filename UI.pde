
/*

// Canvas: a system for all user interface elements 
class Canvas extends ScreenLayer {
  
  QueryList<UIElement> Elements = new QueryList<UIElement>();
  
  Canvas() {
    //super(P2D);

    input.OnMouseLeftClick.AddListner("OnLeftClick", this);
    input.OnMouseRightClick.AddListner("OnRightClick", this);
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

  void OnLeftClick() {
    for(UIElement elm : Elements) {
      if(input.mousePos)
    }
  }
  void OnRightClick() {

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

  QueryList<UIComponent> Components = new QueryList<UIComponent>();

  UIComponent AddComponent(UIComponent comp) {
    comp.element = this;
    Components.add(comp);
    return comp;
  }

  void Render() { 
    for(UIComponent comp : Components) {
      comp.Render();
    }
  }
  void Update() {
    for(UIComponent comp : Components) {
      comp.Update();
    }
  }
}

abstract class UIComponent {
  UIElement element;

  void Render() { }
  void Update() { }
}

abstract class ResponsiveUIComponent extends UIComponent {

  ResponsiveUIComponent() {
    OnLeftClick.AddListner("OnLClick", this);
    OnRightClick.AddListner("OnRClick", this);
  }

  Event OnHover = new Event();
  Event OnLeftClick = new Event();
  Event OnRightClick = new Event();

  void OnHover() { }
  void OnLClick() { println("LeftClickElement"); }
  void OnRClick() { println("RightClickElement"); }
}

*/








abstract class UIObject {
	Vector2 pos = new Vector2();
    Rectangle rect = new Rectangle(0F, 0F);
	void SetTransform(float x, float y, float w, float h) {
		pos.setValue(x, y);
		rect.Width = w; rect.Height = h;
	}
	UICanvas canvas;
    void Render() { }
}


abstract class UIParent extends UIObject {
	QueryList<UIObject> Children = new QueryList<UIObject>();

	UIParent(UIObject... chil) {
		Children.Insert(chil);
	}
}


class UICanvas extends ScreenLayer {

    QueryList<UIObject> Elements = new QueryList<UIObject>();

    UICanvas(UIObject... elms) {
        Add(elms);
    }

    void Add(UIObject... elms) {
      for(UIObject obj : elms) {
        obj.canvas = this;
      }
      Elements.Insert(elms);
    }

    @Override
    void Render() {
        ScreenSurface.graphics.camera();
        ScreenSurface.graphics.perspective();
        for(UIObject el : Elements) {
            el.Render();
        }
    }

    Event UpdateEvent = new Event();

    void Update() {
        UpdateEvent.Run();
    }
}




class TextBox extends UIObject {
    String text;

    TextBox(String t, float x, float y, float width, float height) {
        text = t;
        SetTransform(x, y, width, height);
    }

    @Override
    void Render() {
        ScreenSurface.graphics.text(text, pos.x, pos.y, rect.Width, rect.Height);
    }
}

class Button extends UIObject {
	TextBox textBox;

	Button(String text, float x, float y, float width, float height) {
		SetTransform(x, y, width, height);
		textBox = new TextBox(text, pos.x, pos.y, rect.Width, rect.Height);
	}

	@Override
	void Render() {
		ScreenSurface.graphics.fill(0);
		ScreenSurface.graphics.rect(pos.x, pos.y, rect.Width, rect.Height);
		ScreenSurface.graphics.fill(255);
		textBox.Render();
	}
}


UICanvas CreatTestUI() {
	UICanvas can;

	can = new UICanvas(new TextBox("Erat stet voluptua dolor et magna dolores eirmod sit.Erat ipsum sit ea stet nonumy tempor, duo tempor justo sed et rebum dolore labore et, accusam voluptua eos dolor et diam et, clita stet tempor stet rebum magna sea ea dolores et. Et accusam sit dolore rebum labore lorem at. Et stet ea et et, magna diam invidunt erat lorem lorem diam at dolor. Aliquyam sit et stet dolore sadipscing. Labore rebum et sed dolor diam. Kasd amet ipsum dolores dolore, dolor sit justo gubergren amet sea vero, sed dolores kasd labore invidunt sed, invidunt magna et aliquyam et sed et. Et justo justo lorem sanctus voluptua, est ut labore diam nonumy. Clita lorem amet vero et et lorem tempor ea, et sed voluptua ut lorem ea sit lorem consetetur, sed rebum gubergren diam diam lorem lorem. Nonumy sit aliquyam magna erat magna sit. Dolor amet ea amet et ea ipsum labore diam, sit duo accusam ut dolor labore takimata diam dolore labore. Et accusam ipsum et consetetur. Vero lorem sed nonumy ipsum ipsum sea stet eirmod nonumy. Ea lorem duo ipsum lorem sed aliquyam justo ipsum, et justo sit sea vero dolor, et et stet kasd no dolores takimata, dolore sit sanctus et clita consetetur elitr, justo sadipscing eos ipsum amet ut rebum duo ipsum amet, ipsum duo voluptua sed eos justo erat ipsum ipsum dolor. Dolore ipsum erat invidunt dolores invidunt, eirmod invidunt diam rebum lorem ea dolor dolor aliquyam, stet elitr labore lorem dolores magna dolores takimata duo vero, lorem diam duo et sanctus elitr, est dolor sit no et ipsum diam stet stet eirmod. Amet erat diam dolores sadipscing duo. Est diam accusam lorem clita elitr diam sit. Sit dolores erat vero accusam, eos est dolore stet kasd accusam amet dolor. Consetetur takimata sed sit gubergren dolor et, ut sadipscing sea eos dolor et labore. Diam accusam sadipscing sea eirmod lorem sadipscing, erat vero et et.", 0, 0, 200, 1000));

	Button btn = new Button("Test", 400, 400, 70, 30);
	can.Add(btn);

	return can;
}