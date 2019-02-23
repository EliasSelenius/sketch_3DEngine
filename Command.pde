
class CommandExecutor {
  
  // Scripts: scripts loaded from a file
  Script[] Scripts;
  
  // Global: reference to an object in the application
  Object Global;
  
  HashMap<String, Object> vars = new HashMap<String, Object>();
  
  String[] ExecuteScript(String script) {
    for(Script s : Scripts){
      if(s.name.equals(script)){
        return s.Execute();
      }
    }
    return new String[] {script + " was not found in memory."};
  }
  
  String[] ExecuteLine(String line) {
    String[] args = line.split(" ");
    switch(args[0]){
      case "find":
        String[] path = args[1].split("\\.");
        Global = Reflect.GetObjectSuper(App, path[0]);
        for(int i = 1; i < path.length; i++){
          Global = Reflect.GetObjectSuper(Global, path[i]);
        }
        break;
      case "set":
        vars.put(args[1], Global);
        break;
      case "get":
        Global = vars.get(args[1]);
        break;
      case "print":
        println("print: " + ((Global == null)? "null" : Global.toString()));
        break;
      case "invoke":
        Global = InvokeCommand(Global, args[1], (ArrayList)ExcludeIndices(args, 0, 1));
        break;
      case "exec":
        ExecuteScript(args[1]);
        break;
      case "use":
        Global = InitObject(args[1], ExcludeIndices(args, 0, 1).toArray(new String[args.length - 2]));
    }
    return new String[] { line + " Not recognized, There is probably a syntax error..." };
  }
  
  Object InitObject(String obj, String... args) {
    // check for primitive value-type (String, float, bool)
    Float f = float(obj);
    if(!f.isNaN()) {
      return f;
    } else if(obj.equals("true")) {
      return true;
    } else if(obj.equals("false")) {
      return false;
    } else if(obj.equals("null")) {
      return null;
    }else if(obj.charAt(0) == '\"') {
      return obj.substring(1, obj.length() - 1);
    } else if(obj.equals("get")) {
      return vars.get(args[0]);
    }
    // if its not a primitive:
    if(args.length > 0) {
      Object[] arry = new Object[args.length];
      for(int i = 0; i < args.length; i++) {
        arry[i] = InitObject(args[i]);
      }
      return Reflect.InstantiateObject(Reflect.GetClass(obj), arry);
    } else {
      return Reflect.InstantiateObject(Reflect.GetClass(obj));
    }
  }
  
  Object InvokeCommand(Object o, String name, ArrayList<String> args) {
    if(args.size() > 0) {
      Object[] a = new Object[args.size()];
      boolean skipnext = false;
      for(int i = 0; i < a.length; i++) {
        a[i] = InitObject(args.get(i), args.get(i + 1));
      }
      return Reflect.InvokeMethod(o, name, a);
    } else {
      return Reflect.InvokeMethod(o, name);
    }
  }
    
  void LoadScript(){
    File dir = new File(sketchPath() + "\\data\\Scripts");
    File[] files = dir.listFiles();
    Scripts = new Script[files.length];
    for(int i = 0; i < Scripts.length; i++){
      //println(files[i].getName());
      Scripts[i] = new Script(files[i].getName(), loadStrings(files[i]));
    }
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
        ExecuteLine(text[i]);
      }
      return log;
    }
  }
}



Object StringToObject(String string) {
	ArrayList<String> parsed = SepperateString(string);
	String type = parsed.get(0);


	// float
	Float f = float(type);
	if(!f.isNaN()) {
		return f;
	}


	// null
	else if(type.equals("null")) {
		return null;
	}


	// bool
	else if(type.equals("true")) {
		return true;
	} else if (type.equals("false")) {
		return false;
	}


	// String
	if(type.charAt(0) == '\"') {
		return type.substring(1, type.length());
	}


	// class type
	Class c = Reflect.GetClass(type);
	if(c != null) { // its a class
		ArrayList<Object> args = new ArrayList<Object>();
		for(int i = 1; i < parsed.size(); i++) {
			args.add(StringToObject(parsed.get(i)));
		}
		return Reflect.InstantiateObject(c, args.toArray(new Object[args.size()]));
	}



	println("THERE WAS AN ERROR IN: StringToObject");
	return null;	
}

void TestStringToObject() {
	
/*
	Class c = Vector3.class;
	Object[] args = new Object[4];
	args[0] = App;
	args[1] = 123f;
	args[2] = 564f;
	args[3] = 10f;

	Class[] argsType = new Class[4];
	for(int i = 0; i < args.length; i++) {
		argsType[i] = Reflect.GetType(args[i]);
	}

	try { 
		Constructor con = c.getDeclaredConstructor(argsType);

		println(con.newInstance(args));
	} catch (Exception e) {
		e.printStackTrace();
	}
	if(true) {
		return;
	}
	*/

	println(StringToObject("Vector3 10 2 40"));


	// ParticleSystem (PointEmission 0 4) (Mesh (get boxShape)) .5 6
	String str = "Tbase (Tsub (Tinner true) \"Hello\") (Tinner false)";
	
	println(SepperateString(str));

	/*
	println(StringToObject("21"));
	println(StringToObject("67f"));
	println(StringToObject("6341d"));

	println(StringToObject("null"));

	println(StringToObject("true"));
	println(StringToObject("false"));
*/

	//println(StringToObject("fdawd 10 50 34"));
	println(StringToObject("Vector3"));
	println(StringToObject("Vector3 10 50 34"));
	println(StringToObject("null"));
	println(StringToObject("true"));
	println(StringToObject("false"));
	println(StringToObject("ass"));
	println(StringToObject("Transform (Vector3 100 200 300) (Vector3 10) (Quaternion)"));	

	println(new Tbase(new Tsub(new Tinner(true), "Hello"), new Tinner(false)));

	println(StringToObject("Tbase (Tsub (Tinner true) \"Hello\") (Tinner false)"));
}


String InnerSubString(String string) {
	int start = 0;
	for(int i = 0; i < string.length(); i++) {
		char c = string.charAt(i);
		if(c == '(') {
			start = i;
		} else if(c == ')') {
			return string.substring(start + 1, i);
		}
	}
	return string;
}


/*
  10
  Vector3 100 30 731
  Transform (Vector3 10) (Vector3 1) (Quaternion)
  ParticleSystem (PointEmission 0 4) (Mesh (get boxShape)) .5 6

	list<String> subs
	int start = 0
	int end = 0
	for c, i in string
		if c is ' '
			end = i
			subs.add string.substring(start, end)
			start = end
		else if c is '('
			String sub string.substring(i, string.length())
			int count = 1
			int whileIndex = 0
			while count != 0
				whileIndex++
				char ch = sub.charAt(whileIndex)
				if ch is '('
					count++
				else ch is ')'
					count--
			subs.add sub.substring(0, whileIndex)
			i += whileIndex


		== new Doc

		for c, i in string
			list String subs
			if c is '('
				int newindex = (index of end parnthesis)
				subs.add string.substring i newindex
				i = newindex
			else if c is '"'
				int newindex = (index of next '"')
				subs.add string.substring i newindex
				i = newindex
			else if c is not whitespace or i is 0
				int newindex = (next index that is whitespace)
				subs.add string.substring i newindex
				i = newindex

*/

// ParticleSystem (PointEmission 0 4) (Mesh (get boxShape)) .5 6.0f

ArrayList<String> SepperateString(String string) {
	ArrayList<String> res = new ArrayList<String>();
	for(int i = 0; i < string.length(); i++) {
		char c = string.charAt(i);
		if (c == '(') {
			int newindex = indexOfEndParentes(string, i);
			res.add(string.substring(i + 1, newindex));
			i = newindex + 1;
		} else if (c == '"') {
			int newindex = indexOfNextChar(string, i, '\"');
			res.add(string.substring(i, newindex));
			i = newindex;
		} else if (c != ' ' || c != '\n') {
			int newindex = nextIndexThatIsWhitespace(string, i);
			res.add(string.substring(i, newindex));
			i = newindex;
		}
	}
	return res;
}

int indexOfNextChar(String string, int startPoint, char c) {
	for(int i = startPoint + 1; i < string.length(); i++) {
		if(string.charAt(i) == c) {
			return i;
		}
	}
	return string.length();
}

int indexOfEndParentes(String string, int startPoint) {
	int startIndex = startPoint;
	int index = startIndex;
	int count = 1;

	while(count != 0) {
		index++;
		char c = string.charAt(index);

		if(c == '(') {
			count++;
		} else if(c == ')') {
			count--;
		}
	}

	return index;
}

int nextIndexThatIsWhitespace(String string, int startPoint) {
	for(int i = startPoint + 1; i < string.length(); i++) {
		char c = string.charAt(i);
		if(c == ' ' || c == '\n') {
			return i;
		}
	}
	return string.length();
}


String[] GetSubstrings(String string) {
	ArrayList<String> res = new ArrayList<String>();

	int start = 0;
	int end = 0;

	// Transform (Vector3 10) (Vector3 1) (Quaternion)

	for(int i = 0; i < string.length(); i++) {
		char c = string.charAt(i);
		if (c == ' ') {
			end = i;
			res.add(string.substring(start, end));
			start = end;
		} else if(i == string.length() - 1) {
			res.add(string.substring(start, string.length()));
		} else if(c == '(') {
			String sub = string.substring(i, string.length());
			int count = 1;
			int whileIndex = 0;
			while (count != 0) {
				whileIndex++;
				char ch = sub.charAt(whileIndex);
				if (ch == '(') {
					count++;
				} else if(ch == ')'){
					count--;
				}
			}
			i += whileIndex;
		}
	}

	return res.toArray(new String[0]);
}



String FirstSubstring(String string) {
	int startIndex = string.indexOf('(');
	int index = startIndex;
	int count = 1;

	while(count != 0) {
		index++;
		char c = string.charAt(index);

		if(c == '(') {
			count++;
		} else if(c == ')') {
			count--;
		}
	}

	return string.substring(startIndex + 1, index);
}










class Tbase {
	Tbase(Tsub sub, Tinner in) {
		println("Tbase was initialized");
	}
}

class Tsub {
	Tsub(Tinner inner, String n) {
		println("Tsub was initialized with string: " + n);
	}
}

class Tinner {
	Tinner(boolean t) {
		println("Tinner was initialized with value " + t);
	}
}