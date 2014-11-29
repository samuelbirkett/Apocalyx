----BOUNCING BALLS ON TRIMESH
----ODE Demo
----Questions? Contact: leo <tetractys@users.sf.net>

----INITIALIZATION----
function init()
  if kindOfTerrain == nil then
    kindOfTerrain = 1
  end
  ----CAMERA----
  setAmbient(.5,.5,.5)
  setPerspective(60,0.5,1500)
  enableFog(500, 0.4,0.4,1)
  local camera = getCamera()
  camera:reset()
  local Height
  Height = 20
  camera:setPosition(0,Height,50)
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
    4, 0.2
  )
  setSun(sun)
  ----MAIN TERRAIN----
  if kindOfTerrain ~= 4 then
    local terrainMaterial = Material()
    terrainMaterial:setAmbient(.7,.7,.7)
    terrainMaterial:setDiffuse(1,1,1)
    terrainMaterial:setDiffuseTexture(zip:getTexture("marble.jpg",1))
    local terrain = FlatTerrain(terrainMaterial,1500,75)
    terrain:setReflective()
    setTerrain(terrain)
    terrainMaterial:delete()
  end
  ----TERRAIN----
  if kindOfTerrain == 1 then
    terrain2 = zip:getMesh("terrain.3ds")
    terrain2:pitch(-1.57)
    addObject(terrain2)
  elseif kindOfTerrain == 2 then
    local heightImage = zip:getImage("terrain1.png")
    local terrainMaterial = Material()
    terrainMaterial:setDiffuseTexture(zip:getTexture("marble.jpg"))
    terrainMaterial:setGlossTexture(zip:getTexture("wood.jpg",1))
    terrain2 = HeightField(
      heightImage,terrainMaterial,100,100,15,0,16)
    terrain2:move(0,0,-10)
    terrainMaterial:delete()
    addObject(terrain2)
  elseif kindOfTerrain == 3 then
    local heightImage = zip:getImage("patches.png")
    local colorImage = zip:getImage("patches.jpg")
    local material = Material()
    material:setDiffuseTexture(zip:getTexture("wood.jpg",true))
    material:setGlossTexture(zip:getTexture("wood.jpg",true))
    terrain2 = Patches(heightImage,colorImage,material,1024,64,8,48,128)
    setTerrain(terrain2)
    heightImage:delete()
    colorImage:delete()
    material:delete()
  elseif kindOfTerrain == 4 then
    local bsp = zip:getLevel("small.bsp",2.5)
    terrain2 = bsp
    bsp:setDefaultTexture(zip:getTexture("wood.jpg",1))
    setScenery(bsp)
  end
  ----SPHERE----
  sphere = zip:getMesh("sphere.3ds")
  sphere:move(0,Height + 2,-5)
  addObject(sphere)
  sphere2 = zip:getMesh("sphere.3ds")
  sphere2:move(0,Height + 5,-5)
  addObject(sphere2)
  ----ODE----
  timeLeft = 0
  odeWorld = OdeWorld()
  odeWorld:setGravity(0,-9.81,0)
  odeMass = OdeMass()
  odeBody = odeWorld:createBody()
  odeBody:setPosition(0,Height + 2,-5)
  odeBody:setLinearVel(0,10,-1)
  odeMass:setSphere(10,1)
  odeBody:setMass(odeMass)
  odeBody2 = odeWorld:createBody()
  odeBody2:setPosition(0.1,Height + 5,-5)
  odeBody2:setLinearVel(0,10,-1)
  odeBody2:setMass(odeMass)
  odeSimpleSpace = OdeSimpleSpace()
  odeGeomSphere = OdeSphere(1,odeSimpleSpace)
  odeGeomSphere:setBody(odeBody)
  odeGeomSphere2 = OdeSphere(1,odeSimpleSpace)
  odeGeomSphere2:setBody(odeBody2)
  odeTriMeshData = OdeTriMeshData()
  if kindOfTerrain == 1 then
    odeTriMeshData:build(terrain2:getShape())
    odeTriMesh = OdeTriMesh(odeTriMeshData,odeSimpleSpace) 
    odeTriMesh:setRotation(terrain2)
  elseif kindOfTerrain == 2 then
    odeTriMeshData:build(terrain2)
    odeTriMesh = OdeTriMesh(odeTriMeshData,odeSimpleSpace) 
    odeTriMesh:setPosition(0,0,-10)
  elseif kindOfTerrain == 3 then
    odeTriMeshData:build(terrain2)
    odeTriMesh = OdeTriMesh(odeTriMeshData,odeSimpleSpace) 
  elseif kindOfTerrain == 4 then
    odeTriMeshData:build(terrain2)
    odeTriMesh = OdeTriMesh(odeTriMeshData,odeSimpleSpace) 
  end
  odeGeomPlane = OdePlane(0,1,0, 0, odeSimpleSpace)
  odeJointGroup = OdeJointGroup()
  odeContactsInfo = OdeContactsInfo(10)
  odeContactsInfo:setBounce(0.9)
  odeContactsInfo:setMu() -- infinity
  ----HELP----
  local help = {
    "[  1  ] Shape trimesh",
    "[  2  ] Heightfield trimesh",
    "[  3  ] Patches trimesh",
    "[  4  ] Bsp trimesh",
    " ",
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
  if timeStep > 0.1 then
    timeStep = 0.1
  end
  ----ODE----
  timeStep = timeStep+timeLeft
  local steps = math.floor(timeStep*1000)
  timeLeft = timeStep-steps*0.001
  for step = 1, steps do
    odeSimpleSpace:innerCollide(odeContactsInfo,odeWorld,odeJointGroup)
    odeWorld:quickStep(0.001)
    odeJointGroup:empty()
  end
  odeBody:getTransform(sphere)
  odeBody2:getTransform(sphere2)
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
  bsp = nil
  terrain2 = nil
  sphere = nil
  sphere2 = nil
  rotateView = nil
  ----ODE----
  timeLeft = nil
  odeMass:delete()
  odeBody:delete()
  odeBody2:delete()
  odeWorld:delete()
  odeTriMeshData:delete()
  odeSimpleSpace:delete()
  odeGeomSphere = nil
  odeGeomSphere2 = nil
  odeGeomPlane = nil
  odeContactsInfo:delete()
  odeJointGroup:delete()
  OdeClose()
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
  elseif isKeyPressed(string.byte("1")) then
    releaseKey(string.byte("1"))
    kindOfTerrain = 1
    setScene(Scene(init,update,final,keyDown))
  elseif isKeyPressed(string.byte("2")) then
    releaseKey(string.byte("2"))
    kindOfTerrain = 2
    setScene(Scene(init,update,final,keyDown))
  elseif isKeyPressed(string.byte("3")) then
    releaseKey(string.byte("3"))
    kindOfTerrain = 3
    setScene(Scene(init,update,final,keyDown))
  elseif isKeyPressed(string.byte("4")) then
    releaseKey(string.byte("4"))
    kindOfTerrain = 4
    setScene(Scene(init,update,final,keyDown))
  end
end

----SCENE SETUP----
setScene(Scene(init,update,final,keyDown))
