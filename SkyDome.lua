----SKYDOME
----Questions? Contact: leo <tetractys@users.sf.net>

----INITIALIZATION----
function init()
  ----CAMERA----
  setAmbient(.3,.3,.3)
  setPerspective(60,.5,3000)
  enableFog(750, .5,.5,.75)
  local camera = getCamera()
  camera:reset()
  camera:setPosition(0,2.5,8)
  camera:rotStanding(3.1415)
  empty()
  ----SKYBOX----
  local zip = Zip("DemoPack1.dat")
  sunAngle = 0
  sky = SkyDome(24,6,100)
  local sunY, sunZ = 0,math.sin(sunAngle),math.cos(sunAngle)
  sky:setSun( 1,1,1, 1, 0,sunY,sunZ )
  sky:setAtmosphere( 0.25,0.25,1, 0.8,0.5, -15,20)
  sky:setHaze( 1,1,1, 0.5,0.5, -15,5 )
  sky:setRedShift( -10,15 )
  sky:update()
  setBackground(sky)
  ----CLOUDLAYER----
  local cloudsImage = zip:getImage("cloudlayer.jpg")
  local alphaImage = zip:getImage("cloudlayer.png")
  cloudsImage:addAlpha(alphaImage)
  local cloudsTexture = Texture(cloudsImage,1)
  cloudsImage:delete()
  alphaImage:delete()
  local material = Material()
  material:setEmissive(0.9,0.9,0.6)
  material:setEnlighted(false)
  material:setDiffuseTexture(cloudsTexture)
  cloudLayer = CloudLayer(material,4000,100,10)
  cloudLayer:setSpeed(10,10)
  setCloudLayer(cloudLayer)
  ----SUN----
  sun = Sun(
    zip:getTexture("light.jpg"),0.25,
    0,sunY,sunZ,
    zip:getTexture("lensflares.png"),
    4, 0.1
  )
  setSun(sun)
  ----TERRAIN----
  local terrainMaterial = Material()
  terrainMaterial:setAmbient(.7,.7,.7)
  terrainMaterial:setDiffuse(1,1,1)
  terrainMaterial:setDiffuseTexture(zip:getTexture("marble.jpg",1))
  local terrain = FlatTerrain(terrainMaterial,3000,300)
  setTerrain(terrain)
  terrainMaterial:delete()
  ----HELP----
  local help = {
    "[MOUSE] Look Around",
    "[CLICK] Raise/Lower Sun",
    "[ UP  ] Move Forward",
    "[DOWN ] Move Backward",
    "[LEFT ] Rotate Left",
    "[RIGHT] Rotate Right",
    "[PREV ] Move UP",
    "[NEXT ] Move Down",
    "[SPACE] On/Off Rotation",
    " ",
    "[ENTER] Demos Menu",
    "[F1] Show/Hide Help",
  }
  setHelp(help)
  hideConsole()
  ----DELETE ZIP----
  zip:delete()
  end

----LOOP----
function update()
  local camera = getCamera()
  local timeStep = getTimeStep()
  
  if isMouseLeftPressed() then
    sunAngle = sunAngle+6.28*timeStep/90
  elseif isMouseRightPressed() then
    sunAngle = sunAngle-6.28*timeStep/90
  end
  
  local sunY = math.sin(sunAngle)
  local sunZ = math.cos(sunAngle)
  sky:setSun( 1,1,1, 1, 0,sunY,sunZ )
  sky:update()
  sun:setDirection(0,sunY,sunZ)
  enableFog(750, sky:getFogColor())
  sun:setColor(sky:getSunColor())
  cloudLayer:setColor(sky:getCloudColor())
  
  ----ROTATE VIEW----
  if rotateView then
    local rotAngle = .13*timeStep
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
  local speed = 3
  if isKeyPressed(38) then --> VK_UP
    camera:moveStanding(speed*timeStep)
    end
  if isKeyPressed(40) then --> VK_DOWN
    camera:moveStanding(-speed*timeStep)
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
  ----LOAD MAIN MENU----
  if isKeyPressed(string.byte("\r")) then
    releaseKey(string.byte("\r"))
    dofile("main.lua")
    return
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
  ----GLOBALS----
  sunAngle = nil
  cloudLayer = nil
  sky = nil
  sun = nil
  rotateView = nil
  ----EMPTY WORLD----
  disableFog()
  empty()
  end

----SCENE SETUP----
setScene(Scene(init,update,final))

