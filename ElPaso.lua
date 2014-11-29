----El Paso DEMO
----Questions? Contact: leo <tetractys@users.sf.net>

------------------
----MENU SCENE----
------------------

-----------------------
----BSP LEVEL SCENE----
-----------------------

----BSP INITIALIZATION----
function BSP_init()
  showLoadingScreen()
  ----CAMERA----
  empty()
  setAmbient(.2,.2,.2)
  setPerspective(60,3,12000)
  local camera = getCamera()
  camera:reset()
  camera:move(0,0*32,-50*32)
  ----SKYBOX----
  if not fileExists("ElPaso.dat") then
    showConsole()
    error("\nERROR: File 'ElPaso.dat' not found.")
  end
  local zip = Zip("ElPaso.dat")
  local skyTxt = {
    zip:getTexture("env/rock_rt.jpg"),
    zip:getTexture("env/rock_ft.jpg"),
    zip:getTexture("env/rock_lf.jpg"),
    zip:getTexture("env/rock_bk.jpg"),
    zip:getTexture("env/rock_up.jpg"),
    zip:getTexture("env/rock_dn.jpg")
  }
  local sky = Sky(skyTxt)
  setBackground(sky)
  ----BSP----
  bsp = zip:getLevel("elpaso.bsx",1.5)
  bsp:setShowUntexturedMeshes()
  bsp:setShowUntexturedPatches()
  bsp:setShowTransparencies()
--  bsp:setDefaultTexture(zip:getTexture("???",1))
  setScenery(bsp)
  collSet = true
  ----HELP----
  local help = {
    "Scenery:",
    "Western Quake III MOD",
    "www.westernquake3.net",
    "You can easily recognize the",
    "town of El Paso from the movie",
    "'For a Few Dollars More'",
    "by Sergio Leone",
    " ",
    "[   MOUSE  ] Look around",
    "[  UP/DOWN ] Move Forward/Back",
    "[LEFT/RIGHT] Rotate Left/Right",
    "[    C     ] Set/Unset Collisions",
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

----BSP LOOP----
function BSP_update()
  local camera = getCamera()
  local timeStep = getTimeStep()
  if timeStep > 0.1 then timeStep = 0.1 end 
  if isKeyPressed(38) or isKeyPressed(40) then ---> VK_UP || VK_DOWN
    local posX,posY,posZ = camera:getPosition()
    local moveSpeed = 400
    local k = timeStep*moveSpeed
    if isKeyPressed(40) then ---> VK_UP
      k = -k
    end
    local velX,velY,velZ = camera:getViewDirection()
    if collSet then
      posX,posY,posZ =
        bsp:slideCollision(posX,posY,posZ,k*velX,k*velY,k*velZ,14,14,14)
      camera:setPosition(posX,posY,posZ)
    else
      camera:setPosition(posX+k*velX,posY+k*velY,posZ+k*velZ)
    end
  end
  local rotAngle = 0.15*timeStep
  local dx, dy = getMouseMove()
  if dx ~= 0 then
    camera:rotStanding(-dx*rotAngle)
  end
  if dy ~= 0 then
    camera:pitch(-dy*rotAngle)
  end
end

----BSP FINALIZATION----
function BSP_final()
  ----DELETE GLOBALS----
  bsp = nil
  emptyOverlay()
  empty()
end

----BSP KEYBOARD----
function BSP_keyDown(key)
  if key == string.byte("C") then
    if collSet then
      collSet = false
    else
      collSet = true
    end
  end
end

-------------------
----SCENE SETUP----
-------------------
setScene(Scene(BSP_init,BSP_update,BSP_final,BSP_keyDown))

