


class BackgroundLayer extends ScreenLayer {
    
    Skybox skybox;

    BackgroundLayer() {
        skybox = new Skybox();
    } 
    
    @Override
    void Render() {
        skybox.Render(GameManager.MainCamera.transform.position, new Vector3(1000f), new Quaternion());
    }
}