	----------------------------------------------------
---- Project: Tutorial 3
---- Description:  learn UV coords, load image,
----               create texture, create material,
----               apply texture.
----
---- Created by: Roswell_r, 2008 for ApocalyX Engine
----------------------------------------------------

---- Modules ----
---- This is used for our group of functions starting with callback.
callback = {}

---- ApocalyX uses the axis          So we're going to create a square face
----        +y|  /+z < behind you    0.5, 0.5, 0) 0--------1 (-0.5, 0.5, 0)
----    +x    | /                            |\ _     |
----    ------0------                        |   \ _  |
----         /|    -x                        |      \ |
----      -z/ |-y             (0.5, -0.5, 0) 3--------2 (-0.5, -0.5, 0)
----
---- The square face is made up of 2 polygons, you cant see the split line
---- very well as it is hard to be artistic in ascii, but to the point it is
---- made up of 2 triangles.

square = { }
---- Contains our vertex data, specifying each point in space
square.vertices = {	 -- one per point not triangle!
					--Front
					 0.5,  0.5,  -0.5, --top left
                    -0.5,  0.5,  -0.5, --top right
                    -0.5, -0.5,  -0.5, --bottom right
                     0.5, -0.5,  -0.5, --bottom left
					 -- --Back
					 -- 0.5,  0.5,   0.5, --top left
                    -- -0.5,  0.5,   0.5, --top right
                    -- -0.5, -0.5,   0.5, --bottom right
                     -- 0.5, -0.5,   0.5, --bottom left
					 }

square.normals = { }
---- This time we will be specifying texture mapping quardinants. UV Texture
---- coords are measured from 0-1. Where U is horizontal and V is vertical.
---- By having a positive Vertical UV it means to go up and therefore the start
---- of UV coordinates 0,0 would start at the bottom left of a texture and end
---- coordinates 1,1 would end at the top right of the texture. We just want to
---- map a whole texture to the 2 faces.
square.mappings = { 0,1, 1,1, 1,0, 0,0 }

---- Again here we specify the faces of the triangles, we're going to create
---- 4 faces this time for the same reason in the last tutorial we want a back
---- face behind this as we're going to rotate it like we did in the last
---- example.
square.faces = {--one per triangle and per side/face, corresponds to vertices position in vertices list
				 0, 1, 2, --front top
                 0, 2, 3, --front bottom
                 -- 0, 2, 1, --back top
                 -- 0, 3, 2, --back bottom
				 -- 0, 2, 1, --right top
                 -- 0, 3, 2, --right bottom
				 -- 0, 2, 1, --left top
                 -- 0, 3, 2, --left bottom
				 -- 0, 2, 1, --bottom back
                 -- 0, 3, 2, --bottom front
				 -- 0, 2, 1, --top back
                 -- 0, 3, 2, --top front

				 }

function callback.init()

         ---- We set the title of our render window. We then also set the size
         ---- of our window. This is part of the WIN object.
         setTitle("Tutorial 3: Textured polygons")
         setDimension(800, 600)

         ---- empty() and emptyOverlay() empty the 3D scene objects and 2D
         ---- scene objects. These methods are part of the WORLD object.
         empty()
         emptyOverlay()

         ---- This removes the partial help menu located on the left hand side
         ---- during rendering. With the following command it will simply
         ---- display "F1 Show/Hide Help". If you want to disable the help menu
         ---- completely use the command hideHelp(). These methods are part of
         ---- the WIN object.
         showHelpReduced()

         ---- This sets the blanking colour of the scene. This is colour
         ---- fills the screen after each frame. Part of the WORLD object.
         setClear(0.0,0.0,1.0)

         ---- The following loads a image file from hard disk, in this case we
         ---- are loading a PNG logo of LUA.
         squareImage = Image("powered-by-128.png")
         
         ---- We now have the image data we're going to now turn it into a
         ---- texture for skinning a object. Reason we do this is so the engine
         ---- loads that texture into OpenGL and optimises it for use.
         squareTexture = Texture(squareImage)
         
         ---- We create a default material like we did for the previous example
         ---- but this time we're going to set the DiffuseTexture and give it
         ---- reference to our texture we've just loaded. That means anything
         ---- that has our squareMaterial applied to it will be textured.
         squareMaterial = Material()
         squareMaterial:setDiffuseTexture(squareTexture)

         ---- This creates a new shape based on our array of vertices, normals
         ---- which are blank, our texture mappings which are also blank and
         ---- our array of faces.
         local squareShape = Shape(square.vertices, square.normals, square.mappings, square.faces)
         
         ---- We've only created a shape which is made up of our vertices and
         ---- faces we now have to add that shape to our mesh. We can use this
         ---- shape later for another mesh or we can manipulate the vertex data
         ---- at a later time.
         ----
         ---- Here we specify our squareMaterial which contains our texture to
         ---- be applied to our square face polygons.
         squareMesh = Mesh(squareShape, squareMaterial)
         
         ---- Here we set the perspective of the camera. Part of WORLD object.
         ---- The parameters here are degrees of freedom, meaning degress from
         ---- the camera to render. The second two values are the clipping
         ---- plane and they specify render objects from 1 to 1000 units of
         ---- depth in the scene. [TODO: explain this better]
         setPerspective(60, 1, 1000)
         
         ---- This obtains the default camera for our world. Also WORLD object.
         local camera = getCamera()
         
         ---- Here we reset the camera's position and rotation. Part of the
         ---- REFERENCE class.
         camera:reset()
         
         ---- Because the triangle is positioned at 0,0,0 we need to take a
         ---- step back before we will actually see anything on the screen. So
         ---- we move the camera back 3 units so we have a nice view of the
         ---- mesh. This is part of the REFERENCE class.
         camera:moveForward(-3)

         ---- Add our mesh to our world. This adds the mesh at its current
         ---- position 0,0,0 and will be rendered in our scene. This is part of
         ---- the WORLD object.
         addObject(squareMesh)

end

function callback.update()

         ---- Here we could move out objects around and take input
         ---- Currently we're rotating the Triangle mesh around the Y axis.
         squareMesh:rotAround(1 * getTimeStep())

end

function callback.final()

         ---- empty() and emptyOverlay() empty the 3D scene objects and 2D
         ---- scene objects. This tutorial has no objects but it is always
         ---- good practice to clear the scene. These again are part of the
         ---- WORLD object.
         emptyOverlay()
         empty()

end

----SCENE SETUP----
---- This is where the engine actually gets initilised. The render loop is
---- controlled by ApocalyX and you gain control back through the CallBack
---- functions.

---- What this means is when ApocalyX Engine starts it runs our function
---- callback.init specified in the first parameter.

---- Before the engine renders its next frame to the screen it also runs our
---- function callback.update specified in the second parameter.

---- When you close the program or end the scene the engine runs our function
---- callback.final specified in the third parameter. This is used to free up
---- any resources or you might want to save some data.

setScene(Scene(callback.init,callback.update,callback.final))

---- Scene is a construct method of Scene object and is used for setScene which
---- is part of the WIN object.

