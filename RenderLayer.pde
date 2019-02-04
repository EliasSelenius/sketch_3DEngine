


ScreenSurface ScreenSurface;

class ScreenSurface {
    PGraphics graphics;
    QueryList<ScreenLayer> Layers = new QueryList<ScreenLayer>();
    
    Camera MainCamera;
    QueryList<Camera> Cameras = new QueryList<Camera>();

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
    }

    void Init(String renderer) {
        graphics = createGraphics(width, height, renderer);

        AddCamera();
    }
    ScreenSurface() {
        Init(P3D);
    }
    ScreenSurface(String renderer) {
        Init(renderer);
    }
}

abstract class ScreenLayer {	
    abstract void Render();
}




class BackgroundLayer extends ScreenLayer {
    
    Skybox skybox;

    BackgroundLayer() {
        skybox = new Skybox();
    } 
    
    @Override
    void Render() {
        skybox.Render(ScreenSurface.MainCamera.transform.position, new Vector3(1000f), new Quaternion());
    }
}