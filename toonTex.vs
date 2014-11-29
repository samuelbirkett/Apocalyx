varying vec3 vNormal;
varying vec3 vVertex;
void main(void) {
  gl_TexCoord[0] = gl_MultiTexCoord0; 
  vVertex = gl_Vertex.xyz;
  vNormal = gl_Normal;
  gl_Position = gl_ModelViewProjectionMatrix*gl_Vertex;
} 

 

