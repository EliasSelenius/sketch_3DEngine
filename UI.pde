

interface UIRenderable {
	void InitUI();

	TextBox Text(String txt);
	// TextEditor TextEdt();
	Button Btn(String txt);
	// Image Img(String resource);
	// CheckBox Chkb();
	// ComboBox Cbob(String... opts);
	// Table Table(String... headers);
	// Table Table(int cols);

	 
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
        ScreenSurface.graphics.text(frameRate, 600,600);
        for(UIObject el : Elements) {
            el.Render();
        }
    }

    Event UpdateEvent = new Event();

    void Update() {
        UpdateEvent.Run();
    }
}


enum Align {
	Left,
	Right,
	Center,
	Fixed
}

abstract class UIObject extends RenderObject {

	UICanvas canvas;
		
	Transform transform = new Transform();
	Rectangle rect = new Rectangle(100F, 40F);
		
	int topMargin = 10;
	int bottomMargin = 10;
	int leftMargin = 10;
	int rightMargin = 10;

	Align align = Align.Center;

	void SetTransform(float x, float y, float w, float h) {
		transform.position.setValue(x, y);
		rect.Width = w; rect.Height = h;
	}

	final void Render() { 
		Render(transform);
		ScreenSurface.graphics.fill(0);
		ScreenSurface.graphics.ellipse(transform.position.x, transform.position.y, 20,20);
	}
}

class TextBox extends UIObject {
    String text;

    TextBox(String t) {
        text = t;
    }

	@Override
	void Draw() {

		


		float hw = rect.Width / 2f;
		float hh = rect.Height / 2f;
        ScreenSurface.graphics.text(text, 
									-hw,
									-hh,
									rect.Width, rect.Height);
	}
}

class Button extends UIObject {
	
	String text;

	Button(String t) {
		text = t;
	}

	@Override
	void Draw() {

		transform.Rotate(0, .05, 0);

		float hw = rect.Width / 2f;
		float hh = rect.Height / 2f;
		ScreenSurface.graphics.rect(-hw,
									-hh,
									rect.Width,
									rect.Height);	
	}
}


UICanvas CreatTestUI() {

  	TextBox tb = new TextBox("Hello World qw e ee ee eee eee eee ee eeee eeeee ee eee");
	tb.transform.Translate(100, 100);

	Button btn = new Button("Test");
	btn.transform.Translate(200, 300);
	
	return new UICanvas(tb, btn);

}

