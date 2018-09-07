

class Canvas {
  
  ArrayList<UIElement> Elements = new ArrayList<UIElement>();
  
  void Update(){
    pushMatrix();
    
    //Vector4 a = defScene.camera.transform.rotation.GetAxisAngle();
    //Vector3 p = defScene.camera.transform.position;
    //p = p.plus(defScene.camera.transform.Forward().multiply(99));
    //translate(p.x, p.y, p.z);
    //rotate(a.w, a.x, a.y, a.z);
    
    text(frameRate, width / 2,height / 2);
    image(assets.getTexture("front"), 0, 0, width, height);
    for(int i = 0; i < Elements.size(); i++){
      Elements.get(i).Update();
    }  
    popMatrix();
  }
}

abstract class UIElement{
  
  abstract void Update();
}