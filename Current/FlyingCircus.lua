--[[
         F L Y I N G    C I R C U S

          A Simple Flight Simulator

                P R E V I E W

Questions? Contact leo <tetractys@users.sf.net>

--]]

----MODULES----

MENU = {}
ALL = {}
SIM = {}

----FLIGHT SIM. Flight Model from:
----http://www.web-discovery.net/aerodynamics1.asp
----UNITS: length in feet, time in seconds, mass in slugs
----(1 slug = 32.2 lbs)

function SIM.setPosition(self,x,y,z)
  self.X =  z*3.2808
  self.Y = -x*3.2808
  self.Z = -y*3.2808
end

function SIM.simulateAirplane(self,timeStep)
  -- to be optimized
  local deltaT = 0.001
  steps = math.ceil(timeStep/deltaT)
--  local t11,t12,t13,t21,t22,t23,t31,t32,t33
  for step = 1, steps do
  local P, Q, R = self.P, self.Q, self.R
  local P, Q, R = self.P, self.Q, self.R
  local U, V, W = self.U, self.V, self.W
  local invU
  if U == 0 then invU = 0 else invU = 1/U end
  local alpha = math.atan(W*invU) ---> angle of attack
  local beta = math.atan(V*invU) ---> angle of sideslip
  local elevator = self.elevator
  local aileron = self.aileron
  local rudder = self.rudder
  local liftCoefficient = self.CLo + self.CLa*alpha + self.CLde*elevator
  local dragCoefficient = self.CDo + self.CDa*math.abs(alpha) + self.CDde*math.abs(elevator)
  local sideCoefficient = self.CYb*beta+self.CYdr*rudder
  local rho = 0.0025 ---> air density (sl/ft^3)
  local speed2 = U*U+V*V+W*W
  local qbarS = rho*speed2*self.S*0.5 ---> dynamic pressure
  local lift = liftCoefficient*qbarS 
  local drag = dragCoefficient*qbarS
  local sideForce = sideCoefficient*qbarS
  local sinAlpha = math.sin(alpha)
  local cosAlpha = math.cos(alpha)
  local Fx = lift*sinAlpha-drag*cosAlpha+self.thrust
  local Fy = sideForce
  local Fz = -lift*cosAlpha-drag*sinAlpha
  local theta = self.theta
  local phi = self.phi
  local cosTheta = math.cos(theta)
  local sinTheta = math.sin(theta)
  local cosPhi = math.cos(phi)
  local sinPhi = math.sin(phi)
  local invMass = self.invMass
  local g = 32.2 ---> ft/s^2
  local Ua = V*R-W*Q-g*sinTheta+Fx*invMass
  local Va = W*P-U*R+g*sinPhi*cosTheta+Fy*invMass
  local Wa = U*Q-V*P+g*cosPhi*cosTheta+Fz*invMass
  U = U+Ua*deltaT
  V = V+Va*deltaT
  W = W+Wa*deltaT
  self.U, self.V, self.W = U, V, W
  local invSpeed
  if speed2 == 0 then invSpeed = 0 else invSpeed = 1/math.sqrt(speed2) end
  local c = self.c
  local b = self.b
  local L = (self.CLb*beta+self.CLp*P*b*invSpeed*0.5+self.CLr*R*b*invSpeed*0.5+self.CLda*aileron+self.CLdr*rudder)*qbarS*b ---> Roll
  local M = (self.CMo+self.CMa*alpha+self.CMq*Q*c*invSpeed*0.5+self.CMde*elevator)*qbarS*c ---> Pitch
  local N = (self.CNb*beta+self.CNp*P*b*invSpeed*0.5+self.CNr*R*b*invSpeed*0.5+self.CNda*aileron+self.CNdr*rudder)*qbarS*b ---> Yaw
  local Ixx = self.Ixx
  local Iyy = self.Iyy
  local Izz = self.Izz
  local Ixz = self.Ixz
  local Ixz2 = Ixz*Ixz
  local cc0 = 1/(Ixx*Izz-Ixz2)
  local cc1 = cc0*((Iyy-Izz)*Izz-Ixz2)
  local cc2 = cc0*Ixz*(Ixx-Iyy+Izz)
  local cc3 = cc0*Izz
  local cc4 = cc0*Ixz
  local cc7 = 1/Iyy
  local cc5 = cc7*(Izz-Ixx)
  local cc6 = cc7*Ixz
  local cc8 = cc0*((Ixx-Iyy)*Ixx+Ixz2)
  local cc9 = cc0*Ixz*(Iyy-Izz-Ixx)
  local cc10 = cc0*Ixx
  local Pa = (cc1*R+cc2*P)*Q+cc3*L+cc4*N  ---> angular acc. (rad/s^2)
  local Qa = cc5*R*P+cc6*(R*R-P*P)+cc7*M  ---> angular acc. (rad/s^2)
  local Ra = (cc8*P+cc9*R)*Q+cc4*L+cc10*N ---> angular acc. (rad/s^2)
  local Q0 = self.Q0
  local Q1 = self.Q1
  local Q2 = self.Q2
  local Q3 = self.Q3
  local invNorm = 1/math.sqrt(Q0*Q0+Q1*Q1+Q2*Q2+Q3*Q3)
  Q0 = Q0*invNorm
  Q1 = Q1*invNorm
  Q2 = Q2*invNorm
  Q3 = Q3*invNorm
  local Q0Q0 = Q0*Q0
  local Q1Q1 = Q1*Q1
  local Q2Q2 = Q2*Q2
  local Q3Q3 = Q3*Q3
  local Q0Q1 = Q0*Q1
  local Q0Q2 = Q0*Q2
  local Q0Q3 = Q0*Q3
  local Q1Q2 = Q1*Q2
  local Q1Q3 = Q1*Q3
  local Q2Q3 = Q2*Q3
  local Qdot0 = -0.5*(Q1*P+Q2*Q+Q3*R)
  local Qdot1 = 0.5*(Q0*P+Q2*R-Q3*Q)
  local Qdot2 = 0.5*(Q0*Q+Q3*P-Q1*R)
  local Qdot3 = 0.5*(Q0*R+Q1*Q-Q2*P)
  Q0 = Q0+Qdot0*deltaT
  Q1 = Q1+Qdot1*deltaT
  Q2 = Q2+Qdot2*deltaT
  Q3 = Q3+Qdot3*deltaT
  self.Q0, self.Q1, self.Q2, self.Q3 = Q0, Q1, Q2, Q3
  t11 = Q0Q0+Q1Q1-Q2Q2-Q3Q3
  t21 = 2*(Q1Q2+Q0Q3)
  t31 = 2*(Q1Q3-Q0Q2)
  t12 = 2*(Q1Q2-Q0Q3)
  t22 = Q0Q0-Q1Q1+Q2Q2-Q3Q3
  t32 = 2*(Q2Q3+Q0Q1)
  t13 = 2*(Q1Q3+Q0Q2)
  t23 = 2*(Q2Q3-Q0Q1)
  t33 = Q0Q0-Q1Q1-Q2Q2+Q3Q3
  P = P+Pa*deltaT
  Q = Q+Qa*deltaT
  R = R+Ra*deltaT
  self.P, self.Q, self.R = P, Q, R
  local temp = -t31
  if temp < -1 then
    temp = -1
  elseif   temp > 1 then
    temp = 1
  end
  self.theta = math.asin(temp)
  self.phi = math.atan2(t32,t33)
  local Uw = U*t11+V*t12+W*t13
  local Vw = U*t21+V*t22+W*t23
  local Ww = U*t31+V*t32+W*t33
  self.X = self.X+Uw*deltaT
  self.Y = self.Y+Vw*deltaT
  self.Z = self.Z+Ww*deltaT
  end
  if steps ~= 0 then
    local transform = self.transform
    transform:setSideDirection(t22,t32,-t12)
    transform:setUpDirection(t23,t33,-t13)
    transform:setViewDirection(-t21,-t31,t11)
    transform:setPosition(-self.Y*0.3048,-self.Z*0.3048,self.X*0.3048)
  end
end

function SIM.createAirplane()
  local airplane = { ---> Data from A4-sparrow
    simulateAirplane = SIM.simulateAirplane, ---> simulator hook
    setPosition = SIM.setPosition, ---> simulator hook
    transform = Reference(), ---> the transform
    invMass = 1/546, ---> inverse of mass (1/sl)
    theta = 0, phi = 0, ---> angular orientation (rad)
    X = 0, Y = 0, Z = 0, ---> position in feet
    U = 400, V = 0, W = 0, ---> linear velocity (ft/s)
    P = 0, Q = 0, R = 0, ---> angular velocity (rad/s)
    Q0 = 1, Q1 = 0, Q2 = 0, Q3 = 0, ---> quaternion
    thrust = 3000, maxThrust = 5000, ---> thrust (sl*ft/s^2)
    elevator = 0, maxElevator = 0.5236, ---> elevator angle (rad)
    aileron = 0, maxAileron = 0.5236, ---> ailerons angle (rad)
    rudder = 0, maxRudder = 0.2618, ---> rudder angle (rad)
    CLo = 0.28, ---> reference lift at zero angle of attack
    CLa = 3.45, ---> lift curve slope
    CLde = 0.36, ---> lift due to elevator
    CDo = 0.03, ---> reference drag at zero angle of attack
    CDa = 0.3, ---> drag curve slope
    CDde = 0.04, ---> drag due to elevator
    CYb = -0.98, ---> side force due to sideslip
    CYdr = 0.17, ---> side force due to rudder
    CLb = -0.12, ---> dihedral effect
    CLp = -0.26, ---> roll damping
    CLr = 0.14, ---> roll due to yaw rate
    CLda = 0.08, ---> roll due to aileron
    CLdr = -0.105, ---> roll due to rudder
    CMo = 0.0, ---> pitch moment coefficient
    CMq = -3.6, ---> pitch moment coefficient due to pitch rate
    CMa = -0.38, ---> pitch moment coefficient due to angle of attack
    CMda = -1.1, ---> pitch moment coefficient due to angle of attack rate
    CMde = -0.5, ---> pitch moment coefficient due to elevator
    CNb = 0.25, ---> weather cocking stability
    CNp = 0.022, ---> rudder adverse yaw
    CNr = -0.35, ---> yaw damping
    CNda = 0.06, ---> yaw due to aileron
    CNdr = 0.032, ---> yaw due to rudder
    Ixx = 8090, ---> roll inertia in slug/feet^2
    Iyy = 25900, ---> pitch inertia in slug/feet^2
    Izz = 29200, ---> yaw inertia in slug/feet^2
    Ixz = 1300, ---> overall inertia along the trasversal Y-Z in slug/feet^2
    S = 260.0, ---> wing surface area (ft^2)
    b = 27.5, ---> wing span in feet
    c = 10.8 ---> chord length in feet
  }
  return airplane
end

----
----HUD
----

----HUD SUPPORT----

function SIM.setupMap(zip,mapImage)
  local MAP_SIZE = 170
  SIM.HUD.isMapShown = true
  SIM.HUD.mapSprite =
    OverlaySprite(MAP_SIZE,MAP_SIZE,Texture(mapImage,true))
  local mapSprite = SIM.HUD.mapSprite
  mapSprite:setLayer(0)
  mapSprite:setColor(1,1,1,0.5)
  local W, H = getDimension()
  mapSprite:setLocation(W-MAP_SIZE,H-MAP_SIZE)
  addToOverlay(SIM.HUD.mapSprite)
  local markImage = zip:getImage("dot.png")
  local markSize = markImage:getDimension()
  markImage:addAlpha(markImage)
  local markSprite = OverlaySprite(markSize,markSize,Texture(markImage),true)
  markImage:delete()
  SIM.HUD.markSprite = markSprite
  markSprite:setLayer(-1)
  markSprite:setColor(1,1,1)
  addToOverlay(markSprite)
end

function SIM.setupStick(zip,stickName)
  local stickImage = zip:getImage(stickName)
  stickImage:addAlpha(stickImage)
  local MAP_SIZE = 170
  local STICK_SIZE = 128
  SIM.HUD.isStickShown = true
  SIM.HUD.stickSprite =
    OverlaySprite(STICK_SIZE,STICK_SIZE,Texture(stickImage),true)
  local stickSprite = SIM.HUD.stickSprite
  stickImage:delete()
  stickSprite:setLayer(0)
  stickSprite:setColor(1,0.9,0.5)
  local W, H = getDimension()
  stickSprite:setLocation(W-MAP_SIZE,STICK_SIZE)
  addToOverlay(SIM.HUD.stickSprite)
  local posImage = zip:getImage("dot.png")
  local posSize = posImage:getDimension()
  posImage:addAlpha(posImage)
  local posSprite = OverlaySprite(posSize,posSize,Texture(posImage),true)
  posImage:delete()
  SIM.HUD.posSprite = posSprite
  posSprite:setLayer(-1)
  posSprite:setColor(1,0,0)
  addToOverlay(posSprite)
end

function SIM.setupHud(theScore,len,offset,texture,u0,v0,u1,v1)
  local w, h = getDimension()
  local w2, h2 = w*0.5, h*0.5
  local sw, sh = 64, 32
  local sw2, sh2 = sw*0.5, sh*0.5
  local nw, nh = 16, 16
  local nw2, nh2 = nw*0.5, nh*0.5
  local sprite = OverlaySprite(sw,sh,texture,true)
  sprite:setTextureCoord(u0,v0,u1,v1)
  sprite:setLocation(w2+offset,h-sh2)
  sprite:setColor(0.75,0.75,0)
  addToOverlay(sprite)
  local offsetX, offsetY = w2+offset+nw2*(len+1), h-sh2-nh2-nh 
  for ct = 1, len do
    theScore[ct] = OverlaySprite(nw,nh,texture,true)
    local number = theScore[ct]
    number:setTextureCoord(0,0.75,0.25,1)
    number:setLocation(offsetX-nw*ct,offsetY)
    number:setColor(1,1,0)
    addToOverlay(number)
  end
end

function SIM.setHudValue(theScore,chars,value)
  local theString = string.format("%d",value)
  local len = math.min(string.len(theString),chars)
  for ct = 1, len do
    local byte = string.byte(theString,ct)-string.byte("0")
    local u, v = math.mod(byte,4)*0.25, math.floor(byte*0.25)*0.25
    theScore[len-ct+1]:setTextureCoord(u,0.75-v,u+0.25,1-v)
  end
  for ct = len+1, chars do
    theScore[ct]:setTextureCoord(0,0.75,0.25,1)
  end
end

function SIM.setupHuds(zip)
  local scoreImage = zip:getImage("numbers.png")
  local texture = Texture(scoreImage)
  scoreImage:delete()
  local setupScore = SIM.setupHud
  SIM.HUD.maxhHud = {}
  setupScore(SIM.HUD.maxhHud,4,-160,texture,0,0,0.5,0.25)
  SIM.HUD.heightHud = {}
  setupScore(SIM.HUD.heightHud,4,0,texture,0.5,0,1,0.25)
  SIM.HUD.speedHud = {}
  setupScore(SIM.HUD.speedHud,3,160,texture,0.5,0.25,1,0.5)
  SIM.setHudValue(SIM.HUD.maxhHud,4,0)
  SIM.setHudValue(SIM.HUD.heightHud,4,0)
  SIM.setHudValue(SIM.HUD.speedHud,3,0)
end

----
----SIM
----

----INITIALIZATION----
function SIM.init()
  ----CAMERA----
  setAmbient(0.3,0.3,0.3)
  local MAX_DIST = 3000
  setPerspective(60,1,MAX_DIST)
  local fogColor = {0.475,0.431,0.451}
  enableFog(MAX_DIST, fogColor[1],fogColor[2],fogColor[3])
  local camera = getCamera()
  camera:reset()
  empty()
  ----ZIP----
  local zip = Zip("FlyingCircus.dat")
  ----SKYBOX----
  local skytype = "orange_"
  local skyTxt = {
    zip:getTexture(skytype.."top.jpg",false,false),
    zip:getTexture(skytype.."left.jpg",false,false),
    zip:getTexture(skytype.."front.jpg",false,false),
    zip:getTexture(skytype.."right.jpg",false,false),
    zip:getTexture(skytype.."back.jpg",false,false)
  }
  local sky = HalfSky(skyTxt)
  sky:setGroundColor(fogColor[1],fogColor[2],fogColor[3])
  setBackground(sky)
  ----MOON----
  local moon = Moon(
    zip:getTexture("moon.jpg"),0.05,
    0,0.342,-0.9397,MAX_DIST-500
  )
  moon:setColor(0.9,0.9,0.7)
  setMoon(moon)
  ----SUN----
  local sun = Sun(
    zip:getTexture("light.jpg"),0.15,
    0,0.342,0.9397,
    zip:getTexture("lensflares.png"),
    6,0.1,MAX_DIST-500
  )
  sun:setColor(1,1,0.6)
  setSun(sun)
  ----SOUNDS----
  local engineSample = zip:getSample3D("motor.wav");
  engineSample:setLooping(true)
  engineSample:setVolume(255)
  engineSample:setMinDistance(100)
  ----SHADOW----
  local shadowImage = zip:getImage("shadow.png")
  shadowImage:convertTo111A()
  local shadowTexture = Texture(shadowImage)
  shadowImage:delete()
  ----PLANE----
  plane = MS3DModel("plane-data/air_ita_ww1.ms3d")
  plane:setMaxRadius(4)
  plane:move(0,30*32,140)
  addObject(plane)
  addShadow(Shadow(plane,6,6,shadowTexture))
  planeSource = Source(engineSample,plane,true)
  addSource(planeSource)
  ----EMITTER----
  local smokeImage = zip:getImage("smoke.png")
  smokeImage:convertTo111A()
  local smokeTexture = Texture(smokeImage)
  smokeImage:delete()
  smokeEmitter = Emitter(150,2,100,false)
  smokeEmitter:setTexture(smokeTexture,1)
  smokeEmitter:setVelocity(0,0,0, 1)
  smokeEmitter:setColor(0.5,0.5,0.5,1, 1,1,1,0)
  smokeEmitter:setSize(0.75,10)
  smokeEmitter:setGravity(0,0,0, 0,0,0)
  smokeEmitter:reset()
  addObject(smokeEmitter)
  smokeEmitter:hide()
  smokeTexture:delete()
  ----IMAGES----
  local module
  if NOISE == 1 then module = NoisePerlin()
  elseif NOISE == 2 then module = NoiseRidgedMulti()
  else module = NoiseBillow() end
  module:setFrequency(FREQUENCY)
  module:setLacunarity(LACUNARITY)
  module:setQuality(QUALITY)
  module:setOctaves(OCTAVES)
  module:setPersistence(PERSISTENCE)
  module:setSeed(SEED)
  local map = NoiseMap()
  local mapBuilder = NoiseMapBuilderPlane(-1,1,-1,1,true)
  mapBuilder:setSourceModule(module)
  mapBuilder:setDestMap(map)
  mapBuilder:setDestSize(512,512)
  mapBuilder:build()
  local image = NoiseImage()
  local renderer = NoiseColorMapRenderer()
  renderer:setSourceMap(map)
  renderer:setDestImage(image)
  renderer:render()
  local heightImage = ImageFromNoiseImage(image)
  heightImage:convertToRGB()
  heightImage:convertToGray()
  renderer:buildTerrainGradient()
  renderer:render()
  local colorImage = ImageFromNoiseImage(image)
  colorImage:convertToRGB()
  renderer:setLightEnabled()
  renderer:setWrapEnabled()
  renderer:setLightAzimuth(90)
  renderer:setLightBrightness(5)
  renderer:setLightColor(255,255,255,255)
  renderer:setLightIntensity(5)
  renderer:setLightContrast(4)
  renderer:setLightElevation(20)
  renderer:render()
  local shadowImage = ImageFromNoiseImage(image)
  shadowImage:convertToRGB()
  image:delete()
  renderer:delete()
  mapBuilder:delete()
  map:delete()
  module:delete()
  ----HUD----
  SIM.HUD = {}
  SIM.HUD.maxHeight = 0
  SIM.setupHuds(zip)
  SIM.setupMap(zip,colorImage)
  SIM.setupStick(zip,"stick.png")
  ----TERRAIN----
  local material = Material()
  material:setDiffuseTexture(zip:getTexture("coarse.jpg",true))
  material:setGlossTexture(zip:getTexture("detail.jpg",true))
  patches = Patches(heightImage,shadowImage,material,512*30,32*30,8,48,128)
  patches:setShadowFadeDistance(100)
  patches:setShadowOffset(0.25)
  patches:setShadowed()
  setTerrain(patches)
  heightImage:delete()
  colorImage:delete()
  shadowImage:delete()
  material:delete()
  ----WATER MATERIAL----
  local waterImages = {}
  local imagesCount = 32
  for ct = 1, imagesCount do
    local index = "0"
    if ct < 10 then
      index = index.."0"..ct
    else 
      index = index..ct
    end
    local imageName = "c_"..index..".jpg"
    waterImages[ct] = zip:getImage(imageName)
  end
  local waterTexture = AnimatedTexture(waterImages,4,true)
  for ct = 1, imagesCount do
    waterImages[ct]:delete()
  end
  local waterMaterial = Material()
  waterMaterial:setEnlighted(false)
  waterMaterial:setEmissive(1,1,1, 0.3)
  waterMaterial:setDiffuseTexture(waterTexture)
  ----CLOUDLAYER----
  local cloudLayer = CloudLayer(waterMaterial,1500*2,450,20)
  cloudLayer:setSpeed(0,0)
  setCloudLayer(cloudLayer)
  ----AIRPLANE----
  airplane = SIM.createAirplane()
  local startX, startZ = 0, 30*32
  local startH = patches:getHeightAt(startX,startZ)
  airplane:setPosition(startX,startH+200,startZ)
  offset = {view = 2, dist = 75, height = 5, forward = -75, up = 15, side = 0}
  ----HELP----
  local help = {
    "[   MOUSE  ] Stick Control",
    "[LEFT|RIGHT] Ailerons Control",
    "[  UP|DOWN ] Elevator Control",
    "[ DEL|END  ] Rudder Control",
    "[    0     ] Zero Controls",
    "[NEXT|PRIOR] Thrust",
    "[    S     ] Show/Hide Smoke",
    "[  * | /   ] Zoom View",
    "[  + | -   ] Incline View",
    "[  1 - 9   ] Change View",
    "[ENTER] Back to menu",
    " ",
    "[F1] Show/Hide Help",
  }
  setHelp(help)
  hideConsole()
  hideHelp()
  ----DELETE ZIP----
  zip:delete()
end

----FINALIZATION----
function SIM.final()
  SIM.HUD = nil
  offset = nil
  plane = nil
  smokeEmitter = nil
  airplane = nil
  patches = nil
  ----EMPTY WORLD----
  disableFog()
  emptyOverlay()
  empty()
end

----KEYDOWN----
function SIM.keyDown(key)
  if key >= 97 and key <= 105 then ---> VK_NUMPAD1-9
    if key == 97 then
      releaseKey(97)
      offset.view = 1
      offset.forward = -offset.dist*0.707
      offset.side = offset.dist*0.707
      offset.up = offset.height
    elseif key == 98 then
      releaseKey(98)
      offset.view = 2
      offset.forward = -offset.dist
      offset.side = 0
      offset.up = offset.height
    elseif key == 99 then
      releaseKey(99)
      offset.view = 3
      offset.forward = -offset.dist*0.707
      offset.side = -offset.dist*0.707
      offset.up = offset.height
    elseif key == 100 then
      releaseKey(100)
      offset.view = 4
      offset.forward = 0
      offset.side = offset.dist
      offset.up = offset.height
    elseif key == 101 then
      releaseKey(101)
      if offset.view == 5 then
        offset.view = 0
        offset.up = -offset.dist
      else
        offset.view = 5
        offset.up = offset.dist
      end
      offset.forward = 0
      offset.side = 0
    elseif key == 102 then
      releaseKey(102)
      offset.view = 6
      offset.forward = 0
      offset.side = -offset.dist
      offset.up = offset.height
    elseif key == 103 then
      releaseKey(103)
      offset.view = 7
      offset.forward = offset.dist*0.707
      offset.side = offset.dist*0.707
      offset.up = offset.height
    elseif key == 104 then
      releaseKey(104)
      offset.view = 8
      offset.forward = offset.dist
      offset.side = 0
      offset.up = offset.height
    elseif key == 105 then
      releaseKey(105)
      offset.view = 9
      offset.forward = offset.dist*0.707
      offset.side = -offset.dist*0.707
      offset.up = offset.height
    end
  elseif key == string.byte("S") then
    if smokeEmitter:isVisible() then
      smokeEmitter:hide()
    else
      smokeEmitter:show()
    end
  elseif key == 13 then
    releaseKey(13)
    setScene(Scene(MENU.init,MENU.update,MENU.final))
  end
end

----LOOP----
function SIM.update()
  local camera = getCamera()
  local timeStep = getTimeStep()
  if timeStep > 0.1 then timeStep = 0.1 end
  ----MOVE CONTROLS----
  if isMouseLeftPressed() or isKeyPressed(33) then --> VK_PRIOR
    local thrust = airplane.thrust
    local maxThrust = airplane.maxThrust
    thrust = thrust+timeStep*maxThrust*0.1
    if(thrust > maxThrust) then
      thrust = maxThrust
    end
    airplane.thrust = thrust
  elseif isMouseRightPressed() or isKeyPressed(34) then --> VK_NEXT
    local thrust = airplane.thrust
    local maxThrust = airplane.maxThrust
    thrust = thrust-timeStep*maxThrust*0.1
    if(thrust < 0) then
      thrust = 0
    end
    airplane.thrust = thrust
  end
  local dx, dy = getMouseMove()
  if dx ~= 0 or dy ~=0 then
    local elevator = airplane.elevator
    local maxElevator = airplane.maxElevator*0.5
    elevator = elevator+dy*maxElevator*0.0015
    if elevator > maxElevator then
      elevator = maxElevator
    elseif elevator < -maxElevator then
      elevator = -maxElevator
    end
    airplane.elevator = elevator
    local aileron = airplane.aileron
    local maxAileron = airplane.maxAileron*0.25
    aileron = aileron+dx*maxAileron*0.0015
    if aileron > maxAileron then
      aileron = maxAileron
    elseif aileron < -maxAileron then
      aileron = -maxAileron
    end
    airplane.aileron = aileron
  end
  if isKeyPressed(38) then --> VK_UP
    local elevator = airplane.elevator
    local maxElevator = airplane.maxElevator
    elevator = elevator+timeStep*maxElevator*0.2
    if elevator > maxElevator then
      elevator = maxElevator
    elseif elevator < -maxElevator then
      elevator = -maxElevator
    end
    airplane.elevator = elevator
  elseif isKeyPressed(40) then --> VK_DOWN
    local elevator = airplane.elevator
    local maxElevator = airplane.maxElevator
    elevator = elevator-timeStep*maxElevator*0.2
    if elevator > maxElevator then
      elevator = maxElevator
    elseif elevator < -maxElevator then
      elevator = -maxElevator
    end
    airplane.elevator = elevator
  end
  if isKeyPressed(37) then --> VK_LEFT
    local aileron = airplane.aileron
    local maxAileron = airplane.maxAileron
    aileron = aileron-timeStep*maxAileron*0.2
    if aileron > maxAileron then
      aileron = maxAileron
    elseif aileron < -maxAileron then
      aileron = -maxAileron
    end
    airplane.aileron = aileron
  elseif isKeyPressed(39) then --> VK_RIGHT
    local aileron = airplane.aileron
    local maxAileron = airplane.maxAileron
    aileron = aileron+timeStep*maxAileron*0.2
    if aileron > maxAileron then
      aileron = maxAileron
    elseif aileron < -maxAileron then
      aileron = -maxAileron
    end
    airplane.aileron = aileron
  end
  if isKeyPressed(46) then --> VK_DEL
    local rudder = airplane.rudder
    local maxRudder = airplane.maxRudder
    rudder = rudder+timeStep*maxRudder*0.2
    if rudder > maxRudder then
      rudder = maxRudder
    end
    airplane.rudder = rudder
  elseif isKeyPressed(35) then --> VK_END
    local rudder = airplane.rudder
    local maxRudder = airplane.maxRudder
    rudder = rudder-timeStep*maxRudder*0.2
    if rudder < -maxRudder then
      rudder = -maxRudder
    end
    airplane.rudder = rudder
  end
  if isKeyPressed(107) then ---> VK_ADD
    if offset.view ~= 0 and offset.view ~= 5 then
      local scale = 1+timeStep
      offset.height = offset.height*scale
      if offset.height <= 500 then
        offset.up = offset.height
      else
        offset.height = 500
      end
    end
  elseif isKeyPressed(109) then ---> VK_SUBTRACT
    if offset.view ~= 0 and offset.view ~= 5 then
      local scale = 1-timeStep
      offset.height = offset.height*scale
      if offset.height >= 0 then
        offset.up = offset.height
      else
        offset.height = 0
      end
    end
  end
  if isKeyPressed(111) then ---> VK_DIVIDE
    local scale = 1-timeStep
    offset.dist = offset.dist*scale
    if offset.dist >= 10 then
      offset.forward = offset.forward*scale
      offset.side = offset.side*scale
      offset.up = offset.up*scale
    else
      offset.dist = 10
    end
  elseif isKeyPressed(106) then ---> VK_MULTIPLY
    local scale = 1+timeStep
    offset.dist = offset.dist*scale
    if offset.dist <= 500 then
      offset.forward = offset.forward*scale
      offset.side = offset.side*scale
      offset.up = offset.up*scale
    else
      offset.dist = 500
    end
  end
  if isKeyPressed(96) then ---> VK_NUMPAD0
    airplane.elevator = 0
    airplane.rudder = 0
    airplane.aileron = 0
  end
  ----SIMULATION----
  airplane:simulateAirplane(timeStep)
  plane:set(airplane.transform)
  local posX, posY, posZ = plane:getPosition()
  if posY > SIM.HUD.maxHeight then
    SIM.HUD.maxHeight = posY
    SIM.setHudValue(SIM.HUD.maxhHud,4,posY)
  end
  SIM.setHudValue(SIM.HUD.heightHud,4,posY)
  smokeEmitter:set(plane)
  smokeEmitter:moveForward(-5)
  smokeEmitter:moveUp(1)
  camera:set(plane)
  camera:moveForward(offset.forward)
  camera:moveSide(offset.side)
  camera:moveUp(offset.up)
  local camX, camY, camZ = camera:getPosition()
  local camH = patches:getHeightAt(camX,camZ)+10
  if camY < camH then camera:setPosition(camX,camH,camZ) end
  local posX, posY, posZ = plane:getPosition()
  camera:pointTo(posX,posY,posZ)
  local speedX = airplane.U*1.1
  local speedY = airplane.V*1.1
  local speedZ = airplane.W*1.1
  local speed = math.sqrt(speedX*speedX+speedY*speedY+speedZ*speedZ)
  SIM.setHudValue(SIM.HUD.speedHud,3,speed)
  ----UPDATE MAP----
  if SIM.HUD.isMapShown then
    local horViewX,horViewZ = camera:getHorizontalView()
    local mapSprite = SIM.HUD.mapSprite
    local TEX_SCALE = 6.510417e-5 ---> 1/(512*30)
    if horViewZ ~= 0 then
      mapSprite:setRotation(math.atan2(horViewX,horViewZ))
      local markSprite = SIM.HUD.markSprite
      local W, H = getDimension()
      local MAP_SIZE = 170
      local SCALE = MAP_SIZE*TEX_SCALE
      local CENTER_X = W-MAP_SIZE
      local CENTER_Z = H-MAP_SIZE
      local x,y,z = plane:getPosition()
      x, z = (camX-x)*SCALE, (z-camZ)*SCALE
      if x >= -85 and x <= 85 and z >= -85 and z <= 85 then
        local dx = x*horViewZ+z*horViewX
        local dz = -x*horViewX+z*horViewZ
        markSprite:setLocation(CENTER_X+dx,CENTER_Z+dz)
        markSprite:show()
      else
        markSprite:hide()
      end
    end
    local texX = camX*TEX_SCALE+0.5
    local texZ = camZ*TEX_SCALE+0.5
    mapSprite:setTextureCoord(texX+0.5,texZ-0.5,texX-0.5,texZ+0.5)
  end
  ----UPDATE STICK----
  if SIM.HUD.isStickShown then
    local posSprite = SIM.HUD.posSprite
    local W, H = getDimension()
    local MAP_SIZE = 170
    local STICK_SIZE = 128
    local CENTER_X = W-MAP_SIZE
    local CENTER_Z = STICK_SIZE
    local stickX = airplane.aileron/airplane.maxAileron*STICK_SIZE*2
    local stickZ = airplane.elevator/airplane.maxElevator*STICK_SIZE
    posSprite:setLocation(CENTER_X+stickX,CENTER_Z+stickZ)
  end
  ----CRASH----
  if posY < patches:getHeightAt(posX,posZ) then
    setScene(Scene(MENU.init,MENU.update,MENU.final))
  end
end

----INITIALIZATION SUPPORT----

function ALL.showSplashImage(zip)
  local splashImage = zip:getImage("logo.jpg")
  showSplashImage(splashImage)
  splashImage:delete()
end

function ALL.playSoundtrack(zip,fileName,MODULE)
  MODULE.soundTrack = zip:getMusic(fileName)
  local soundTrack = MODULE.soundTrack
  soundTrack:setVolume(255)
  soundTrack:setLooping(1)
  soundTrack:play()
end

function ALL.stopSoundtrack(MODULE)
  local soundTrack = MODULE.soundTrack
  if soundTrack then
    soundTrack:stop()
    soundTrack:delete()
    MODULE.soundTrack = nil
  end
end

function ALL.createSkybox(zip)
  local txtNames = {"Top", "Left", "Front", "Right", "Back"}
  local skyTxt = {}
  for txtIdx = 1, table.getn(txtNames) do
    skyTxt[txtIdx] = zip:getTexture("skybox"..txtNames[txtIdx]..".jpg")
  end
  local sky = MirroredSky(skyTxt)
  setBackground(sky)
end

function ALL.createSun(zip)
  local sun = {
    size = 0.32, distance = 3200, texture = zip:getTexture("light.jpg"),
    dir = {x = 0.0, y = 0.2588, z = 0.9659},
    color = {r = 0.9, g = 0.5, b = 0.2},
    flares = {
      count = 5, size = 0.128, texture = zip:getTexture("lensflares.png")
    }
  }
  local theSun = Sun(
    sun.texture, sun.size, sun.dir.x,sun.dir.y,sun.dir.z,
    sun.flares.texture,sun.flares.count,sun.flares.size,
    sun.distance
  )
  theSun:setColor(sun.color.r,sun.color.g,sun.color.b)
  setSun(theSun)
end

function ALL.createLevel(zip)
  local bsp = zip:getLevel("city.bsx",3)
  bsp:setShowUntexturedMeshes()
  bsp:setShowUntexturedPatches()
  bsp:setDefaultTexture(
    zip:getTexture("textures/maxpayne/Brick52a.jpg",1)
  )
  bsp:setShadowsStatic()
  setScenery(bsp)
  return bsp
end

----
----MENU SCENE
----

----INITIALIZATION SUPPORT----

--[[
function MENU.setupPointer(zip)
  local pointerImage = zip:getImage("arrow.png")
  local pointerSize = pointerImage:getDimension()
  pointerImage:addAlpha(pointerImage)
  local pointerSprite = OverlaySprite(
    pointerSize,pointerSize,Texture(pointerImage),true
  )
  pointerImage:delete()
  pointerSprite:setLayer(0)
  setPointer(pointerSprite)
  local w, h = getDimension()
  setPointerLocation(w/2,h/2)
  setPointerOffset(-7,7)
  showPointer()
end
]]--

function MENU.createLogo(zip)
  local logoImage = zip:getImage("logo.jpg")
  local logoSize = logoImage:getDimension()
  MENU.GUI.logoSprite = OverlaySprite(
    logoSize,logoSize,Texture(logoImage),true
  )
  local logoSprite = MENU.GUI.logoSprite
  logoSprite:setLayer(1)
  logoImage:delete()
  local w, h = getDimension()
  logoSprite:setLocation((w-logoSize)/2,h)
  addToOverlay(logoSprite)
end

function MENU.createCredits()
  local colors = {
    {r = 1,    g = 1, b = 0},
    {r = 0.75, g = 1, b = 1},
    {r = 1,    g = 1, b = 1}
  }
  local creditStrings = {
    {
      1, "F L Y I N G   C I R C U S",
      2, "",
      3, "Copyright \184 2007",
      2, "Leonardo Boselli",
      1, "",
      3, "A Simple Flight Simulator",
      2, "",
      2, ""
    },
    {
      1, "- Programming & Design -",
      2, "Leonardo \"leo\" Boselli",
      3, "tetractys@users.sf.net",
      3, "",
      1, "- Models -",
      2, "kendo",
      3, "www.dogsquad.co.uk/dif",
      3, ""
    },
    {
      3, "Thanks to",
      3, "",
      2, "Matteo \"Fuzz\" Perenzoni",
      3, "",
      3, "for fruitful discussions on",
      3, "OpenGL and 3D programming.",
      3, "",
      3, "The sources of his demo for",
      3, "the NeHe's Apocalypse Contest",
      3, "were the first building blocks",
      3, "of the APOCALYX 3D Engine."
    },
    {
      3, "Thanks to",
      3, "",
      1, "TeCGraf, PUC-Rio",
      3, "for the LUA script language",
      2, "www.lua.org",
      3, "",
      1, "Borland",
      3, "for their free C++ compiler",
      2, "www.borland.com",
    },
    {
      3, "Thanks to the following sites",
      3, "for their useful tutorials",
      3, "about game programming",
      3, "",
      1, "NeHe Productions",
      2, "nehe.gamedev.net",
      1, "Game Tutorials",
      2, "www.gametutorials.com",
      1, "SULACO",
      2, "www.sulaco.co.za",
      3, "",
      3, "and",
      3, "",
      1, "Game Programming Italia",
      2, "www.gameprog.it"
    },
    {
      3, "Thanks to these web sites",
      3, "for publishing news about game",
      3, "development and related stuff",
      3, "",
      1, "GameDev",
      2, "www.gamedev.net",
      1, "FlipCode",
      2, "www.flipcode.org",
      1, "CFXweb",
      2, "www.cfxweb.net",
      1, "OpenGL.org",
      2, "www.opengl.org"
    },
    {
      3, "And, finally, thanks to",
      3, "ALL the people of the",
      3, "italian newsgroup",
      3, "",
      1, "it.comp.giochi.sviluppo",
      3, "",
      3, "",
      3, ""
    }
  }
  local font = getMainOverlayFont()
  local fontH = font:getHeight()
  local w, h = getDimension()
  local x = w/2+160
  MENU.GUI.credits = {}
  local credits = MENU.GUI.credits
  credits.status = 0
  credits.index = 1
  credits.texts = {}
  local creditTexts = credits.texts
  for creditIdx = 1, table.getn(creditStrings) do
    creditTexts[creditIdx] = OverlayTexts(font)
    local currentCreditText = creditTexts[creditIdx]
    currentCreditText:setLayer(1)
    local textLines = creditStrings[creditIdx]
    local textLinesCount = table.getn(textLines)
    local y = (h+fontH*(textLinesCount-1))/2-240
    for textLineIdx = 1, table.getn(textLines), 2 do
      local text = OverlayText(textLines[textLineIdx+1])
      local colorIdx = textLines[textLineIdx]
      text:setColor(
        colors[colorIdx].r,colors[colorIdx].g,colors[colorIdx].b
      )
      text:setLocation(x,y)
      y = y-fontH
      currentCreditText:add(text)
    end
    currentCreditText:setLocation(0,-h/2)
    addToOverlay(currentCreditText)
    currentCreditText:hide()
  end
end

function MENU.setupCamera()
  setAmbient(0.3,0.3,0.3)
  local camera = {angleOfView = 60, nearClip = 3, farClip = 3000}
  setPerspective(camera.angleOfView, camera.nearClip, camera.farClip)
  local theCamera = getCamera()
  theCamera:reset()
  theCamera:move(0,800,0)
end

function MENU.setupHelp()
  hideConsole()
  showHelpReduced()
  local help = {
    "F L Y I N G   C I R C U S",
    "A Simple Flight Shooter",
    "Questions? Contact leo <boselli@uno.it>",
    " ",
    "[ F 1 ] Show/Hide Help",
  }
  setHelp(help)
end

----INITIALIZATION----

function MENU.init()
  setTitle(" F L Y I N G   C I R C U S")
  MENU.GUI = {}
  empty()
  emptyOverlay()
  local zip = Zip("FlyingCircus.dat")
  ALL.playSoundtrack(zip,"intro.mid",MENU.GUI)
  ALL.showSplashImage(zip)
  MENU.createLogo(zip)
  MENU.createCredits()
  MENU.createGui()
  ----SCENERY
    ----SKYBOX----
  local MAX_DIST = 3000
  local fogColor = {0.475,0.431,0.451}
  enableFog(MAX_DIST, fogColor[1],fogColor[2],fogColor[3])
  local skytype = "orange_"
  local skyTxt = {
    zip:getTexture(skytype.."top.jpg",false,false),
    zip:getTexture(skytype.."left.jpg",false,false),
    zip:getTexture(skytype.."front.jpg",false,false),
    zip:getTexture(skytype.."right.jpg",false,false),
    zip:getTexture(skytype.."back.jpg",false,false)
  }
  local sky = HalfSky(skyTxt)
  sky:setGroundColor(fogColor[1],fogColor[2],fogColor[3])
  setBackground(sky)
    ----MOON----
  local moon = Moon(
    zip:getTexture("moon.jpg"),0.05,
    0,0.342,-0.9397,MAX_DIST-500
  )
  moon:setColor(0.9,0.9,0.7)
  setMoon(moon)
    ----SUN----
  local sun = Sun(
    zip:getTexture("light.jpg"),0.15,
    0,0.342,0.9397,
    zip:getTexture("lensflares.png"),
    6,0.1,MAX_DIST-500
  )
  sun:setColor(1,1,0.6)
  setSun(sun)
  ----SCENERY (END)
  MENU.setupCamera()
--[[  MENU.setupPointer(zip) ]]--
  MENU.setupHelp()
  zip:delete()
end

----FINALIZATION----

function MENU.final()
  ALL.stopSoundtrack(MENU.GUI)
  MENU.GUI = nil
--[[  hidePointer() ]]--
  disableFog()
  emptyOverlay()
  empty()
  MENU.deleteGui()
end

----UPDATE SUPPORT----

function MENU.rotateCamera(timeStep)
  local camera = getCamera()
  local rotSpeed = -math.pi/12
  camera:rotStanding(rotSpeed*timeStep)
end

function MENU.animateLogo(timeStep)
  local GUI = MENU.GUI
  local logoSprite = GUI.logoSprite
  local credits = GUI.credits
  local creditTexts = credits.texts
  local creditTextTime = credits.time
  local creditTextIndex = credits.index
  local creditTextStatus = credits.status
  local logoSpeedX, logoSpeedY = 200, 400
  local logoSize = logoSprite:getDimension()
  local w, h = getDimension()
  local markX = (w-logoSize-320)/2+logoSize/2
  local markY = (h-480)/2+logoSize/2
  local logoX, logoY = logoSprite:getLocation()
  if logoY > markY then
    logoY = logoY-timeStep*logoSpeedY
    if logoY < markY then
      logoY = markY
    end
    logoSprite:setLocation(logoX,logoY)
  elseif logoY == markY then
    logoSprite:setLocation(logoX,markY-1)
  else
    if logoX > markX then
      logoX = logoX-timeStep*logoSpeedX
      if logoX < markX then
        logoX = markX
      end
      logoSprite:setLocation(logoX,logoY)
    elseif logoX == markX then
      hideHelp()
      logoSprite:setLocation(logoX-1,logoY)
      creditTexts[creditTextIndex]:show()
      creditTexts[creditTextIndex]:setLocation(0,-h/2)
    else
      local creditText = creditTexts[creditTextIndex]
      if creditTextStatus == 0 then --> FADE_IN
        local creditX, creditY = creditText:getLocation()
        creditY = creditY+timeStep*logoSpeedX
        if creditY >= 0 then
           creditText:setLocation(creditX,0)
           credits.time = getElapsedTime()
           credits.status = 1 --> WAIT
        else
          creditText:setLocation(creditX,creditY)
        end
      elseif creditTextStatus == 1 then --> WAIT
        local diff = getElapsedTime()-creditTextTime
        if diff > creditText:getCount()*0.5 then
          credits.status = 2 --> FADE_OUT
        end
      elseif creditTextStatus == 2 then --> FADE_OUT
        local creditX, creditY = creditText:getLocation()
        creditY = creditY-timeStep*logoSpeedY
        if creditY <= -h/2 then
          creditText:setLocation(creditX,-h/2)
          creditText:hide()
          credits.index = creditTextIndex+1
          if credits.index > table.getn(creditTexts) then
            credits.index = 1
          end
          creditTexts[credits.index]:show()
          credits.status = 0 --> FADE_IN
        else
          creditText:setLocation(creditX,creditY)
        end
      end
    end
  end
end

function MENU.createGui()
  acquireMouse(false)
  ----GUI----
  guiInitialize("gui-data/accid___.ttf")
  local GUI = MENU.GUI
  local wX, wY = 50, 50
  local wW, wH = 300, 350
  ----GUI: Main Dialog----
  dialogButtonGen_Func = function()
    if GUI.mapSprite then removeFromOverlay(GUI.mapSprite) end
    GUI.mapSprite = MENU.createMapSprite()
    addToOverlay(GUI.mapSprite)
  end
  GUI.dialogButtonGenSlot = GuiSlotHolder("dialogButtonGen_Func")
  GUI.dialog = GuiFrameWindow(wX,wY,wX+wW,wY+wH)
  GUI.dialog:setText("Terrain Properties")
  GUI.dialog:setMovable()
  GUI.dialogPanel = GuiPanel(0,0,300,350)
  local dialogLayouter = GuiGridLayouter()
  dialogLayouter:setRowsCount(8)
  dialogLayouter:setColumnsCount(2)
  dialogLayouter:setHorizontalSpacing(4)
  dialogLayouter:setVerticalSpacing(8)
  GUI.dialogPanel:setLayouter(dialogLayouter)
  GUI.dialogLabelNoise = GuiStaticText("Noise")
  GUI.dialogPanel:addChildWindow(GUI.dialogLabelNoise)
  GUI.dialogComboNoise = GuiComboBox(0,0,300,20)
  GUI.dialogComboNoise:addString("Billow")
  GUI.dialogComboNoise:addString("Perlin")
  GUI.dialogComboNoise:addString("RidgedMulti")
  if NOISE == nil then NOISE = 0 end
  GUI.dialogComboNoise:selectStringAt(NOISE)
  GUI.dialogPanel:addChildWindow(GUI.dialogComboNoise)
  GUI.dialogLabelFreq = GuiStaticText("Frequency")
  GUI.dialogPanel:addChildWindow(GUI.dialogLabelFreq)
  if FREQUENCY == nil then FREQUENCY = 1 end
  GUI.dialogEditFreq = GuiEditField(tostring(FREQUENCY))
  GUI.dialogEditFreq:connectReturnPressed(GUI.dialogButtonGenSlot)
  GUI.dialogPanel:addChildWindow(GUI.dialogEditFreq)
  GUI.dialogLabelLac = GuiStaticText("Lacunarity")
  if LACUNARITY == nil then LACUNARITY = 2 end
  GUI.dialogPanel:addChildWindow(GUI.dialogLabelLac)
  GUI.dialogEditLac = GuiEditField(tostring(LACUNARITY))
  GUI.dialogEditLac:connectReturnPressed(GUI.dialogButtonGenSlot)
  GUI.dialogPanel:addChildWindow(GUI.dialogEditLac)
  GUI.dialogLabelQua = GuiStaticText("Quality")
  GUI.dialogPanel:addChildWindow(GUI.dialogLabelQua)
  if QUALITY == nil then QUALITY = 1 end
  GUI.dialogEditQua = GuiEditField(tostring(QUALITY))
  GUI.dialogEditQua:connectReturnPressed(GUI.dialogButtonGenSlot)
  GUI.dialogPanel:addChildWindow(GUI.dialogEditQua)
  GUI.dialogLabelOct = GuiStaticText("Octaves")
  GUI.dialogPanel:addChildWindow(GUI.dialogLabelOct)
  if OCTAVES == nil then OCTAVES = 6 end
  GUI.dialogEditOct = GuiEditField(tostring(OCTAVES))
  GUI.dialogEditOct:connectReturnPressed(GUI.dialogButtonGenSlot)
  GUI.dialogPanel:addChildWindow(GUI.dialogEditOct)
  GUI.dialogLabelPers = GuiStaticText("Persistence")
  GUI.dialogPanel:addChildWindow(GUI.dialogLabelPers)
  if PERSISTENCE == nil then PERSISTENCE = 0.5 end
  GUI.dialogEditPers = GuiEditField(tostring(PERSISTENCE))
  GUI.dialogEditPers:connectReturnPressed(GUI.dialogButtonGenSlot)
  GUI.dialogPanel:addChildWindow(GUI.dialogEditPers)
  GUI.dialogLabelSeed = GuiStaticText("Seed")
  GUI.dialogPanel:addChildWindow(GUI.dialogLabelSeed)
  if SEED == nil then SEED = 0 end
  GUI.dialogEditSeed = GuiEditField(tostring(SEED))
  GUI.dialogEditSeed:connectReturnPressed(GUI.dialogButtonGenSlot)
  GUI.dialogPanel:addChildWindow(GUI.dialogEditSeed)
  GUI.dialogButtonGen = GuiButton("Generate")
  GUI.dialogButtonGen:connectClicked(GUI.dialogButtonGenSlot)
  GUI.dialogPanel:addChildWindow(GUI.dialogButtonGen)
  GUI.dialogButtonExe = GuiButton("Execute")
  dialogButtonExe_Func = function()
    NOISE = GUI.dialogComboNoise:getSelectedIndex()
    FREQUENCY = tonumber(GUI.dialogEditFreq:getText())
    LACUNARITY = tonumber(GUI.dialogEditLac:getText())
    QUALITY = tonumber(GUI.dialogEditQua:getText())
    OCTAVES = tonumber(GUI.dialogEditOct:getText())
    PERSISTENCE = tonumber(GUI.dialogEditPers:getText())
    SEED = tonumber(GUI.dialogEditSeed:getText())
    setScene(Scene(SIM.init,SIM.update,SIM.final,SIM.keyDown))
  end
  GUI.dialogButtonExeSlot = GuiSlotHolder("dialogButtonExe_Func")
  GUI.dialogButtonExe:connectClicked(GUI.dialogButtonExeSlot)
  GUI.dialogPanel:addChildWindow(GUI.dialogButtonExe)
  GUI.dialog:setClientWindow(GUI.dialogPanel)
  guiAddWindow(GUI.dialog)
  ----GUI: Map----
  if GUI.mapSprite then
    removeFromOverlay(GUI.mapSprite)
  end
  GUI.mapSprite = MENU.createMapSprite()
  addToOverlay(GUI.mapSprite)
end

function MENU.createMapSprite()
  local GUI = MENU.GUI
  local module
  local noiseIndex = GUI.dialogComboNoise:getSelectedIndex()
  if noiseIndex == 1 then module = NoisePerlin()
  elseif noiseIndex == 2 then module = NoiseRidgedMulti()
  else module = NoiseBillow() end
  module:setFrequency(tonumber(GUI.dialogEditFreq:getText()))
  module:setLacunarity(tonumber(GUI.dialogEditLac:getText()))
  module:setQuality(tonumber(GUI.dialogEditQua:getText()))
  module:setOctaves(tonumber(GUI.dialogEditOct:getText()))
  module:setPersistence(tonumber(GUI.dialogEditPers:getText()))
  module:setSeed(tonumber(GUI.dialogEditSeed:getText()))
  local map = NoiseMap()
  local mapBuilder = NoiseMapBuilderPlane(-1,1,-1,1,true)
  mapBuilder:setSourceModule(module)
  mapBuilder:setDestMap(map)
  mapBuilder:setDestSize(256,256)
  mapBuilder:build()
  local image = NoiseImage()
  local renderer = NoiseColorMapRenderer()
  renderer:setSourceMap(map)
  renderer:setDestImage(image)
  renderer:buildTerrainGradient()
  renderer:render()
  local colorImage = ImageFromNoiseImage(image)
  colorImage:convertToRGB()
  image:delete()
  renderer:delete()
  mapBuilder:delete()
  map:delete()
  module:delete()
  local MAP_SIZE = 256
  local mapSprite = OverlaySprite(MAP_SIZE,MAP_SIZE,Texture(colorImage,true))
  mapSprite:setLayer(1)
  mapSprite:setColor(1,1,1,0.75)
  local W, H = getDimension()
  mapSprite:setLocation(W-MAP_SIZE/2-50,H-MAP_SIZE/2-50)
  colorImage:delete()
  return mapSprite
end

function MENU.deleteGui()
  acquireMouse(true)
  local GUI = MENU.GUI
  guiRemoveAllWindows()
  GUI.dialog:delete()
  GUI.dialogLabelFreq:delete()
  GUI.dialogEditFreq:delete()
  GUI.dialogLabelLac:delete()
  GUI.dialogEditLac:delete()
  GUI.dialogLabelQua:delete()
  GUI.dialogEditQua:delete()
  GUI.dialogLabelOct:delete()
  GUI.dialogEditOct:delete()
  GUI.dialogLabelPers:delete()
  GUI.dialogEditPers:delete()
  GUI.dialogLabelSeed:delete()
  GUI.dialogEditSeed:delete()
  GUI.dialogButtonGenSlot:delete()
  GUI.dialogButtonGenExe:delete()
  GUI.dialogButtonGen:delete()
  GUI.dialogButtonExe:delete()
  GUI.dialogPanel:delete()
  guiTerminate()
end

----UPDATE----

function MENU.update()
  local timeStep = getTimeStep()
  if timeStep > 0.1 then timeStep = 0.1 end
  MENU.rotateCamera(timeStep)
  MENU.animateLogo(timeStep)
--[[
  local dx, dy = getMouseMove()
  movePointer(dx,dy,getDimension())
  ]]--
end

----SCENE SETUP----
setScene(Scene(MENU.init,MENU.update,MENU.final))
