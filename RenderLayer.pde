


ScreenSurface ScreenSurface;

class ScreenSurface {
    PGraphics graphics;
    QueryList<ScreenLayer> Layers = new QueryList<ScreenLayer>();
    void Render() {
        for(ScreenLayer layer : Layers) {
            graphics.beginDraw();
            layer.Render();
            graphics.endDraw();
        }
        image(graphics, 0, 0);
    }

    void Init(String renderer) {
        graphics = createGraphics(width, height, renderer);
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
        skybox.Render(defScene.MainCamera.transform.position, new Vector3(1000f), new Quaternion());
    }
}