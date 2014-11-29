----Scene initialization (see below for the Native Gui Dialog controls)
----Questions? Contact:leo <tetractys@users.sf.net>

----INITIALIZATION----
function init()
  rotateView = true
  ----CAMERA----
  setAmbient(0.5,0.5,0.5)
  setPerspective(60,0.25*32,1000*32)
  enableFog(200*32, 99/256,104/256,107/256)
  local camera = getCamera()
  camera:reset()
  camera:setPosition(0,1*32,-4*32)
  empty()
  ----SKYBOX----
  if not fileExists("DemoPack3.dat") then
    showConsole()
    error("\nERROR: File 'DemoPack3.dat' not found.")
  end
  local zip = Zip("DemoPack3.dat")
  local skyTxt = {
    zip:getTexture("left4.jpg"),
    zip:getTexture("front4.jpg"),
    zip:getTexture("right4.jpg"),
    zip:getTexture("back4.jpg"),
    zip:getTexture("top4.jpg"),
    zip:getTexture("bottom4.jpg")
  }
  local sky = Sky(skyTxt)
  sky:rotStanding(3.1415)
  setBackground(sky)
  ----SUN----
  local sun = Sun(
    zip:getTexture("light.jpg"),0.25,
    0.0, 0.2588, -0.9659,
    zip:getTexture("lensflares.png"),
    5, 0.2
  )
  sun:setColor(0.855,0.475,0.298);
  setSun(sun)
  ----TERRAIN----
  local terrainMaterial = Material()
  terrainMaterial:setAmbient(1,1,1)
  terrainMaterial:setDiffuse(1,1,1)
  terrainMaterial:setDiffuseTexture(zip:getTexture("snow4.jpg",1))
  local ground = FlatTerrain(terrainMaterial,500*32,125)
  ground:setShadowed()
  ground:setShadowOffset(0.01*32)
  setTerrain(ground)
  terrainMaterial:delete()
  ----MODEL----
  animation = 0
  model = MDLModel("models-data/platoon.mdl")
  model:move(0,0,0)
  model:pitch(-1.5708)
  model:rotStanding(1.5708)
  model:setMaxRadius(2*32)
  model:setBodyGroup(0,0)
  model:setBodyGroup(1,0)
  model:setBodyGroup(2,0)
  model:setBodyGroup(3,0)
  model:setSequence(0)
  addObject(model)
  local shadow = Shadow(model)
  shadow:setMaxRadius(model:getMaxRadius()*3)
  addShadow(shadow)
  lastModelAngle = 0
  lastSceneAngle = 0
  ----NATIVE GUI----
  -- Rotations Tab --
  local tit_c = iup.label{title = "Rotate Camera", alignment = "ACENTER", size = "100x10"}
  local tit_m = iup.label{title = "Rotate Model", alignment = "ACENTER", size = "100x10"}
  local lbl_c = iup.label{title = "0", alignment = "ACENTER", size = "100x10"}
  local lbl_m = iup.label{title = "0", alignment = "ACENTER", size = "100x10"}
  local dial_c = iup.dial{"HORIZONTAL"; size="100x20"}
  local dial_m = iup.dial{"HORIZONTAL"; density=0.3}
  function dial_c:mousemove_cb(a)
    lbl_c.title = math.floor(a/3.1415*180)
    local angle = a-lastSceneAngle
    getCamera():rotAround(-angle)
    local px, py, pz = model:getPosition()
    getCamera():pointTo(px,py+1*32,pz)
    lastSceneAngle = a
    return iup.DEFAULT
  end
  function dial_c:button_press_cb(a)
    lbl_c.bgcolor = "255 255 0"
    lbl_c.title = 0
    return iup.DEFAULT
  end
  function dial_c:button_release_cb(a)
    lbl_c.bgcolor = nil
    return iup.DEFAULT
  end
  function dial_m:mousemove_cb(a)
    lbl_m.title = math.floor(a/3.1415*180)
    local angle = a-lastModelAngle
    model:rotStanding(angle)
    lastModelAngle = a
    return iup.DEFAULT
  end
  function dial_m:button_press_cb(a)
    lbl_m.bgcolor = "255 255 0"
    lbl_m.title = 0
    return iup.DEFAULT
  end
  function dial_m:button_release_cb(a)
    lbl_m.bgcolor = nil
    return iup.DEFAULT
  end
  local rotationsTab =
    iup.hbox {
      iup.fill{},
      iup.vbox {
        iup.fill{},
        iup.frame {
          iup.vbox {
            iup.hbox {iup.fill{}, tit_c, iup.fill{}},
            iup.hbox {iup.fill{}, dial_c, iup.fill{}},
            iup.hbox {iup.fill{}, lbl_c, iup.fill{}}
          }
        },
        iup.fill{},
        iup.frame {
          iup.vbox { 
            iup.hbox {iup.fill{}, tit_m, iup.fill{}},
            iup.hbox {iup.fill{}, dial_m, iup.fill{}},
            iup.hbox {iup.fill{}, lbl_m, iup.fill{}},
          } 
        },
        iup.fill{},
      },
      iup.fill{}
    }
  rotationsTab.tabtitle = "Rotations"
  --Meshes Tab--
  local list_head = iup.list{
    "mask", "commander", "shotgun", "gunner white",
    "gunner black", "MP", "major", "commander black";
    dropdown="YES", visible_items=8
  }
  function list_head:action(t, i, v)
    if v ~= 0 then model:setBodyGroup(1,i-1) end
    return iup.DEFAULT
  end
  local frm_head = iup.frame{list_head; title = "Heads"}
  --
  local list_torso = iup.list{
    "regular", "gunner", "no back", "shotgun";
    dropdown="YES", visible_items=4
  }
  function list_torso:action(t, i, v)
    if v ~= 0 then model:setBodyGroup(2,i-1) end
    return iup.DEFAULT
  end
  local frm_torso = iup.frame{list_torso; title = "Jacket"}
  --
  local list_weapon = iup.list{
    "MP5", "shotgun", "saw", "none";
    dropdown="YES", visible_items=4
  }
  function list_weapon:action(t, i, v)
    if v ~= 0 then model:setBodyGroup(3,i-1) end
    return iup.DEFAULT
  end
  local frm_weapon = iup.frame{list_weapon; title = "Weapon"}
  --
  local list_body = iup.list{"white", "red", "blue", "green"; dropdown="YES", visible_items=4}
  function list_body:action(t, i, v)
    if v ~= 0 then
      model:setBodyGroup(0,i-1)
    end
    return iup.DEFAULT
  end
  local frm_body = iup.frame{list_body; title = "Fatigues"}
  --
  local meshesTab = iup.frame{
    iup.vbox {
      iup.fill{}, iup.hbox{iup.fill{}, frm_head, iup.fill{}},
      iup.fill{}, iup.hbox{iup.fill{}, frm_torso, iup.fill{}},
      iup.fill{}, iup.hbox{iup.fill{}, frm_weapon, iup.fill{}},
      iup.fill{}, iup.hbox{iup.fill{}, frm_body, iup.fill{}},
      iup.fill{}
    }
  }
  meshesTab.tabtitle = "Meshes"
  --Animations Tab--
  local list_anim = iup.list{
    "idle 1", "idle 2", "crouching idle", "cower", "walk1", "run",
    "rotate left", "rotate right", "smflinch", "shoot shotgun",
    "launch grenade", "throw grenade", "reload", "front kick",
    "advance signal", "flank signal", "retreat signal",
    "limping walk", "limping run", "die backwards 1", "die forward",
    "die simple", "die backwards 2", "die head shot", "dead on stomach 1",
    "dead on stomach 2", "dead side", "dead on back", "dead sitting",
    "sitting 1", "sitting 2", "sitting 3", "holfing on";
    dropdown="YES", visible_items=10}
  function list_anim:action(t, i, v)
    if v ~= 0 then
      model:setSequence(i-1)
    end
    return iup.DEFAULT
  end
  local frm_anim = iup.frame{
    iup.vbox{
      iup.fill{}, iup.hbox{iup.fill{}, list_anim, iup.fill{}}, iup.fill{}
    }; title = "Animations"
  }
  frm_anim.tabtitle = "Animations"
  --The Tabs---
  local tabs = iup.tabs{rotationsTab,meshesTab,frm_anim}
  dlg = iup.dialog{tabs; title="Scene Controls", size="200x150"}
  dlg.TOPMOST = "YES"
  dlg:showxy(iup.CENTER,iup.CENTER)
  acquireMouse(false)
  ----HELP----
  local help = {
    "The model of this tutorial was included in",
    "  Half-Life: Opposing Force",
    "Do not use in commercial products!",
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
  local fwdSpeed = 0
  local rotSpeed = 0
  ----MODEL----
  model:advanceFrame(timeStep)
end

----FINALIZATION----
function final()
  acquireMouse(true)
  if dlg then
    dlg:destroy()
    dlg = nil
  end
  ----DELETE GLOBALS----
  lastModelAngle = nil
  lastSceneAngle = nil
  model = nil
  animation = nil
  ----EMPTY WORLD----
  disableFog()
  empty()
end

----KEYBOARD----
function keyDown(key)
  ----LOAD MAIN MENU----
  if key == string.byte("\r") then
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
