
//----Command-Executor-fabricators----



//----Command-Executors----

class CommandExecutor {
  
  // Scripts: scripts loaded from a file
  Script[] Scripts;
  
  // Global: reference to an object in the application
  Object Global;
  
  HashMap<String, Object> vars = new HashMap<String, Object>();
  
  
  CommandExecutor(){
    Scripts = new Script[1];
    Scripts[0] = new Script("hey", "find Math", "global");
  }
  
  
  String[] ExecuteScript(String script) {
    for(Script s : Scripts){
      if(s.name.equals(script)){
        return s.Execute();
      }
    }
    return new String[0];
  }
  
  String ExecuteLine(String line){
    String[] args = line.split(" ");
    switch(args[0]){
      case "find":
        Global = GetObject(This, args[1]);
        break;
      case "set":
        vars.put(args[1], Global);
        Global = null;
        break;
      case "global":
        return"The global: " + Global.toString();
      case "invoke":
        
        break;
      case "exec":
        ExecuteScript(args[1]);
        return "Executing " + args[1];
      default:
        return args[0] + " is not a command";
    }
    
    // if it dident alredy return we return an empty string
    return "";
  }
    
  void LoadScript(){
    // TODO:  implemment....
  }
  
  class Script {
    String name;
    String[] text;
    Script(String n, String... t){
      name = n; text = t;
    }
    String[] Execute(){
      String[] log = new String[text.length];
      for(int i = 0; i < text.length; i++){
        log[i] = ExecuteLine(text[i]);
      }
      return log;
    }
  }
}


////----Commands----


//abstract class Command {
//  String name;
//  Command(String n) { name = n; }
//  abstract void Execute(String[] args);
//}


//class InvokeCommand extends Command {
//  InvokeCommand(){
//    super("invoke");
//  }
//  @Override
//  void Execute(String[] args){
//    String[] p = new String[args.length - 1];
//    for(int i = 0; i < p.length; i++){
//      p[i] = args[i + 1];
//    }
//    InvokeMethod(defScene, args[0], p);
//  }
//}




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
