-----------------------------------------------
-----------S U R E   A S   A   G U N-----------
---------A Simple Third Person Shooter---------
----Questions? Contact leo <boselli@uno.it>----
-----------------------------------------------

----MODULES----

MENU = {}
PLAY = {}
MODELS = {}
ALL = {}

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
  local txtNames = {"rt", "ft", "lf", "bk", "up", "dn"}
  local skyTxt = {}
  for txtIdx = 1, table.getn(txtNames) do
    skyTxt[txtIdx] = zip:getTexture("redrocksky_"..txtNames[txtIdx]..".jpg")
  end
  local sky = Sky(skyTxt)
  setBackground(sky)
end

function ALL.createSun(zip)
  local dir = 1.6
  local inc =  0.425
  local dirX = math.cos(inc)*math.cos(dir)
  local dirZ = math.cos(inc)*math.sin(dir)
  local dirY = math.sin(inc)
  local sun = {
    size = 0.3, distance = 11000, texture = zip:getTexture("sun.jpg"),
    dir = {x = dirX, y = dirY, z = dirZ},
    color = {r = 0.9, g = 0.5, b = 0.2},
    flares = {
      count = 5, size = 0.15, texture = zip:getTexture("lensflare.png")
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

ALL.cameraPositions = {
  {-7.29, 53.94, 199.89},
  {-4.50, 194.84, 119.69},
  {-692.23, 190.04, 72.92},
  {-1253.26, 179.76, 86.83},
  {-1355.56, 60.88, 295.14},
  {-2389.15, 164.94, -682.05},
  {-1899.00, 92.88, -1125.00},
  {-677.07, 175.12, -460.44},
  {-1203.47, 187.90, -1700.49},
  {-1551.02, 158.67, -1714.53},
  {-2662.79, 79.63, -1498.66},
  {-2561.59, 26.18, -2039.05},
  {-1855.09, 33.82, -2057.44},
  {-1353.11, 88.25, -2003.78},
  {-1417.29, 32.55, -1697.27},
  {-1731.89, 250.11, -2209.00},
  {-2618.09, 289.96, -1486.25},
  {-1264.63, 188.11, -307.24},
}

function ALL.cameraPositions.getPosition (index)
  local pos = ALL.cameraPositions[index]
  return pos[1], pos[2], pos[3]
end

function ALL.createLevel(zip)
  local bsp = zip:getLevel("durango.bsx",2)
  bsp:setShowTransparencies(true)
  bsp:setShowUntexturedMeshes()
  bsp:setShowUntexturedPatches()
  bsp:setDefaultTexture(
    zip:getTexture("textures/Wq3_stone/stone_bricks1.jpg",1)
  )
  bsp:setShadowsStatic()
  bsp:setShadowOffset(1)
  bsp:setShadowIntensity(1)
  setScenery(bsp)
  return bsp
end

------------------
----MENU SCENE----
------------------

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
  setPointerLocation(w/2,h/2)
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
  logoSprite:setLocation(w/2,h)
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
      2, "",
      1, "S U R E   A S   A   G U N",
      3, "Very Early Preview",
      2, "",
      3, "Copyright \184 2006",
      2, "Leonardo Boselli",
      1, "",
      3, "A Third Person Shooter",
      3, "in a Western Background",
      2, " ",
      2, " ",
      2, " ",
    },
    {
      1, "- Programming & Design -",
      3, "Leonardo \"leo\" Boselli",
      2, "tetractys@users.sf.net",
      1, "- Scenery & Models -",
      3, "Daniel \"spoon\" Hofmann",
      3, "Western Quake III MOD",
      2, "www.westernquake3.net",
      1, "- Original Soundtrack -",
      3, "\"The Happy Cowboy\"",
      3, "by Jim Paterson",
      2, "www.mfiles.co.uk",
      2, "",
      3, "These resources can't be",
      3, "used without the written",
      3, "consent of their authors",
    },
    {
      3, "This is a little tribute to",
      1, "the director Sergio Leone",
      3, "and his great movies.",
      3, "",
      3, "Among the models you can",
      3, "easily recognize unforgotten",
      3, "characters interpreted by",
      3, "Clint Eastwood, Eli Wallach",
      3, "and Lee Van Cleef in",
      1, "\"The Good, the Bad, the Ugly\"",
      3, "",
      3, "During duels you can also listen",
      3, "the notes of the \"Carillon\"",
      3, "by Ennio Morricone from",
      1, "\"For a Few Dollars More\"",
    },
    {
      3, "Thanks to",
      3, "",
      1, "ReD NeCKersoN and",
      1, "the \"WesternQ3\" Team",
      3, "for the authorization to use",
      3, "their great models and scenery",
      2, "",
      3, "To know more about the",
      3, "WQ3 MOD visit the site",
      3, "",
      2, "www.westernquake3.net",
      3, " ",
      3, " ",
    },
    {
      3, "Thanks to",
      3, "",
      1, "Matteo \"Fuzz\" Perenzoni",
      3, "",
      3, "for fruitful discussions on",
      3, "OpenGL and 3D programming.",
      3, "",
      3, "The sources of his demo for",
      3, "the NeHe's Apocalypse Contest",
      3, "were the first building blocks",
      3, "of the APOCALYX 3D Engine.",
      3, " ",
      3, " ",
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
      3, "",
      1, "ID Software",
      3, "for developing great FPS",
      3, "whose file formats were",
      3, "fundamental for this game"
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
      3, " ",
      3, " ",
      3, " ",
      3, " ",
      3, " ",
    }
  }
  local font = getMainOverlayFont()
  local fontH = font:getHeight()
  local w, h = getDimension()
  local x = w/2+160
  MENU.GUI.optionsTexts = OverlayTexts(font)
  local optionsTexts = MENU.GUI.optionsTexts
  local scale = 2
  local offset = fontH*2
  local playText
  playText = OverlayText("[2] Level  Preview")
  playText:setScale(scale)
  playText:setColor(1,1,0)
  playText:setLocation(0,offset)
  optionsTexts:add(playText)
  offset = offset+fontH*2
  playText = OverlayText("[1] Models Preview")
  playText:setScale(scale)
  playText:setColor(1,1,0)
  playText:setLocation(0,offset)
  optionsTexts:add(playText)
  optionsTexts:setLocation(w/2,h)
  addToOverlay(optionsTexts)
  MENU.GUI.credits = {}
  local credits = MENU.GUI.credits
  credits.status = 0
  credits.index = 1
  credits.texts = {}
  local creditTexts = credits.texts
  for creditIdx = 1, table.getn(creditStrings) do
    creditTexts[creditIdx] = OverlayTexts(font)
    local currentCreditText = creditTexts[creditIdx]
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

function MENU.setupCamera(bsp)
  setAmbient(0.3,0.3,0.3)
  local camera = {angleOfView = 60, nearClip = 3, farClip = 12000}
  setPerspective(camera.angleOfView, camera.nearClip, camera.farClip)
  local theCamera = getCamera()
  theCamera:reset()
  local GUI = MENU.GUI
  GUI.startIndex = math.random(1,table.getn(ALL.cameraPositions))
  theCamera:setPosition(ALL.cameraPositions.getPosition(GUI.startIndex))
end

function MENU.setupHelp()
  hideConsole()
  showHelpReduced()
  local help = {
    "S U R E   A S   A   G U N",
    "A Simple Third Person Shooter",
    "Questions? Contact leo <boselli@uno.it>",
    " ",
    "[ F 1 ] Show/Hide Help",
  }
  setHelp(help)
end

----INITIALIZATION----

function MENU.init()
  setTitle(" S U R E   A S   A   G U N")
  MENU.GUI = {}
  empty()
  emptyOverlay()
  local zip = Zip("SureAsAGun.dat")
  ALL.playSoundtrack(zip,"happyCowboy.mid",MENU.GUI)
  ALL.showSplashImage(zip)
  MENU.createLogo(zip)
  MENU.createCredits()
  ALL.createSkybox(zip)
  ALL.createSun(zip)
  local GUI = MENU.GUI
  GUI.bsp = ALL.createLevel(zip)
  MENU.setupCamera(GUI.bsp)
  MENU.setupPointer(zip)
  MENU.setupHelp()
  zip:delete()
  ----FADER----
  faderAlpha = 1
  fader = OverlayFader(1,1,1)
  fader:setLayer(1)
  addToOverlay(fader)
  countdown = 10
  collectgarbage("collect") -- without this call the demo crashes (!?!?!?)
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
  local markX = (w-320)/2
  local markY = (h+logoSize-480)/2
  local logoX, logoY = logoSprite:getLocation()
  if logoY > markY then
    logoY = logoY-timeStep*logoSpeedY
    if logoY < markY then
      logoY = markY
    end
    MENU.GUI.optionsTexts:setLocation(w/2,logoY+(h-logoSize)/2)
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

----UPDATE----

function MENU.update()
  local GUI = MENU.GUI
  local timeStep = getTimeStep()
  if timeStep > 0.1 then timeStep = 0.1 end
  if faderAlpha ~= 0 then
    faderAlpha = faderAlpha-timeStep/2
    if faderAlpha < 0 then
      faderAlpha = 0
    end
    fader:setColor(1,1,1,faderAlpha)
  end
  countdown = countdown-timeStep
  if countdown < 0 then
    countdown = 10
    faderAlpha = 1
    fader:setColor(1,1,1,1)
    GUI.startIndex = GUI.startIndex+1
    if GUI.startIndex > table.getn(ALL.cameraPositions) then
      GUI.startIndex = 1
    end
    getCamera():setPosition(ALL.cameraPositions.getPosition(GUI.startIndex))
  end
  MENU.rotateCamera(timeStep)
  MENU.animateLogo(timeStep)
  local dx, dy = getMouseMove()
  movePointer(dx,dy,getDimension())
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
      if MENU.GUI.selected == nil then
        MENU.GUI.selected = true
        MENU.keyDown(string.byte(text:getText(),2))
      end
    else
      MENU.GUI.selected = nil
    end
  elseif oldPointerText then
    oldPointerText:setColor(1,1,0)
    GUI.oldPointerText = nil
  end
end

----FINALIZATION----

function MENU.final()
  ALL.stopSoundtrack(MENU.GUI)
  hidePointer()
  emptyOverlay()
  empty()
  MENU.GUI = nil
  countdown = nil
  faderAlpha = nil
  fader = nil
end

----KEYBOARD----

function MENU.keyDown(key)
  if key == 13 then ---> KEY_RETURN
    releaseKey(13)
    MENU.final()
    dofile("main.lua")
    return
  elseif key == string.byte("1") then
    releaseKey(string.byte("1"))
    setScene(Scene(MODELS.init,MODELS.update,MODELS.final,MODELS.keyDown))
  elseif key == string.byte("2") then
    releaseKey(string.byte("2"))
    setScene(Scene(PLAY.init,PLAY.update,PLAY.final,PLAY.keyDown))
  end
end

------------------
----PLAY SCENE----
------------------

----INITIALIZATION SUPPORT----

function PLAY.setupCamera()
  setAmbient(0.3,0.3,0.3)
  local camera = {angleOfView = 60, nearClip = 3, farClip = 12000}
  setPerspective(camera.angleOfView, camera.nearClip, camera.farClip)
  local theCamera = getCamera()
  theCamera:set(PLAY.AVATAR.object)
end

function PLAY.setupScore(theScore,len,offset,texture,u0,v0,u1,v1)
  local w, h = getDimension()
  local w2, h2 = w/2, h/2
  local sw, sh = 64, 32
  local sw2, sh2 = sw/2, sh/2
  local nw, nh = 16, 16
  local nw2, nh2 = nw/2, nh/2
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

function PLAY.setScoreValue(theScore,value)
  local theString = string.format("%d",value)
  local len = string.len(theString) 
  for ct = 1, len do
    local byte = string.byte(theString,ct)-string.byte("0")
    local u, v = math.mod(byte,4)*0.25, math.floor(byte/4)*0.25
    theScore[len-ct+1]:setTextureCoord(u,0.75-v,u+0.25,1-v)
  end
end

function PLAY.setupScores(zip)
  local scoreImage = zip:getImage("numbers.png",0)
  local texture = Texture(scoreImage)
  scoreImage:delete()
  local AVATAR = PLAY.AVATAR
  local setupScore = PLAY.setupScore
  AVATAR.highestScore = {}
  setupScore(AVATAR.highestScore,5,-160,texture,0,0,0.5,0.25)
  AVATAR.scoreScore = {}
  setupScore(AVATAR.scoreScore,5,0,texture,0.5,0,1,0.25)
  AVATAR.damageScore = {}
  setupScore(AVATAR.damageScore,3,160,texture,0.5,0.25,1,0.5)
  if fileExists("hiscore.txt") then
    local file = ReadableTextFile("hiscore.txt")
    if file then
      local read = file:read()
      AVATAR.highest = tonumber(read)
      file:close()
    end
  end
  PLAY.setScoreValue(AVATAR.highestScore,AVATAR.highest)
  PLAY.setScoreValue(AVATAR.scoreScore,AVATAR.score)
  PLAY.setScoreValue(AVATAR.damageScore,AVATAR.damage)
end

function PLAY.setupHelp()
  hideHelp()
  hideConsole()
  local help = {
    "S U R E   A S   A   G U N",
    "A Third Person Shooter",
    "Questions? Contact leo <boselli@uno.it>",
    " ",
    "[   MOUSE  ] Look around",
    "[ L/R CLICK] Shoot Bullet/Grenade",
    "[  UP/DOWN ] Move Forward/Back",
    "[LEFT/RIGHT] Slide Left/Right",
    "[PRIOR/NEXT] Move Up/Down (when flying)",
    "[   SPACE  ] Fly/Follow Avatar",
    "[    +/-   ] Fast/Slow Motion",
    "[   PAUSE  ] Pause",
    "[   ENTER  ] Back to Menu",
    "[     1    ] Start Game",
    " ",
    "[F1] Show/Hide Help",
  }
  setHelp(help)
end

function PLAY.createEmitter(zip)
  local fireImage = zip:getImage("fire.png")
  fireImage:convertTo111A()
  local fireTexture = Texture(fireImage)
  fireImage:delete()
  PLAY.AVATAR.shotEmitter = Emitter(5,0.075,3)
  local shotEmitter = PLAY.AVATAR.shotEmitter
  shotEmitter:setTexture(fireTexture,1)
  shotEmitter:setVelocity(200,0,0, 0)
  shotEmitter:setColor(1,1,1,1, 1,0.5,0,0)
  shotEmitter:setSize(5,5)
  shotEmitter:setGravity(0,0,0, 0,0,0)
  shotEmitter:setOneShot()
  shotEmitter:reset()
  addObject(shotEmitter)
  shotEmitter:hide()
  fireTexture:delete()
end

function PLAY.createAvatar(zip,bsp,shadowTexture)
  PLAY.createEmitter(zip)
  local AVATAR = PLAY.AVATAR
  AVATAR.class = 0 ---> AVATAR
  AVATAR.alive = true
  AVATAR.score = 0
  AVATAR.highest = 0
  AVATAR.damage = 0
  AVATAR.flyModeActive = 0
  AVATAR.isRunning = 0
  AVATAR.isStrafing = 0
  AVATAR.linkReference = Reference()
  local legs = 9 ---> LEGS_IDLE
  AVATAR.legs = legs
  AVATAR.weapon = zip:getModel("peacemaker.mdx","peacemaker.jpg")
  local weapon = AVATAR.weapon
  AVATAR.object = zip:getBot("cowboy2.mdl")
  local avatar = AVATAR.object
  avatar:pitch(-1.5708)
  local startIndex = math.random(1,table.getn(ALL.cameraPositions))
  avatar:move(ALL.cameraPositions.getPosition(startIndex))
  avatar:getUpper():link("tag_weapon",weapon)
  avatar:setAnimationTime(0)
  avatar:setUpperAnimation(5) ---> TORSO_STAND
  avatar:setLowerAnimation(legs)
  addObject(avatar)
  addShadow(Shadow(avatar,28,28,shadowTexture))
  PLAY.SIM.OBJECTS[PLAY.SIM.MAX_ENEMIES*3+1] = AVATAR
  local boomSample = zip:getSample3D("dynExplosion.wav");
  AVATAR.boomSample = boomSample
  boomSample:setVolume(255)
  boomSample:setMinDistance(500)
  local shotSample = zip:getSample3D("peaceShot1.wav");
  AVATAR.shotSample = shotSample
  shotSample:setVolume(255)
  shotSample:setMinDistance(500)
  AVATAR.shotSource = Source(shotSample,avatar,false);
  local shotSource = AVATAR.shotSource
  addSource(shotSource)
  local runSound = zip:getSample3D("run.wav");
  runSound:setLooping(1)
  runSound:setVolume(255)
  runSound:setMinDistance(32)
  AVATAR.runSource = Source(runSound,avatar,false);
  local runSource = AVATAR.runSource
  addSource(runSource)
end

----INITIALIZATION----

function PLAY.init()
  PLAY.AVATAR = {}
  PLAY.SIM = {}
  local SIM = PLAY.SIM
  SIM.MAX_ENEMIES = 24
  SIM.ENEMIES = {}
  SIM.BULLETS = {}
  SIM.EXPLOSIONS = {}
  SIM.OBJECTS = {}
  SIM.timeMultiplier = 1
  SIM.aiElapsedTime = 0
  SIM.physicsElapsedTime = 0
  empty()
  emptyOverlay()
  setListenerScale(16)
  local zip = Zip("SureAsAGun.dat")
  ALL.playSoundtrack(zip,"carillon.mid",PLAY.SIM)
  ALL.showSplashImage(zip)
  ALL.createSkybox(zip)
  ALL.createSun(zip)
  PLAY.SIM.bsp = ALL.createLevel(zip)
  local bsp = PLAY.SIM.bsp
  local shadowImage = zip:getImage("shadow.png")
  shadowImage:convertTo111A()
  local shadowTexture = Texture(shadowImage)
  shadowImage:delete()
  PLAY.createAvatar(zip,bsp,shadowTexture)
  PLAY.setupScores(zip)
  PLAY.setupCamera()
  PLAY.setupHelp()
  zip:delete()
  VEL_Y = 0
end

----UPDATE SUPPORT----

function PLAY.rotateIfNeeded(timeStep)
  local avatar = PLAY.AVATAR.object
  local headAngle = avatar:getHead():getYawAngle()
  local upperAngle = avatar:getUpper():getYawAngle()
  local yawAngle = headAngle+upperAngle
  if yawAngle ~= 0 then
    local rotation = timeStep*3.1415
    if yawAngle > 0 then
      rotation = -rotation
    end
    avatar:rotStanding(-rotation)
    if headAngle ~= 0 then
      local newHeadAngle = headAngle+rotation
      if headAngle*newHeadAngle < 0 then
        avatar:getHead():setYawAngle(0)
        avatar:getUpper():addYawAngle(newHeadAngle-headAngle,1.047)
      else
        avatar:getHead():addYawAngle(rotation,1.5708)
      end
    else
      local diff = avatar:getUpper():addYawAngle(rotation,1.047)
      if diff ~= 0 then
        avatar:getHead():addYawAngle(diff,1.5708)
      end
    end
  end
end

----UPDATE----

function PLAY.update()
  local camera = getCamera()
  local AVATAR = PLAY.AVATAR
  local avatar = AVATAR.object
  local SIM = PLAY.SIM
  local ENEMIES = SIM.ENEMIES
  local BULLETS = SIM.BULLETS
  local EXPLOSIONS = SIM.EXPLOSIONS
  local OBJECTS = SIM.OBJECTS
  local bsp = SIM.bsp
  local timeStep = getTimeStep()
  local modelTimeStep
  if isPaused() then
    modelTimeStep = 0
  else
    modelTimeStep  = timeStep*SIM.timeMultiplier
    local animationTime = avatar:getAnimationTime()+modelTimeStep
    avatar:setAnimationTime(animationTime)
  end
  if avatar:getUpper():getStoppedAnimation() == 6 then ---> TORSO_ATTACK
    avatar:setUpperAnimation(5) ---> TORSO_STAND
  end
  if
    (isMouseLeftPressed() or isMouseRightPressed()) and
    (avatar:getUpperAnimation() ~= 6) and ---> TORSO_ATTACK
    AVATAR.alive
  then
    avatar:setUpperAnimation(6) ---> TORSO_ATTACK
    AVATAR.shotSource:getSound3D():play()
    if avatar:getLinkTransform("tag_weapon",AVATAR.linkReference) then
      local shotEmitter = AVATAR.shotEmitter
      local linkReference = AVATAR.linkReference
      shotEmitter:set(linkReference)
      shotEmitter:moveSide(10)
      shotEmitter:show()
      shotEmitter:reset()
      for ct = 1, table.getn(BULLETS) do
        local bullet = BULLETS[ct]
        local sprite = bullet.object
        if not sprite:isVisible() then
          local posX,posY,posZ = linkReference:getPosition()
          local dirX,dirY,dirZ = linkReference:getSideDirection()
          sprite:setPosition(posX+dirX*16,posY+dirY*16,posZ+dirZ*16)
          bullet.velX,bullet.velY,bullet.velZ = dirX*480,dirY*480,dirZ*480
          if isMouseLeftPressed() then
            bullet.type = 0 ---> BULLET
          else
            bullet.type = 1 ---> GRENADE
            bullet.countdown = 3
          end
          sprite:show()
          break
        end
      end
    end
  end
  if AVATAR.flyModeActive == 1 then
    if
      isKeyPressed(38) or isKeyPressed(40) or ---> KEY_UP || KEY_DOWN
      isKeyPressed(37) or isKeyPressed(39) or ---> KEY_LEFT || KEY_RIGHT
      isKeyPressed(33) or isKeyPressed(34)    ---> KEY_PRIOR || KEY_NEXT
    then 
      local stepSpeed = 150
      local step = 0
      if isKeyPressed(38) then ---> KEY_UP
        step =  stepSpeed*timeStep
      elseif isKeyPressed(40) then ---> KEY_DOWN
        step = -stepSpeed*timeStep
      end
      local sideSpeed = 150
      local side = 0
      if isKeyPressed(37) then ---> KEY_LEFT
        side =  sideSpeed*timeStep
      elseif isKeyPressed(39) then ---> KEY_RIGHT
        side = -sideSpeed*timeStep
      end
      local climbSpeed = 75
      local climb = 0
      if isKeyPressed(33) then ---> KEY_PRIOR
        climb =  climbSpeed*timeStep
      elseif isKeyPressed(34) then ---> KEY_NEXT
        climb = -climbSpeed*timeStep
      end
      local posX,posY,posZ = camera:getPosition()
      local velX,velY,velZ = camera:getViewDirection()
      local sidX,sidY,sidZ = camera:getSideDirection()
      posX,posY,posZ = bsp:slideCollision(
        posX,posY,posZ,
        step*velX+side*sidX,climb,step*velZ+side*sidZ,
        7,7,7
      )
      camera:setPosition(posX,posY,posZ)
    end
    local rotAngle = 0.15*timeStep
    local dx, dy = getMouseMove()
    if dx ~= 0 then
      camera:rotStanding(-dx*rotAngle)
    end
    if dy ~= 0 then
      camera:pitch(-dy*rotAngle)
    end
  else
    local rotAngle = 0.15*modelTimeStep
    local moveSpeed = 25*modelTimeStep
    local velX,velY,velZ
    local posX,posY,posZ = avatar:getPosition()
    if isKeyPressed(38) or isKeyPressed(40) then ---> KEY_UP || KEY_DOWN
      if AVATAR.legs == 9 then ---> LEGS_IDLE
        AVATAR.isRunning = 1
        AVATAR.runSource:getSound3D():play()
        if isKeyPressed(38) then ---> KEY_UP
          AVATAR.legs = 5 ---> LEGS_RUN
          avatar:setLowerAnimation(2)
        else
          AVATAR.legs = 6 ---> LEGS_BACK
          avatar:setLowerAnimation(3)
        end
      end
      if isKeyPressed(38) then ---> KEY_UP
        moveSpeed = 5*moveSpeed
      elseif isKeyPressed(40) then ---> KEY_DOWN
        moveSpeed = -3.5*moveSpeed
      end
      velX,velY,velZ = avatar:getSideDirection()
      velX = velX*moveSpeed
      velY = velY*moveSpeed
      velZ = velZ*moveSpeed
    else
      if AVATAR.isRunning == 1 then
        AVATAR.legs = 9 ---> LEGS_IDLE
        avatar:setLowerAnimation(4)
        AVATAR.isRunning = 0
        AVATAR.runSource:getSound3D():stop()
      end
      if isKeyPressed(37) or isKeyPressed(39) then ---> KEY_LEFT || KEY_RIGHT
        if (AVATAR.isRunning == 0) and (AVATAR.isStrafing == 0) then
          AVATAR.isStrafing = 1
          AVATAR.runSource:getSound3D():play()
          avatar:setLowerAnimation(4) ---> LEGS_TURN
        end
        PLAY.rotateIfNeeded(modelTimeStep)
        moveSpeed = 2*moveSpeed
        if isKeyPressed(39) then ---> KEY_RIGHT
          moveSpeed = -moveSpeed
        end
        velX,velY,velZ = avatar:getUpDirection()
        velX = velX*moveSpeed
        velY = velY*moveSpeed
        velZ = velZ*moveSpeed
      else
        if AVATAR.isStrafing == 1 then
          AVATAR.isStrafing = 0
          AVATAR.runSource:getSound3D():stop()
          avatar:setLowerAnimation(9) ---> LEGS_IDLE
        end
        velX,velY,velZ = 0,0,0
      end
    end
    VEL_Y = VEL_Y-500*timeStep
    velY = velY+VEL_Y*timeStep -- velY is a length, while VEL_Y a speed
    local POS_Y
    posX,POS_Y,posZ = bsp:slideCollision(posX,posY,posZ,velX,velY,velZ,16,24,16)
    if POS_Y < posY then
      VEL_Y = (POS_Y-posY)/timeStep
    else
      VEL_Y = 0
    end
    posY = POS_Y+0.032 
    avatar:setPosition(posX,posY,posZ);
    local dx,dy = getMouseMove()
    if dx ~= 0 then
      local headAngle = avatar:getHead():getYawAngle()
      if headAngle ~= 0 then
        local newHeadAngle = headAngle-dx*rotAngle
        if headAngle*newHeadAngle < 0 then
          avatar:getHead():setYawAngle(0)
          avatar:getUpper():addYawAngle(newHeadAngle-headAngle,1.047)
        else
          avatar:getHead():addYawAngle(-dx*rotAngle,1.5708)
        end
      else
        local diff = avatar:getUpper():addYawAngle(-dx*rotAngle,1.047)
        if diff ~= 0 then
          avatar:getHead():addYawAngle(diff,1.5708)
        end
      end
    end
    if AVATAR.isRunning == 1 then
      PLAY.rotateIfNeeded(modelTimeStep)
    end
    if dy ~= 0 then
      local headAngle = avatar:getHead():getPitchAngle()
      if headAngle ~= 0 then
        local newHeadAngle = headAngle-dy*rotAngle
        if headAngle*newHeadAngle < 0 then
          avatar:getHead():setPitchAngle(0)
          avatar:getUpper():addPitchAngle(
            newHeadAngle-headAngle,1.047,-.5236
          )
        else
          avatar:getHead():addPitchAngle(
            -dy*rotAngle,.5236,-.7854
          )
        end
      else
        local diff = avatar:getUpper():addPitchAngle(
          -dy*rotAngle,1.047,-.5236
        )
        if diff ~= 0 then
          avatar:getHead():addPitchAngle(diff,.5236,-7854)
        end
      end
    end
    camera:set(avatar)
    camera:rotateT(avatar:getUpper())
    camera:rotateT(avatar:getHead())
    camera:exchangeYZX()
    local posX,posY,posZ = camera:getPosition()
    posY = posY+50
    local velX,velY,velZ = camera:getViewDirection()
    velX,velY,velZ = -90*velX,-90*velY,-90*velZ
    posX,posY,posZ = bsp:checkCollision(posX,posY,posZ,velX,velY,velZ,4,4,4)
    camera:setPosition(posX,posY,posZ)
  end
end

----FINALIZATION----

function PLAY.final()
  ALL.stopSoundtrack(PLAY.SIM)
  local AVATAR = PLAY.AVATAR
  if AVATAR.weapon then
    AVATAR.weapon:delete()
    AVATAR.weapon = nil
  end
  PLAY.AVATAR = nil
  PLAY.SIM = nil
  empty()
  emptyOverlay()
  VEL_Y = nil
end

----KEYBOARD----

function PLAY.keyDown(key)
  if key == 32 then ---> KEY_RETURN
    releaseKey(32)
    if PLAY.AVATAR.alive then
      PLAY.AVATAR.flyModeActive = 1-PLAY.AVATAR.flyModeActive
      if PLAY.AVATAR.flyModeActive == 1 then
        local camera = getCamera()
        local posX,posY,posZ = camera:getPosition()
        camera:set(PLAY.AVATAR.object)
        camera:exchangeYZX()
        camera:setPosition(posX,posY,posZ)
      end
    end
  elseif key == 107 then ---> KEY_ADD
    releaseKey(107)
    PLAY.SIM.timeMultiplier = PLAY.SIM.timeMultiplier*2
    if PLAY.SIM.timeMultiplier > 2 then
      PLAY.SIM.timeMultiplier = 2
    end
  elseif key == 109 then ---> KEY_SUBTRACT
    releaseKey(109)
    PLAY.SIM.timeMultiplier = PLAY.SIM.timeMultiplier/2
    if PLAY.SIM.timeMultiplier < 0.125 then
      PLAY.SIM.timeMultiplier = 0.125
    end
  elseif key == 13 then ---> KEY_RETURN
    releaseKey(13)
    setScene(Scene(MENU.init,MENU.update,MENU.final,MENU.keyDown))
  elseif key == string.byte("1") then
    releaseKey(string.byte("1"))
    setScene(Scene(PLAY.init,PLAY.update,PLAY.final,PLAY.keyDown))
  end
end

--------------------
----MODELS SCENE----
--------------------

----INITIALIZATION----
function MODELS.init()
  local zip = Zip("SureAsAGun.dat")
  ALL.playSoundtrack(zip,"happyCowboy.mid",MODELS)
  ----CAMERA----
  setAmbient(.5,.5,.5)
  setPerspective(60,.25,1000)
  enableFog(200, .522,.373,.298)
  local camera = getCamera()
  camera:reset()
  camera:rotStanding(3.1415)
  camera:setPosition(0,1.8,5)
  empty()
  emptyOverlay()
  ----SKYBOX----
  local skyTxt = {
    zip:getTexture("redrocksky_rt.jpg"),
    zip:getTexture("redrocksky_ft.jpg"),
    zip:getTexture("redrocksky_lf.jpg"),
    zip:getTexture("redrocksky_bk.jpg"),
    zip:getTexture("redrocksky_up.jpg"),
    zip:getTexture("redrocksky_dn.jpg")
  }
  local sky = Sky(skyTxt)
  setBackground(sky)
  ----SUN----
  local dir = 1.6
  local inc =  0.425
  local dirX = math.cos(inc)*math.cos(dir)
  local dirZ = math.cos(inc)*math.sin(dir)
  local dirY = math.sin(inc)
  local sun = Sun(
    zip:getTexture("sun.jpg"),0.3,dirX,dirY,dirZ,
    zip:getTexture("lensflare.png"),6,0.15,800
  )
  sun:setColor(1,1,0.6)
  setSun(sun)
  ----TERRAIN----
  local terrainMaterial = Material()
  terrainMaterial:setAmbient(1,1,1)
  terrainMaterial:setDiffuse(0,0,0)
  terrainMaterial:setDiffuseTexture(zip:getTexture("textures/Wq3_dirt/dirt_wall7.jpg",1))
  local ground = FlatTerrain(terrainMaterial,500,125)
  ground:setShadowed()
  ground:setShadowOffset(0.01)
  terrainMaterial:delete()
  setTerrain(ground)
  ----MODELS----
  torso = 2  ---> TORSO_HOLSTERED
  legs = 2   ---> LEGS_WALK
  weapon = zip:getModel("peacemaker.mdx","peacemaker.jpg")
  weapon:rescale(0.04)
  weapon2 = zip:getModel("winchester66.mdx","winchester66.jpg")
  weapon2:rescale(0.04)
  holsterL = zip:getModel("holsterL.mdx","holster.jpg")
  holsterL:rescale(0.04)
  holsterR = zip:getModel("holsterR.mdx","holster.jpg")
  holsterR:rescale(0.04)
  avatar = zip:getBot("cowboy2.mdl")
  avatar:setAnimationTime(0)
  avatar:rescale(0.04)
  avatar:pitch(-1.5708)
  avatar:rotStanding(-1.5708)
  avatar:move(0,1,0)
  avatar:getUpper():link("tag_weapon",weapon)
  avatar:getLower():link("tag_holsterr",holsterR)
  avatar:setUpperAnimation(torso)
  avatar:setLowerAnimation(legs)
  addObject(avatar)
  local shadow = Shadow(avatar)
  addShadow(shadow)
  avatar2 = zip:getBot("cowboy1.mdl")
  avatar2:rescale(0.04)
  avatar2:pitch(-1.5708)
  avatar2:rotStanding(-1.5708)
  avatar2:move(1.5,1,0)
  avatar2:getUpper():link("tag_weapon",weapon2)
  avatar2:getLower():link("tag_holsterl",holsterL)
  avatar2:setUpperAnimation(torso)
  avatar2:setLowerAnimation(legs)
  addObject(avatar2)
  shadow = Shadow(avatar2)
  addShadow(shadow)
  avatar3 = zip:getBot("cowboy3.mdl")
  avatar3:rescale(0.04)
  avatar3:pitch(-1.5708)
  avatar3:rotStanding(-1.5708)
  avatar3:move(-1.5,1,0)
  avatar3:getUpper():link("tag_weapon",weapon)
  avatar3:getUpper():link("tag_weapon2",weapon)
  avatar:getLower():link("tag_holsterl",holsterL)
  avatar:getLower():link("tag_holsterr",holsterR)
  avatar3:setUpperAnimation(torso)
  avatar3:setLowerAnimation(legs)
  addObject(avatar3)
  shadow = Shadow(avatar3)
  addShadow(shadow)
  avatar4 = zip:getBot("cowboy4.mdl")
  avatar4:rescale(0.04)
  avatar4:pitch(-1.5708)
  avatar4:rotStanding(-1.5708)
  avatar4:move(0.75,1,-2)
  avatar4:getUpper():link("tag_weapon",weapon)
  avatar:getLower():link("tag_holsterl",holsterL)
  avatar4:setUpperAnimation(torso)
  avatar4:setLowerAnimation(legs)
  addObject(avatar4)
  shadow = Shadow(avatar4)
  addShadow(shadow)
  avatar5 = zip:getBot("cowboy5.mdl")
  avatar5:rescale(0.04)
  avatar5:pitch(-1.5708)
  avatar5:rotStanding(-1.5708)
  avatar5:move(-0.75,1,-2)
  avatar5:getUpper():link("tag_weapon",weapon)
  avatar5:getUpper():link("tag_weapon2",weapon)
  avatar:getLower():link("tag_holsterl",holsterL)
  avatar:getLower():link("tag_holsterr",holsterR)
  avatar5:setUpperAnimation(torso)
  avatar5:setLowerAnimation(legs)
  addObject(avatar5)
  shadow = Shadow(avatar5)
  addShadow(shadow)
  avatar6 = zip:getBot("cowboy6.mdl")
  avatar6:rescale(0.04)
  avatar6:pitch(-1.5708)
  avatar6:rotStanding(-1.5708)
  avatar6:move(0,1,-4)
  avatar6:getUpper():link("tag_weapon",weapon2)
  avatar:getLower():link("tag_holsterl",holsterL)
  avatar6:setUpperAnimation(torso)
  avatar6:setLowerAnimation(legs)
  addObject(avatar6)
  shadow = Shadow(avatar6)
  addShadow(shadow)
  ----HELP----
  local help = {
    "[  MOUSE  ] Look around",
    "[ UP/DOWN ] Move Forward/Back",
    "[PREV/NEXT] Raise/Lower View",
    "[  Z key  ] Change Torso Animation",
    "[  X key  ] Change Legs Animation",
    "[  C key  ] Death Animation",
    "[ Q,W,E,R ] Rotate/Bend Head",
    "[ A,S,D,F ] Rotate/Bend Torso",
    "[  SPACE  ] Rotate Scene",
    " ",
    "[ENTER] Main Menu",
    "[F1] Show/Hide Help",
  }
  setHelp(help)
  showHelpReduced()
  hideConsole()
  ----DELETE ZIP----
  zip:delete()
end

----LOOP----
function MODELS.update()
  local camera = getCamera()
  local timeStep = getTimeStep()
  if timeStep > 0.1 then
    timeStep = 0.1
  end
  avatar:setAnimationTime(avatar:getAnimationTime()+timeStep)
  ----ROTATE VIEW----
  if rotateView then
    local rotAngle = .13*timeStep
    camera:rotAround(rotAngle)
    local posX,posY,posZ = avatar:getPosition()
    camera:pointTo(posX,posY+1,posZ)
  end
  ----MOVE CAMERA (KEYBOARD)----
  local moveSpeed = 15
  local climbSpeed = 15
  if isKeyPressed(38) then --> VK_UP
    camera:moveStanding(moveSpeed*timeStep)
  elseif isKeyPressed(40) then --> VK_DOWN
    camera:moveStanding(-moveSpeed*timeStep)
  elseif isKeyPressed(37) then --> VK_LEFT
    camera:rotStanding(0.4*timeStep)
  elseif isKeyPressed(39) then --> VK_RIGHT
    camera:rotStanding(-0.4*timeStep)
  elseif isKeyPressed(33) then --> VK_PRIOR
    camera:move(0,climbSpeed*timeStep,0)
  elseif isKeyPressed(34) then --> VK_NEXT
    camera:move(0,-climbSpeed*timeStep,0)
    local posX,posY,posZ = camera:getPosition()
    if posY < 0.5 then
      camera:setPosition(posX,0.5,posZ)
    end
  end
  ----MODEL MOVEMENT----
  if isKeyPressed(string.byte("D")) then
    local angle = 3.1415*timeStep
    avatar:getUpper():addPitchAngle(angle,0.7854,-0.5236)
  elseif isKeyPressed(string.byte("F")) then
    local angle = -3.1415*timeStep
    avatar:getUpper():addPitchAngle(angle,0.7854,-0.5236)
  elseif isKeyPressed(string.byte("A")) then
    local angle = 3.1415*timeStep
    avatar:getUpper():addYawAngle(angle,1.5708)
  elseif isKeyPressed(string.byte("S")) then
    local angle = -3.1415*timeStep
    avatar:getUpper():addYawAngle(angle,1.5708)
  elseif isKeyPressed(string.byte("E")) then
    local angle = 3.1415*timeStep
    avatar:getHead():addPitchAngle(angle,0.7854)
  elseif isKeyPressed(string.byte("R")) then
    local angle = -3.1415*timeStep
    avatar:getHead():addPitchAngle(angle,0.7854)
  elseif isKeyPressed(string.byte("Q")) then
    local angle = 3.1415*timeStep
    avatar:getHead():addYawAngle(angle,1.5708)
  elseif isKeyPressed(string.byte("W")) then
    local angle = -3.1415*timeStep
    avatar:getHead():addYawAngle(angle,1.5708)
  end
  ----MOVE CAMERA (MOUSE)----
  if not rotateView then
    local dx, dy = getMouseMove()
    local changeStep = 0.15*timeStep;
    if dx ~= 0 then
      camera:rotStanding(-dx*changeStep)
      end
    if dy ~= 0 then
      camera:pitch(-dy*changeStep)
      end
    end
  end

----FINALIZATION----
function MODELS.final()
  ALL.stopSoundtrack(MODELS)
  ----DELETE GLOBALS----
  rotateView = nil
  torso = nil
  legs = nil
  ----EMPTY WORLD----
  avatar = nil
  avatar2 = nil
  avatar3 = nil
  avatar4 = nil
  avatar5 = nil
  avatar6 = nil
  if weapon then
    weapon:delete()
    weapon = nil
  end
  if weapon2 then
    weapon2:delete()
    weapon2 = nil
  end
  if holsterL then
    holsterL:delete()
    holsterL = nil
  end
  if holsterR then
    holsterR:delete()
    holsterR = nil
  end
  disableFog()
  empty()
  emptyOverlay()
end

----KEYBOARD----
function MODELS.keyDown(key)
  if key == 32 then --> SPACE
    releaseKey(32)
    if rotateView then
      rotateView = nil
    else
      rotateView = 1
    end
  end
  ----VARIOUS SCENE MODIFIERS----
  if key == string.byte("Z") then
    releaseKey(string.byte("Z"))
    if torso < 2 or torso > 17 then
      torso = 1
    end
    torso = torso+1
    avatar:setUpperAnimation(torso)
    avatar2:setUpperAnimation(torso)
    avatar3:setUpperAnimation(torso)
    avatar4:setUpperAnimation(torso)
    avatar5:setUpperAnimation(torso)
    avatar6:setUpperAnimation(torso)
  elseif key == string.byte("X") then
    releaseKey(string.byte("X"))
    if legs < 2 or legs > 11 then
      legs = 1
    end
    legs = legs+1
    avatar:setLowerAnimation(legs)
    avatar2:setLowerAnimation(legs)
    avatar3:setLowerAnimation(legs)
    avatar4:setLowerAnimation(legs)
    avatar5:setLowerAnimation(legs)
    avatar6:setLowerAnimation(legs)
  elseif key == string.byte("C") then
    releaseKey(string.byte("C"))
    if legs > 1 then 
      torso = -1
      legs = -1
    end
    torso = torso+1
    legs = legs+1
    avatar:setLowerAnimation(legs)
    avatar:setUpperAnimation(torso)
    avatar2:setLowerAnimation(legs)
    avatar2:setUpperAnimation(torso)
    avatar3:setLowerAnimation(legs)
    avatar3:setUpperAnimation(torso)
    avatar4:setLowerAnimation(legs)
    avatar4:setUpperAnimation(torso)
    avatar5:setLowerAnimation(legs)
    avatar5:setUpperAnimation(torso)
    avatar6:setLowerAnimation(legs)
    avatar6:setUpperAnimation(torso)
  elseif key == string.byte("V") then
    releaseKey(string.byte("V"))
    avatar:setLowerAnimation(legs)
    avatar:setUpperAnimation(torso)
    avatar2:setLowerAnimation(legs)
    avatar2:setUpperAnimation(torso)
    avatar3:setLowerAnimation(legs)
    avatar3:setUpperAnimation(torso)
    avatar4:setLowerAnimation(legs)
    avatar4:setUpperAnimation(torso)
    avatar5:setLowerAnimation(legs)
    avatar5:setUpperAnimation(torso)
    avatar6:setLowerAnimation(legs)
    avatar6:setUpperAnimation(torso)
  elseif key == 13 then ---> KEY_RETURN
    releaseKey(13)
    setScene(Scene(MENU.init,MENU.update,MENU.final,MENU.keyDown))
  end
end

-------------------
----SCENE SETUP----
-------------------
setScene(Scene(MENU.init,MENU.update,MENU.final,MENU.keyDown))
