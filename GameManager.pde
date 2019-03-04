
GameManager Game = new GameManager();
class GameManager {

    // rendring:
    PGraphics graphics;
    QueryList<RenderLayer> Layers = new QueryList<RenderLayer>();
    FrequencyTimer RenderTime = new FrequencyTimer();

    Camera MainCamera;
    QueryList<Camera> Cameras = new QueryList<Camera>();

    // thread:
    ThreadLoop thread;
    FrequencyTimer Time;

    // Game elements (scene, ui)...
    Scene scene;
    UICanvas ui;

    // Skybox
    Skybox skybox;
    Vector3 skybox_scale = new Vector3(1000f);
    Quaternion skybox_rotation = new Quaternion();



    GameManager() {
        //InitRenderer(P3D);
    }

    void Init() {
        InitRenderer(P3D);
        InitThread();
    }

    void InitRenderer(String renderer) {
        graphics = createGraphics(width, height, renderer);
        skybox = new Skybox();
        AddCamera();
    }

    void InitThread() {
        thread = new ThreadLoop();
        Time = thread.Time;
        thread.LoopEvent.AddListner("Update", this);
    }


    void AddCamera() {
        Camera cam = new Camera();
        if(MainCamera == null) {
            MainCamera = cam;
        }
        Cameras.add(cam);
    }

    void Start() {
        thread.StartLoop();
        RenderTime.Start();
    }

    void Render() {
         
        for(Camera cam : Cameras) {
            cam.ApplySettings();
        }


        graphics.beginDraw();
        skybox.Render(MainCamera.transform.position, skybox_scale, skybox_rotation);
        graphics.endDraw();
        graphics.beginDraw();
        scene.Render();
        graphics.endDraw();
        graphics.beginDraw();
        ui.Render();
        graphics.endDraw();

    /*  
        // do all rendering
        for(RenderLayer layer : Layers) {
            graphics.beginDraw();
            layer.Render();
            graphics.endDraw();
        }
    */


        // finally display graphics to screen
        image(graphics, 0, 0);

        RenderTime.Next();
    }

    void Update() {
        scene.Update();
        ui.Update();
        input.Update();

        //println(RenderTime.Frequency());
    }
}


abstract class GameState {

    QueryList<RenderLayer> Layers = new QueryList<RenderLayer>();

    void InitLayers(RenderLayer... layers) {
        Layers.Insert(layers);
    }
}






abstract class RenderLayer {	
    abstract void Render();
}


