#ifndef TOLUA_H
#define TOLUA_H
#define TOLUA_API extern
#include "lua.h"
struct tolua_Error {int index; int array; const char* type;};
typedef struct tolua_Error tolua_Error;
const char* tolua_typename(lua_State* L, int lo);
void tolua_error(lua_State* L, char* msg, tolua_Error* err);
int tolua_isnoobj(lua_State* L, int lo, tolua_Error* err);
int tolua_isvalue(lua_State* L, int lo, int def, tolua_Error* err);
int tolua_isboolean(lua_State* L, int lo, int def, tolua_Error* err);
int tolua_isnumber(lua_State* L, int lo, int def, tolua_Error* err);
int tolua_isstring(lua_State* L, int lo, int def, tolua_Error* err);
int tolua_istable(lua_State* L, int lo, int def, tolua_Error* err);
int tolua_isusertable(lua_State* L, int lo, const char* type, int def, tolua_Error* err);
int tolua_isuserdata(lua_State* L, int lo, int def, tolua_Error* err);
int tolua_isusertype(lua_State* L, int lo, const char* type, int def, tolua_Error* err);
int tolua_isvaluearray(lua_State* L, int lo, int dim, int def, tolua_Error* err);
int tolua_isbooleanarray(lua_State* L, int lo, int dim, int def, tolua_Error* err);
int tolua_isnumberarray(lua_State* L, int lo, int dim, int def, tolua_Error* err);
int tolua_isstringarray(lua_State* L, int lo, int dim, int def, tolua_Error* err);
int tolua_istablearray(lua_State* L, int lo, int dim, int def, tolua_Error* err);
int tolua_isuserdataarray(lua_State* L, int lo, int dim, int def, tolua_Error* err);
int tolua_isusertypearray(lua_State* L, int lo, const char* type, int dim, int def, tolua_Error* err);
void tolua_open(lua_State* L);
void* tolua_copy(lua_State* L, void* value, unsigned int size);
int tolua_register_gc(lua_State* L, int lo);
int tolua_default_collect(lua_State* tolua_S);
void tolua_usertype(lua_State* L, char* type);
void tolua_beginmodule(lua_State* L, char* name);
void tolua_endmodule(lua_State* L);
void tolua_module(lua_State* L, char* name, int hasvar);
void tolua_cclass(lua_State* L, char* lname, char* name, char* base, lua_CFunction col);
void tolua_function(lua_State* L, char* name, lua_CFunction func);
void tolua_constant(lua_State* L, char* name, double value);
void tolua_variable(lua_State* L, char* name, lua_CFunction get, lua_CFunction set);
void tolua_array(lua_State* L,char* name, lua_CFunction get, lua_CFunction set);
void tolua_pushvalue(lua_State* L, int lo);
void tolua_pushboolean(lua_State* L, int value);
void tolua_pushnumber(lua_State* L, double value);
void tolua_pushstring(lua_State* L, const char* value);
void tolua_pushuserdata(lua_State* L, void* value);
void tolua_pushusertype(lua_State* L, void* value, const char* type);
void tolua_pushusertype_and_takeownership(lua_State* L, void* value, const char* type);
void tolua_pushfieldvalue(lua_State* L, int lo, int index, int v);
void tolua_pushfieldboolean(lua_State* L, int lo, int index, int v);
void tolua_pushfieldnumber(lua_State* L, int lo, int index, double v);
void tolua_pushfieldstring(lua_State* L, int lo, int index, const char* v);
void tolua_pushfielduserdata(lua_State* L, int lo, int index, void* v);
void tolua_pushfieldusertype(lua_State* L, int lo, int index, void* v, const char* type);
void tolua_pushfieldusertype_and_takeownership(lua_State* L, int lo, int index, void* v, const char* type);
double tolua_tonumber(lua_State* L, int narg, double def);
const char* tolua_tostring(lua_State* L, int narg, const char* def);
void* tolua_touserdata(lua_State* L, int narg, void* def);
void* tolua_tousertype(lua_State* L, int narg, void* def);
int tolua_tovalue(lua_State* L, int narg, int def);
int tolua_toboolean(lua_State* L, int narg, int def);
double tolua_tofieldnumber(lua_State* L, int lo, int index, double def);
const char* tolua_tofieldstring(lua_State* L, int lo, int index, const char* def);
void* tolua_tofielduserdata(lua_State* L, int lo, int index, void* def);
void* tolua_tofieldusertype(lua_State* L, int lo, int index, void* def);
int tolua_tofieldvalue(lua_State* L, int lo, int index, int def);
int tolua_getfieldboolean(lua_State* L, int lo, int index, int def);
void tolua_dobuffer(lua_State* L, char* B, unsigned int size, const char* name);
int class_gc_event(lua_State* L);
#define tolua_tocppstring tolua_tostring
#define tolua_tofieldcppstring tolua_tofieldstring
int tolua_fast_isa(lua_State *L, int mt_indexa, int mt_indexb, int super_index);
#endif // TOLUA_H
