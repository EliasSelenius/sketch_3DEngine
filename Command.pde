
//----Command-Executor-fabricators----



//----Command-Executors----

abstract class CommandExecutor {
  
  Command[] commands;
  
  CommandExecutor(Command[] c){
    commands = c;
  }
  
  abstract void Execute(String line);
    
  void LoadCommand(){
  
  }
  
  Object String2Object(String strobj){
    return null;
  }
}

abstract class Command {
  String name;
  Command(String n) { name = n; }
  abstract void Execute(String[] args);
}







//class SceneCommander extends CommandExecutor {
  
//  Scene scene;
  
//  SceneCommander(Scene s){
//    scene = s;
//    commands.set("initobj", "Instantiate");
//  }
  
//  @Override
//  void Execute(String line) {
//    String[] code = line.split(" ");
//    Object[] params = new Object[code.length - 1];
//    for(int i = 0; i < params.length; i++){
//      params[i] = String2Object(code[i + 1]);
//    }
//    InvokeMethod(scene, commands.get(code[0]),  params);
//  }
  
//}
