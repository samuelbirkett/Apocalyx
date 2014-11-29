----INITIALIZATION----
function init()
  showConsole(false)
  print("\ntoLua++ Demo\n")
  print("The script compiles the source 'ToLuaDemo.c'")
  print("containing two conversion functions and then")
  print("compiles the source 'ToLuaDemoBind.c' that")
  print("binds Lua functions to the C functions.")
  print("'ToLuaDemoBind.c' was generated from the")
  print("'ToLuaBind.pkg' file thanks to the toLua++")
  print("utility (available in the 'utilityx' folder).")
  print("WARNING! A little editing of the generated")
  print("file IS necessary: Every function defined")
  print("\tint func_name(lua_State* LS) {...}")
  print("must become")
  print("\tint func_name() {")
  print("\t\tlua_State* LS = lua_getstate(); ...}\n")
  cc = Compiler(false)
  print("Compile 'ToLuaDemo.c'")
  local ok = cc:compileFile("ToLuaDemo.c")
  if not ok then print("ERROR"); return end
  print("Compile 'ToLuaDemoBind.c'")
  cc:compileFile("ToLuaDemoBind.c")
  if not ok then print("ERROR"); return end
  print("Linking...")
  ok = cc:link()
  if not ok then print("ERROR"); return end
  print("Execute the bind calling 'tolua_ToLuaDemoBind_open()'")
  cc:callPassingLuaState("tolua_ToLuaDemoBind_open")
  print("Convert cartesian to polar:")
  local r, alpha = cartesianToPolar(2,2)
  print("(x = 2, y = 2) = (r =",r,", alpha = ",alpha,")")
  print("Convert polar to cartesian:")
  local x, y = polarToCartesian(r,alpha)
  print("(r =",r,", alpha = ",alpha,") = ( x =",x,", y =",y,")")
  print("\nPress 'ENTER' to go back to demos menu")
end

----LOOP----
function update()
end

----FINALIZATION----
function final()
  cc:delete()
  cc = nil
end

----KEYDOWN----
function keyDown(key)
  if key == string.byte("\r") then
    releaseKey(string.byte("\r"))
    hideConsole()
    final()
    dofile("main.lua")
  end
end

----SCENE SETUP----
setScene(Scene(init,update,final,keyDown))

