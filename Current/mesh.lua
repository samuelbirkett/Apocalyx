----------------------------------------------------
---- Project: Tutorial 2
---- Description:  create tables, create shape,
----               create mesh, setup camera, add
----               object to scene.
----
---- Created by: Roswell_r, 2008 for ApocalyX Engine
----------------------------------------------------

---- Modules ----
---- This is used for our group of functions starting with callback.
callback = {}

---- ApocalyX uses the axis          So we're going to create a face/polygon
----        +y|  /+z                                 0 (0, 1, 0)
----    +x    | /                                   / \
----    ------0------                              /   \
----         /|    -x                             /     \
----      -z/ |-y                     (1, -1, 0) 2------1 (-1, -1, 0)
----

tri = { }
---- Contains our vertex data, specifying each point in space
tri.vertices = {  0,  1,  0,
                 -1, -1,  0,
                  1, -1,  0  }

tri.normals = { }
tri.mappings = { }

---- The following Contains the faces of the triangle. We specify 2 faces
---- because part of engine optimisation is to not render the face behind the
---- triangle, to do that would waste valuable cpu time. The engine performs
---- back face culling which it does not render the back face. A function of
---- the SHAPE object is setTwoSided which tells the engine to render this
---- shape without back face culling and you would get a double sided face.
----
---- But instead we will specfy here that we want a two sided triangle.
----
tri.faces = { 0, 1, 2}

function callback.init()

         ---- We set the title of our render window. We then also set the size
         ---- of our window. This is part of the WIN object.
         setTitle("Tutorial 2: First polygon a triangle Shape & Mesh")
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

         ---- This creates a new shape based on our array of vertices, normals
         ---- which are blank, our texture mappings which are also blank and
         ---- our array of faces.
         local triShape = Shape(tri.vertices, tri.normals, tri.mappings, tri.faces)
         
         ---- We've only created a shape which is made up of our vertices and
         ---- faces we now have to add that shape to our mesh. We can use this
         ---- shape later for another mesh or we can manipulate the vertex data
         ---- at a later time. We also give it a default Material().
         triMesh = Mesh(triShape, Material())
         
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
         addObject(triMesh)

end

function callback.update()

         ---- Here we could move out objects around and take input
         ---- Currently we're rotating the Triangle mesh around the Y axis.
         triMesh:rotAround(1 * getTimeStep())

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