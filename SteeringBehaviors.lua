--[[
       S T E E R I N G   B E H A V I O R S

       Questions? Contact leo at tetractys@users.sourceforge.net

--]]

----MODULES----

DEMO = {}
ALL = {}

----MODELS SUPPORT----

function ALL.createModel(zip,modelMD2,modelTXT,posX,posY,posZ,scale,anim)
  local model = zip:getMD2Model(modelMD2,modelTXT)
  material = model:getMaterial()
  material:setAmbient(1,1,1)
  material:setDiffuse(1,1,1)
  material:setSpecular(1,1,1)
  material:setShininess(64)
  model:rescale(0.04*scale)
  model:pitch(-1.5708)
  model:move(posX,posY,posZ)
  model:setAnimation(anim)
  addObject(model)
  local shadow = Shadow(model)
  shadow:setMaxRadius(model:getMaxRadius()*3)
  addShadow(shadow)
  return model
end

function ALL.cloneModel(model,zip,modelTXT,posX,posY,posZ)
  local model2 = MD2Model(model)
  if modelTXT then
    local material = Material()
    material:setDiffuseTexture(zip:getTexture(modelTXT))
    material:setAmbient(1,1,1)
    material:setDiffuse(1,1,1)
    material:setSpecular(1,1,1)
    material:setShininess(64)
    model2:setMaterial(material)
  end
  model2:move(posX,posY,posZ)
  model2:pitch(-1.5708)
  addObject(model2)
  local shadow = Shadow(model2)
  shadow:setMaxRadius(model2:getMaxRadius()*3)
  addShadow(shadow)
  return model2
end

function ALL.createBuilding(zip,fileName, x,z)
  local building = zip:getMesh(fileName)
  building:setPosition(x,0,z)
  addObject(building)
  local shadow = Shadow(building)
  shadow:setMaxRadius(building:getMaxRadius()*3)
  addShadow(shadow)
end

----INITIALIZATION----
function DEMO.init()
  ----ZIP----
  empty()
  emptyOverlay()
  setClear(0.75,0.75,0.5)
  enableFog(275, 0.75,0.75,0.5)
  if not fileExists("DemoPack1.dat") then
    showConsole()
    error("\nERROR: File 'DemoPack1.dat' not found")
  end
  local zip = Zip("DemoPack1.dat")
  ----CAMERA----
  setAmbient(0.5,0.5,0.5)
  setPerspective(60,1,250)
  local camera = getCamera()
  camera:reset()
  camera:move(50,35,50)
  camera:pointTo(80,2,30)
  ----SUN----
  local sun = Sun(zip:getTexture("light.jpg"),0.15, -0.5,0.707,-0.5, nil, 0, 0, 200)
  sun:setColor(1,1,1)
  setSun(sun)
  ----TERRAIN----
  local mapImage = zip:getImage("tiles.png")
  local material = Material()
  material:setDiffuseTexture(zip:getTexture("circleTextures64.jpg"))
  tiled = TiledTerrain(material,8,mapImage,50,8,16) 
  tiled:setShadowOffset(0.05)
  tiled:setShadowIntensity(0.5)
  tiled:setShadowed()
  setTerrain(tiled)
  ----MODELS----
  ALL.createBuilding(zip,"tower.obj", 80,30)
  local name = "pknight"
  originalModel = ALL.createModel(zip,
    name..".md2",name..".jpg", 0,2,0, 2, 1)
  originalModel:hide()
  models = {}
  for ct = 1, 16 do
    models[ct] = ALL.cloneModel(
      originalModel, zip,nil, math.random(0,60),2,math.random(0,60))
  end
  ----VEHICLES----
  proximity = SteerProximityLocalityQuery(
    50,2,50, 70,10,70, 20,1,20
  )
  vehicles = {}
  for ct = 1, table.getn(models) do
    local vehicle = SteerVehicle()
    vehicles[ct] = vehicle
    vehicle:setSpeed(15)
    vehicle:setRadius(1)
    vehicle:setMaxForce(50)
    vehicle:setMaxSpeed(15)
    vehicle:setTransform(models[ct])
    vehicle:randomizeHeading()
    proximity:allocate(vehicle)
  end
  local points = {
    20,2,25, 40,2,25, 50,2,35, 70,2,30, 80,2,30, 60,2,70, 20,2,70
  }
  pathway = SteerPolylinePathway(points,0.5,true)
  obstacle = SteerSphericalObstacle()
  obstacle:setCenter(80,2,30)
  obstacle:setRadius(6)
  group = SteerVehicleGroup()
  ----HELP----
  local help = {
    "S T E E R I N G   B E H A V I O R S",
    "",
    "[ MOUSE ] Look Around",
    "[ ARROW ] Move/Rotate",
    "[ PG_UP ] Move Up",
    "[ PG_DW ] Move Down",
    "[ ENTER ] Back to Demos Menu",
    " ",
    "[F1] Show/Hide Help",
  }
  setHelp(help)
  hideHelp()
  hideConsole()
  ----DELETE ZIP----
  zip:delete()
end

----FINALIZATION----
function DEMO.final()
  setClear(0,0,0)
  tiled = nil
  originalModel = nil
  models = nil
  pathway:delete()
  pathway = nil
  obstacle:delete()
  obstacle = nil
  proximity:delete()
  proximity = nil
  group:delete()
  group = nil
  for ct = 1, table.getn(vehicles) do
    vehicles[ct]:delete()
    vehicles[ct] = nil
  end
  vehicles = nil
  ----EMPTY WORLD----
  disableFog()
  empty()
  emptyOverlay()
end

----LOOP----
function DEMO.update()
  local camera = getCamera()
  local timeStep = getTimeStep()
  if timeStep > 0.1 then timeStep = 0.1 end
  ----MOVE MODELS----
  for ct = 1, table.getn(models) do
    local vehicle = vehicles[ct]
    local ox,oy,oz = vehicle:avoidObstacle(2,obstacle)
    if math.abs(ox) > 0.001 or math.abs(oz) > 0.001 then
      ox, oz = ox*100, oz*100
    end
    local x,y,z = vehicle:getPosition()
    local vx,vy,vz = vehicle:getForward()
    group:clear()
    vehicle:findNeighbors(x+vx*6,y+vy*6,z+vz*6, 8, group)
    local nx, ny, nz = vehicle:avoidNeighbors(2,group)
    if math.abs(nx) > 0.001 or math.abs(nz) > 0.001 then
      nx, nz = nx*100, nz*100
    end
    local sign = (ct%2)*2-1
    local px, py, pz = vehicle:followPath(sign, 1, pathway)
    local fx,fz = ox+nx+px+vx*5, oz+nz+pz+vz*5
    vehicle:applyForce(fx,0,fz, timeStep)
    vehicle:updateProximity()
    vx,vy,vz = vehicle:getVelocity()
    vehicle:regenerateTransform(vx,vy,vz, timeStep)
    vehicle:getTransform(models[ct])
    models[ct]:pitch(-1.5708)
    models[ct]:rotStanding(-1.5708)
  end
  ----MOVE CAMERA (KEYBOARD)----
  local speed = 20
  if isKeyPressed(38) then --> VK_UP
    camera:moveStanding(speed*timeStep)
  end
  if isKeyPressed(40) then --> VK_DOWN
    camera:moveStanding(-speed*timeStep)
  end
  if isKeyPressed(37) then --> VK_LEFT
    camera:rotStanding( 1*timeStep)
  end
  if isKeyPressed(39) then --> VK_RIGHT
    camera:rotStanding(-1*timeStep)
  end
  local climbSpeed = 20
  if isKeyPressed(33) then --> VK_PRIOR
    camera:move(0, climbSpeed*timeStep, 0)
  end
  if isKeyPressed(34) then --> VK_NEXT
    camera:move(0, -climbSpeed*timeStep, 0)
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

----KEYDOWN----
function DEMO.keyDown(key)
  if key == 13 then ---> ENTER
    releaseKey(13)
    final()
    dofile("main.lua")
    return
  end
end

----SCENE SETUP----
setScene(Scene(DEMO.init,DEMO.update,DEMO.final,DEMO.keyDown))
