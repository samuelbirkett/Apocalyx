----Several ways to call functions stored in Dynamic Link Libraries
----Questions? Contact: leo <tetractys@users.sf.net>

----INIT----
function init()
  showConsole(false)
  ----
  print("\n*** BEGIN ***\n")
  print("\n1) Loading a DLL function through LUA using loadlib()")
  local norm = package.loadlib("SampleLibrary.dll","luaNorm")
  local val = norm(2,3,4)
  print("The norm of (2,3,4) is ",val)
  ----
  print("\n2) Loading a DLL function through C with...")
  cc = Compiler()
  ok = cc:compileFile("LoadDLL.c");
  if ok then
    cc:addLibrary("SampleLibrary.dll")
    ok = cc:link()
  else
    print("\nCompile error")
  end
  if ok then
    c_function = cc:getFunction("main")
  else
    print("\nLink error")
  end
  if c_function then
    c_function()
  else
    print("\nCompiler:getFunction() error")
  end
  print("\n*** END ***\n\n")
  print("Press 'ENTER' to go back to demos menu")
  ----HELP----
  local help = {
    "[ENTER] Demos Menu",
  }
  setHelp(help)
  showHelpReduced()
end

----LOOP----
function update()
end

----FINAL----
function final()
  if cc then
    cc:delete()
    cc = nil
  end
  c_function = nil
  ok = nil
end

----KEYDOWN----
function keyDown(key)
  ----LOAD MAIN MENU----
  if key == string.byte("\r") then
    releaseKey(string.byte("\r"))
    final()
    dofile("main.lua")
    return
  end
end

----SCENE SETUP----
setScene(Scene(init,update,final,keyDown))
