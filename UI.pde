

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

class UICanvas extends RenderLayer {

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
        Game.graphics.camera();
        Game.graphics.perspective();
        Game.graphics.text(frameRate, 600,600);
        for(UIObject el : Elements) {
            el.Render();
        }
    }


    void Update() {
        for(UIObject el : Elements) {
            el.Update();
        }
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
		Game.graphics.pushMatrix();
		Game.graphics.fill(0);
		Game.graphics.ellipse(transform.position.x, transform.position.y, 20,20);
		Game.graphics.popMatrix();
	}

	void Update() { }
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
        Game.graphics.text(text, 
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

		
		float hw = rect.Width / 2f;
		float hh = rect.Height / 2f;
		Game.graphics.rect(-hw,
									-hh,
									rect.Width,
									rect.Height);	
	}

	@Override
	void Update() {
		/*
		println(PI * Game.Time.Delta() + " AND " + (PI * deltaTime) + " AND " + (10000f * Game.Time.Delta()) + " AND " + (millis()) );
		transform.Rotate(0, 10000f * Game.Time.Delta(), 0);
		println("rotation " + transform.rotation);
*/
		//transform.Translate(sin(Game.Time.UpdateCount / 0.1f) * 100f, 0f, 0f);
	}
}


UICanvas CreatTestUI() {

  	TextBox tb = new TextBox("Hello World qw e ee ee eee eee eee ee eeee eeeee ee eee");
	tb.transform.Translate(100, 100);

	Button btn = new Button("Test");
	btn.transform.Translate(200, 300);
	
	return new UICanvas(tb, btn);

}

