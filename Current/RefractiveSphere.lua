----REFRACTIVE SPHERE
----Questions? Contact: leo <tetractys@users.sf.net>

----INITIALIZATION----
function init()
  if not isFragmentProgramSupported() then
    showConsole()
    error("\nFragment Programs not supported by your OpenGL drivers")
  end
  setTitle("Refractive Sphere Demo")
  ----GLOBALS----
  reflectionAmount = 0.2
  refractionIndex = 1.33
  ----CAMERA----
  setAmbient(.5,.5,.5)
  setPerspective(60,.25,1000)
  enableFog(200, 0.6,0.7,1)
  local camera = getCamera()
  camera:reset()
  camera:setPosition(0,1.8,-5)
  empty()
  ----SKYBOX----
  if not fileExists("DemoPack1.dat") then
    showConsole()
    error("\nERROR: File 'DemoPack1.dat' not found")
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
  sky:rotStanding(3.14159)
  setBackground(sky)
  ----SUN----
  local sun = Sun(
    zip:getTexture("light.jpg"),0.25,
    0,0.41,-0.91,
    zip:getTexture("lensflares.png"),
    5, 0.1
  )
  setSun(sun)
  ----GROUND----
  local groundMaterial = Material()
  groundMaterial:setEnlighted(false)
  groundMaterial:setEmissive(1,1,1)
  groundMaterial:setDiffuseTexture(zip:getTexture("marble.jpg",true))
  local ground = FlatTerrain(groundMaterial,500,250)
  setTerrain(ground)
  ----SPRITE/SPHERE----
  local file = io.open("RefractiveSphere.fp","r")
  local source = file:read("*a")
  file:close()
  fragmentProgram = FragmentProgram(source)
  local cubeMapFileNames = {
    "cubemapTop.jpg", "cubemapLeft.jpg", "cubemapFront.jpg",
    "cubemapRight.jpg", "cubemapBack.jpg", "cubemapTop.jpg"
  }
  local sphereMaterial = ProgramMaterial()
  sphereMaterial:setFragmentProgram(fragmentProgram)
  sphereMaterial:setDiffuseTexture(zip:getCubeMapTexture(cubeMapFileNames,false))
  sphereMaterial:setGlossTexture(zip:getTexture("marble.jpg",false,false))
  sphere = Sprite(0.5,0.5,sphereMaterial)
  sphere:setTransparent()
  sphere:move(0,1.8,0)
  addObject(sphere)
  ----HELP----
  local help = {
    "Title : Refractive Sphere Demo",
    "Engine: http://apocalyx.sf.net",
    "Author: Leonardo Boselli",
    "E-mail: tetractys@users.sf.net",
    " ",
    "[  SPACE  ] Rotate Around Sphere",
    "[  MOUSE  ] Look Around",
    "[ UP/DOWN ] Move Camera Forward/Back",
    "[LEFT/RGHT] Move Camera Left/Right",
    "[PREV/NEXT] Raise/Lower Camera",
    "[ W,A,S,Z ] Move Sphere Around",
    "[HOME/END ] Raise/Lower Sphere",
    "[1,2,3,4,5] Reflection Amount (0%-100%)",
    "[ 6,7,8,9 ] Index of Refraction (n)",
    "n = 1 (air), 1.33 (water), 1.52 (crown), 1.66 (flint)",
    " ",
    "[ENTER] Demos Menu",
    "[F1] Show/Hide Help"
  }
  setHelp(help)
  hideConsole()
  showHelpReduced()
  ----DELETE ZIP----
  zip:delete()
end

----LOOP----
function update()
  local camera = getCamera()
  local timeStep = getTimeStep()
  ----ROTATE VIEW----
  if rotateView then
    local rotAngle = .13*timeStep
    camera:rotAround(rotAngle)
    camera:pointTo(sphere:getPosition())
  end
  ----MOVE CAMERA (KEYBOARD)----
  local moveSpeed = 3
  if isKeyPressed(38) then --> VK_UP
    camera:moveStanding(moveSpeed*timeStep)
  end
  if isKeyPressed(40) then --> VK_DOWN
    camera:moveStanding(-moveSpeed*timeStep)
  end
  if isKeyPressed(37) then --> VK_LEFT
    camera:rotStanding(0.4*timeStep)
  end
  if isKeyPressed(39) then --> VK_RIGHT
    camera:rotStanding(-0.4*timeStep)
  end
  local climbSpeed = 3
  if isKeyPressed(33) then --> VK_PRIOR
    camera:move(0,climbSpeed*timeStep,0)
  end
  if isKeyPressed(34) then --> VK_NEXT
    camera:move(0,-climbSpeed*timeStep,0)
  end
  if isKeyPressed(string.byte("A")) then
    sphere:move(moveSpeed*timeStep,0,0)
  end
  if isKeyPressed(string.byte("S")) then
    sphere:move(-moveSpeed*timeStep,0,0)
  end
  if isKeyPressed(string.byte("W")) then
    sphere:move(0,0,moveSpeed*timeStep)
  end
  if isKeyPressed(string.byte("Z")) then
    sphere:move(0,0,-moveSpeed*timeStep)
  end
  if isKeyPressed(36) then ---> VK_HOME
    sphere:move(0,climbSpeed*timeStep,0)
  end
  local SIDE = 0.5
  local R = SIDE/1.4142/2
  if isKeyPressed(35) then ---> VK_END
    sphere:move(0,-climbSpeed*timeStep,0)
    local x, y, z = sphere:getPosition()
    if y < R then
      sphere:setPosition(x,R,z)
    end
  end
  ----MOVE CAMERA (MOUSE)----
  local dx, dy = getMouseMove()
  local changeStep = 0.15*timeStep
  if dx ~= 0 then
    camera:rotStanding(-dx*changeStep)
  end
  if dy ~= 0 then
    camera:pitch(-dy*changeStep)
  end
  local posX, posY, posZ = camera:getPosition()
  if posY < 2*R then
    camera:setPosition(posX,2*R,posZ)
  end
  ----FRAGMENT PROGRAM PARAMETRERS----
  -- constant parameters for geometry and optics
  -- SIDE and R already defined
  local A = 500/250
  -- local parameters for fragment program
  local oX, oY, oZ = camera:getPosition()
  local cX, cY, cZ = sphere:getPosition()
  local ocX, ocY, ocZ = oX-cX, oY-cY, oZ-cZ
  fragmentProgram:apply()
  fragmentProgram:setLocalParameter(0,
    1/R, 1/A, R*R-(ocX*ocX+ocY*ocY+ocZ*ocZ), reflectionAmount
  )
  local n = refractionIndex
  fragmentProgram:setLocalParameter(1, n, 1/n, n*n-1, 1/(n*n)-1)
  local sideDirX, sideDirY, sideDirZ = camera:getSideDirection()
  local uX, uY, uZ = -SIDE*sideDirX, -SIDE*sideDirY, -SIDE*sideDirZ
  fragmentProgram:setLocalParameter(2, uX,uY,uZ,1)
  local upDirX, upDirY, upDirZ = camera:getUpDirection()
  local vX, vY, vZ = SIDE*upDirX, SIDE*upDirY, SIDE*upDirZ
  fragmentProgram:setLocalParameter(3, vX,vY,vZ,1)
  fragmentProgram:setLocalParameter(4, oX,oY,oZ,1)
  local roX, roY, roZ =
    cX-0.5*uX-0.5*vX-oX,
    cY-0.5*uY-0.5*vY-oY,
    cZ-0.5*uZ-0.5*vZ-oZ
  fragmentProgram:setLocalParameter(5, roX,roY,roZ,1)
  fragmentProgram:setLocalParameter(6, cX,cY,cZ,1)
  fragmentProgram:setLocalParameter(7, ocX,ocY,ocZ,1)
  fragmentProgram:unapply()
end

----FINALIZATION----
function final()
  ----EMPTY WORLD----
  disableFog()
  empty()
  if fragmentProgram then
    fragmentProgram:delete()
    fragmentProgram = nil
  end
  ----GLOBALS----
  sphere = nil
  reflectionAmount = nil
  refractionIndex = nil
  rotateView = nil
end

----KEYBOARD----
function keyDown(key)
  local numberKey = key-string.byte("0")
  if numberKey >= 1 and numberKey <= 5 then
    reflectionAmount = (numberKey-1)*0.25
  elseif numberKey >= 6 and numberKey <= 9 then
    if numberKey == 6 then
      refractionIndex = 1
    elseif numberKey == 7 then
      refractionIndex = 1.33
    elseif numberKey == 8 then
      refractionIndex = 1.52
    elseif numberKey == 9 then
      refractionIndex = 1.66
    end
  elseif isKeyPressed(string.byte(" ")) then
    releaseKey(string.byte(" "))
    if rotateView then
      rotateView = nil
    else
      rotateView = 1
    end
  elseif isKeyPressed(string.byte("\r")) then
    releaseKey(string.byte("\r"))
    if fileExists("main.lua") then
      final()
      dofile("main.lua")
    end
    return
  end
end

----SCENE SETUP----
setScene(Scene(init,update,final,keyDown))
