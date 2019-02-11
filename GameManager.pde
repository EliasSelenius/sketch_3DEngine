
GameManager GameManager = new GameManager();
class GameManager {

    PGraphics graphics;
    QueryList<ScreenLayer> Layers = new QueryList<ScreenLayer>();
    
    Camera MainCamera;
    QueryList<Camera> Cameras = new QueryList<Camera>();

    FrequencyTimer RenderTime = new FrequencyTimer();

    GameManager() {
        //InitRenderer(P3D);
    }

    void InitRenderer(String renderer) {
        graphics = createGraphics(width, height, renderer);
        AddCamera();
    }


    void AddCamera() {
        Camera cam = new Camera();
        if(MainCamera == null) {
            MainCamera = cam;
        }
        Cameras.add(cam);
    }

    void Render() {
         
        for(Camera cam : Cameras) {
            cam.ApplySettings();
        }
        
        // do all rendering
        for(ScreenLayer layer : Layers) {
            graphics.beginDraw();
            layer.Render();
            graphics.endDraw();
        }

        // finally display graphics to screen
        image(graphics, 0, 0);

        RenderTime.Next();
    }


    Scene ActiveScene;

    void Update() {
        ActiveScene.Update();
        page.Update();
        input.Update();

        println(RenderTime.Frequency());
    }
}

abstract class ScreenLayer {	
    abstract void Render();
}