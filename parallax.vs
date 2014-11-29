// attribute vec3 tangent;
// attribute vec3 binormal;

// To simplify this shader I use a versor 'ver' that point
// up and this means that the shader works correctly
// only for vertical faces. A better approach is to pass
// 'tangent' and 'binormal' versors for each face

varying vec3 eyeVec;

void main() { 
  gl_TexCoord[0] = gl_MultiTexCoord0; 
  vec3 ver = vec3(0,1,0);
  //
  vec3 tangent = cross(ver,gl_Normal);
  vec3 binormal = cross(gl_Normal,tangent);
  //
  mat3 TBN_Matrix;// = mat3(tangent, binormal, gl_Normal);  
  TBN_Matrix[0] =  gl_NormalMatrix * tangent; 
  TBN_Matrix[1] =  gl_NormalMatrix * binormal; 
  TBN_Matrix[2] =  gl_NormalMatrix * gl_Normal; 
  vec4 Vertex_ModelView = gl_ModelViewMatrix * gl_Vertex; 
  eyeVec = vec3(-Vertex_ModelView) * TBN_Matrix ;      
  // Vertex transformation 
  gl_Position = ftransform(); 
}
