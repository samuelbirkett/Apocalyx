#ifndef LUA_H
#define LUA_H
//// lua interface
typedef int size_t;
typedef int lua_Object;
typedef int lua_Integer;
typedef double lua_Number;
typedef struct lua_State lua_State;
typedef int (*lua_CFunction)(void);
lua_State* lua_getstate(void);
typedef const char *(*lua_Reader) (lua_State *L, void *ud, int *sz);
typedef int (*lua_Writer) (lua_State *L, const void* p, int sz, void* ud);
typedef void *(*lua_Alloc) (void *ud, void *ptr, int osize, int nsize);
// stack manipulation
int lua_checkstack (lua_State *L, int extra);
int lua_gettop(lua_State* LS);
void lua_settop(lua_State* LS, int idx);
void lua_pop(lua_State* LS, int n);
void lua_pushvalue(lua_State* LS, int idx);
void lua_remove(lua_State* LS, int idx);
void lua_insert(lua_State* LS, int idx);
void lua_replace(lua_State* LS, int idx);
// querying the stack
enum {
  LUA_REGISTRYINDEX = -10000, LUA_ENVIRONINDEX = -10001,
  LUA_GLOBALSINDEX = -10002, LUA_MULTRET = -1,
  LUA_TNONE = -1, LUA_TNIL = 0, LUA_TBOOLEAN = 1, LUA_TLIGHTUSERDATA = 2,
  LUA_TNUMBER = 3, LUA_TSTRING = 4, LUA_TTABLE = 5, LUA_TFUNCTION = 6,
  LUA_TUSERDATA = 7, LUA_TTHREAD = 8
};
const char* lua_typename(lua_State *LS, int tp);
int lua_type(lua_State* LS, int idx);
int lua_isnil(lua_State* LS, int idx);
int lua_isboolean(lua_State* LS, int idx);
int lua_isnumber(lua_State* LS, int idx);
int lua_isstring(lua_State* LS, int idx);
int lua_iscfunction(lua_State* LS, int idx);
int lua_isfunction(lua_State* LS, int idx);
int lua_istable(lua_State* LS, int idx);
int lua_isuserdata(lua_State* LS, int idx);
int lua_islightuserdata(lua_State* LS, int idx);
int lua_rawequal(lua_State* LS, int idx1, int idx2);
int lua_equal(lua_State* LS, int idx1, int idx2);
int lua_lessthan(lua_State* LS, int idx1, int idx2);
// getting values from the stack
int lua_toboolean(lua_State* LS, int idx);
double lua_tonumber(lua_State* LS, int idx);
int lua_tointeger(lua_State* LS, int idx);
int lua_objlen(lua_State *LS, int idx);
const char* lua_tolstring(lua_State *LS, int idx, unsigned int* len);
const char* lua_tostring(lua_State* LS, int idx);
int lua_strlen(lua_State* LS, int idx);
lua_CFunction lua_tocfunction(lua_State* LS, int idx);
void* lua_touserdata(lua_State* LS, int idx);
lua_State* lua_tothread(lua_State* LS, int idx);
const void* lua_topointer(lua_State* LS, int idx);
// pushing values onto the stack
void lua_pushnil(lua_State* LS);
void lua_pushboolean(lua_State* LS, int b);
void lua_pushnumber(lua_State* LS, double number);
void lua_pushinteger(lua_State* LS, int number);
void lua_pushlstring(lua_State* LS, const char* s, int len);
void lua_pushstring(lua_State* LS, const char* s);
void lua_pushcfunction(lua_State* LS, lua_CFunction f);
void lua_pushcclosure (lua_State *LS, lua_CFunction fn, int n);
void lua_pushlightuserdata(lua_State* LS, void* p);
void lua_pushthread(lua_State* LS);
void lua_concat(lua_State* LS, int n);
// controlling garbage collection
enum {
  LUA_GCSTOP = 0, LUA_GCRESTART = 1, LUA_GCCOLLECT = 2,
  LUA_GCCOUNT = 3, LUA_GCCOUNTB = 4, LUA_GCSTEP = 5,
  LUA_GCSETPAUSE = 6, LUA_GCSETSTEPMUL = 7
};
int lua_gc(lua_State* LS, int what, int data);
// userdata
void* lua_newuserdata(lua_State* LS, int size);
// metatables
int lua_getmetatable(lua_State* LS, int idx);
int lua_setmetatable(lua_State* LS, int idx);
// manipulating tables
void lua_createtable(lua_State *LS, int narr, int nrec);
void lua_newtable(lua_State* LS);
void lua_gettable(lua_State* LS, int idx);
void lua_getfield(lua_State* LS, int idx, const char* k);
void lua_rawget(lua_State* LS, int idx);
void lua_rawgeti(lua_State* LS, int idx, int n);
void lua_settable(lua_State* LS, int idx);
void lua_setfield(lua_State* LS, int idx, const char* k);
void lua_rawset(lua_State* LS, int idx);
void lua_rawseti(lua_State* LS, int idx, int n);
int lua_next(lua_State* LS, int idx);
// manipulating environments
void lua_getfenv(lua_State* LS, int idx);
int lua_setfenv(lua_State* LS, int idx);
// calling functions
enum {
  LUA_YIELD = 1, LUA_ERRRUN = 2, LUA_ERRSYNTAX = 3,
  LUA_ERRMEM = 4, LUA_ERRERR = 5
};
void lua_call(lua_State* LS, int args, int results);
int lua_pcall(lua_State *LS, int args, int results, int errfunc);
int lua_cpcall(lua_State *LS, lua_CFunction func, void *ud);
int lua_load(lua_State *LS, lua_Reader reader, void *dt, const char *chunkname);
int lua_dump(lua_State *LS, lua_Writer writer, void *data);
// threads
lua_State* lua_newstate(lua_Alloc f, void *ud);
void lua_close(lua_State* thread);
lua_State* lua_newthread(lua_State* LS);
int lua_resume(lua_State* LS, int narg);
int lua_yield(lua_State* LS, int nresults);
int lua_status(lua_State* LS);
void lua_xmove(lua_State* from, lua_State* to, int n);
// allocation
lua_Alloc lua_getallocf(lua_State *LS, void **ud);
void lua_setallocf(lua_State *LS, lua_Alloc f, void *ud);
// manipulating global variables
void lua_getglobal(lua_State* LS, const char* name);
void lua_setglobal(lua_State* LS, const char* name);
// error notifying
void lua_error(lua_State* LS);
#endif // LUA_H