--PRIMITIVES 2D DEMO
----Questions? Contact: leo <tetractys@users.sf.net>

--INIT FUNCTION--
function init()
  --CAMERA INIT
  local camera = getCamera() --Get the camera
  camera:reset() --Reset
  emptyOverlay() -- empty 2D overlay
  empty() -- empty 3D world
  --2D Primitives (POINTS)
  local coords = {-20,-20, -20,20, 20,20, 20,-20,}
  -- Creates the coordinates used to define vertices (a square)
  local colors = {1,0,0,1, 1,1,0,1, 1,0,1,1, 0,1,1,1,}
  -- Creates the colors used to color vertices (red, yellow, magenta, cyan)
  overlayPoints = OverlayPoints(coords,colors) -- the points
  overlayPoints:setSmooth(true) -- rendered as smooth points
  overlayPoints:setSize(8) -- size is 8
  overlayPoints:setLocation(200,400) -- move to location 100,100
  overlayPoints:setRotation(30/180*3.1415) -- rotate by 30 degrees
  addToOverlay(overlayPoints) -- add to overlay
  --2D Primitives (LINES)
  coords = {-40,-40, -40,40, 40,40, 40,-40,}
  -- colors the same as above
  local indexes = {0,1,2,3,}
  overlayLines = OverlayLines(indexes,coords,colors) -- the points
  overlayLines:setModeLineStrip() -- specifies that the lines are connected...
  overlayLines:setModeLineLoop() -- ... and the loop is closed
  overlayLines:setSmooth(true) -- rendered as smooth lines
  overlayLines:setSize(4) -- width of line is 4
  overlayLines:setStipple(0xff00,1)
  -- the stipple specify the pattern of the line: in this case is a dashed line
  -- because only the set bits of the pattern are drawn (0xff00 in exhadecimal
  -- means 16 bits set and 16 bits cleared). The second arg is a scale factor
  -- for the pattern
  overlayLines:setLocation(400,400) -- move to location 400,400
  overlayLines:setRotation(45/180*3.1415) -- rotate by 45 degrees
  addToOverlay(overlayLines) -- add to overlay
  --2D Primitives (POLYS)
  -- coords the same as above
  local colors = {1,0,0,1, 1,1,0,1, 1,0,1,1, 0,1,1,0.5,}
  -- Creates the colors used to color vertices
  -- (red, yellow, magenta, cyan half transparent)
  -- indexes the same as above
  overlayPolys = OverlayPolys(indexes,coords,colors) -- the points
  overlayPolys:setColor(1,1,1,0)
  -- specifies the color of the vertexes, but in this case the colors are already
  -- given by the "colors" table, so only the alpha component is important
  -- to specify that there is transparency
  overlayPolys:setModeTriangFan() -- rendered as a fan of triangles
  overlayPolys:setSmooth(true) -- rendered as smooth lines
  overlayPolys:setLocation(600,400) -- move to location 600,400
  overlayPolys:setRotation(-15/180*3.1415) -- rotate by -15 degrees
  addToOverlay(overlayPolys) -- add to overlay
  --HELP TEXT--
  local help = {
    "2D Primitives Test",
    "",
    "Use the mouse to move the lines",
    "Press 'ENTER' to go back to demos menu",
  }
  setHelp(help)
  showHelpUser()
  hideConsole()
end --INIT

--UPDATE FUNCTION--
function update()
  local camera = getCamera()
  local dx, dy = getMouseMove()
  local x, y = overlayLines:getLocation()
  overlayLines:setLocation(x+dx,y+dy)
end

--KEY PRESS DETECTION
function keyDown(key)
  if isKeyPressed(string.byte("\r")) then
    releaseKey(string.byte("\r"))
    hideConsole()
    final()
    dofile("main.lua")
    return
  end
end

--CLEANUP AND END
function final()
  overlayPoints = nil
  overlayLines = nil
  overlayPolys = nil
  emptyOverlay() -- empty 2D overlay
  empty() -- empty 3D world
end

--SETUP THE SCENE (RUN)--
setScene(Scene(init,update,final,keyDown))
