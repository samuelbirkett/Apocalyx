--[[
       H O V E R J E T   R A C I N G

       Questions? Contact leo at tetractys@users.sourceforge.net

--]]

----MODULES----

GAME = {}
MENU = {}
ALL = {}

----
----SIM SUPPORT
----

function GAME.applyForces(a)
  local vx0,vy0,vz0 = a:getVelocity(0)
  local fric = 0.0000001
  a:addForce(0,-math.abs(vx0)*vx0*fric,-math.abs(vy0)*vy0*fric,-math.abs(vz0)*vz0*fric)
  local x0,y0,z0 = a:getPosition(0)
  local x1,y1,z1 = a:getPosition(1)
  local ID = a:getID()
  local jet = GAME.jets[ID]
  if ID ~= GAME.modelIndex then
    local fx,fy,fz = x1-x0,y1-y0,z1-z0
    local speed2 = vx0*vx0+vy0*vy0+vz0*vz0
    local thrust = 0.00039
    local tx,ty,tz = fx*thrust,fy*thrust,fz*thrust
    a:addForce(1,tx,ty,tz)
    local sx,sz = z0-z1,x1-x0
    thrust = speed2*0.000000004
    sx,sz = thrust*sx,thrust*sz
    a:addForce(1,sx,0,sz)
    a:addForce(0,0,-0.003,0)
    a:addForce(1,0,-0.003,0)
    return
  end
  if jet.ENGINE_FORW == 1 then
    local fx,fy,fz = x1-x0,y1-y0,z1-z0
    local thrust
    if jet.BOOST_ON == 1 then
      thrust = 0.0008
    else
      thrust = 0.0004
    end
    local tx,ty,tz = fx*thrust,fy*thrust,fz*thrust
    a:addForce(1,tx,ty,tz)
  elseif jet.ENGINE_BACK == 1 then
    local fx,fy,fz = x1-x0,y1-y0,z1-z0
    local thrust
    thrust = -0.0002
    local tx,ty,tz = fx*thrust,fy*thrust,fz*thrust
    a:addForce(1,tx,ty,tz)
  end
  if jet.ENGINE_LEFT == 1 then
    local sx,sz = z1-z0,x0-x1
    local thrust = 0.0002
    sx,sz = thrust*sx,thrust*sz
    a:addForce(1,sx,0,sz)
  elseif jet.ENGINE_RIGHT == 1 then
    local sx,sz = z1-z0,x0-x1
    local thrust = -0.0002
    sx,sz = thrust*sx,thrust*sz
    a:addForce(1,sx,0,sz)
  end
  a:addForce(0,0,-0.003,0) -- was 0.0015
  a:addForce(1,0,-0.003,0)
end

----INITIALIZATION SUPPORT----

function ALL.showSplashImage(zip)
  local splashImage = zip:getImage("logo.jpg")
  showSplashImage(splashImage)
  splashImage:delete()
end

function ALL.playSoundtrack(zip,fileName,MODULE)
  MODULE.soundTrack = zip:getMusic(fileName)
  MODULE.soundTrackIsPlaying = true
  local soundTrack = MODULE.soundTrack
  soundTrack:setLooping(1)
  soundTrack:play()
  soundTrack:setVolume(220)
end

function ALL.stopSoundtrack(MODULE)
  local soundTrack = MODULE.soundTrack
  MODULE.soundTrackIsPlaying = false
  if soundTrack then
    soundTrack:stop()
    soundTrack:delete()
    MODULE.soundTrack = nil
  end
end

----
----GAME SCENE
----

----HUD SUPPORT----

function GAME.setupMap(zip,mapName,tiled)
  local mapImage = zip:getImage(mapName)
  mapImage:convertToRGB()
  local MAP_SIZE = 170
  GAME.HUD.isMapShown = true
  GAME.HUD.mapSprite =
    OverlaySprite(MAP_SIZE,MAP_SIZE,Texture(mapImage,tiled))
  local mapSprite = GAME.HUD.mapSprite
  mapImage:delete()
  mapSprite:setLayer(0)
  mapSprite:setColor(1,0.9,0.5,0.5)
  local W, H = getDimension()
  mapSprite:setLocation(W-MAP_SIZE,H-MAP_SIZE)
  addToOverlay(GAME.HUD.mapSprite)
  local markImage = zip:getImage("dot.png")
  local markSize = markImage:getDimension()
  markImage:addAlpha(markImage)
  local markTexture = Texture(markImage)
  markImage:delete()
  local JETS_COUNT = 7
  for jetCt = 1, JETS_COUNT do
    local markSprite = OverlaySprite(markSize,markSize,markTexture,true)
    GAME.HUD.markSprite[jetCt] = markSprite
    markSprite:setLayer(-1)
    markSprite:setColor(1,1,0)
    addToOverlay(markSprite)
  end
  local markSprite = GAME.HUD.markSprite[GAME.modelIndex]
  markSprite:setLayer(-2)
  markSprite:setColor(1,1,1)
end

function GAME.setupHud(theScore,len,offset,texture,u0,v0,u1,v1)
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

function GAME.setHudValue(theScore,chars,value)
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

function GAME.setupHuds(zip)
  local scoreImage = zip:getImage("numbers.png",0)
  local texture = Texture(scoreImage)
  scoreImage:delete()
  local setupScore = GAME.setupHud
  GAME.HUD.maxhHud = {}
  setupScore(GAME.HUD.maxhHud,4,-160,texture,0,0,0.5,0.25)
  GAME.HUD.heightHud = {}
  setupScore(GAME.HUD.heightHud,4,0,texture,0.5,0,1,0.25)
  GAME.HUD.speedHud = {}
  setupScore(GAME.HUD.speedHud,3,160,texture,0.5,0.25,1,0.5)
  GAME.setHudValue(GAME.HUD.maxhHud,4,0)
  GAME.setHudValue(GAME.HUD.heightHud,4,0)
  GAME.setHudValue(GAME.HUD.speedHud,3,0)
end

----ISLES SUPPORT----

----Generate Trees Material
function GAME.generateTreesMaterial(zip, fileName)
  local treesMaterial = Material()
  treesMaterial:setAmbient(1,1,1)
  treesMaterial:setDiffuse(1,1,1)
  treesMaterial:setDiffuseTexture(zip:getTexture(fileName));
  return treesMaterial
end

----Generate Isle (Transparency)
function GAME.generateIsle(
  zip, terrainTextureName, detailedTexture, detailRepeat,
  heightFieldName, waterLevel, width, depth, height, x, y,
  treesCount, treesMaterial, minTreesHeight
)
  ----LOAD IMAGES AND CREATE TEXTURES----
  local terrainImage = zip:getImage(terrainTextureName)
  local heightImage = zip:getImage(heightFieldName)
  terrainImage:addAlpha(heightImage,32,18)
  local terrainTexture = Texture(terrainImage)
  terrainImage:delete()
  ----TERRAIN MATERIAL----
  local terrainMaterial = Material()
  terrainMaterial:setDiffuseTexture(terrainTexture)
  terrainMaterial:setGlossTexture(detailedTexture)
  ----CREATE HEIGHTFIELD----
  local heightField = HeightField(
    heightImage,terrainMaterial,width,depth,height,-waterLevel,8
  )
  heightField:move(x,-waterLevel,y)
  heightField:setHintNoRotation()
  addObject(heightField)
  terrainMaterial:delete()
  terrainTexture:delete()
  ----TREES CREATION----
  local trees = nil
  if treesCount > 0 then
    trees = Trees(treesCount,2,treesMaterial,2,0.1)
    local treesSize = 18
    local counter = 0
    while counter < treesCount do
      local xx = math.random()*width-width*0.5
      local yy = math.random()*depth-depth*0.5
      local h = heightField:getHeightAtRelative(xx,yy)
      if h > minTreesHeight then
        counter = counter + 1
        trees:addTree(
          xx,h,yy,treesSize,treesSize,math.mod(counter,4),counter<treesCount*2
        )
      end
    end
    trees:setTransparent()
    trees:move(x,treesSize*0.5-waterLevel,y)
    addObject(trees)
    treesMaterial:delete()
  end
  return heightField, trees
end

----Generate Isle 2 (Reflection)
function GAME.generateIsle2(
  zip, terrainTextureName, detailedTexture, detailRepeat,
  heightFieldName, waterLevel, width, depth, height, x, y
)
  ----LOAD IMAGES AND CREATE TEXTURES----
  local terrainImage = zip:getImage(terrainTextureName)
  local heightImage = zip:getImage(heightFieldName)
  local terrainTexture = Texture(terrainImage)
  terrainImage:delete()
  ----TERRAIN MATERIAL----
  local terrainMaterial = Material()
  terrainMaterial:setDiffuse(1,1,1)
  terrainMaterial:setDiffuseTexture(terrainTexture)
  terrainMaterial:setGlossTexture(detailedTexture)
  ----CREATE HEIGHTFIELD----
  local heightField = HeightField(
    heightImage,terrainMaterial,width,depth,height,waterLevel,8
  )
  heightField:move(x,-waterLevel,y)
  heightField:setHintNoRotation()
  addObject(heightField)
  terrainMaterial:delete()
  terrainTexture:delete()
  return heightField
end

----INITIALIZATION----
function GAME.init()
  GAME.target = Reference()
  if GAME.mapIndex == nil then
    GAME.mapIndex = 5
  end
  if GAME.modelIndex == nil then
    GAME.modelIndex = 1
  end
  GAME.cloudsList = {}
  ----ZIP----
  setListenerScale(1)
  empty()
  emptyOverlay()
  if not fileExists("HoverjetRacing.dat") then
    showConsole()
    error("\nERROR: File 'HoverjetRacing.dat' not found")
  end
  local zip = Zip("HoverjetRacing.dat")
  ALL.showSplashImage(zip)
  ALL.playSoundtrack(zip,"soundtrack.mid",GAME)
  ----CAMERA----
  setAmbient(0.5,0.5,0.5)
  local fogColor
  if GAME.mapIndex == 1 then ---> FORBIDDEN PLANET
    GAME.MAX_DIST = 3000
    setPerspective(80,1,GAME.MAX_DIST)
    fogColor = {0,0,0}
  elseif GAME.mapIndex == 2 then ---> ROCKY MOUNTAINS
    GAME.MAX_DIST = 3000
    setPerspective(80,1,GAME.MAX_DIST)
    fogColor = {0.475,0.431,0.451}
  elseif GAME.mapIndex == 3 then ---> PACIFIC OCEAN
    GAME.MAX_DIST = 3000
    setPerspective(80,1,GAME.MAX_DIST)
    fogColor = {0.647,0.698,0.863}
  elseif GAME.mapIndex == 4 then ---> ANTARCTICA
    GAME.MAX_DIST = 4500
    setPerspective(80,1,GAME.MAX_DIST)
    fogColor = {0.75,0.75,1}
  elseif GAME.mapIndex == 5 then ---> TERRAFORMED MARS
    GAME.MAX_DIST = 3000
    setPerspective(80,1,GAME.MAX_DIST)
    fogColor = {0.475,0.431,0.451}
  end
  enableFog(GAME.MAX_DIST, fogColor[1],fogColor[2],fogColor[3])
  local camera = getCamera()
  camera:reset()
  ----SKYBOX----
  if GAME.mapIndex == 1 then ---> FORBIDDEN PLANET
    local starfield = StarField(50,4000,zip:getTexture("stars.jpg"),20)
    setBackground(starfield)
  elseif GAME.mapIndex == 2 then ---> ROCKY MOUNTAINS
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
  elseif GAME.mapIndex == 3 then ---> PACIFIC OCEAN
    local skytype = "clear_"
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
  elseif GAME.mapIndex == 4 then ---> ANTARCTICA
    local skytype = "blue_"
    local skyTxt = {
      zip:getTexture(skytype.."top.jpg",false,false),
      zip:getTexture(skytype.."left.jpg",false,false),
      zip:getTexture(skytype.."front.jpg",false,false),
      zip:getTexture(skytype.."right.jpg",false,false),
      zip:getTexture(skytype.."back.jpg",false,false)
    }
    local sky = MirroredSky(skyTxt)
    setBackground(sky)
  elseif GAME.mapIndex == 5 then ---> TERRAFORMED MARS
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
  end
  ----MOON----
  if GAME.mapIndex == 2 then ---> ROCKY
    local moon = Moon(
      zip:getTexture("moon.jpg"),0.05,
      0,0.342,-0.9397,GAME.MAX_DIST-500
    )
    moon:setColor(0.9,0.9,0.7)
    setMoon(moon)
  end
  ----SUN----
  local sun = Sun(
    zip:getTexture("light.jpg"),0.15,
    0,0.342,0.9397,
    zip:getTexture("lensflares.png"),
    6,0.1,GAME.MAX_DIST-500
  )
  sun:setColor(1,1,0.6)
  setSun(sun)
  ----TERRAIN----
  if GAME.mapIndex == 1 then ---> FORBIDDEN PLANET
    local heightImage = zip:getImage("terrainE.png")
    local colorImage = zip:getImage("terrainE.jpg")
    local material = Material()
    material:setDiffuseTexture(zip:getTexture("terrainmap.jpg",true))
    material:setGlossTexture(zip:getTexture("terrainmapB.jpg",true))
    GAME.patches = Patches(heightImage,colorImage,material,512*30,32*30,8,96,512)
    GAME.patches:setShadowFadeDistance(50)
    GAME.patches:setShadowOffset(0.25)
    GAME.patches:setShadowed()
    setTerrain(GAME.patches)
    heightImage:delete()
    colorImage:delete()
    material:delete()
    local obstruction = PatchedObstruction(GAME.patches,1.5)
    obstruction:setParticleProjected()
    GAME.environment = StaticEnvironment(0,0,0,1.5,obstruction)
    GAME.environment:setTerrainFriction(false)
  elseif GAME.mapIndex == 2 then ---> ROCKY MOUNTAINS
    local heightImage = zip:getImage("terrainB.png")
    local colorImage = zip:getImage("terrainB.jpg")
    local material = Material()
    material:setDiffuseTexture(zip:getTexture("terrainmapB.jpg",true))
    material:setGlossTexture(zip:getTexture("terrainmapB.jpg",true))
    GAME.patches = Patches(heightImage,colorImage,material,512*30,32*30,8,96,512)
    GAME.patches:setShadowFadeDistance(50)
    GAME.patches:setShadowOffset(0.25)
    GAME.patches:setShadowed()
    setTerrain(GAME.patches)
    heightImage:delete()
    colorImage:delete()
    material:delete()
    local obstruction = PatchedObstruction(GAME.patches,1.5)
    obstruction:setParticleProjected()
    GAME.environment = StaticEnvironment(0,0,0,1.5,obstruction)
    GAME.environment:setTerrainFriction(false)
  elseif GAME.mapIndex == 3 then ---> PACIFIC OCEAN
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
    local waterTexture = AnimatedTexture(waterImages,3,true)
    for ct = 1, imagesCount do
      waterImages[ct]:delete()
    end
    local waterMaterial = Material()
    waterMaterial:setAmbient(0.7,0.7,0.7,0.5)
    waterMaterial:setDiffuse(1,1,1,0.5)
    waterMaterial:setSpecular(1,1,0.5)
    waterMaterial:setShininess(96)
    waterMaterial:setDiffuseTexture(waterTexture)
    ----OCEAN----
    local waveAmplitude = 5e-8
    local waveDisplacement = 8
    local windX = -40
    local surfaceTileSide = 750
    local gridSize = 4
    local surfaceTilesCount = 8
    local textureTilesCount = 16
    local ocean = Ocean(
      waterMaterial,waveAmplitude,waveDisplacement,windX,0,
      surfaceTileSide,gridSize,surfaceTilesCount,textureTilesCount
    )
    ocean:setShadowFadeDistance(50)
    ocean:setShadowOffset(0.25)
    ocean:setShadowsStatic()
    ocean:setShadowed()
    ocean:setTransparent()
    setTerrain(ocean)
    waterMaterial:delete()
    ----ISLES----
    local detailedTexture = zip:getTexture("detail.jpg",1)
    GAME.isle1 = GAME.generateIsle(
      zip, ---- ZIP file
      "terrain1.jpg", ---- ground texture
      detailedTexture, ---- detailedTexture
      256, ---- detailedTiles
      "terrain1.png", ---- heightfield map
      12, ---- water level
      960, ---- width
      960, ---- depth
      64, ---- height
      1440, ---- position x
      480, ---- position z
      128, ---- trees count
      GAME.generateTreesMaterial(zip,"trees1.png"), ---- trees material
      32 ---- trees min height
    )
    GAME.isle2 = GAME.generateIsle(
      zip,"terrain2.jpg",detailedTexture,256,"terrain2.png",12,
      960,960,64,-480,1440,128,GAME.generateTreesMaterial(zip,"trees2.png"),32
    )
    GAME.isle3 = GAME.generateIsle(
      zip,"terrain3.jpg",detailedTexture,256,"terrain3.png",12,
      960,960,64,-1440,-480,128,GAME.generateTreesMaterial(zip,"trees3.png"),32
    )
    GAME.isle4 = GAME.generateIsle(
      zip,"volcano.jpg",detailedTexture,256,"volcano.png",16,
      960,960,120,480,-1440,0
    )
    ocean:addDelegate(GAME.isle1)
    ocean:addDelegate(GAME.isle2)
    ocean:addDelegate(GAME.isle3)
    ocean:addDelegate(GAME.isle4)
    GAME.environment = StaticEnvironment(0,0,0,1.5)
    GAME.environment:setTerrainFriction(false)
    local obstruction
    obstruction = HeightFieldObstruction(GAME.isle1,1.5)
    obstruction:setParticleProjected()
    GAME.environment:addObstruction(obstruction)
    obstruction = HeightFieldObstruction(GAME.isle2,1.5)
    obstruction:setParticleProjected()
    GAME.environment:addObstruction(obstruction)
    obstruction = HeightFieldObstruction(GAME.isle3,1.5)
    obstruction:setParticleProjected()
    GAME.environment:addObstruction(obstruction)
    obstruction = HeightFieldObstruction(GAME.isle4,1.5)
    obstruction:setParticleProjected()
    GAME.environment:addObstruction(obstruction)
    ----FIRE----
    local fireImage = zip:getImage("smoke.png")
    fireImage:convertTo111A()
    local fireTexture = Texture(fireImage)
    fireImage:delete()
    local fireEmitter = Emitter(10,1,30)
    fireEmitter:setTexture(fireTexture,1)
    fireEmitter:setVelocity(30,22.5,3.75, 8)
    fireEmitter:setColor(1,1,0,1, 1,0,0,0)
    fireEmitter:setSize(20,5)
    fireEmitter:setGravity(0,0,0, 0,0,0)
    fireEmitter:move(480,90,-1440)
    fireEmitter:reset()
    addObject(fireEmitter)
    local bombEmitter = Emitter(10,10,100)
    bombEmitter:setTexture(fireTexture,1)
    bombEmitter:setVelocity(0,50,0, 10)
    bombEmitter:setColor(.25,0,0,1, 1,1,0,0)
    bombEmitter:setSize(2,2)
    bombEmitter:setGravity(0,-15,0, 0,-15,0)
    bombEmitter:move(480,90,-1440)
    bombEmitter:reset()
    addObject(bombEmitter)
    fireTexture:delete()
    ----SMOKE----
    local smokeImage = zip:getImage("smoke.png")
    smokeImage:convertToRGBA()
    local smokeTexture = Texture(smokeImage)
    smokeImage:delete()
    local smokeEmitter = Emitter(40,4,100)
    smokeEmitter:setTexture(smokeTexture,1)
    smokeEmitter:setVelocity(7.5,18,-4.5, 5)
    smokeEmitter:setColor(0,0,0,0.8, 0.25,0.25,0.25,0)
    smokeEmitter:setSize(10,25)
    smokeEmitter:setGravity(0,0,0, 0,0,0)
    smokeEmitter:move(480,85,-1440)
    smokeEmitter:reset()
    addObject(smokeEmitter)
    smokeTexture:delete()
  elseif GAME.mapIndex == 4 then ---> ANTARCTICA
    local snow = zip:getTexture("snow.jpg",1)
    ----TERRAIN----
    local terrainMaterial = Material()
    terrainMaterial:setAmbient(1,1,1)
    terrainMaterial:setDiffuse(0,0,0)
    terrainMaterial:setDiffuseTexture(snow)
    local ground = FlatTerrain(terrainMaterial,GAME.MAX_DIST+1000,125)
    ground:setShadowFadeDistance(50)
    ground:setShadowOffset(0.25)
    ground:setShadowsStatic()
    ground:setShadowed()
    ground:setReflective()
    terrainMaterial:delete()
    setTerrain(ground)
    ----ISLES----
    local detailedTexture = snow
    GAME.isle1 = GAME.generateIsle2(
      zip, ---- ZIP file
      "terrain1.jpg", ---- ground texture
      detailedTexture, ---- detailedTexture
      2048, ---- detailedTiles
      "terrain1.png", ---- heightfield map
      32, ---- water level
      1920, ---- width
      1920, ---- depth
      256, ---- height
      1440, ---- position x
      1440 ---- position z
    )
    GAME.isle2 = GAME.generateIsle2(
      zip,"terrain2.jpg",detailedTexture,2048,"terrain2.png",32,
      1920,1920,256,-1440,-1440
    )
    GAME.isle3 = GAME.generateIsle2(
      zip,"terrain3.jpg",detailedTexture,2048,"terrain3.png",32,
      1920,1920,256,-1440,1440
    )
    GAME.isle4 = GAME.generateIsle2(
      zip,"volcano.jpg",detailedTexture,2048,"volcano.png",32,
      1920,1920,256,1440,-1440
    )
    ground:addDelegate(GAME.isle1)
    ground:addDelegate(GAME.isle2)
    ground:addDelegate(GAME.isle3)
    ground:addDelegate(GAME.isle4)
    GAME.environment = StaticEnvironment(0,0,0,1.5)
    GAME.environment:setTerrainFriction(false)
    local obstruction
    obstruction = HeightFieldObstruction(GAME.isle1,1.5)
    obstruction:setParticleProjected()
    GAME.environment:addObstruction(obstruction)
    obstruction = HeightFieldObstruction(GAME.isle2,1.5)
    obstruction:setParticleProjected()
    GAME.environment:addObstruction(obstruction)
    obstruction = HeightFieldObstruction(GAME.isle3,1.5)
    obstruction:setParticleProjected()
    GAME.environment:addObstruction(obstruction)
    obstruction = HeightFieldObstruction(GAME.isle4,1.5)
    obstruction:setParticleProjected()
    GAME.environment:addObstruction(obstruction)
  elseif GAME.mapIndex == 5 then ---> TERRAFORMED MARS
    local heightImage = zip:getImage("terrain.png")
    local colorImage = zip:getImage("terrain.jpg")
    local material = Material()
    material:setDiffuseTexture(zip:getTexture("terrainmap.jpg",true))
    material:setGlossTexture(zip:getTexture("detail.jpg",true))
    GAME.patches = Patches(heightImage,colorImage,material,512*30,32*30,8,96,512)
    GAME.patches:setShadowFadeDistance(50)
    GAME.patches:setShadowOffset(0.25)
    GAME.patches:setShadowed()
    setTerrain(GAME.patches)
    heightImage:delete()
    colorImage:delete()
    material:delete()
    local obstruction = PatchedObstruction(GAME.patches,1.5)
    obstruction:setParticleProjected()
    GAME.environment = StaticEnvironment(0,0,0,1.5,obstruction)
    GAME.environment:setTerrainFriction(false)
  end
  ----CLOUDS----
  if GAME.mapIndex == 5 then ---> TERRAFORMED MARS
    ----CLOUDLAYER----
    local cloudsImage = zip:getImage("cloudlayer2.jpg")
    local alphaImage = zip:getImage("cloudlayer2.png")
    cloudsImage:addAlpha(alphaImage)
    local cloudsTexture = Texture(cloudsImage,1)
    cloudsImage:delete()
    alphaImage:delete()
    local material = Material()
    material:setEmissive(0.9,0.9,0.6)
    material:setEnlighted(false)
    material:setDiffuseTexture(cloudsTexture)
    local cloudLayer = CloudLayer(material,GAME.MAX_DIST*2,500,10)
    cloudLayer:setSpeed(10,10)
    setCloudLayer(cloudLayer)
  elseif GAME.mapIndex ~= 1 then ---> not FORBIDDEN PLANET
    for ct = 1, 8 do
      local cloudImage = zip:getImage("cloud"..ct..".png")
      cloudImage:convertTo111A()
      local text = Texture(cloudImage)
      cloudImage:delete()
      local mat = Material()
      mat:setEnlighted(false)
      mat:setEmissive(1,1,1)
      mat:setDiffuseTexture(text)
      local sizeX = 512
      local sizeY = 256
      local cloud = FadingBillboard(1000,GAME.MAX_DIST-500,sizeX,sizeY,mat)
      local radius = math.random()*1000+1000
      local angle = math.random()*math.pi*2
      local posX = radius*math.cos(angle)
      local posY = radius*math.sin(angle)
      local h = 750+math.random()*256
      cloud:setPosition(posX,h,posY)
      cloud:setTransparent()
      addObject(cloud)
      table.insert(GAME.cloudsList,cloud)
    end
  end
  ----JETS SUPPORT----
    ----TEXTURES----
  local fireImage = zip:getImage("smoke.png")
  fireImage:convertTo111A()
  local fireTexture = Texture(fireImage)
  fireImage:delete()
  local shadowImage = zip:getImage("shadow.png")
  shadowImage:convertTo111A()
  local shadowTexture = Texture(shadowImage)
  shadowImage:delete()
  local envtext = zip:getTexture("environ1.jpg")
    ----SOUNDS----
  local engineSample = zip:getSample3D("jetengine.wav");
  engineSample:setLooping(true)
  engineSample:setVolume(64)
  engineSample:setMinDistance(64)
  local crashSample = zip:getSample3D("crash.wav");
  crashSample:setLooping(false)
  crashSample:setVolume(255)
  crashSample:setMinDistance(64)
  local windSample = zip:getSample("wind.wav")
  windSample:setLooping(1)
  GAME.windSound = windSample:createSound()
  GAME.windSound:play()
  GAME.windSound:setVolume(64)
    ----LISTS----
  GAME.jets = {}
  GAME.rockets = {
    { {2,0,-2}, {-2,0,-2} },
    { {0,0,-3} },
    { {1.5,0,-2}, {-1.5,0,-2} },
    { {0,0,-3} },
    { {0,0,-3} },
    { {0,1,-2} },
    { {1,0,-2}, {-1,0,-2} }
  }
  GAME.holder = {
    {0,0,4.25},
    {0,0.5,4.5},
    {0,0,2.75},
    {0,0,4.75},
    {0,0,1.5},
    {0,0.25,4.1},
    {0,0.33,4},
  }
      ----SIMULATOR----
  GAME.simulator = Simulator()
  local stickIndexes = {0,1}
  ----JETS----
  local JETS_COUNT = 7
  for jetCt = 1, JETS_COUNT do
    local jet = {}
    GAME.jets[jetCt] = jet
    ----JET CONTROL----
    jet.BOOST_ON = 0
    jet.ENGINE_BACK = 0
    jet.ENGINE_FORW = 1
    jet.ENGINE_LEFT = 0
    jet.ENGINE_RIGHT = 0
    ----JET BURST----
    local jetEmitter = Emitter(15,0.1,10,true)
    jetEmitter:setTexture(fireTexture,1)
    jetEmitter:setVelocity(0,0,-20, 4)
    jetEmitter:setColor(1,1,0.5,0.9, 1,0,0,0)
    jetEmitter:setSize(.25,1)
    jetEmitter:setGravity(0,0,0, 0,0,0)
    jetEmitter:reset()
    addObject(jetEmitter)
    jetEmitter:hide()
    local jetEmitter2 = Emitter(15,0.1,10,true)
    jetEmitter2:setTexture(fireTexture,1)
    jetEmitter2:setVelocity(0,0,-20, 4)
    jetEmitter2:setColor(1,1,0.5,0.9, 1,0,0,0)
    jetEmitter2:setSize(.25,1)
    jetEmitter2:setGravity(0,0,0, 0,0,0)
    jetEmitter2:reset()
    addObject(jetEmitter2)
    jetEmitter2:hide()
    local dustEmitter = Emitter(15,0.4,25)
    dustEmitter:setTexture(fireTexture,1)
    dustEmitter:setOneShot()
    dustEmitter:setVelocity(0,10,0, 10)
    if GAME.mapIndex == 3 then ---> OCEAN
      dustEmitter:setColor(0.75,0.55,0.35,1, 0.25,0.25,0.25,0)
    elseif GAME.mapIndex == 4 then ---> ANTARCTICA
      dustEmitter:setColor(0.9,0.9,1,1, 0.45,0.45,0.5,0)
    else ---> otherwise
      dustEmitter:setColor(0.5,0.3,0.1,1, 0.15,0.15,0.15,0)
    end
    dustEmitter:setSize(4,12)
    dustEmitter:setGravity(0,0,0, 0,0,0)
    dustEmitter:reset()
    addObject(dustEmitter)
    dustEmitter:hide()
    local waterEmitter = Emitter(15,0.4,25)
    waterEmitter:setTexture(fireTexture,1)
    waterEmitter:setVelocity(0,5,0, 5)
    waterEmitter:setColor(0.9,0.9,1,1, 0.45,0.45,0.5,0)
    waterEmitter:setSize(4,12)
    waterEmitter:setGravity(0,0,0, 0,0,0)
    waterEmitter:reset()
    addObject(waterEmitter)
    waterEmitter:hide()
    ----ASTROS----
    local astro
    local mat
    jet.dustEmitter = dustEmitter
    jet.waterEmitter = waterEmitter
    jet.jetEmitter = jetEmitter
    jet.jetEmitter2 = jetEmitter2
    astro = zip:getMesh("astro"..jetCt..".3ds")
    mat = astro:getMaterial()
    mat:setAmbient(1,1,1)
    mat:setDiffuse(1,1,1)
    mat:setSpecular(1,1,0.5)
    mat:setShininess(96)
    mat:setEnvironmentTexture(envtext,0.15)
    addObject(astro)
    addShadow(Shadow(astro,6,6,shadowTexture))
    jet.model = astro
    jet.rockets = GAME.rockets[jetCt]
    jet.holder = GAME.holder[jetCt]
    local source
    source  = Source(engineSample,astro,false)
    addSource(source)
    jet.jetSound = source
    source  = Source(crashSample,astro,false)
    addSource(source)
    jet.crashSound = source
    ----PHYSICS----
    local startX, startY, startZ = -jetCt*10, 3, 810
    local astroH
    if GAME.patches then
      astroH = GAME.patches:getHeightAt(startX,startZ)
    else
      if GAME.isle1:includes(startX,startY,startZ) then
        astroH = GAME.isle1:getHeightAtAbsolute(startX,startZ)
      elseif GAME.isle2:includes(startX,startY,startZ) then
        astroH = GAME.isle2:getHeightAtAbsolute(startX,startZ)
      elseif GAME.isle3:includes(startX,startY,startZ) then
        astroH = GAME.isle3:getHeightAtAbsolute(startX,startZ)
      elseif GAME.isle4:includes(startX,startY,startZ) then
        astroH = GAME.isle4:getHeightAtAbsolute(startX,startZ)
      else
        astroH = 0
      end
    end
    local particlePositions = {
      startX,startY+astroH+5,startZ-3,
      startX,startY+astroH+5,startZ+4
    }
    local assembly = Assembly(
      GAME.simulator,GAME.environment,particlePositions,stickIndexes,GAME.applyForces
    )
    assembly:setID(jetCt)
    assembly:setRadius(3)
    jet.assembly = assembly
    jet.envHit = getElapsedTime()
    jet.terHit = getElapsedTime()
    jet.colHit = getElapsedTime()
  end
  for jetCt = 2, JETS_COUNT do
    jet = GAME.jets[jetCt]
    jet.jetEmitter:show()
    if table.getn(jet.rockets) > 1 then
      jet.jetEmitter2:show()
    end
    jet.jetSound:getSound3D():play()
  end
  ----HUD----
  GAME.HUD = {}
  GAME.HUD.markSprite = {}
  GAME.HUD.maxHeight = 0
  GAME.setupHuds(zip)
  if GAME.mapIndex == 1 then ---> FORBIDDEN PLANET
    GAME.setupMap(zip,"mapE.png",true)
  elseif GAME.mapIndex == 2 then ---> ROCKY MOUNTAINS
    GAME.setupMap(zip,"mapB.png",true)
  elseif GAME.mapIndex == 3 then ---> PACIFIC OCEAN
    GAME.setupMap(zip,"mapC.png",false)
  elseif GAME.mapIndex == 4 then ---> ANTARCTICA
    GAME.setupMap(zip,"mapD.png",false)
  elseif GAME.mapIndex == 5 then ---> TERRAFORMED MARS
    GAME.setupMap(zip,"map.png",true)
  end
  CAMERA = {view = 2, dist = 30, height = 15, forward = -30, up = 10, side = 0, isFree = false}
--  CAMERA = {view = 2, dist = 20, height = 5, forward = -20, up = 5, side = 0, isFree = false}
  ----HELP----
  local help = {
    "H O V E R J E T   R A C I N G",
    "",
    "[NPAD1-9] Change View",
    "[ / | * ] Zoom In/Out",
    "[   V   ] Show/Hide Map",
    "[UP|DOWN] Thrust Forw/Back",
    "[LFT|RGH] Thrust Left/Right",
    "[  1-9  ] Use Item",
    "[   M   ] Play/Stop Music",
    "[ ENTER ] Back to Menu",
    " ",
    "[F1] Show/Hide Help",
  }
  setHelp(help)
  hideConsole()
  ----DELETE ZIP----
  zip:delete()
end

----FINALIZATION----
function GAME.final()
  GAME.target = nil
  ALL.stopSoundtrack(GAME)
  if GAME.simulator then
    GAME.simulator:empty()
    GAME.simulator:delete()
    GAME.simulator = nil
  end
  if GAME.environment then
    GAME.environment:delete()
    GAME.environment = nil
  end
  if GAME.windSound then
    GAME.windSound:delete()
    GAME.windSound = nil
  end
  GAME.MAX_DIST = nil
  GAME.jets = nil
  GAME.rockets = nil
  GAME.holder = nil
  GAME.patches = nil
  GAME.isle1 = nil
  GAME.isle2 = nil
  GAME.isle3 = nil
  GAME.isle4 = nil
  GAME.cloudsList = nil
  GAME.HUD = nil
  CAMERA = nil
  ----EMPTY WORLD----
  disableFog()
  empty()
  emptyOverlay()
end

----LOOP----
function GAME.update()
  local camera = getCamera()
  local timeStep = getTimeStep()
  if timeStep > 0.1 then timeStep = 0.1 end
  GAME.simulator:runStep(timeStep)
  ----UPDATE MODEL----
  local JETS_COUNT = 7
  for jetCt = 1, JETS_COUNT do
    local jet = GAME.jets[jetCt]
    local assembly = jet.assembly
    local x0,y0,z0 = assembly:getPosition(0)
    local x1,y1,z1 = assembly:getPosition(1)
    local posX,posY,posZ = (x1+x0)*0.5,(y1+y0)*0.5,(z1+z0)*0.5
    local viewX,viewY,viewZ = x1-x0,y1-y0,z1-z0
    local invView = 1/math.sqrt(viewX*viewX+viewY*viewY+viewZ*viewZ)
    viewX,viewY,viewZ = viewX*invView,viewY*invView,viewZ*invView
    local upX, upY, upZ
    if GAME.patches then
      GAME.patches:getHeightAt(posX,posZ)
      upX, upY, upZ = GAME.patches:getLastNormal()
    else
      if GAME.isle1:includes(posX,posY,posZ) then
        GAME.isle1:getHeightAtAbsolute(posX,posZ)
        upX, upY, upZ = GAME.isle1:getLastNormal()
      elseif GAME.isle2:includes(posX,posY,posZ) then
        GAME.isle2:getHeightAtAbsolute(posX,posZ)
        upX, upY, upZ = GAME.isle2:getLastNormal()
      elseif GAME.isle3:includes(posX,posY,posZ) then
        GAME.isle3:getHeightAtAbsolute(posX,posZ)
        upX, upY, upZ = GAME.isle3:getLastNormal()
      elseif GAME.isle4:includes(posX,posY,posZ) then
        GAME.isle4:getHeightAtAbsolute(posX,posZ)
        upX, upY, upZ = GAME.isle4:getLastNormal()
      else
        upX, upY, upZ = 0, 1, 0
      end
    end
    local sideX,sideY,sideZ =
      viewZ*upY-viewY*upZ,
      viewX*upZ-viewZ*upX,
      viewY*upX-viewX*upY
    local invSide = 1/math.sqrt(sideX*sideX+sideY*sideY+sideZ*sideZ)
    sideX,sideY,sideZ = sideX*invSide,sideY*invSide,sideZ*invSide 
    upX,upY,upZ =
      viewY*sideZ-viewZ*sideY,
      viewZ*sideX-viewX*sideZ,
      viewX*sideY-viewY*sideX
    local target = GAME.target
    target:setViewDirection(viewX,viewY,viewZ)
    target:setSideDirection(sideX,sideY,sideZ)
    target:setUpDirection(upX,upY,upZ)
    local model = jet.model
    model:interpolate(target,0.1)
    model:setPosition(posX,posY,posZ)
    viewX, viewY, viewZ = model:getViewDirection()
    sideX, sideY, sideZ = model:getSideDirection()
    upX, upY, upZ = model:getUpDirection()
    local rockets = jet.rockets
    local NUM_ROCKETS = table.getn(rockets)
    if NUM_ROCKETS > 1 then
      local rocket = rockets[1]
      local dx,dy,dz = rocket[1],rocket[2],rocket[3]
      local emitter = jet.jetEmitter
      emitter:set(model)
      emitter:move(
        dz*viewX+dx*sideX+dy*upX,
        dz*viewY+dx*sideY+dy*upY,
        dz*viewZ+dx*sideZ+dy*upZ
      )
      rocket = rockets[2]
      dx,dy,dz = rocket[1],rocket[2],rocket[3]
      local emitter2 = jet.jetEmitter2
      emitter2:set(model)
      emitter2:move(
        dz*viewX+dx*sideX+dy*upX,
        dz*viewY+dx*sideY+dy*upY,
        dz*viewZ+dx*sideZ+dy*upZ
      )
    else
      local rocket = rockets[1]
      local dx,dy,dz = rocket[1],rocket[2],rocket[3]
      local emitter = jet.jetEmitter
      emitter:set(model)
      emitter:move(
        dz*viewX+dx*sideX+dy*upX,
        dz*viewY+dx*sideY+dy*upY,
        dz*viewZ+dx*sideZ+dy*upZ
      )
    end
    if assembly:wasEnvironmentHit() then
      local time = getElapsedTime()
      if assembly:wasTerrainHit() then
        if time > jet.terHit+1 then
          jet.crashSound:getSound3D():play()
        end
        local emitter = jet.waterEmitter
        local vx,vy,vz = assembly:getVelocity(1)
        local speed = math.floor(math.sqrt(vx*vx+vy*vy+vz*vz)*3.6)
        if speed >= 30 then
          emitter:set(model)
          emitter:move(0,-1,0)
          emitter:setVelocity(0,speed*0.01,0, speed*0.015)
          emitter:setSize(speed*0.005,speed*0.025)
          emitter:show()
        else
          emitter:hide()
        end
        jet.terHit = time
      else
        if time > jet.envHit+1 then
          jet.crashSound:getSound3D():play()
          local emitter
          emitter = jet.waterEmitter
          emitter:hide()
          emitter = jet.dustEmitter
          emitter:set(model)
          emitter:move(0,-1,0)
          emitter:show()
          emitter:reset()
        end
        jet.envHit = time
      end
    else
      local emitter = jet.waterEmitter
      emitter:hide()
    end
    local collider = assembly:getColliderHit()
    if collider >= 0 then
      local time = getElapsedTime()
      if time > jet.colHit+1 then
        jet.crashSound:getSound3D():play()
      end
      jet.colHit = time
      if collider > 0 then
        GAME.jets[collider].colHit = time
      end
    end
  end
  local jet = GAME.jets[GAME.modelIndex]
  local assembly = jet.assembly
  local vx,vy,vz = assembly:getVelocity(1)
  local speed = math.floor(math.sqrt(vx*vx+vy*vy+vz*vz)*3.6)
  GAME.setHudValue(GAME.HUD.speedHud,3,speed)
  local volume = speed*0.5
  if(volume > 255) then
    volume = 255
  end
  GAME.windSound:setVolume(volume)
  local posX,posY,posZ =  assembly:getPosition(1)
  if posY > GAME.HUD.maxHeight then
    GAME.HUD.maxHeight = posY
    GAME.setHudValue(GAME.HUD.maxhHud,4,posY)
  end
  GAME.setHudValue(GAME.HUD.heightHud,4,posY)
  local NUM_ROCKETS = table.getn(jet.rockets)
  ----CAMERA CONTROL----
  local camX,camY,camZ
  if CAMERA.isFree then
    local speed = 200
    if isKeyPressed(38) then --> UP
      camera:moveForward(speed*timeStep)
    elseif isKeyPressed(40) then --> DOWN
      camera:moveForward(-speed*timeStep)
    end
    if isKeyPressed(37) then --> LEFT
      camera:moveSide(speed*timeStep)
    elseif isKeyPressed(39) then --> RIGHT
      camera:moveSide(speed*timeStep)
    end
    local climbSpeed = 200
    if isKeyPressed(33) then --> PRIOR
      camera:move(0,climbSpeed*timeStep,0)
    elseif isKeyPressed(34) then --> NEXT
      camera:move(0,-climbSpeed*timeStep,0)
    end
    local dx, dy = getMouseMove()
    local changeStep = 0.15*timeStep;
    if dx ~= 0 then
      camera:rotStanding(-dx*changeStep)
    end
    if dy ~= 0 then
      camera:pitch(-dy*changeStep)
    end
    camX,camY,camZ = camera:getPosition()
    local h
    if GAME.patches then
      h = GAME.patches:getHeightAt(camX,camZ)
    else
      if GAME.isle1:includes(camX,camY,camZ) then
        h = GAME.isle1:getHeightAtAbsolute(camX,camZ)
        if h < 0 then h = 0 end
      elseif GAME.isle2:includes(camX,camY,camZ) then
        h = GAME.isle2:getHeightAtAbsolute(camX,camZ)
        if h < 0 then h = 0 end
      elseif GAME.isle3:includes(camX,camY,camZ) then
        h = GAME.isle3:getHeightAtAbsolute(camX,camZ)
        if h < 0 then h = 0 end
      elseif GAME.isle4:includes(camX,camY,camZ) then
        h = GAME.isle4:getHeightAtAbsolute(camX,camZ)
        if h < 0 then h = 0 end
      else
        h = 0
      end
    end
    if camY < h+5 then
      camY = h+5
    end
    camera:setPosition(camX,camY,camZ)
  else
    if isKeyPressed(32) == true and jet.BOOST_ON == 0 then --> SPACE
      jet.jetEmitter:setColor(1,1,1,0.9, 1,1,0,0)
      if NUM_ROCKETS > 1 then
        jet.jetEmitter2:setColor(1,1,1,0.9, 1,1,0,0)
      end
      jet.BOOST_ON = 1
    elseif isKeyPressed(32) == false and jet.BOOST_ON == 1 then
      jet.BOOST_ON = 0
      jet.jetEmitter:setColor(1,1,0.5,0.9, 1,0,0,0)
      if NUM_ROCKETS > 1 then
        jet.jetEmitter2:setColor(1,1,0.5,0.9, 1,0,0,0)
      end
    end
    if isKeyPressed(38) == true and jet.ENGINE_FORW == 0 then --> UP
      jet.jetEmitter:show()
      if NUM_ROCKETS > 1 then
        jet.jetEmitter2:show()
      end
      jet.jetSound:getSound3D():play()
      jet.ENGINE_FORW = 1
    elseif isKeyPressed(38) == false and jet.ENGINE_FORW == 1 then
      jet.ENGINE_FORW = 0
      if jet.ENGINE_LEFT == 0 and jet.ENGINE_RIGHT == 0 then
        jet.jetEmitter:hide()
        jet.jetEmitter2:hide()
        jet.jetSound:getSound3D():stop()
      end
    end
    if isKeyPressed(37) == true and jet.ENGINE_LEFT == 0 then --> LEFT
      if NUM_ROCKETS > 1 then
        jet.jetEmitter2:show()
      else
        jet.jetEmitter:show()
      end
      jet.jetSound:getSound3D():play()
      jet.ENGINE_LEFT = 1
    elseif isKeyPressed(37) == false and jet.ENGINE_LEFT == 1 then
      jet.ENGINE_LEFT = 0
      if jet.ENGINE_FORW == 0 and jet.ENGINE_RIGHT == 0 then
        jet.jetEmitter:hide()
        jet.jetEmitter2:hide()
        jet.jetSound:getSound3D():stop()
      end
    end
    if isKeyPressed(39) == true and jet.ENGINE_RIGHT == 0 then --> RIGHT
      jet.jetEmitter:show()
      jet.jetSound:getSound3D():play()
      jet.ENGINE_RIGHT = 1
    elseif isKeyPressed(39) == false and jet.ENGINE_RIGHT == 1 then
      jet.ENGINE_RIGHT = 0
      if jet.ENGINE_LEFT == 0 and jet.ENGINE_FORW == 0 then
        jet.jetEmitter:hide()
        jet.jetEmitter2:hide()
        jet.jetSound:getSound3D():stop()
      end
    end
    if isKeyPressed(40) == true and jet.ENGINE_BACK == 0 then --> DOWN
      jet.jetEmitter:show()
      if NUM_ROCKETS > 1 then
        jet.jetEmitter2:show()
      end
      jet.jetSound:getSound3D():play()
      jet.ENGINE_BACK = 1
    elseif isKeyPressed(40) == false and jet.ENGINE_BACK == 1 then
      jet.ENGINE_BACK = 0
      jet.jetEmitter:hide()
      if NUM_ROCKETS > 1 then
        jet.jetEmitter2:hide()
      end
      jet.jetSound:getSound3D():stop()
    end
    if isKeyPressed(107) then ---> ADD
      if CAMERA.view ~= 0 and CAMERA.view ~= 5 then
        local scale = 1+timeStep
        CAMERA.height = CAMERA.height*scale
        if CAMERA.height <= 500 then
          CAMERA.up = CAMERA.height
        else
          CAMERA.height = 500
        end
      end
    elseif isKeyPressed(109) then ---> SUBTRACT
      if CAMERA.view ~= 0 and CAMERA.view ~= 5 then
        local scale = 1-timeStep
        CAMERA.height = CAMERA.height*scale
        if CAMERA.height >= 0 then
          CAMERA.up = CAMERA.height
        else
          CAMERA.height = 0
        end
      end
    end
    if isKeyPressed(111) then ---> DIVIDE
      local scale = 1-timeStep
      CAMERA.dist = CAMERA.dist*scale
      if CAMERA.dist >= 20 then
        CAMERA.forward = CAMERA.forward*scale
        CAMERA.side = CAMERA.side*scale
        CAMERA.up = CAMERA.up*scale
      else
        CAMERA.dist = 20
      end
      elseif isKeyPressed(106) then ---> MULTIPLY
      local scale = 1+timeStep
      CAMERA.dist = CAMERA.dist*scale
      if CAMERA.dist <= 500 then
        CAMERA.forward = CAMERA.forward*scale
        CAMERA.side = CAMERA.side*scale
        CAMERA.up = CAMERA.up*scale
      else
        CAMERA.dist = 500
      end
    end
    local target = GAME.target
    target:set(jet.model)
    target:moveForward(CAMERA.forward)
    target:moveSide(CAMERA.side)
    local posX, posY, posZ = target:getPosition()
    posY = posY+CAMERA.up
    local posH
    if GAME.patches then
      posH = GAME.patches:getHeightAt(posX,posZ)
    else
      if GAME.isle1:includes(posX,posY,posZ) then
        posH = GAME.isle1:getHeightAtAbsolute(posX,posZ)
        if posH < 0 then posH = 0 end
      elseif GAME.isle2:includes(posX,posY,posZ) then
        posH = GAME.isle2:getHeightAtAbsolute(posX,posZ)
        if posH < 0 then posH = 0 end
      elseif GAME.isle3:includes(posX,posY,posZ) then
        posH = GAME.isle3:getHeightAtAbsolute(posX,posZ)
        if posH < 0 then posH = 0 end
      elseif GAME.isle4:includes(posX,posY,posZ) then
        posH = GAME.isle4:getHeightAtAbsolute(posX,posZ)
        if posH < 0 then posH = 0 end
      else
        posH = 0
      end
    end
    if posY < posH+5 then target:setPosition(posX,posH+5,posZ) end
    camX,camY,camZ = camera:getPosition()
    local pathX,pathY,pathZ = posX-camX,posY-camY,posZ-camZ
    camera:interpolate(target,0.01)
    local interpolation = 0.05
    camX = camX+interpolation*pathX
    camY = camY+interpolation*pathY
    camZ = camZ+interpolation*pathZ
    if GAME.patches then
      posH = GAME.patches:getHeightAt(camX,camZ)
    else
      if GAME.isle1:includes(camX,camY,camZ) then
        posH = GAME.isle1:getHeightAtAbsolute(camX,camZ)
        if posH < 0 then posH = 0 end
      elseif GAME.isle2:includes(camX,camY,camZ) then
        posH = GAME.isle2:getHeightAtAbsolute(camX,camZ)
        if posH < 0 then posH = 0 end
      elseif GAME.isle3:includes(camX,camY,camZ) then
        posH = GAME.isle3:getHeightAtAbsolute(camX,camZ)
        if posH < 0 then posH = 0 end
      elseif GAME.isle4:includes(camX,camY,camZ) then
        posH = GAME.isle4:getHeightAtAbsolute(camX,camZ)
        if posH < 0 then posH = 0 end
      else
        posH = 0
      end
    end
    if camY < posH+5 then camY = posH+5 end
    camera:setPosition(camX,camY,camZ)
    posX, posY, posZ = jet.model:getPosition()
    camera:pointTo(posX,posY+CAMERA.up,posZ)
  end
  ----UPDATE MAP----
  if GAME.HUD.isMapShown then
    local horViewX,horViewZ = camera:getHorizontalView()
    local mapSprite = GAME.HUD.mapSprite
    local TEX_SCALE = 6.510417e-5 ---> 1/(512*30)
    if horViewZ ~= 0 then
      mapSprite:setRotation(math.atan2(horViewX,horViewZ))
      local markSprite = GAME.HUD.markSprite
      local W, H = getDimension()
      local MAP_SIZE = 170
      local SCALE = MAP_SIZE*TEX_SCALE
      local CENTER_X = W-MAP_SIZE
      local CENTER_Z = H-MAP_SIZE
      for jetCt = 1, JETS_COUNT do
        local x,y,z = GAME.jets[jetCt].model:getPosition()
        x, z = (camX-x)*SCALE, (z-camZ)*SCALE
        if x >= -85 and x <= 85 and z >= -85 and z <= 85 then
          local dx = x*horViewZ+z*horViewX
          local dz = -x*horViewX+z*horViewZ
          markSprite[jetCt]:setLocation(CENTER_X+dx,CENTER_Z+dz)
          markSprite[jetCt]:show()
        else
          markSprite[jetCt]:hide()
        end
      end
    end
    local texX = camX*TEX_SCALE+0.5
    local texZ = camZ*TEX_SCALE+0.5
    mapSprite:setTextureCoord(texX+0.5,texZ-0.5,texX-0.5,texZ+0.5)
  end
  ----MOVE CLOUDS----
  for index,cloud in ipairs(GAME.cloudsList) do
    if cloud:getDistance() > GAME.MAX_DIST then
      local sideX, sideY, sideZ = camera:getSideDirection()
      local viewX, viewY, viewZ = camera:getViewDirection()
      local dist = GAME.MAX_DIST-500
      local span = math.random()*1000-500
      local px = sideX*span+viewX*dist+posX
      local pz = sideZ*span+viewZ*dist+posZ
      local h = 750+math.random()*256
      cloud:setPosition(px,h,pz)
      local sizeX = 512
      local sizeY = 256
      cloud:setSize(sizeX,sizeY)
     end
  end
end

----KEYDOWN----
function GAME.keyDown(key)
  if key >= 97 and key <= 105 then ---> NUMPAD1-9
    releaseKey(key)
    if key == 97 then
      CAMERA.view = 1
      CAMERA.forward = -CAMERA.dist*0.707
      CAMERA.side = CAMERA.dist*0.707
      CAMERA.up = CAMERA.height
    elseif key == 98 then
      CAMERA.view = 2
      CAMERA.forward = -CAMERA.dist
      CAMERA.side = 0
      CAMERA.up = CAMERA.height
    elseif key == 99 then
      CAMERA.view = 3
      CAMERA.forward = -CAMERA.dist*0.707
      CAMERA.side = -CAMERA.dist*0.707
      CAMERA.up = CAMERA.height
    elseif key == 100 then
      CAMERA.view = 4
      CAMERA.forward = 0
      CAMERA.side = CAMERA.dist
      CAMERA.up = CAMERA.height
    elseif key == 101 then
      if CAMERA.view == 5 then
        CAMERA.view = 0
        CAMERA.up = -CAMERA.dist
      else
        CAMERA.view = 5
        CAMERA.up = CAMERA.dist
      end
      CAMERA.forward = 0
      CAMERA.side = 0
    elseif key == 102 then
      CAMERA.view = 6
      CAMERA.forward = 0
      CAMERA.side = -CAMERA.dist
      CAMERA.up = CAMERA.height
    elseif key == 103 then
      CAMERA.view = 7
      CAMERA.forward = CAMERA.dist*0.707
      CAMERA.side = CAMERA.dist*0.707
      CAMERA.up = CAMERA.height
    elseif key == 104 then
      CAMERA.view = 8
      CAMERA.forward = CAMERA.dist
      CAMERA.side = 0
      CAMERA.up = CAMERA.height
    elseif key == 105 then
      CAMERA.view = 9
      CAMERA.forward = CAMERA.dist*0.707
      CAMERA.side = -CAMERA.dist*0.707
      CAMERA.up = CAMERA.height
    end
  elseif key == 8 then ---> BACKSPACE
    releaseKey(key)
    CAMERA.isFree = not CAMERA.isFree
  elseif key == 13 then ---> RETURN
    releaseKey(key)
    setScene(Scene(MENU.init,MENU.update,MENU.final,MENU.keyDown))
  elseif key == string.byte("M") then ---> M
    releaseKey(key)
    if GAME.soundTrackIsPlaying then
      GAME.soundTrack:stop()
      GAME.soundTrackIsPlaying = false
    else
      GAME.soundTrack:play()
      GAME.soundTrackIsPlaying = true
    end
  elseif key == string.byte("V") then ---> V
    releaseKey(key)
    if GAME.HUD.isMapShown then
      GAME.HUD.mapSprite:hide()
      local JETS_COUNT = 7
      for jetCt = 1, JETS_COUNT do
        GAME.HUD.markSprite[jetCt]:hide()
      end
      GAME.HUD.isMapShown = false
    else
      GAME.HUD.mapSprite:show()
      local JETS_COUNT = 7
      for jetCt = 1, JETS_COUNT do
        GAME.HUD.markSprite[jetCt]:show()
      end
      GAME.HUD.isMapShown = true
    end
  end
end

----
----MENU SCENE
----

----INITIALIZATION SUPPORT----

function MENU.setupPointer(zip)
  local pointerImage = zip:getImage("arrow.png")
  local pointerSize = pointerImage:getDimension()
  pointerImage:addAlpha(pointerImage)
  local pointerSprite = OverlaySprite(
    pointerSize,pointerSize,Texture(pointerImage),true
  )
  pointerImage:delete()
  pointerSprite:setLayer(-1)
  setPointer(pointerSprite)
  local w, h = getDimension()
  setPointerLocation(w*0.5,h*0.5)
  showPointer()
end

function MENU.createLogo(zip)
  local logoImage = zip:getImage("logo.jpg")
  local alphaImage = zip:getImage("logo.png")
  alphaImage:convertTo111A()
  logoImage:addAlpha(alphaImage)
  alphaImage:delete()
  local logoSize = logoImage:getDimension()
  MENU.GUI.logoSprite = OverlaySprite(
    logoSize,logoSize,Texture(logoImage),true
  )
  local logoSprite = MENU.GUI.logoSprite
  logoImage:delete()
  local w, h = getDimension()
  logoSprite:setLocation(w*0.5,h)
  addToOverlay(logoSprite)
end

function MENU.createTexts()
  local colors = {
    {r = 1, g = 1, b = 0},
    {r = 0, g = 1, b = 1},
    {r = 1, g = 1, b = 1}
  }
  local creditStrings = {
    {
      1, "H O V E R J E T   R A C I N G",
      2, "",
      2, "D E M O",
      2, "",
      3, "Copyright \184 2005",
      2, "Leonardo Boselli",
      2, ""
    },
    {
      1, "Programming & Design",
      3, "",
      2, "Leonardo \"leo\" Boselli",
      3, "tetractys@users.sf.net",
      3, "",
      1, "3D Models",
      3, "",
      2, "Giovanni \"JohnJ\" Peirone",
      3, "peirone@libero.it",
      3, "",
      2, "Andrea \"Motenai\" Orioli",
      3, "andreone82@libero.it",
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
  local instructionStrings = {
    1, "H O V E R J E T   R A C I N G",
    3, "",
    3, "Hoverjets are vehicles sustained over ground by antigravity ",
    3, "engines and propelled by rockets. You can pilot your vehicle",
    3, "using the arrow keys and change the view using the numpad.  ",
    2, "THRUST: UP = forward; LEFT|RIGHT = lateral; DOWN = backward ",
    2, "VIEW  : 1-9 = change view; /|* = zoom in/out; +|- = incline ",
    3, "The F1 key shows the complete list of available keys.",
    3, "",
    3, "Enjoy the demo!  leo",
    3, "",
    2, "Press ENTER to start",
  }
  local font = getMainOverlayFont()
  local fontH = font:getHeight()
  local w, h = getDimension()
  MENU.GUI.optionsTexts = OverlayTexts(font)
  local optionsTexts = MENU.GUI.optionsTexts
  local scale = 1.5
  local offset = fontH*2
  local playText
  playText = OverlayText("[9] Exit          ")
  playText:setScale(scale)
  playText:setColor(1,1,0)
  playText:setLocation(0,offset)
  optionsTexts:add(playText)
  offset = offset+fontH*2
  playText = OverlayText("[3] Start Race    ")
  playText:setScale(scale)
  playText:setColor(1,1,0)
  playText:setLocation(0,offset)
  optionsTexts:add(playText)
  offset = offset+fontH*2
  playText = OverlayText("[2] Choose Track  ")
  playText:setScale(scale)
  playText:setColor(1,1,0)
  playText:setLocation(0,offset)
  optionsTexts:add(playText)
  offset = offset+fontH*2
  playText = OverlayText("[1] Choose Vehicle")
  playText:setScale(scale)
  playText:setColor(1,1,0)
  playText:setLocation(0,offset)
  optionsTexts:add(playText)
  offset = offset+fontH*2
  playText = OverlayText("[0] Instructions  ")
  playText:setScale(scale)
  playText:setColor(1,1,0)
  playText:setLocation(0,offset)
  optionsTexts:add(playText)
  offset = offset+fontH*2
  optionsTexts:setLocation(w*0.5,h)
  addToOverlay(optionsTexts)
  MENU.GUI.credits = {}
  local credits = MENU.GUI.credits
  credits.status = 0
  credits.index = 1
  credits.texts = {}
  local x = w*0.5+160
  local creditTexts = credits.texts
  for creditIdx = 1, table.getn(creditStrings) do
    creditTexts[creditIdx] = OverlayTexts(font)
    local currentCreditText = creditTexts[creditIdx]
    local textLines = creditStrings[creditIdx]
    local textLinesCount = table.getn(textLines)
    local y = (h+fontH*(textLinesCount-1))*0.5-240
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
    currentCreditText:setLocation(0,-h*0.5)
    addToOverlay(currentCreditText)
    currentCreditText:hide()
  end
  MENU.GUI.instructionTexts = OverlayTexts(font)
  local instructionCount = table.getn(instructionStrings)
  y = fontH*instructionCount*0.25
  for lineIdx = 1, instructionCount, 2 do
    local text = OverlayText(instructionStrings[lineIdx+1])
    local colorIdx = instructionStrings[lineIdx]
    text:setColor(
      colors[colorIdx].r,colors[colorIdx].g,colors[colorIdx].b
    )
    text:setLocation(0,y)
    y = y-fontH
    MENU.GUI.instructionTexts:add(text)
  end
  MENU.GUI.instructionTexts:setLocation(w*0.5,h*0.5)
  addToOverlay(MENU.GUI.instructionTexts)
  MENU.GUI.instructionTexts:hide()
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
    "H O V E R J E T   R A C I N G",
    " ",
    "[  0  ] Instructions",
    "[  1  ] Choose Vehicle",
    "[  2  ] Choose Track",
    "[  3  ] Start Race",
    "[  4  ] Exit",
    " ",
    "[ F 1 ] Show/Hide Help",
  }
  setHelp(help)
end

----INITIALIZATION----

function MENU.init()
  empty()
  emptyOverlay()
  MENU.GUI = {}
  if not fileExists("HoverjetRacing.dat") then
    showConsole()
    error("\nERROR: File 'HoverjetRacing.dat' not found")
  end
  local zip = Zip("HoverjetRacing.dat")
  ALL.showSplashImage(zip)
  ALL.playSoundtrack(zip,"intro.mid",MENU.GUI)
  setTitle(" H O V E R J E T   R A C I N G")
  MENU.createLogo(zip)
  MENU.createTexts()
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
    ----TERRAIN----
  local heightImage = zip:getImage("terrain.png")
  local colorImage = zip:getImage("terrain.jpg")
  local material = Material()
  material:setDiffuseTexture(zip:getTexture("terrainmapB.jpg",true))
  material:setGlossTexture(zip:getTexture("terrainmapB.jpg",true))
  local patches = Patches(heightImage,colorImage,material,512*30,32*30,8,96,512)
  setTerrain(patches)
  heightImage:delete()
  colorImage:delete()
  material:delete()
    ----ASTROS----
  local envtext = zip:getTexture("environ1.jpg")
  local astro
  local mat
  MENU.GUI.jetModels = {}
  astro = zip:getMesh("astro1.3ds")
  mat = astro:getMaterial()
  mat:setAmbient(1,1,1)
  mat:setDiffuse(1,1,1)
  mat:setSpecular(1,1,0.5)
  mat:setShininess(96)
  mat:setEnvironmentTexture(envtext,0.15)
  addObject(astro)
  astro:hide()
  MENU.GUI.jetModels[1] = astro
  astro = zip:getMesh("astro2.3ds")
  mat = astro:getMaterial()
  mat:setAmbient(1,1,1)
  mat:setDiffuse(1,1,1)
  mat:setSpecular(1,1,0.5)
  mat:setShininess(96)
  mat:setEnvironmentTexture(envtext,0.15)
  addObject(astro)
  astro:hide()
  MENU.GUI.jetModels[2] = astro
  astro = zip:getMesh("astro3.3ds")
  mat = astro:getMaterial()
  mat:setAmbient(1,1,1)
  mat:setDiffuse(1,1,1)
  mat:setSpecular(1,1,0.5)
  mat:setShininess(96)
  mat:setEnvironmentTexture(envtext,0.15)
  addObject(astro)
  astro:hide()
  MENU.GUI.jetModels[3] = astro
  astro = zip:getMesh("astro4.3ds")
  mat = astro:getMaterial()
  mat:setAmbient(1,1,1)
  mat:setDiffuse(1,1,1)
  mat:setSpecular(1,1,0.5)
  mat:setShininess(96)
  mat:setEnvironmentTexture(envtext,0.15)
  addObject(astro)
  astro:hide()
  MENU.GUI.jetModels[4] = astro
  astro = zip:getMesh("astro5.3ds")
  mat = astro:getMaterial()
  mat:setAmbient(1,1,1)
  mat:setDiffuse(1,1,1)
  mat:setSpecular(1,1,0.5)
  mat:setShininess(96)
  mat:setEnvironmentTexture(envtext,0.15)
  addObject(astro)
  astro:hide()
  MENU.GUI.jetModels[5] = astro
  astro = zip:getMesh("astro6.3ds")
  mat = astro:getMaterial()
  mat:setAmbient(1,1,1)
  mat:setDiffuse(1,1,1)
  mat:setSpecular(1,1,0.5)
  mat:setShininess(96)
  mat:setEnvironmentTexture(envtext,0.15)
  addObject(astro)
  astro:hide()
  MENU.GUI.jetModels[6] = astro
  astro = zip:getMesh("astro7.3ds")
  mat = astro:getMaterial()
  mat:setAmbient(1,1,1)
  mat:setDiffuse(1,1,1)
  mat:setSpecular(1,1,0.5)
  mat:setShininess(96)
  mat:setEnvironmentTexture(envtext,0.15)
  addObject(astro)
  astro:hide()
  MENU.GUI.jetModels[7] = astro
  if GAME.modelIndex then
    MENU.GUI.modelIndex = GAME.modelIndex
  else
    MENU.GUI.modelIndex = 1
  end
  MENU.GUI.jetData = {
    {name = "MIMETIC BOLT", length = 7, width = 6, weight = 12500, rockets = 2, power = 1500},
    {name = "STEEL FLAME", length = 8, width = 6, weight = 10500, rockets = 1, power = 2800},
    {name = "PALE SAUCER", length = 5, width = 8, weight = 12000, rockets = 2, power = 1400},
    {name = "LETHAL BLADES", length = 8, width = 4, weight = 10200, rockets = 1, power = 2700},
    {name = "FORKED ARROW", length = 9, width = 4, weight = 10050, rockets = 1, power = 2600},
    {name = "DEADLY ROTOR", length = 7, width = 6, weight = 11000, rockets = 1, power = 2700},
    {name = "FIRE SHIELD", length = 7, width = 6, weight = 11000, rockets = 2, power = 1350},
  }
  local w,h = getDimension()
  local font = getMainOverlayFont()
  local fontH = font:getHeight()
  MENU.GUI.dataTexts = {}
  local dataTexts = MENU.GUI.dataTexts
  for dataIdx = 1, table.getn(MENU.GUI.jetData) do
    dataTexts[dataIdx] = OverlayTexts(font)
    local data = MENU.GUI.jetData[dataIdx]
    local text
    local offset = 0
    text = OverlayText(data.name)
    text:setColor(1,1,0)
    text:setScale(2)
    text:setLocation(0,offset)
    offset = offset-fontH*2
    dataTexts[dataIdx]:add(text)
    text = OverlayText(string.format("length %d m      ",data.length))
    text:setColor(1,1,1)
    text:setLocation(0,offset)
    offset = offset-fontH
    dataTexts[dataIdx]:add(text)
    text = OverlayText(string.format(" width %d m      ",data.width))
    text:setColor(1,1,1)
    text:setLocation(0,offset)
    offset = offset-fontH
    dataTexts[dataIdx]:add(text)
    text = OverlayText(string.format("weight %d Kg ",data.weight))
    text:setColor(1,1,1)
    text:setLocation(0,offset)
    offset = offset-fontH
    dataTexts[dataIdx]:add(text)
    text = OverlayText(string.format(" power %dx%d KW",data.rockets,data.power))
    text:setColor(1,1,1)
    text:setLocation(0,offset)
    offset = offset-fontH*2
    dataTexts[dataIdx]:add(text)
    text = OverlayText("ARROW KEYS to change | ENTER to select")
    text:setColor(0,1,1)
    text:setLocation(0,offset)
    offset = offset-fontH
    dataTexts[dataIdx]:add(text)
    dataTexts[dataIdx]:setLocation(w*0.5,h*0.25)
    addToOverlay(dataTexts[dataIdx])
    dataTexts[dataIdx]:hide()
  end
  ----MAPS
  MENU.GUI.maps = {}
  local MAP_SIZE = 256
  local mapSprite
  local mapImage
  mapImage = zip:getImage("mapE.png")
  mapImage:convertToRGB()
  MENU.GUI.maps[1] = OverlaySprite(MAP_SIZE,MAP_SIZE,Texture(mapImage,true))
  local mapSprite = MENU.GUI.maps[1]
  mapImage:delete()
  mapSprite:setLayer(-1)
  mapSprite:setColor(0.8,0.9,1,0.5)
  mapSprite:setLocation(w*0.5,h*0.667)
  addToOverlay(mapSprite)
  mapSprite:hide()
  mapImage = zip:getImage("mapB.png")
  mapImage:convertToRGB()
  MENU.GUI.maps[2] = OverlaySprite(MAP_SIZE,MAP_SIZE,Texture(mapImage,true))
  local mapSprite = MENU.GUI.maps[2]
  mapImage:delete()
  mapSprite:setLayer(-1)
  mapSprite:setColor(1,0.9,0.5,0.5)
  mapSprite:setLocation(w*0.5,h*0.667)
  addToOverlay(mapSprite)
  mapSprite:hide()
  mapImage = zip:getImage("mapC.png")
  mapImage:convertToRGB()
  MENU.GUI.maps[3] = OverlaySprite(MAP_SIZE,MAP_SIZE,Texture(mapImage,true))
  local mapSprite = MENU.GUI.maps[3]
  mapImage:delete()
  mapSprite:setLayer(-1)
  mapSprite:setColor(0.6,0.6,1,0.5)
  mapSprite:setLocation(w*0.5,h*0.667)
  addToOverlay(mapSprite)
  mapSprite:hide()
  mapImage = zip:getImage("mapD.png")
  mapImage:convertToRGB()
  MENU.GUI.maps[4] = OverlaySprite(MAP_SIZE,MAP_SIZE,Texture(mapImage,true))
  local mapSprite = MENU.GUI.maps[4]
  mapImage:delete()
  mapSprite:setLayer(-1)
  mapSprite:setColor(1,1,1,0.5)
  mapSprite:setLocation(w*0.5,h*0.667)
  addToOverlay(mapSprite)
  mapSprite:hide()
  mapImage = zip:getImage("map.png")
  mapImage:convertToRGB()
  MENU.GUI.maps[5] = OverlaySprite(MAP_SIZE,MAP_SIZE,Texture(mapImage,true))
  local mapSprite = MENU.GUI.maps[5]
  mapImage:delete()
  mapSprite:setLayer(-1)
  mapSprite:setColor(1,0.85,0.85,0.5)
  mapSprite:setLocation(w*0.5,h*0.667)
  addToOverlay(mapSprite)
  mapSprite:hide()
  if GAME.mapIndex then
    MENU.GUI.mapIndex = GAME.mapIndex
  else
    MENU.GUI.mapIndex = 5
  end
  MENU.GUI.mapTexts = {}
  local mapTexts
  local mapText
  mapTexts = OverlayTexts(font)
  mapText = OverlayText("Forbidden Planet");
  mapText:setColor(1,1,0)
  mapText:setScale(2)
  mapTexts:add(mapText)
  mapText = OverlayText("Maze track on a far planet in the Magellan Cloud")
  mapText:setLocation(0,-fontH*2)
  mapText:setColor(1,1,1)
  mapTexts:add(mapText)
  mapText = OverlayText("ARROW KEYS to change | ENTER to select")
  mapText:setLocation(0,-fontH*4)
  mapText:setColor(0,1,1)
  mapTexts:add(mapText)
  mapTexts:setLocation(w*0.5,h*0.25)
  addToOverlay(mapTexts)
  mapTexts:hide()
  MENU.GUI.mapTexts[1] = mapTexts
  mapTexts = OverlayTexts(font)
  mapText = OverlayText("Rocky Mountains");
  mapText:setColor(1,1,0)
  mapText:setScale(2)
  mapTexts:add(mapText)
  mapText = OverlayText("Hard track carved in a canyon of the Rocky Mountains")
  mapText:setLocation(0,-fontH*2)
  mapText:setColor(1,1,1)
  mapTexts:add(mapText)
  mapText = OverlayText("ARROW KEYS to change | ENTER to select")
  mapText:setLocation(0,-fontH*4)
  mapText:setColor(0,1,1)
  mapTexts:add(mapText)
  mapTexts:setLocation(w*0.5,h*0.25)
  addToOverlay(mapTexts)
  mapTexts:hide()
  MENU.GUI.mapTexts[2] = mapTexts
  mapTexts = OverlayTexts(font)
  mapText = OverlayText("Pacific Ocean");
  mapText:setColor(1,1,0)
  mapText:setScale(2)
  mapTexts:add(mapText)
  mapText = OverlayText("Water track around four isles lost in the Pacific Ocean")
  mapText:setLocation(0,-fontH*2)
  mapText:setColor(1,1,1)
  mapTexts:add(mapText)
  mapText = OverlayText("ARROW KEYS to change | ENTER to select")
  mapText:setLocation(0,-fontH*4)
  mapText:setColor(0,1,1)
  mapTexts:add(mapText)
  mapTexts:setLocation(w*0.5,h*0.25)
  addToOverlay(mapTexts)
  mapTexts:hide()
  MENU.GUI.mapTexts[3] = mapTexts
  mapTexts = OverlayTexts(font)
  mapText = OverlayText("Antarctica");
  mapText:setColor(1,1,0)
  mapText:setScale(2)
  mapTexts:add(mapText)
  mapText = OverlayText("Iced track around four huge rocks in the Antarctica")
  mapText:setLocation(0,-fontH*2)
  mapText:setColor(1,1,1)
  mapTexts:add(mapText)
  mapText = OverlayText("ARROW KEYS to change | ENTER to select")
  mapText:setLocation(0,-fontH*4)
  mapText:setColor(0,1,1)
  mapTexts:add(mapText)
  mapTexts:setLocation(w*0.5,h*0.25)
  addToOverlay(mapTexts)
  mapTexts:hide()
  MENU.GUI.mapTexts[4] = mapTexts
  mapTexts = OverlayTexts(font)
  mapText = OverlayText("Terraformed Mars");
  mapText:setColor(1,1,0)
  mapText:setScale(2)
  mapTexts:add(mapText)
  mapText = OverlayText("Deep track dug on Mars just after human colonization")
  mapText:setLocation(0,-fontH*2)
  mapText:setColor(1,1,1)
  mapTexts:add(mapText)
  mapText = OverlayText("ARROW KEYS to change | ENTER to select")
  mapText:setLocation(0,-fontH*4)
  mapText:setColor(0,1,1)
  mapTexts:add(mapText)
  mapTexts:setLocation(w*0.5,h*0.25)
  addToOverlay(mapTexts)
  mapTexts:hide()
  MENU.GUI.mapTexts[5] = mapTexts
  ----SCENERY (END)
  MENU.setupCamera()
  MENU.setupPointer(zip)
  MENU.setupHelp()
  zip:delete()
  ----MODE
  MENU.GUI.mode = -1 ---> OPTIONS
end

----FINALIZATION----

function MENU.final()
  ALL.stopSoundtrack(MENU.GUI)
  MENU.GUI = nil
  hidePointer()
  disableFog()
  empty()
  emptyOverlay()
end

----KEYBOARD----

function MENU.keyDown(key)
  if MENU.GUI.mode == -1 then
    local key0 = string.byte("0")
    if key == key0+3 then
      releaseKey(key)
      GAME.modelIndex = MENU.GUI.modelIndex
      GAME.mapIndex = MENU.GUI.mapIndex
      setScene(Scene(GAME.init,GAME.update,GAME.final,GAME.keyDown))
    elseif key >= key0 and key <= key0+2 then
      releaseKey(key)
      hidePointer()
      MENU.GUI.mode = key-key0 ---> Instructions
      MENU.GUI.optionsTexts:hide()
      MENU.GUI.logoSprite:hide()
      MENU.GUI.credits.texts[MENU.GUI.credits.index]:hide()
      if key == key0 then
        MENU.GUI.instructionTexts:show()
      elseif key == key0+1 then
        MENU.GUI.jetModels[MENU.GUI.modelIndex]:show()
        MENU.GUI.dataTexts[MENU.GUI.modelIndex]:show()
      elseif key == key0+2 then
        MENU.GUI.maps[MENU.GUI.mapIndex]:show()
        MENU.GUI.mapTexts[MENU.GUI.mapIndex]:show()
      end
    elseif key == key0+9 then
      releaseKey(key)
      exit()
    end
  elseif MENU.GUI.mode == 0 then
    if key == 13 then ---> RETURN
      releaseKey(key)
      MENU.GUI.mode = -1
      showPointer()
      MENU.GUI.optionsTexts:show()
      MENU.GUI.logoSprite:show()
      MENU.GUI.credits.texts[MENU.GUI.credits.index]:show()
      MENU.GUI.instructionTexts:hide()
    end
  elseif MENU.GUI.mode == 1 then
    if key == 13 then ---> RETURN
      releaseKey(key)
      MENU.GUI.mode = -1
      showPointer()
      MENU.GUI.optionsTexts:show()
      MENU.GUI.logoSprite:show()
      MENU.GUI.credits.texts[MENU.GUI.credits.index]:show()
      MENU.GUI.jetModels[MENU.GUI.modelIndex]:hide()
      MENU.GUI.dataTexts[MENU.GUI.modelIndex]:hide()
    elseif key == 37 or key == 40 then ---> LEFT
      releaseKey(key)
      MENU.GUI.jetModels[MENU.GUI.modelIndex]:hide()
      MENU.GUI.dataTexts[MENU.GUI.modelIndex]:hide()
      if MENU.GUI.modelIndex == 1 then
        MENU.GUI.modelIndex = table.getn(MENU.GUI.jetModels)
      else
        MENU.GUI.modelIndex = MENU.GUI.modelIndex-1
      end
      MENU.GUI.jetModels[MENU.GUI.modelIndex]:show()
      MENU.GUI.dataTexts[MENU.GUI.modelIndex]:show()
    elseif key == 39 or key == 38 then ---> RIGHT
      releaseKey(key)
      MENU.GUI.jetModels[MENU.GUI.modelIndex]:hide()
      MENU.GUI.dataTexts[MENU.GUI.modelIndex]:hide()
      if MENU.GUI.modelIndex == table.getn(MENU.GUI.jetModels) then
        MENU.GUI.modelIndex = 1
      else
        MENU.GUI.modelIndex = MENU.GUI.modelIndex+1
      end
      MENU.GUI.jetModels[MENU.GUI.modelIndex]:show()
      MENU.GUI.dataTexts[MENU.GUI.modelIndex]:show()
    end
  elseif MENU.GUI.mode == 2 then
    if key == 13 then ---> RETURN
      releaseKey(key)
      MENU.GUI.mode = -1
      showPointer()
      MENU.GUI.optionsTexts:show()
      MENU.GUI.logoSprite:show()
      MENU.GUI.credits.texts[MENU.GUI.credits.index]:show()
      MENU.GUI.maps[MENU.GUI.mapIndex]:hide()
      MENU.GUI.mapTexts[MENU.GUI.mapIndex]:hide()
    elseif key == 37 or key == 40 then ---> LEFT
      releaseKey(key)
      MENU.GUI.maps[MENU.GUI.mapIndex]:hide()
      MENU.GUI.mapTexts[MENU.GUI.mapIndex]:hide()
      if MENU.GUI.mapIndex == 1 then
        MENU.GUI.mapIndex = table.getn(MENU.GUI.maps)
      else
        MENU.GUI.mapIndex = MENU.GUI.mapIndex-1
      end
      MENU.GUI.maps[MENU.GUI.mapIndex]:show()
      MENU.GUI.mapTexts[MENU.GUI.mapIndex]:show()
    elseif key == 39 or key == 38 then ---> RIGHT
      releaseKey(key)
      MENU.GUI.maps[MENU.GUI.mapIndex]:hide()
      MENU.GUI.mapTexts[MENU.GUI.mapIndex]:hide()
      if MENU.GUI.mapIndex == table.getn(MENU.GUI.maps) then
        MENU.GUI.mapIndex = 1
      else
        MENU.GUI.mapIndex = MENU.GUI.mapIndex+1
      end
      MENU.GUI.maps[MENU.GUI.mapIndex]:show()
      MENU.GUI.mapTexts[MENU.GUI.mapIndex]:show()
    end
  end
end

----UPDATE SUPPORT----

function MENU.rotateCamera(timeStep)
  local camera = getCamera()
  local rotSpeed = -math.pi*0.083333 ---> 1/12
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
  local markX = (w-320)*0.5
  local markY = (h+logoSize-480)*0.5
  local logoX, logoY = logoSprite:getLocation()
  if timeStep > 0.1 then
    timeStep = 0.1
  end
  if logoY > markY then
    logoY = logoY-timeStep*logoSpeedY
    if logoY < markY then
      logoY = markY
    end
    MENU.GUI.optionsTexts:setLocation(w*0.5,logoY+(h-logoSize)*0.5)
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
      creditTexts[creditTextIndex]:setLocation(0,-h*0.5)
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
        if creditY <= -h*0.5 then
          creditText:setLocation(creditX,-h*0.5)
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

----UPDATE----

function MENU.update()
  local timeStep = getTimeStep()
  if timeStep > 0.1 then timeStep = 0.1 end
  MENU.rotateCamera(timeStep)
  local mode = MENU.GUI.mode
  if mode == -1 then ---> OPTIONS
    MENU.animateLogo(timeStep)
    local dx, dy = getMouseMove()
    movePointer(dx,dy,getDimension())
    local GUI = MENU.GUI
    local text = GUI.optionsTexts:getTextAt(getPointerLocation())
    local oldPointerText = GUI.oldPointerText
    if text then
      if text ~= oldPointerText then
        if oldPointerText then
          oldPointerText:setColor(1,1,0)
        end
        text:setColor(1,0.25,0.25)
        GUI.oldPointerText = text
      end
      if isMouseLeftPressed() then
        if GUI.selected == nil then
          GUI.selected = true
          MENU.keyDown(string.byte(text:getText(),2))
        end
      else
        GUI.selected = nil
      end
    elseif oldPointerText then
      oldPointerText:setColor(1,1,0)
      GUI.oldPointerText = nil
    end
  elseif mode == 1 then ---> Vehicle
    local model = MENU.GUI.jetModels[MENU.GUI.modelIndex]
    local camera = getCamera()
    model:reset()
    model:pitch(math.pi*0.167)
    model:setPosition(camera:getPosition())
    local scale = 15
    local tx,ty,tz = camera:getViewDirection()
    model:move(scale*tx,scale*ty,scale*tz)
  elseif mode == 2 then ---> Track
  end
end

----SCENE SETUP----
setScene(Scene(MENU.init,MENU.update,MENU.final,MENU.keyDown))
