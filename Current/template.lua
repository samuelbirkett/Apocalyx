----------------------------------------------------
---- Project: Tutorial 1
---- Description:  Basic tutorial, start engine, set
----               clear screen color, update, and
----               finalise.
----
---- Created by: Roswell_r, 2008 for ApocalyX Engine
----------------------------------------------------

---- The following are functions needed at the start of the script. The actual
---- start of the script is at the bottom of the file. You may wish to read
---- the bottom segment first.

---- Modules ----
---- This is used for our group of functions starting with callback.
callback = {}

function callback.init()

         ---- We set the title of our render window. We then also set the size
         ---- of our window. This is part of the WIN object.
         setTitle("Tutorial 1: Basic Engine Template")
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

end

function callback.update()

         ---- Here we could move our objects around and take input
         
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