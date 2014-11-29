
callback = {}

	--make cube vertices
	tri = { }
	---- Contains our vertex data, specifying each point in space
	tri.vertices = { -- one per point not triangle!
					--Front
					 0.8,  0.8,  0.8, --top left FRONT 0
                    -0.8,  0.8,  0.8, --top right FRONT 0.8
                    -0.8, -0.8,  0.8, --bottom right FRONT 2
                     0.8, -0.8,  0.8, --bottom left FRONT 3
					 --Back
					 -- 0.8,  0.8,  -0.8, --top left 4
                    -- -0.8,  0.8,  -0.8, --top right 5
                    -- -0.8, -0.8,  -0.8, --bottom right 6
                     -- 0.8, -0.8,  -0.8, --bottom left 7
	}

	tri.normals = { }
	tri.mappings = { 1,1, 0,1, 0,0, 1,0}
	tri.faces ={--one per triangle and per side/face, corresponds to vertices position in vertices list -- clockwise facing viewer
				 0, 1, 2, --front top
                 0, 2, 3, --front bottom
                 -- 4, 6, 5, --back top
                 -- 4, 7, 6, --back bottom
				 -- 1, 5, 6, --right top
                 -- 1, 6, 2, --right bottom
				 -- 0, 3, 7, --left top
                 -- 0, 7, 4, --left bottom
				 -- 2, 7, 6, --bottom back
                 -- 2, 3, 7, --bottom front
				 -- 1, 4, 5, --top back
                 -- 1, 0, 4, --top front

				 }
				 
				
function callback.init()
	speed = 3
	-- setTitle("Tutorial 1: Basic Engine Template")
	-- --setDimension(800, 600)
	setClear(1,1,1)
	-- hideHelp()
	hideConsole()
	hideWatermark()
    
	camera = getCamera()
	
		 
	setAmbient(0.5, 0.5, 0.5)
	setPerspective(75,.5,3000)
	local camera = getCamera()
	camera:reset()
	camera:setPosition(0,2.5,8)
	camera:rotStanding(3.1415)
	empty()
	emptyOverlay()
	
	img = Image("lua.png")
	tex = Texture(img)
	mat = Material()
	mat:setDiffuseTexture(tex)
	charLight = Light(tex,200)
	
	local triShape = Shape(tri.vertices, tri.normals, tri.mappings, tri.faces)
	triMesh = Mesh(triShape, mat)
	triMesh2 = Mesh(triShape, mat)
	triMesh3 = Mesh(triShape, mat)
	triMesh4 = Mesh(triShape, mat)
	triMesh5 = Mesh(triShape, mat)
	triMesh6 = Mesh(triShape, mat)
	sphere = MS3DModel("sphere.ms3d")
	monkey = MS3DModel("monkey.ms3d")
	
	addObject(triMesh)
	addObject(triMesh2)
	addObject(triMesh3)
	addObject(triMesh4)
	addObject(triMesh5)
	addObject(triMesh6)
	addObject(sphere)
	addObject(monkey)
	monkey:moveForward(-5)
	
	triMesh2:yaw(1.57079633)
	triMesh3:yaw(3.14159265)
	triMesh4:yaw(4.71238898)
	triMesh5:pitch(-1.57079633)
	triMesh6:pitch(1.57079633)
	addLight(charLight)
	enableFog(60, 1, 1, 1)
end
	local timestep = timestep or 0
function callback.update()
	local camera = getCamera()
	timeStep = getTimeStep()
	
	--hideConsole()
	hideHelp()
	--rotate cube
	--triMesh:rotAround(1 * getTimeStep())
	
  local camera = getCamera()
  local timeStep = getTimeStep()

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
 -- ----MOVE CAMERA (keyboard)----
if isKeyPressed(87) then --> VK_UP
    camera:moveStanding(speed*timeStep)
  end
  if isKeyPressed(83) then --> VK_DOWN
    camera:moveStanding(-speed*timeStep)
  end
  if isKeyPressed(65) then --> VK_LEFT
    camera:moveSide(speed*timeStep)
  end
  if isKeyPressed(68) then --> VK_RIGHT
    camera:moveSide(-speed*timeStep)
  end
  if isKeyPressed(38) then --> VK_RIGHT
    camera:moveForward(speed*timeStep)
  end
  
  charLight:setPosition(camera:getPosition())

end

function callback.final()
	
	emptyOverlay()
	empty()

end

setScene(Scene(callback.init,callback.update,callback.final,callback.keyDown))