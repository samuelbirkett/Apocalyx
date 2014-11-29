#ifndef LAUXLIB_H
#define LAUXLIB_H
#include "lua.h"
typedef struct luaL_Buffer luaL_Buffer;
void luaL_addchar (luaL_Buffer *B, char c);
void luaL_addlstring (luaL_Buffer *B, const char *s, size_t l);
void luaL_addsize (luaL_Buffer *B, size_t n);
void luaL_addstring (luaL_Buffer *B, const char *s);
void luaL_addvalue (luaL_Buffer *B);
void luaL_argcheck (lua_State *L,
  int cond, int numarg, const char *extramsg);
int luaL_argerror (lua_State *L, int numarg, const char *extramsg);
void luaL_buffinit (lua_State *L, luaL_Buffer *B);
int luaL_callmeta (lua_State *L, int obj, const char *e);
void luaL_checkany (lua_State *L, int narg);
int luaL_checkint (lua_State *L, int narg);
lua_Integer luaL_checkinteger (lua_State *L, int narg);
long luaL_checklong (lua_State *L, int narg);
const char *luaL_checklstring (lua_State *L, int narg, size_t *l);
lua_Number luaL_checknumber (lua_State *L, int narg);
int luaL_checkoption (lua_State *L,
  int narg, const char *def, const char *const lst[]);
void luaL_checkstack (lua_State *L, int sz, const char *msg);
const char *luaL_checkstring (lua_State *L, int narg);
void luaL_checktype (lua_State *L, int narg, int t);
void *luaL_checkudata (lua_State *L, int narg, const char *tname);
int luaL_dofile (lua_State *L, const char *filename);
int luaL_dostring (lua_State *L, const char *str);
int luaL_error (lua_State *L, const char *fmt, ...);
int luaL_getmetafield (lua_State *L, int obj, const char *e);
void luaL_getmetatable (lua_State *L, const char *tname);
const char *luaL_gsub (lua_State *L,
  const char *s, const char *p, const char *r);
int luaL_loadbuffer (lua_State *L,
  const char *buff, size_t sz, const char *name);
int luaL_loadfile (lua_State *L, const char *filename);
int luaL_loadstring (lua_State *L, const char *s);
int luaL_newmetatable (lua_State *L, const char *tname);
lua_State *luaL_newstate (void);
void luaL_openlibs (lua_State *L);
int luaL_optint (lua_State *L, int narg, int d);
lua_Integer luaL_optinteger (lua_State *L, int narg, lua_Integer d);
long luaL_optlong (lua_State *L, int narg, long d);
const char *luaL_optlstring (lua_State *L,
  int narg, const char *d, size_t *l);
lua_Number luaL_optnumber (lua_State *L, int narg, lua_Number d);
const char *luaL_optstring (lua_State *L, int narg, const char *d);
char *luaL_prepbuffer (luaL_Buffer *B);
void luaL_pushresult (luaL_Buffer *B);
int luaL_ref (lua_State *L, int t);
typedef struct luaL_Reg {
  const char *name;
  lua_CFunction func;
} luaL_Reg;
void luaL_register (lua_State *L,
  const char *libname, const luaL_Reg *l);
const char *luaL_typename (lua_State *L, int idx);
int luaL_typerror (lua_State *L, int narg, const char *tname);
void luaL_unref (lua_State *L, int t, int ref);
void luaL_where (lua_State *L, int lvl);
#endif // LAUXLIB_H
