--[[
       D R A G O N ' S   R I D E

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
  soundTrack:setVolume(16)
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

function ALL.createModelAndWeapon(
  zip,modelMD2,modelTXT,weaponMD2,weaponTXT,posX,posY,posZ,scale,anim
)
  local weapon = ALL.createModel(zip,weaponMD2,weaponTXT,posX,posY,posZ,scale,anim)
  local model = ALL.createModel(zip,modelMD2,modelTXT,posX,posY,posZ,scale,anim)
  return model,weapon
end

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

function ALL.cloneModelAndWeapon(model,weapon,zip,modelTXT,posX,posY,posZ)
  local weapon2 = ALL.cloneModel(weapon,nil,nil,posX,posY,posZ)
  local model2 = ALL.cloneModel(model,zip,modelTXT,posX,posY,posZ)
  return model2, weapon2
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
      1, "D R A G O N ' S   R I D E",
      2, "",
      2, "D E M O",
      2, "",
      3, "Copyright \184 2006",
      2, "Leonardo Boselli",
      2, ""
    },
    {
      1, "Programming & Design",
      2, "Leonardo \"leo\" Boselli",
      3, "tetractys@users.sf.net",
      2, "",
      1, "3D Models",
      2, "Michael \"Magarnigal\" Mellor",
      3, "mmellor@tantalus.com.au",
      2, "Brian \"EvilBastard\" Collins",
      3, "brian@zono.com",
      2, "James Green",
      3, "james@perilith.com",
      2, "\"Hunter\"",
      3, "Hunter@Polycount.com",
      2, "",
      1, "Tiled Textures",
      3, "http://lostgarden.com",
    },
    {
      3, "Thanks to",
      3, "",
      2, "Michael \"Magarnigal\" Mellor",
      3, "for creating the models",
      1, "Dragon-Knight & Ogro",
      3, "",
      2, "Brian \"EvilBastard\" Collins",
      3, "for creating the models",
      1, "Hueteotl & Bauul",
    },
    {
      3, "Thanks to",
      3, "",
      2, "James Green",
      3, "for creating",
      1, "PKnight",
      3, "",
      2, "\"Hunter\"",
      3, "for creating",
      1, "Hobgoblin",
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
    2, "D R A G O N ' S   R I D E",
    3, "",
    1, "A dragon without wings? Yes, dragons were difficult to be",
    1, "trained so northern armies used to clip dragon's wings to",
    1, "control them better, in fact knights were more interested",
    1, "in the capability of dragons to spit fire than in flying.",
    3, "",
    1, "In this demo you can ride a dragon to fight against hordes",
    1, "of evil creatures: ogres, hueteotls, hobgoblins, renegades",
    1, "and bauuls.                                               ",
    3, "",
    1, " The demo was created in less than one week with the help ",
    1, "of my 3D engine (APOCALYX) and free resources available on",
    1, "internet, so it is quite basic in functionalities, but I'm",
    1, "looking for help to improve it with more levels, textures,",
    1, "enemies, weapons, powerups and all the other stuff needed ",
    1, "to make it an amusing SHMUP :)",
    3, "",
    2, "Use arrows keys to move the dragon and hit space to fire,",
    2, "avoid to collide running enemies to preserve your health,",
    2, " charge standing enemies or fire them to increase score. ",
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
  playText = OverlayText("[2] Play          ")
  playText:setScale(scale)
  playText:setColor(1,1,0)
  playText:setLocation(0,offset)
  optionsTexts:add(playText)
  offset = offset+fontH*2
  playText = OverlayText("[1] Gallery       ")
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
    "D R A G O N ' S   R I D E",
    " ",
    "[  0  ] Instructions",
    "[  1  ] Gallery",
    "[  2  ] Play",
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
  if not fileExists("DragonsRide.dat") then
    showConsole()
    error("\nERROR: File 'DragonsRide.dat' not found")
  end
  local zip = Zip("DragonsRide.dat")
  ALL.showSplashImage(zip)
  ALL.playSoundtrack(zip,"intro.mid",MENU.GUI)
  setTitle(" D R A G O N ' S   R I D E")
  MENU.createLogo(zip)
  MENU.createTexts()
  ----SCENERY
    ----CAMERA----
  setAmbient(0.5,0.5,0.5)
  local camera = {angleOfView = 60, nearClip = .5, farClip = 1000}
  setPerspective(camera.angleOfView, camera.nearClip, camera.farClip)
  local theCamera = getCamera()
  theCamera:reset()
  theCamera:move(0,2,-10)
    ----FADER----
  faderAlpha = 1
  fader = OverlayFader(1,1,1)
  fader:setLayer(1)
  addToOverlay(fader)
  ----SKYBOX----
  enableFog(500, .5,.5,.75)
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
  local modelNames = {"pknight","hueteotl","bauul","hobgoblin","ogro"}
  animationTimers = {}
  models = {}
  weapons = {}
  for ct = 1, table.getn(modelNames) do
    local name = modelNames[ct]
    models[ct], weapons[ct] = ALL.createModelAndWeapon(zip,
      name..".md2",name..".jpg",
      name.."_weapon.md2",name.."_weapon.jpg",
      0,1,0, 1, 0)
    local ang = ct*1.047
    local posX, posZ = 6*math.sin(ang), 6*math.cos(ang)
    models[ct]:rotStanding(-1.5708)
    models[ct]:rotStanding(ang)
    models[ct]:hide()
    models[ct]:move(posX,0,posZ)
    weapons[ct]:rotStanding(-1.5708)
    weapons[ct]:rotStanding(ang)
    weapons[ct]:hide()
    weapons[ct]:move(posX,0,posZ)
    animationTimers[ct] = math.random(5,10)
  end
  dragon,knight = ALL.createModelAndWeapon(zip,
    "dragonknight_dragon.md2","dragonknight_armour.jpg",
    "dragonknight_knight.md2","dragonknight_knight.jpg",
    0,2,0, 2, 0)
  dragon:rotStanding(-1.5708)
  knight:rotStanding(-1.5708)
  dragonAnimationTimer = 10
  dragonAnimation = 0
    ----FIRE----
  local fireImage = zip:getImage("smoke.png")
  fireImage:convertTo111A()
  local fireTexture = Texture(fireImage)
  fireImage:delete()
  fireEmitter = Emitter(30,1,4)
  fireEmitter:setTexture(fireTexture,1)
  fireEmitter:setVelocity(0,0,0, 0)
  fireEmitter:setColor(1,0.7,0,1, 0,0,0,0)
  fireEmitter:setSize(0.2,1)
  fireEmitter:setGravity(0,0,0, 0,10,0)
  fireEmitter:reset()
  addObject(fireEmitter)
  fireEmitter2 = Emitter(15,0.5,4)
  local lightImage = zip:getImage("light.jpg")
  lightImage:convertTo111A()
  local lightTexture = Texture(lightImage)
  lightImage:delete()
  fireEmitter2:setTexture(lightTexture,1)
  fireEmitter2:setVelocity(0,0,0, 0)
  fireEmitter2:setColor(1,1,0,1, 1,0,0,0)
  fireEmitter2:setSize(0.5,0.1)
  fireEmitter2:setGravity(0,0,0, 0,0,0)
  fireEmitter2:setRadius(0,0.5)
  fireEmitter2:setAngularSpeed(25,25)
  fireEmitter2:reset()
  addObject(fireEmitter2)
    ----SOUNDS----
  local dragonSample = zip:getSample3D("jet.wav");
  dragonSample:setLooping(true)
  dragonSample:setVolume(64)
  dragonSample:setMinDistance(64)
  dragonSource = Source(dragonSample,dragon)
  addSource(dragonSource)
  local crashSample = zip:getSample3D("crash.wav");
  crashSample:setLooping(false)
  crashSample:setVolume(255)
  crashSample:setMinDistance(64)
  crashSource = Source(crashSample,dragon,false)
  addSource(crashSource)
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
  fireEmitter = nil
  fireEmitter2 = nil
  dragon, knight = nil, nil
  models = nil
  weapons = nil
  animationTimers = nil
  dragonAnimationTimer = nil
  dragonAnimation = nil
  dragonSource = nil
  crashSource = nil
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
    if key == key0+2 then
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
    elseif key == key0+1 then
      releaseKey(key)
      hidePointer()
      MENU.GUI.mode = 1 ---> Gallery
      MENU.GUI.optionsTexts:hide()
      MENU.GUI.logoSprite:hide()
      MENU.GUI.credits.texts[MENU.GUI.credits.index]:hide()
      MENU.GUI.instructionTexts:hide()
      MENU.GUI.overlayPoly:hide()
      getCamera():moveForward(-1.5)
      faderAlpha = 1
      fader:setColor(1,1,1,1)
      for ct = 1, table.getn(models) do
        models[ct]:show()
        weapons[ct]:show()
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
      weapons[ct]:hide()
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
  local x1, y1, z1 = dragon:getVertexCoord(137)
  local x2, y2, z2 = dragon:getVertexCoord(165)
  local x3, y3, z3 = dragon:getVertexCoord(160)
  local length2 = (x3-x2)*(x3-x2)+(y3-y2)*(y3-y2)+(z3-z2)*(z3-z2)
  local dragonVolume = length2*500
  if dragonVolume > 255 then
    dragonVolume = 255
  end
  local dragonSound = dragonSource:getSound3D()
  dragonSound:setVolume(dragonVolume)
  fireEmitter:setPosition(x2,y2,z2)
  local speed = length2*8
  local vx, vy, vz = (x2-x1)*speed,(y2-y1)*speed,(z2-z1)*speed
  fireEmitter:setVelocity(vx,vy,vz, 0.5)
  fireEmitter2:setPosition(x2,y2,z2)
  fireEmitter2:setVelocity(vx,vy,vz, 0.2)
  local posX,posY,posZ = dragon:getPosition()
  camera:pointTo(posX,posY,posZ)
  local stopped = dragon:getStoppedAnimation()
  if stopped ~= -1 then
    dragonAnimationTimer = 10
    if stopped == 7 then
      dragonAnimation = 9
      dragon:setAnimation(9)
      knight:setAnimation(9)
    else
      dragonAnimation = 0
      dragon:setAnimation(0)
      knight:setAnimation(0)
    end
  end
  if dragonAnimation == 9 and dragonAnimationTimer < 9.5 then
    dragonAnimation = 0
    local crashSound = crashSource:getSound3D()
    crashSound:play()
  end
  dragonAnimationTimer = dragonAnimationTimer-timeStep
  if dragonAnimationTimer < 0 then
    dragonAnimationTimer = 10
    dragonAnimation = math.random(7,12)
    dragon:setAnimation(dragonAnimation)
    knight:setAnimation(dragonAnimation)
  end
  if mode == -1 then ---> OPTIONS
    MENU.animateLogo(timeStep)
    local dx, dy = getMouseMove()
    movePointer(dx,dy,getDimension())
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
  elseif mode == 1 then ---> GALLERY
    for ct = 1, table.getn(models) do
      animationTimers[ct] = animationTimers[ct]-timeStep
      local stopped = models[ct]:getStoppedAnimation()
      if stopped ~= -1 then
        models[ct]:setAnimation(0)
        weapons[ct]:setAnimation(0)
      elseif animationTimers[ct] < 0 then
        animationTimers[ct] = math.random(5,10)
        local anim = math.random(7,11)
        models[ct]:setAnimation(anim)
        weapons[ct]:setAnimation(anim)
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
  if not fileExists("DragonsRide.dat") then
    showConsole()
    error("\nERROR: File 'DragonsRide.dat' not found")
  end
  local zip = Zip("DragonsRide.dat")
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
  imageW = 8
  imageH = 128
  ----TERRAIN----
  local mapImage = Image("tiles.png")
  local material = Material()
  material:setDiffuseTexture(zip:getTexture("circleTextures64.jpg"))
  tiled = TiledTerrain(material,8,mapImage,50,8,-1) 
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
  HUD.damageHud = {}
  setupScore(HUD.damageHud,3,160,texture,0.5,0.25,1,0.5)
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
  HUD.damage = 0
  GAME.setHudValue(HUD.highestHud,6,HUD.highest)
  GAME.setHudValue(HUD.scoreHud,6,HUD.score)
  GAME.setHudValue(HUD.damageHud,3,HUD.damage)
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

function GAME.incDamage(damage)
  HUD.damage = HUD.damage+damage
  GAME.setHudValue(HUD.damageHud,3,HUD.damage)
  return HUD.damage
end

----INITIALIZATION----
function GAME.init()
  ----ZIP----
  setListenerScale(1)
  empty()
  emptyOverlay()
  if not fileExists("DragonsRide.dat") then
    showConsole()
    error("\nERROR: File 'DragonsRide.dat' not found")
  end
  local zip = Zip("DragonsRide.dat")
  ALL.showSplashImage(zip)
  ALL.playSoundtrack(zip,"soundtrack.mid",GAME)
  ---HUD---
  HUD = {}
  GAME.setupHuds(zip)
  ----CAMERA----
  setAmbient(0.5,0.5,0.5)
  setPerspective(60,1,100)
  local camera = getCamera()
  camera:reset()
  camera:move(-20,40,0)
  camera:pointTo(0,0,0)
  ----SUN----
  local sun = Sun(zip:getTexture("light.jpg"),0.15, -0.5,0.707,-0.5)
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
  dragonAnimation = 1
  dragonShotCount = 0
  dragon,knight = ALL.createModelAndWeapon(zip,
    "dragonknight_dragon.md2","dragonknight_armour.jpg",
    "dragonknight_knight.md2","dragonknight_knight.jpg",
    0,2,0, 2, dragonAnimation)
  dragon:rotStanding(-1.5708)
  knight:rotStanding(-1.5708)
  dragonAtLeft = false
  ----MODELS----
  modelNames = {"hueteotl","pknight","ogro","hobgoblin","bauul"}
  originalModels = {}
  originalWeapons = {}
  for ct = 1, table.getn(modelNames) do
    local name = modelNames[ct]
    originalModels[ct], originalWeapons[ct] = ALL.createModelAndWeapon(zip,
      name..".md2",name..".jpg",
      name.."_weapon.md2",name.."_weapon.jpg",
      0,2,0, 2, 0)
    originalModels[ct]:hide()
    originalWeapons[ct]:hide()
  end
  animationTimers = {}
  animations = {}
  models = {}
  weapons = {}
  for ct = 1, table.getn(modelNames)*2 do
    local index = math.floor((ct-1)/2+1)
    animations[ct] = 0
    models[ct], weapons[ct] = ALL.cloneModelAndWeapon(
      originalModels[index],
      originalWeapons[index],
      zip,nil, 0,2,0, 2
    )
    local ang = math.random(0,16)/16*6.28
    models[ct]:rotStanding(ang)
    local mZ = 50+math.random(0,5)+10*ct
    local mX = math.random(-19,31)
    models[ct]:setPosition(mX,2,mZ)
    weapons[ct]:rotStanding(ang)
    weapons[ct]:setPosition(mX,2,mZ)
    animationTimers[ct] = math.random(5,10)
  end
  ----SHOTS----
  local shotMaterial = Material()
  shotMaterial:setDiffuseTexture(zip:getTexture("fire.png"))
  shotMaterial:setEnlighted(false)
  shotMaterial:setEmissive(1,1,1)
  shots = {}
  for ct = 1, 5 do
    local object = AnimatedSprite(1.5,1.5,3,8,shotMaterial)
    object:setTransparent()
    addObject(object)
    object:hide()
    shots[ct] = object
  end
  ----HELP----
  local help = {
    "D R A G O N ' S   R I D E",
    "",
    "[ ARROW ] Move Around",
    "[ SPACE ] Spit Fire",
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
  tiled = nil
  HUD = nil
  shots = nil
  dragon, knight = nil, nil
  dragonShotCount = nil
  dragonAnimation = nil
  modelNames = nil
  originalModels = nil
  originalWeapons = nil
  models = nil
  weapons = nil
  animations = nil
  animationTimers = nil
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
  ----CAMERA CONTROL----
  if dragonAnimation ~= 17 then
    camera:moveSide(-20*timeStep)
  end
  ----AVATAR CONTROL----
  local cX, cY, cZ = camera:getPosition()
  if dragonAnimation ~= 17 then
    local stopped = dragon:getStoppedAnimation()
    if stopped ~= -1 then
      dragonAnimation = 1
      dragon:setAnimation(1)
      knight:setAnimation(1)
    end
    local step = 20*timeStep
    dragon:moveSide(step)
    knight:moveSide(step)
    if isKeyPressed(37) then ---> KEY_LEFT
      if dragonAnimation == 1 and not dragonAtLeft then
        dragonAnimation = 13
        dragon:setAnimation(13)
        knight:setAnimation(13)
      end
      local step = -15*timeStep
      dragon:moveSide(step)
      knight:moveSide(step)
      if isKeyPressed(38) then ---> KEY_UP
        local step = 5*timeStep
        dragon:moveUp(step)
        knight:moveUp(step)
      elseif isKeyPressed(40) then ---> KEY_DOWN
        local step = -5*timeStep
        dragon:moveUp(step)
        knight:moveUp(step)
      end
    elseif isKeyPressed(39) then ---> KEY_RIGHT
      local step = 15*timeStep
      dragon:moveSide(step)
      knight:moveSide(step)
      if isKeyPressed(38) then ---> KEY_UP
        local step = 20*timeStep
        dragon:moveUp(step)
        knight:moveUp(step)
      elseif isKeyPressed(40) then ---> KEY_DOWN
        local step = -20*timeStep
        dragon:moveUp(step)
        knight:moveUp(step)
      end
    else
      if isKeyPressed(38) then ---> KEY_UP
        local step = 15*timeStep
        dragon:moveUp(step)
        knight:moveUp(step)
      elseif isKeyPressed(40) then ---> KEY_DOWN
        local step = -15*timeStep
        dragon:moveUp(step)
        knight:moveUp(step)
      end
      if dragonAnimation == 13 then
        dragonAnimation = 1
        dragon:setAnimation(1)
        knight:setAnimation(1)
      end
    end
    local dX, dY, dZ = dragon:getPosition()
    dragonShotCount = dragonShotCount-timeStep
    if isKeyPressed(32) and dragonShotCount < 0 then ---> 1
      dragonShotCount = 0.25
      for ct = 1, table.getn(shots) do
        local obj = shots[ct]
        if not obj:isVisible() then
          obj:show()
          obj:setPosition(dX,1.5,dZ+3)
          break
        end
      end
    end
    for ct = 1, table.getn(shots) do
      local obj = shots[ct]
      if obj:isVisible() then
        local x,y,z = obj:getPosition()
        z = z+timeStep*40
        if z-cZ > 50 then
          obj:hide()
        else
          obj:setPosition(x,y,z+timeStep*40)
        end
      end
    end
    local diffZ = dZ-cZ
    if diffZ < -25 then
      dragonAtLeft = true
      if dragonAnimation == 13 then
        dragonAnimation = 1
        dragon:setAnimation(1)
        knight:setAnimation(1)
      end
      dragon:setPosition(dX,dY,cZ-25)
      knight:setPosition(dX,dY,cZ-25)
    else
      dragonAtLeft = false
      if diffZ > 25 then
        dragon:setPosition(dX,dY,cZ+25)
        knight:setPosition(dX,dY,cZ+25)
      end
    end
    if dX < -19 then
      dragon:setPosition(-19,dY,dZ)
      knight:setPosition(-19,dY,dZ)
    elseif dX > 31 then
      dragon:setPosition(31,dY,dZ)
      knight:setPosition(31,dY,dZ)
    end
  end
  local dX, dY, dZ = dragon:getPosition()
  ----MODELS CONTROL----
  for ct = 1, table.getn(models) do
    local mX, mY, mZ = models[ct]:getPosition()
    diffZ = mZ-cZ
    if diffZ < -50 then
      animations[ct] = 0
      models[ct]:setAnimation(0)
      weapons[ct]:setAnimation(0)
      mZ = cZ+50+math.random(0,10)
      mX = math.random(-19,31)
      models[ct]:setPosition(mX,mY,mZ)
      weapons[ct]:setPosition(mX,mY,mZ)
      local ang = math.random(0,16)/16*6.28
      models[ct]:rotStanding(ang)
      weapons[ct]:rotStanding(ang)
    end
    if animations[ct] < 16 then
      local diffX = dX-mX
      local diffZ = dZ-mZ
      local viewX, viewY, viewZ = models[ct]:getSideDirection()
      local dot = diffX*viewX+diffZ*viewZ
      if dot > 0 and mZ-cZ < 40 and dragonAnimation ~= 17 then
        if animations[ct] ~= 1 then
          animations[ct] = 1
          models[ct]:setAnimation(1)
          weapons[ct]:setAnimation(1)
        end
        models[ct]:moveSide(15*timeStep)
        weapons[ct]:moveSide(15*timeStep)
        local cross = diffX*viewZ-diffZ*viewX
        if cross > 0 then
          models[ct]:rotStanding(1.57*timeStep)
          weapons[ct]:rotStanding(1.57*timeStep)
        else
          models[ct]:rotStanding(-1.57*timeStep)
          weapons[ct]:rotStanding(-1.57*timeStep)
        end
      else
        if animations[ct] ~= 1 then
          animationTimers[ct] = animationTimers[ct]-timeStep
          local stopped = models[ct]:getStoppedAnimation()
          if stopped ~= -1 then
            animations[ct] = 0
            models[ct]:setAnimation(0)
            weapons[ct]:setAnimation(0)
          elseif animationTimers[ct] < 0 then
            animationTimers[ct] = math.random(5,10)
            animations[ct] = math.random(7,11)
            models[ct]:setAnimation(animations[ct])
            weapons[ct]:setAnimation(animations[ct])
          end
        else
          animations[ct] = 0
          models[ct]:setAnimation(0)
          weapons[ct]:setAnimation(0)
        end
      end
    end
  end
  ----SHOT HITS----
  for ct = 1, table.getn(shots) do
    local obj = shots[ct]
    if obj:isVisible() then
      local ox,oy,oz = obj:getPosition()
      for idx = 1, table.getn(models) do
        if animations[idx] < 16 then
          local ex,ey,ez = models[idx]:getPosition()
          local dx = ex-ox
          local dz = ez-oz
          local d2 = dx*dx+dz*dz
          if d2 < 2 then
            obj:hide()
            animations[idx] = math.random(16,19)
            models[idx]:setAnimation(animations[idx])
            weapons[idx]:setAnimation(0)
            local score = math.floor(idx/2)+1
            GAME.incScore(score)
          end
        end
      end
    end
  end
  ----DRAGON HITS----
  for idx = 1, table.getn(models) do
    if animations[idx] < 16 then
      local ex,ey,ez = models[idx]:getPosition()
      local dx = ex-dX
      local dz = ez-dZ
      local d2 = dx*dx+dz*dz
      if d2 < 16 then
        if animations[idx] == 1 then
          local damage = math.floor(idx/2)+1
          if GAME.incDamage(damage) >= 100 then
            if HUD.score >= HUD.highest then
              HUD.highest = HUD.score
              local file = WritableTextFile("hiscore.txt")
              if file then
                file:write(string.format("%d",HUD.score))
                file:close()
              end
            end
            dragonAnimation = 17
            dragon:setAnimation(17)
            knight:setAnimation(17)
            for ct = 1, table.getn(shots) do
              shots[ct]:hide()
            end
          end
        end
        animations[idx] = math.random(16,19)
        models[idx]:setAnimation(animations[idx])
        weapons[idx]:setAnimation(0)
        local score = math.floor(idx/2)+1
        GAME.incScore(score)
      end
    end
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
  end
end

----SCENE SETUP----
setScene(Scene(MENU.init,MENU.update,MENU.final,MENU.keyDown))
--setScene(Scene(GAME.init,GAME.update,GAME.final,GAME.keyDown))
--setScene(Scene(EDITOR.init,EDITOR.update,EDITOR.final,EDITOR.keyDown))
