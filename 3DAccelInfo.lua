----3D Accelerator Info DEMO
----Questions? Contact: leo <tetractys@users.sf.net>

----INITIALIZATION----
function init()
  showConsole(false)
  print("\n*** 3D Accelerator Info ***")
  local version, renderer, vendor = getOpenGLStrings()
  print(version,vendor)
  print(renderer)
  print("Tex Units :",getTextureUnitsCount(),
    "\t- Vertex Attribs :",getVertexAttribsCount())
  print("Tex Coords:",getTextureCoordsCount(),
    "\t- Tex Image Units:",getTextureImageUnitsCount())
  print("* Vertex Programs | Fragment Programs")
  print("Instructions:",getVPInstructionsCount(),"|",getFPInstructionsCount())
  print("Temporaries :",getVPTemporariesCount(),"|",getFPTemporariesCount())
  print("Parameters  :",getVPParametersCount(),"|",getFPParametersCount())
  print("Attributes  :",getVPAttribsCount(),"|",getFPAttribsCount())
  print("Ad.Registers:",getVPAddressRegistersCount(),"|",getFPAddressRegistersCount())
  print("Local Param.:",getVPLocalParametersCount(),"|",getFPLocalParametersCount())
  print("Env. Param. :",getVPEnvParametersCount(),"|",getFPEnvParametersCount())
  print("FP ALU Instructions:",getFPAluInstructionsCount())
  print("FP Tex Instructions:",getFPTexInstructionsCount())
  print("FP Tex Indirections:",getFPTexIndirectionsCount())
  print("* Vertex Shaders | Fragment Shaders")
  print("Uniforms Cmp.:",getVSUniformComponentsCount(),"|",getFSUniformComponentsCount())
  print("VS & FS Varying Floats:",getVSVaryingFloatsCount())
  print("\nPress 'ENTER' to go back to demos menu")
end

----LOOP----
function update()
end

----FINALIZATION----
function final()
end

----KEYDOWN----
function keyDown(key)
  if isKeyPressed(string.byte("\r")) then
    releaseKey(string.byte("\r"))
    hideConsole()
    final()
    dofile("main.lua")
    return
  end
end

----SCENE SETUP----
setScene(Scene(init,update,final,keyDown))
