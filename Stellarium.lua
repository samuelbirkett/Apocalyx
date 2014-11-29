----STELLARIUM
----Questions? Contact: leo <tetractys@users.sf.net>

----VARS----
function initVars()
  _timeScale = 1000
  _showStars = false
  _showPlanets = false
  _showHorizon = false
  _showAtmosphere = true
  _showConstellations = false
  _showGrids = false
  _showCardinalPoints = false
end

function finalVars()
  _timeScale =  nil
  _showStars =  nil
  _showPlanets =  nil
  _showHorizon =  nil
  _showAtmosphere =  nil
  _showConstellations =  nil
  _showGrids =  nil
  _showCardinalPoints =  nil
end

----INITIALIZATION----
function init()
  ----VARS----
  initVars()
  ----CAMERA----
  setPerspective(60,0.1,1000)
  local camera = getCamera()
  camera:reset()
  camera:rotStanding(3.1415)
  empty()
  ----SKYBOX----
  stellarium = Stellarium()
  stellarium:setMaxMagnitudeStarsName(2.5)
  setBackground(stellarium)
  ----HELP----
  local help = {
    "[MOUSE] Look Around",
    "[  C  ] Show/Hide Constellations",
    "[  P  ] Show/Hide Planets",
    "[  S  ] Show/Hide Stars",
    "[  H  ] Show/Hide Horizon",
    "[  G  ] Show/Hide Grids",
    "[  N  ] Show/Hide Cardinal Points",
    "[  A  ] Show/Hide Atmosphere",
    "[ X-Z ] Inc/Dec Time Scale (+/-1000)",
    " ",
    "[ENTER] Demos Menu",
    "[F1] Show/Hide Help",
  }
  setHelp(help)
  showHelpUser()
  hideConsole()
end

----LOOP----
function update()
  local camera = getCamera()
  local timeStep = getTimeStep()
  ----STELLARIUM----
  stellarium:addTime(timeStep*0.00001157*_timeScale)
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
end

----FINALIZATION----
function final()
  ----VARS----
  finalVars()
  ----GLOBALS----
  stellarium = nil
  ----EMPTY WORLD----
  empty()
end

function keyDown(key)
  releaseKey(key)
  if key == string.byte("C") then
    _showConstellations = not _showConstellations
    stellarium:setShowConstellations(_showConstellations)
    stellarium:setShowConstellationsName(_showConstellations)
  elseif key == string.byte("P") then
    _showPlanets = not _showPlanets
    stellarium:setShowPlanets(_showPlanets)
    stellarium:setShowPlanetsHint(_showPlanets)
  elseif key == string.byte("H") then
    _showHorizon = not _showHorizon
    stellarium:setShowGround(_showHorizon)
    stellarium:setShowHorizon(_showHorizon)
    stellarium:setShowFog(_showHorizon)
  elseif key == string.byte("S") then
    _showStars = not _showStars
    stellarium:setShowStars(_showStars)
    stellarium:setShowStarsName(_showStars)
  elseif key == string.byte("G") then
    _showGrids = not _showGrids
    stellarium:setShowEquatorialGrid(_showGrids)
    stellarium:setShowEquator(_showGrids)
    stellarium:setShowAzimutalGrid(_showGrids)
    stellarium:setShowEcliptic(_showGrids)
  elseif key == string.byte("N") then
    _showCardinalPoints = not _showCardinalPoints
    stellarium:setShowCardinalPoints(_showCardinalPoints)
  elseif key == string.byte("A") then
    _showAtmosphere = not _showAtmosphere
    stellarium:setShowAtmosphere(_showAtmosphere)
  elseif key == string.byte("X") then
    _timeScale = _timeScale+1000
  elseif key == string.byte("Z") then
    _timeScale = _timeScale-1000
  elseif key == string.byte("\r") then
    dofile("main.lua")
    return
  end
end

----SCENE SETUP----
setScene(Scene(init,update,final,keyDown))
