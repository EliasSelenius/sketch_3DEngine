

class Canvas{
  
  ArrayList<UIElement> Elements = new ArrayList<UIElement>();
  
  void Update(){
    pushMatrix();
    Vector3 a = defScene.camera.transform.rotation.GetEuler();
    
    translate(defScene.camera.transform.position.x, defScene.camera.transform.position.y, defScene.camera.transform.position.z - 100);
    rotateY(a.y);
    //rotate(a.w, a.x, a.y, a.z);
    text(frameRate, width / 2,height / 2);
    for(int i = 0; i < Elements.size(); i++){
      Elements.get(i).Update();
    }  
    popMatrix();
  }
}

abstract class UIElement{
  
  abstract void Update();
}