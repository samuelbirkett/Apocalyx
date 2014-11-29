----INITIALIZATION----
function init()
  ----CAMERA----
  setAmbient(.5,.5,.5)
  setPerspective(60,.5,3000)
  local camera = getCamera()
  camera:reset()
  camera:setPosition(0,0,-10)
  empty()
  hideConsole()
  ----FOOT----
  if not fileExists("DemoPack1.dat") then
    showConsole()
    error("\nERROR: File 'DemoPack1.dat' not found.")
  end
  local zip = Zip("DemoPack1.dat")
  local vertices = {
     1,-1,-1,  -1,-1,-1,  -1,-1, 1,   1,-1, 1,
     1, 1,-1,  -1, 1,-1,  -1, 1, 1,   1, 1, 1
  }
  local normals = {}
  local mappings = {
     0,0,  0,1,  1,1,  1,0,  
     0,1,  1,1,  1,0,  0,0
  }
  local triangles = {
     0,3,1,  3,2,1,  5,4,0,  5,0,1,  5,1,2,  6,5,2,
     7,6,2,  7,2,3,  7,3,4,  4,3,0,  7,4,5,  7,5,6
  }
  local shape = Shape(vertices,normals,mappings,triangles)
  local material = Material()
  material:setDiffuse(1,0.5,0.25)
  material:setDiffuseTexture(zip:getTexture("agate.jpg"))
  local mesh = Mesh(shape,material)
  addObject(mesh)
  --HELP TEXT--
  local help = {
    "Shape Maker",
    "",
    "Press 'ENTER' to go back to demos menu",
  }
  setHelp(help)
  showHelpUser()
  hideConsole()
end

----LOOP----
function update()
  getCamera():rotAround(.25*getTimeStep())
end

----FINALIZATION----
function final()
  empty()
end

----KEYDOWN----
function keyDown(key)
  ----LOAD MAIN MENU----
  if isKeyPressed(string.byte("\r")) then
    releaseKey(string.byte("\r"))
    final()
    dofile("main.lua")
    return
  end
end

----SCENE SETUP----
setScene(Scene(init,update,final,keyDown))

