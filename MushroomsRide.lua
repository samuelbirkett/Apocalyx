--[[
       MUSHROOM' S   R I D E

       Questions? Contact leo at tetractys@users.sourceforge.net

--]]

----MODULES----

EDITOR = {}
GAME = {}
MENU = {}
ALL = {}

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
  soundTrack:setVolume(255)
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
  addShadow(Shadow(model))
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
  model2:pitch(-1.5708)
  model2:move(posX,posY,posZ)
  addObject(model2)
  addShadow(Shadow(model2))
  return model2
end

function ALL.cloneMesh(mesh, posX,posY,posZ)
  local m = Mesh(mesh:getShape(),mesh:getMaterial())
  m:move(posX,posY,posZ)
  addObject(m)
  local s = Shadow(m)
  s:setMaxRadius(m:getMaxRadius()*3)
  addShadow(s)
  return m
end

function ALL.cloneObjects(objects, posX,posZ)
  local m1 = objects:getFirstMesh()
  local m11 = Mesh(m1:getShape(),m1:getMaterial())
  local m2 = objects:getNextMesh()
  local m22 = Mesh(m2:getShape(),m2:getMaterial())
  local objs = Objects()
  objs:add(m11)
  objs:add(m22)
  objs:move(posX,0,posZ)
  addObject(objs)
  local s = Shadow(objs)
  s:setMaxRadius(objs:getMaxRadius()*3)
  addShadow(s)
  return objs
end

function ALL.createCube(zip, sz, texName, posX,posZ)
  local vertices = {
    sz,sz,sz, sz,sz,-sz, -sz,sz,-sz, -sz,sz,sz,
    sz,sz,sz, -sz,sz,sz, -sz,-sz,sz, sz,-sz,sz,
    -sz,sz,sz, -sz,sz,-sz, -sz,-sz,-sz, -sz,-sz,sz,
    -sz,sz,-sz, sz,sz,-sz, sz,-sz,-sz, -sz,-sz,-sz,
    sz,sz,-sz, sz,sz,sz, sz,-sz,sz, sz,-sz,-sz,
    sz,-sz,sz, -sz,-sz,sz, -sz,-sz,-sz, sz,-sz,-sz
  }
  local normals = {
    0,1,0, 0,1,0, 0,1,0, 0,1,0,
    0,0,1, 0,0,1, 0,0,1, 0,0,1,
    -1,0,0, -1,0,0, -1,0,0, -1,0,0,
    0,0,-1, 0,0,-1, 0,0,-1, 0,0,-1,
    1,0,0, 1,0,0, 1,0,0, 1,0,0,
    0,-1,0, 0,-1,0, 0,-1,0, 0,-1,0
  }
  local mappings = {
     0,0,  0,1,  1,1,  1,0,
     0,0,  0,1,  1,1,  1,0,
     0,0,  0,1,  1,1,  1,0,
     0,0,  0,1,  1,1,  1,0,
     0,0,  0,1,  1,1,  1,0,
     0,0,  0,1,  1,1,  1,0
  }
  local triangles = {
    0,1,2, 0,2,3,
    4,5,6, 4,6,7,
    8,9,10, 8,10,11,
    12,13,14, 12,14,15,
    16,17,18, 16,18,19,
    20,21,22, 20,22,23
  }
  local shape = Shape(vertices,normals,mappings,triangles)
  local material = Material()
  material:setDiffuse(1,1,1)
  material:setSpecular(1,1,0)
  material:setAmbient(0.75,0.75,0.75)
  material:setDiffuseTexture(zip:getTexture(texName))
  local cube = Mesh(shape,material)
  cube:move(posX,sz,posZ)
  addObject(cube)
  local shadow = Shadow(cube)
  shadow:setMode(2)
  shadow:setMaxRadius(cube:getMaxRadius()*4)
  addShadow(shadow)
  return cube
end

function ALL.cloneCube(mesh, posX,posY,posZ)
  local m = Mesh(mesh:getShape(),mesh:getMaterial())
  m:move(posX,posY,posZ)
  addObject(m)
  local s = Shadow(m)
  s:setMaxRadius(m:getMaxRadius()*3)
  s:setMode(2)
  addShadow(s)
  return m
end

----
----MENU SCENE
----

----MENU INITIALIZATION SUPPORT----

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
      1, "M U S H R O O M ' S   R I D E",
      2, "",
      2, "D E M O",
      2, "",
      3, "Copyright \184 2008",
      2, "Leonardo Boselli",
      2, ""
    },
    {
      1, "Programming & Design",
      2, "Leonardo \"leo\" Boselli",
      3, "tetractys@users.sf.net",
      2, "",
      1, "Tiled Textures",
      3, "http://www.lostgarden.com",
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
    2, "M U S H R O O M ' S   R I D E",
    3, "",
    1, "As you know, mushrooms hate the full sunlight. They grow ",
    1, "happily only below the shadows of bushes and large trees.",
    1, "You also know that fairies use to lead mushrooms through ",
    1, "the forest where shadows are deeper and the air is fresh.",
    3, "",
    1, "In this demo you must guide a fairy along the borders of ",
    1, "ancient stone blocks to collect mushrooms and drive them ",
    1, "to the goal, following the shadows and avoiding the sun. ",
    3, "",
    2, "Use the cursor keys to drive the fairy, walk on mushrooms",
    2, "to animate them, drive the mushrooms to the goal through ",
    2, "fresh shadows to increase your score and beat the best.  ",
    3, "",
    1, "Enjoy the demo! leo",
    3, "",
    3, "Press ENTER to show the MENU",
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
  playText = OverlayText("[1] Play          ")
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
  local indexes = {0,1,2,3,}
  local coords = {-300,-200, -300,232, 300,232, 300,-200,}
  local colors = {0.5,0.5,0.5,0.75, 1,1,1,0.75, 1,1,1,0.75, 0.5,0.5,0.5,0.75,}
  MENU.GUI.overlayPoly = OverlayPolys(indexes,coords,colors)
  MENU.GUI.overlayPoly:setColor(1,1,1,0)
  MENU.GUI.overlayPoly:setModeTriangFan()
  MENU.GUI.overlayPoly:setLocation(w*0.5,h*0.5)
  MENU.GUI.overlayPoly:setLayer(1)
  addToOverlay(MENU.GUI.overlayPoly)
  MENU.GUI.overlayPoly:hide()
end

function MENU.setupHelp()
  hideConsole()
  showHelpReduced()
  hideFramerate()
  local help = {
    "M U S H R O O M ' S   R I D E",
    " ",
    "[  0  ] Instructions",
    "[  1  ] Play",
    "[  9  ] Exit",
    " ",
    "[ F 1 ] Show/Hide Help",
  }
  setHelp(help)
end

----MENU UPDATE SUPPORT----

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

----INITIALIZATION----

function MENU.init()
  empty()
  emptyOverlay()
  MENU.GUI = {mode = -1} ---> OPTIONS
  if not fileExists("MushroomsRide.dat") then
    showConsole()
    error("\nERROR: File 'MushroomsRide.dat' not found")
  end
  local zip = Zip("MushroomsRide.dat")
  ALL.showSplashImage(zip)
  ALL.playSoundtrack(zip,"soundtrack.mid",MENU.GUI)
  setTitle(" M U S H R O O M ' S   R I D E")
  MENU.createLogo(zip)
  MENU.createTexts()
  ----SCENERY
    ----CAMERA----
  setAmbient(0.5,0.5,0.5)
  local camera = {angleOfView = 60, nearClip = .5, farClip = 1000}
  setPerspective(camera.angleOfView, camera.nearClip, camera.farClip)
  local theCamera = getCamera()
  theCamera:reset()
  theCamera:move(0,2,-12)
    ----FADER----
  faderAlpha = 1
  fader = OverlayFader(1,1,1)
  fader:setLayer(1)
  addToOverlay(fader)
  ----SKYBOX----
  enableFog(500, 0.5,0.5,0.75)
  local skyTxt = {
    zip:getTexture("blue_top.jpg"),
    zip:getTexture("blue_left.jpg"),
    zip:getTexture("blue_front.jpg"),
    zip:getTexture("blue_right.jpg"),
    zip:getTexture("blue_back.jpg"),
  }
  local sky = MirroredSky(skyTxt)
  setBackground(sky)
    ----SUN----
  local sun = Sun(
    zip:getTexture("light.jpg"),0.25,
    0,.41,.91,
    zip:getTexture("lensflares.png"),
    4,0.2,500
  )
  setSun(sun)
  ----TERRAIN----
  local terrainMaterial = Material()
  terrainMaterial:setAmbient(0.4,0.4,0.4)
  terrainMaterial:setDiffuse(1,1,1)
  terrainMaterial:setDiffuseTexture(zip:getTexture("snow.jpg",1))
  local terrain = FlatTerrain(terrainMaterial,2000,300)
  terrain:setReflective()
  terrain:setShadowed()
  terrain:setShadowIntensity(0.5)
  terrain:setShadowOffset(0.01)
  setTerrain(terrain)
    ----MODELS----
  animationTimers = {}
  models = {}
  for ct = 1, 6 do
    local textureName
    if ct%2 == 0 then
      textureName = "faerie.jpg"
    else
      textureName = "faerie2.jpg"
    end
    models[ct] = ALL.createModel(zip,
      "faerie.md2",textureName,
      0,1,0, 1, 0)
    local ang = ct*1.047
    local posX, posZ = 7*math.sin(ang), 7*math.cos(ang)
    models[ct]:rotStanding(-1.5708)
    models[ct]:rotStanding(ang)
    models[ct]:move(posX,0,posZ)
    animationTimers[ct] = math.random(5,10)
  end
  local mush = zip:getMeshes("mushroom.3ds")
  for ct = 1, 10 do
    local r = math.random()*3+3
    local a = math.random()*6.2832
    local posX, posZ = r*math.sin(a), r*math.cos(a)
    ALL.cloneObjects(mush, posX,posZ)
  end
  mush:delete()
  ----SCENERY (END)
  MENU.setupPointer(zip)
  MENU.setupHelp()
  zip:delete()
end

----FINALIZATION----

function MENU.final()
  ALL.stopSoundtrack(MENU.GUI)
  faderAlpha = nil
  fader = nil
  models = nil
  animationTimers = nil
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
    if key == key0+1 then
      releaseKey(key)
      setScene(Scene(GAME.init,GAME.update,GAME.final,GAME.keyDown))
    elseif key == key0 then
      releaseKey(key)
      hidePointer()
      MENU.GUI.mode = 0 ---> Instructions
      MENU.GUI.optionsTexts:hide()
      MENU.GUI.logoSprite:hide()
      MENU.GUI.credits.texts[MENU.GUI.credits.index]:hide()
      MENU.GUI.instructionTexts:show()
      MENU.GUI.overlayPoly:show()
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
      MENU.GUI.overlayPoly:hide()
    end
  elseif MENU.GUI.mode == 1 then
    releaseKey(key)
    MENU.GUI.mode = -1
    showPointer()
    MENU.GUI.optionsTexts:show()
    MENU.GUI.logoSprite:show()
    MENU.GUI.credits.texts[MENU.GUI.credits.index]:show()
    MENU.GUI.instructionTexts:hide()
    MENU.GUI.overlayPoly:hide()
    getCamera():moveForward(1.5)
    faderAlpha = 1
    fader:setColor(1,1,1,1)
    for ct = 1, table.getn(models) do
      models[ct]:hide()
    end
  end
end

----UPDATE----

function MENU.update()
  local timeStep = getTimeStep()
  if timeStep > 0.1 then timeStep = 0.1 end
  if faderAlpha ~= 0 then
    faderAlpha = faderAlpha-timeStep/2
    if faderAlpha < 0 then
      faderAlpha = 0
    end
    fader:setColor(1,1,1,faderAlpha)
  end
  local mode = MENU.GUI.mode
  local camera = getCamera()
  local rotAngle = .13*timeStep
  camera:rotAround(rotAngle)
  camera:pointTo(0,1.5,0)
  if mode == -1 then ---> OPTIONS
    MENU.animateLogo(timeStep)
    local dx, dy = getMouseMove()
    local w,h = getDimension()
    movePointer(dx,dy,w+16,h+8,8,8)
    local GUI = MENU.GUI
    local pointerX, pointerY = getPointerLocation()
    local text = GUI.optionsTexts:getTextAt(pointerX-8,pointerY-8)
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
    if models then
      for ct = 1, table.getn(models) do
        animationTimers[ct] = animationTimers[ct]-timeStep
        local stopped = models[ct]:getStoppedAnimation()
        if stopped ~= -1 then
          models[ct]:setAnimation(0)
        elseif animationTimers[ct] < 0 then
          animationTimers[ct] = math.random(5,10)
          local anim = math.random(7,11)
          models[ct]:setAnimation(anim)
        end
      end
    end    
  end
end

----
----EDITOR SCENE
----

----INITIALIZATION----
function EDITOR.init()
  ----ZIP----
  empty()
  emptyOverlay()
  if not fileExists("MushroomsRide.dat") then
    showConsole()
    error("\nERROR: File 'MushroomsRide.dat' not found")
  end
  local zip = Zip("MushroomsRide.dat")
  ALL.showSplashImage(zip)
  ----CAMERA----
  CAMERA = {isFree = true}
  setAmbient(0.5,0.5,0.5)
  setPerspective(60,1,250)
  local camera = getCamera()
  camera:reset()
  local CAM_X, CAM_Y, CAM_Z = 0,10,0
  camera:move(CAM_X,CAM_Y,CAM_Z)
  ----EDITOR----
  mapPosX = 0
  mapPosY = 0
  ----TERRAIN----
  local mapImage = Image("tiles.png")
  imageW, imageH = mapImage:getDimension()
  local material = Material()
  material:setDiffuseTexture(zip:getTexture("circleTextures64.jpg"))
  tiled = TiledTerrain(material,8,mapImage,50,8,16) 
  setTerrain(tiled)
  ----HELP----
  local help = {
    "T I L E D   T E R R A I N   E D I T O R",
    "",
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
function EDITOR.final()
  mapPosX = nil
  mapPosY = nil
  imageW = nil
  imageH = nil
  CAMERA = nil
  tiled = nil
  ----EMPTY WORLD----
  disableFog()
  empty()
  emptyOverlay()
end

----LOOP----
function EDITOR.update()
  local camera = getCamera()
  local timeStep = getTimeStep()
  if timeStep > 0.1 then timeStep = 0.1 end
  ----CAMERA CONTROL----
  local camX,camY,camZ
  if CAMERA.isFree then
    local speed = 10
    if isKeyPressed(38) then --> UP
      camera:moveStanding( speed*timeStep)
    elseif isKeyPressed(40) then --> DOWN
      camera:moveStanding(-speed*timeStep)
    end
    if isKeyPressed(37) then --> LEFT
      camera:moveSide( speed*timeStep)
    elseif isKeyPressed(39) then --> RIGHT
      camera:moveSide(-speed*timeStep)
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
    local h = 0
    if camY < h+5 then
      camY = h+5
    end
    camera:setPosition(camX,camY,camZ)
  end
end

----KEYDOWN----
function EDITOR.keyDown(key)
  if key == string.byte("W") then
    getCamera():move(0,0,50/8)
    mapPosY = mapPosY+1
    if mapPosY >= imageH then
      mapPosY = 0
    end
  elseif key == string.byte("Z") then
    getCamera():move(0,0,-50/8)
    mapPosY = mapPosY-1
    if mapPosY < 0 then
      mapPosY = imageH-1
    end
  elseif key == string.byte("A") then
    getCamera():move(50/8,0,0)
    mapPosX = mapPosX+1
    if mapPosX >= imageW then
      mapPosX = 0
    end
  elseif key == string.byte("S") then
    getCamera():move(-50/8,0,0)
    mapPosX = mapPosX-1
    if mapPosX < 0 then
      mapPosX = imageW-1
    end
  elseif key == string.byte("I") then
    local tileX, tileY, rot = tiled:getTileAtGrid(mapPosX,mapPosY)
    tileY = tileY+1
    if tileY >= 8 then
      tileY = 0
    end
    tiled:setTileAtGrid(mapPosX,mapPosY,tileX,tileY,rot)
  elseif key == string.byte("M") then
    local tileX, tileY, rot = tiled:getTileAtGrid(mapPosX,mapPosY)
    tileY = tileY-1
    if tileY < 0 then
      tileY = 7
    end
    tiled:setTileAtGrid(mapPosX,mapPosY,tileX,tileY,rot)
  elseif key == string.byte("J") then
    local tileX, tileY, rot = tiled:getTileAtGrid(mapPosX,mapPosY)
    tileX = tileX-1
    if tileX < 0 then
      tileX = 7
    end
    tiled:setTileAtGrid(mapPosX,mapPosY,tileX,tileY,rot)
  elseif key == string.byte("K") then
    local tileX, tileY, rot = tiled:getTileAtGrid(mapPosX,mapPosY)
    tileX = tileX+1
    if tileX >= 8 then
      tileX = 0
    end
    tiled:setTileAtGrid(mapPosX,mapPosY,tileX,tileY,rot)
  elseif key == string.byte("R") then
    local tileX, tileY, rot = tiled:getTileAtGrid(mapPosX,mapPosY)
    rot = rot+1
    if rot >= 4 then
      rot = 0
    end
    tiled:setTileAtGrid(mapPosX,mapPosY,tileX,tileY,rot)
  elseif key == string.byte(" ") then
    local image = tiled:getImageFromTiles()
    image:saveAsPng("tiles.png")
  elseif key == string.byte("\r") then
    setScene(Scene(MENU.init,MENU.update,MENU.final,MENU.keyDown))
  end
end

----
----GAME SCENE
----

----HUD SUPPORT----

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
  HUD.highestHud = {}
  setupScore(HUD.highestHud,6,-160,texture,0,0,0.5,0.25)
  HUD.scoreHud = {}
  setupScore(HUD.scoreHud,6,0,texture,0.5,0,1,0.25)
  HUD.timeHud = {}
  setupScore(HUD.timeHud,3,160,texture,0.5,0.25,1,0.5)
  HUD.highest = 0
  if fileExists("hiscore.txt") then
    local file = ReadableTextFile("hiscore.txt")
    if file then
      local read = file:read()
      HUD.highest = tonumber(read)
      file:close()
    end
  end
  HUD.score = 0
  HUD.maxTime = 134
  HUD.time = HUD.maxTime
  GAME.setHudValue(HUD.highestHud,6,HUD.highest)
  GAME.setHudValue(HUD.scoreHud,6,HUD.score)
  GAME.setHudValue(HUD.timeHud,3,HUD.time)
end

function GAME.incScore(score)
  HUD.score = HUD.score+score
  GAME.setHudValue(HUD.scoreHud,6,HUD.score)
  if HUD.score > HUD.highest then
    HUD.highest = HUD.score
    GAME.setHudValue(HUD.highestHud,6,HUD.highest)
  end
  return HUD.score
end

function GAME.decTime(val)
  HUD.time = HUD.time-val
  GAME.setHudValue(HUD.timeHud,3,HUD.time)
  return HUD.time
end

----INITIALIZATION----

function GAME.compX(obj1,obj2)
  local x1,y1,z1 = obj1:getPosition()
  local x2,y2,z2 = obj2:getPosition()
  return x1 < x2
end

function GAME.init()
  ----ZIP----
  empty()
  emptyOverlay()
  if not fileExists("MushroomsRide.dat") then
    showConsole()
    error("\nERROR: File 'MushroomsRide.dat' not found")
  end
  local zip = Zip("MushroomsRide.dat")
  ALL.playSoundtrack(zip,"soundtrack.mid",GAME)
  ---HUD---
  HUD = {}
  GAME.setupHuds(zip)
  ----FADER----
  faderAlpha = 1
  fader = OverlayFader(1,1,1)
  fader:setLayer(1)
  addToOverlay(fader)
  ----CAMERA----
  setAmbient(0.5,0.5,0.5)
  setPerspective(60,1,100)
  local camera = getCamera()
  camera:reset()
  camera:move(-12.5,25,0)
  camera:pointTo(0,0,0)
  ----SUN----
  sun = Sun(zip:getTexture("light.jpg"),0.15, 0.5,0.707,-0.5)
  sun:setColor(1,1,1)
  setSun(sun)
  ----TERRAIN----
  local mapImage = zip:getImage("tiles.png")
  local material = Material()
  material:setDiffuseTexture(zip:getTexture("circleTextures64.jpg"))
  tiled = TiledTerrain(material,8,mapImage,50,8,-1) 
  tiled:setShadowOffset(0.05)
  tiled:setShadowIntensity(0.5)
  tiled:setShadowed()
  setTerrain(tiled)
  ----AVATAR----
  fairyAnimation = 1
  fairyTimer = 5
  fairy = ALL.createModel(zip,
    "faerie.md2","faerie.jpg",
    0,2,0, 2, 9)
  fairy:rotStanding(-1.5708)
  ----CUBES----
  cubes = {}
  local cube = ALL.createCube(zip, 3, "cube.jpg", 0,0)
  for ct = 1, 25 do
    local posX = math.random()*100-50
    local offY = math.random()*0.5+2
    local posZ = math.random()*100-50
    cubes[ct] = ALL.cloneCube(cube, posX,2+offY,posZ)
  end
  removeObject(cube)
  table.sort(cubes,GAME.compX)
  ----MUSHES----
  mushes = {}
  chain = {}
  ups = {}
  local mush = zip:getMeshes("mushroom.3ds")
  for ct = 1, 100 do
    local posX = math.random()*100-50
    local posZ = math.random()*100-50
    mushes[ct] = ALL.cloneObjects(mush, posX,posZ)
  end
  removeObject(mush)
  table.sort(mushes,GAME.compX)
  ----HELP----
  local help = {
    "M U S H R O O M ' S   R I D E",
    "",
    "[ ARROW ] Move Fairy",
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
  ALL.stopSoundtrack(GAME)
  sun = nil
  tiled = nil
  HUD = nil
  cubes = nil
  mushes = nil
  chain = nil
  ups = nil
  fairy = nil
  fairyAnimation = nil
  oldKey = nil
  faderAlpha = nil
  fader = nil
  ----EMPTY WORLD----
  disableFog()
  empty()
  emptyOverlay()
end

----LOOP----
function GAME.rotFairy(angle)
  local x,y,z = fairy:getPosition()
  fairy:reset()
  fairy:setPosition(x,y,z)
  fairy:pitch(-1.5708)
  fairy:rotStanding(angle)
  fairyAnimation = 1
  fairy:setAnimation(1)
end

function GAME.update()
  local camera = getCamera()
  local timeStep = getTimeStep()
  if timeStep > 0.1 then timeStep = 0.1 end
  ----SUN----
  local sunAng = (HUD.time+30)*3.1415/(HUD.maxTime+60)
  local sunInc = 3.1415/4
  local dirX = math.sin(sunAng)*math.sin(sunInc)
  local dirY = math.sin(sunAng)*math.cos(sunInc)
  local dirZ = math.cos(sunAng)
  sun:setDirection(dirX,dirY,dirZ)
  ----FADER----
  if faderAlpha > 0 then
    faderAlpha = faderAlpha-timeStep/8
    if faderAlpha < 0 then
      faderAlpha = 0
    end
    fader:setColor(0,0,0,faderAlpha)
  end
  ----TIMER----
  if GAME.decTime(timeStep) < 0 then
    if HUD.score >= HUD.highest then
      HUD.highest = HUD.score
      local file = WritableTextFile("hiscore.txt")
      if file then
        file:write(string.format("%d",HUD.score))
        file:close()
      end
    end
    GAME.final()
    GAME.init()
  end
  ----AVATAR CONTROL----
  local cX, cY, cZ = camera:getPosition()
  local step = 20*timeStep
  if isKeyPressed(37) then ---> KEY_LEFT
    if isKeyPressed(38) then ---> KEY_UP
      if oldKey ~= 37+38 then
        oldKey = 37+38
        GAME.rotFairy(3.1415/4)
      end
    elseif isKeyPressed(40) then ---> KEY_DOWN
      if oldKey ~= 37+40 then
        oldKey = 37+40
        GAME.rotFairy(3.1415*3/4)
      end
    else
      if oldKey ~= 37 then
        oldKey = 37
        GAME.rotFairy(3.1415/2)
      end
    end
    fairy:moveSide(step)
  elseif isKeyPressed(39) then ---> KEY_RIGHT
    if isKeyPressed(38) then ---> KEY_UP
      if oldKey ~= 39+38 then
        oldKey = 39+38
        GAME.rotFairy(-3.1415/4)
      end
    elseif isKeyPressed(40) then ---> KEY_DOWN
      if oldKey ~= 39+40 then
        oldKey = 39+40
        GAME.rotFairy(-3.1415*3/4)
      end
    else
      if oldKey ~= 39 then
        oldKey = 39
        GAME.rotFairy(-3.1415/2)
      end
    end
    fairy:moveSide(step)
  elseif isKeyPressed(38) then ---> KEY_UP
    if oldKey ~= 38  then
      oldKey = 38
      GAME.rotFairy(0)
    end
    fairy:moveSide(step)
  elseif isKeyPressed(40) then ---> KEY_DOWN
    if oldKey ~= 40 then
      oldKey = 40
      GAME.rotFairy(3.1415)
    end
    fairy:moveSide(step)
  else
    if oldKey ~= 0 then
      oldKey = 0
      fairyTimer = math.random(5,10)
      fairyAnimation = 0
      fairy:setAnimation(0)
    else
      fairyTimer = fairyTimer-timeStep
      local stopped = fairy:getStoppedAnimation()
      if stopped ~= -1 then
        fairy:setAnimation(0)
      elseif fairyTimer < 0 then
        fairyTimer = math.random(5,10)
        local anim = math.random(7,11)
        fairy:setAnimation(anim)
      end    
    end
  end
  local x,y,z = fairy:getPosition()
  for ct = 1,#cubes do
    local cubeX,cubeY,cubeZ = cubes[ct]:getPosition()
    local diffX = cubeX-x
    if diffX > -4 then
      if diffX > 4 then
        break
      end
      local diffZ = cubeZ-z
      if diffZ > -4 and diffZ < 4 then
        if math.abs(diffX) > math.abs(diffZ) then
          if diffX > 0 then
            diffX = diffX-4
          else
            diffX = 4+diffX
          end
          x = x-diffX
          fairy:move(diffX,0,0)
        else
          if diffZ > 0 then
            diffZ = diffZ-4
          else
            diffZ = 4+diffZ
          end
          z = z-diffZ
          fairy:move(0,0,diffZ)
        end
      end
    end
  end
  for ct = 1,#mushes do
    local mushX,mushY,mushZ = mushes[ct]:getPosition()
    local diffX = mushX-x
    if diffX > -2 then
      if diffX > 2 then
        break
      end
      local diffZ = mushZ-z
      if diffZ > -2 and diffZ < 2 then
        mush = table.remove(mushes,ct)
        table.insert(chain,mush)
        table.insert(ups,0)
        GAME.incScore(1)
        break
      end
    end
  end
  local chainLen = #chain
  if chainLen > 0 then
    local mush = chain[1]
    local mx,my,mz = mush:getPosition()
    local upspeed = ups[1]
    if upspeed ~= 0 then
      upspeed = upspeed-100*timeStep
      local up = my+upspeed*timeStep
      if up < 0 then
        ups[1] = 0
        up = 0
      else
        ups[1] = upspeed
      end
      mush:setPosition(mx,up,mz)
    end
    local dx,dz = x-mx,z-mz
    local dist2 = dx*dx+dz*dz
    if dist2 > 4 then
      if ups[1] == 0 then
        ups[1] = 15
      end
      local invDist = 1/math.sqrt(dist2)
      mush:move(step*dx*invDist,0,step*dz*invDist)
    end
    for ct = 2,chainLen do
      local target = chain[ct-1]
      local tx,ty,tz = target:getPosition()
      local mush = chain[ct]
      local mx,my,mz = mush:getPosition()
      local upspeed = ups[ct]
      if upspeed ~= 0 then
        upspeed = upspeed-100*timeStep
        local up = my+upspeed*timeStep
        if up < 0 then
          ups[ct] = 0
          up = 0
        else
          ups[ct] = upspeed
        end
        mush:setPosition(mx,up,mz)
      end
      local dx,dz = tx-mx,tz-mz
      local dist2 = dx*dx+dz*dz
      if dist2 > 4 then
        if ups[ct] == 0 then
          ups[ct] = 15
        end
        local invDist = 1/math.sqrt(dist2)
        mush:move(step*dx*invDist,0,step*dz*invDist)
      end
    end
  end
  if z < cZ-10 then
    camera:move(0,0,-step)
  elseif z > cZ+10 then
    camera:move(0,0,step)
  end
  if x < cX+5 then
    camera:move(-step,0,0)
  elseif x > cX+25 then
    camera:move(step,0,0)
  end
end

----KEYDOWN----
function GAME.keyDown(key)
  if key == 13 then ---> ENTER or SPACE
    if HUD.score >= HUD.highest then
      HUD.highest = HUD.score
      local file = WritableTextFile("hiscore.txt")
      if file then
        file:write(string.format("%d",HUD.score))
        file:close()
      end
    end
--    setScene(Scene(MENU.init,MENU.update,MENU.final,MENU.keyDown))
  elseif key == string.byte("M") then ---> M
    releaseKey(key)
    if GAME.soundTrackIsPlaying then
      GAME.soundTrack:stop()
      GAME.soundTrackIsPlaying = false
    else
      GAME.soundTrack:play()
      GAME.soundTrackIsPlaying = true
    end
  end
end

----SCENE SETUP----
setScene(Scene(MENU.init,MENU.update,MENU.final,MENU.keyDown))
--setScene(Scene(GAME.init,GAME.update,GAME.final,GAME.keyDown))
--setScene(Scene(EDITOR.init,EDITOR.update,EDITOR.final,EDITOR.keyDown))
