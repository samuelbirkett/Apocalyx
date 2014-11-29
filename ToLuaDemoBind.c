/*
** Lua binding: ToLuaDemoBind
** Generated automatically by tolua++-1.0.92 on 07/23/06 09:08:48.
*/

#ifndef __cplusplus
#include "stdlib.h"
#endif
#include "string.h"

#include "tolua++.h"

/* Exported function */
TOLUA_API int  tolua_ToLuaDemoBind_open (lua_State* tolua_S);


/* function to register type */
static void tolua_reg_types (lua_State* tolua_S)
{
}

/* function: polarToCartesian */
#ifndef TOLUA_DISABLE_tolua_ToLuaDemoBind_polarToCartesian00
static int tolua_ToLuaDemoBind_polarToCartesian00()//lua_State* tolua_S)
{
  lua_State* tolua_S = lua_getstate();
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isnumber(tolua_S,1,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  float r = ((float)  tolua_tonumber(tolua_S,1,0));
  float alpha = ((float)  tolua_tonumber(tolua_S,2,0));
  {
   polarToCartesian(&r,&alpha);
   tolua_pushnumber(tolua_S,(lua_Number)r);
   tolua_pushnumber(tolua_S,(lua_Number)alpha);
  }
 }
 return 2;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'polarToCartesian'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: cartesianToPolar */
#ifndef TOLUA_DISABLE_tolua_ToLuaDemoBind_cartesianToPolar00
static int tolua_ToLuaDemoBind_cartesianToPolar00()//lua_State* tolua_S)
{
  lua_State* tolua_S = lua_getstate();
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isnumber(tolua_S,1,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  float x = ((float)  tolua_tonumber(tolua_S,1,0));
  float y = ((float)  tolua_tonumber(tolua_S,2,0));
  {
   cartesianToPolar(&x,&y);
   tolua_pushnumber(tolua_S,(lua_Number)x);
   tolua_pushnumber(tolua_S,(lua_Number)y);
  }
 }
 return 2;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'cartesianToPolar'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* Open function */
TOLUA_API int tolua_ToLuaDemoBind_open (lua_State* tolua_S)
{
 tolua_open(tolua_S);
 tolua_reg_types(tolua_S);
 tolua_module(tolua_S,NULL,0);
 tolua_beginmodule(tolua_S,NULL);
  tolua_function(tolua_S,"polarToCartesian",tolua_ToLuaDemoBind_polarToCartesian00);
  tolua_function(tolua_S,"cartesianToPolar",tolua_ToLuaDemoBind_cartesianToPolar00);
 tolua_endmodule(tolua_S);
 return 1;
}


#if defined(LUA_VERSION_NUM) && LUA_VERSION_NUM >= 501
 TOLUA_API int luaopen_ToLuaDemoBind (lua_State* tolua_S) {
 return tolua_ToLuaDemoBind_open(tolua_S);
};
#endif

