!!ARBfp1.0

# REFRACTIVE SPHERE
# Copyright (c) 2004 Leonardo Boselli (boselli@uno.it)
# written for the "Shader Triathlon - Summer 2004"
# a shader competition organized by ShaderTech.com

# This fragment program simulates a perfect sphere that refracts
# and reflects the surrounding environment. The fragment program
# must be attached to a square sprite that always faces the camera
# so that its sides are always parallel to the 'up' and 'left'
# orientations of the camera and consequently the view direction
# is perpendicular to the sprite. The environment must be
# composed of a sky box and an infinite plane centered at
# the origin of the coordinates laying on the x and z axis.
#
# Given the sprite, the sky box and the plane so defined,
# the fregment program renders on the sprite a perfect sphere
# that reflects and refracts the sky box and the plane
# as defined by seven local parameters.
#
# First of all, texture[0] must contain the 2D texture applied
# to the infinite plane, while texture[1] must contain the
# CUBE map texture applied to the skybox.
#
# Then the following local parameters must be provided:

# PARAMETERS

PARAM geoK = program.local[0]; # geometric constants
#   .x = 1/r
# contains the inverse of the radius of the sphere
#   .y = 1/a 
# contains the inverse of the length of the side of the texture
# tiles applied to the infinite plane
#   .z = r^2-(O-C)^2 (r2mOC2)
# contains the result of the difference between the square of the
# radius and the square of the length of the vector that goes
# from the center of the sphere to the position of the camera
#   .w = lrp (amount of reflection for lerp)
# contains the amount of reflection of the sphere:
# 0 means no reflection (only refraction)
# 1 means full reflection (no refraction)

PARAM optK = program.local[1]; # optic constants
#   .x = n (refraction index)
# value of the index of refraction. Interesting values are:
# 1 (air, no refraction), 1.33 (water), 1.52 (crown glass),
# 1.66 (flint glass)
#   .y = 1/n (invN - inverse of the refraction index)
# contains the inverse of the index of refraction
#   .z = n^2-1 (n2m1)
# contains the square of the index of refraction minus 1
#   .w = 1/(n^2)-1 (invN2m1)
# contains the square of the inverse of the index of
# refraction minus 1

PARAM U  = program.local[2]; # sprite horiz. generator (length l)
# gives the horizontal vector that represent the horizontal side
# of the sprite. It is aligned along the right-left direction of
# the camera and its length is equal to the length of the side of
# the sprite

PARAM W  = program.local[3]; # sprite vert.  generator (length l)
# gives the vertical vector that represent the vertical side
# of the sprite. It is aligned along the down-up direction of the
# camera and its length is equal to the length of the side of the
# sprite

PARAM O  = program.local[4]; # camera location
# contains the position of the camera

PARAM RO = program.local[5]; # R-O (sprite lower-left loc. rel. to O)
# contains the vector that goes from the position of the camera to
# the lower left corner of the sprite. This relation holds:
# R = C - (W + U) / 2

PARAM C  = program.local[6]; # center of the sphere
# contains the position of the center of the sphere

PARAM OC = program.local[7]; # O-C (camera loc. relative to C)
# contains the vector that goes from the center of the sphere
# to the position of the camera

# The fragment program makes use of seven temporary variables
# and returns the color of the current (s,t) fragment.

# CODE

# NORMALIZED VIEW DIRECTION TO THE PIXEL
# Given the 'texcoord's of the current fragment, compute the
# corresponding normalized view direction (V).

TEMP V;
MAD V, fragment.texcoord.x, U, RO;
MAD V, fragment.texcoord.y, W, V;
TEMP invLenV;
DP3 invLenV, V, V;
RSQ invLenV, invLenV.x;
MUL V, invLenV, V;

# SEARCH FOR VIEW-SPHERE INTERSECTIONS
# Given the view direction V, solve the second order equation
# and check if any intersection exists. Kill the fragment if
# view ray does not intersects sphere.

ALIAS delta4 = invLenV;
TEMP VdotOC;
DP3 VdotOC, V, OC;
MAD delta4, VdotOC, VdotOC, geoK.z;
KIL delta4; # NO INTERSECTIONS FOR NEGATIVE DELTA

# NEAREST INTERSECTION
# So at least an intersection exists. Find the nearer to the
# camera (P).

TEMP P;
RSQ delta4, delta4.x;
RCP delta4, delta4.x;
ADD delta4, VdotOC, delta4;
MAD P, -V, delta4, O;

# NORMAL AT INTERSECTION POINT
# Compute the normal vector (N) to the sphere at the intersection
# point.

ALIAS PC = delta4;
SUB PC, P, C;
TEMP N;
MUL N, PC, geoK.x;
ALIAS NdotV = VdotOC;
DP3 NdotV, N, V;

# PREPARE FOR FIRST REFRACTION (index n)
# Preliminary computations for refraction.

TEMP cosR;
MAD cosR, NdotV, NdotV, optK.z;
RSQ cosR, cosR.x;
RCP cosR, cosR.x;
ADD cosR, cosR, NdotV;

# REFRACTED VIEW
# Find the direction of the refracted view (Vp).
# Now the ray travels in the sphere.

ALIAS Vp = V;
MAD Vp, cosR, -N, V;
MUL Vp, Vp, optK.y;

# COMPUTE PLANE MAP REFLECTION COLOR
# Compute the reflected view and look for the color of the
# corresponding point on the infinite plane, considering
# also the fog parameters (assumed EXP2).

TEMP Vr;
ADD Vr, N, N;
MAD Vr, -Vr, NdotV, V;
ALIAS planeRefl = NdotV;
RCP planeRefl, Vr.y;
MUL planeRefl, planeRefl, P.y;

TEMP fog;
MUL fog, state.fog.params.x, planeRefl;
MUL fog, fog, fog;
POW_SAT fog, 2.7182818.x, -fog.x;

MAD planeRefl, planeRefl, -Vr.xzyw, P.xzyw;
MUL planeRefl, planeRefl, geoK.y;
FRC planeRefl, planeRefl;
TEX planeRefl, planeRefl, texture[1], 2D;

LRP planeRefl, fog, planeRefl, state.fog.color;

# REFRACTED POINT OF INTERSECTION
# Find the point of intersection (Pp) of the refracted view with
# the sphere. The ray travels in the sphere, starting from a
# point on the sphere, so that intersection always exists.

ALIAS Pp = P;
DP3 PC, PC, Vp;
ADD PC, PC, PC;
MAD Pp, -PC, Vp, P;

# CHOOSE THE RIGHT REFLECTIVE COLOR BETWEEN PLANE MAP AND CUBE MAP
# Back to reflection. Find the color on the cube map corresponding
# to the reflected view and choose this or the color from the
# plane according to the direction of the reflected view. If it
# points up, use cube map, while if it points down, use plane.

ALIAS cubeRefl = PC;
TEX cubeRefl, Vr, texture[0], CUBE;
ALIAS colorRefl = PC;
CMP colorRefl, Vr.y, planeRefl, cubeRefl;

# NORMAL AT REFRACTED POINT OF INTERSECTION
# Compute the normal to the sphere at the sedond point of
# intersection.

ALIAS Np = N;
SUB Np, Pp, C;
MUL Np, Np, geoK.x;
ALIAS NdotVp = NdotV;
DP3 NdotVp, Np, Vp;

# PREPARE FOR SECOND REFRACTION (index 1/n, going outside)
# The refracted ray exits the sphere so it is refrected again
# but now the value of the index of refraction is 1/n

MAD cosR, NdotVp, NdotVp, optK.w;
RSQ cosR, cosR.x;
RCP cosR, cosR.x;
SUB cosR, cosR, NdotVp;

# NEW REFRACTED VIEW
# Find the new direction of the refracted view (Vs).
# Now the ray travels outside the sphere.

ALIAS Vs = Vp;
MAD Vs, cosR, Np, Vp;
MUL Vs, Vs, optK.x;

# REFRACTED COLOR
# Given the refracted view, look for the color of the
# corresponding point on the infinite plane, considering
# also the fog parameters (assumed EXP2), and on the
# cube map of the sky box.
# If the refracted view points up, use cube map, while
# if it points down, use plane.

ALIAS cubeRefr = NdotVp;
TEX cubeRefr, Vs, texture[0], CUBE;
ALIAS planeRefr = cosR;
RCP planeRefr, Vs.y;
MUL planeRefr, planeRefr, Pp.y;

MUL fog, state.fog.params.x, planeRefr;
MUL fog, fog, fog;
POW_SAT fog, 2.7182818.x, -fog.x;

MAD planeRefr, planeRefr, -Vs.xzyw, Pp.xzyw;
MUL planeRefr, planeRefr, geoK.y;
FRC planeRefr, planeRefr;
TEX planeRefr, planeRefr, texture[1], 2D;

LRP planeRefr, fog, planeRefr, state.fog.color;

ALIAS colorRefr = Vs;
CMP colorRefr, Vs.y, planeRefr, cubeRefr;

# LERP REFLECTIVE AND REFRACTED COLORS
# Linear interpolate between the computed refracted and
# reflected colors using the given factor and output
# the result.

LRP result.color, geoK.w, colorRefl, colorRefr;

END
