----3D TEXTURE ON TERRAIN
----ODE Demo
----Questions? Contact: leo <tetractys@users.sf.net>

----INITIALIZATION----
function init()
  ----CAMERA----
  setAmbient(.5,.5,.5)
  setPerspective(60,0.5,500)
  enableFog(200, 0.8,0.8,1)
  local camera = getCamera()
  camera:reset()
  camera:setPosition(0,25,0)
  camera:rotStanding(3.1415)
  empty()
  ----SKYBOX----
  if not fileExists("DemoPack1.dat") then
    showConsole()
    error("\nERROR: File 'DemoPack1.dat' not found.")
  end
  local zip = Zip("DemoPack1.dat")
  local skyTxt = {
    zip:getTexture("skyboxTop.jpg"),
    zip:getTexture("skyboxLeft.jpg"),
    zip:getTexture("skyboxFront.jpg"),
    zip:getTexture("skyboxRight.jpg"),
    zip:getTexture("skyboxBack.jpg")
  }
  local sky = MirroredSky(skyTxt)
  setBackground(sky);
  ----SUN----
  local sun = Sun(
    zip:getTexture("light.jpg"),0.25,
    0.0, 0.41, 0.91,
    zip:getTexture("lensflares.png"),
    4, 0.2, 250
  )
  setSun(sun)
  ----TERRAIN----
  local heightImage = zip:getImage("patches.png")
  local colorImage = zip:getImage("patches.jpg")
  local image1 = zip:getImage("wood.jpg")
  local image2 = zip:getImage("marble.jpg")
  local images = {image1,image2}
  local coarseTex3D = Texture3D(images,true,true)
--  images = {image2,image1}
--  local detailTex3D = Texture3D(images,true,true)
  images = nil
  image1:delete()
  image2:delete()
  local material = Material()
  material:setDiffuseTexture(coarseTex3D)
--  material:setGlossTexture(detailTex3D)
  local terrain = Patches(heightImage,colorImage,material,1024,64,16,32,256,false,4)
  setTerrain(terrain)
  heightImage:delete()
  colorImage:delete()
  material:delete()
  ----HELP----
  local help = {
    "[MOUSE] Look Around",
    "[ UP  ] Move Forward",
    "[DOWN ] Move Backward",
    "[PREV ] Move UP",
    "[NEXT ] Move Down",
    "[SPACE] On/Off Rotation",
    " ",
    "[ENTER] Demos Menu",
    "[F1] Show/Hide Help",
  }
  setHelp(help)
  showHelpReduced()
  hideConsole()
  ----DELETE ZIP----
  zip:delete()
end

----LOOP----
function update()
  local camera = getCamera()
  local timeStep = getTimeStep()
  if timeStep > 0.05 then
    timeStep = 0.05
  end
  ----ROTATE VIEW----
  if rotateView then
    local rotAngle = 0.13*timeStep
    camera:rotAround(rotAngle)
  end
  if isKeyPressed(string.byte(" ")) then
    releaseKey(string.byte(" "))
    if rotateView then
      rotateView = nil
    else
      rotateView = 1
    end
  end
  ----MOVE CAMERA (KEYBOARD)----
  local speed = 20
  if isKeyPressed(38) then --> VK_UP
    camera:moveStanding(speed*timeStep)
  end
  if isKeyPressed(40) then --> VK_DOWN
    camera:moveStanding(-speed*timeStep)
  end
  local climbSpeed = 20
  if isKeyPressed(33) then --> VK_PRIOR
    camera:move(0,climbSpeed*timeStep,0)
  end
  if isKeyPressed(34) then --> VK_NEXT
    camera:move(0,-climbSpeed*timeStep,0)
  end
  ----MOVE CAMERA (MOUSE)----
  local dx, dy = getMouseMove()
  local changeStep = 0.15*timeStep;
  if dx ~= 0 then
    camera:rotStanding(-dx*changeStep)
  end
  if dy ~= 0 then
    camera:pitch(-dy*changeStep)
  end
  local posX, posY, posZ = camera:getPosition()
  if posY < 1 then
    camera:setPosition(posX,1,posZ)
  end
end

----FINALIZATION----
function final()
  rotateView = nil
  ----EMPTY WORLD----
  disableFog()
  empty()
end

----KEYDOWN----
function keyDown(key)
  if isKeyPressed(string.byte("\r")) then
    releaseKey(string.byte("\r"))
    hideConsole()
    kindOfTerrain = nil
    dofile("main.lua")
    return
  end
end

----SCENE SETUP----
setScene(Scene(init,update,final,keyDown))
