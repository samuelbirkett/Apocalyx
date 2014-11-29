//Several ways to call functions stored in Dynamic Link Libraries
//Questions? Contact: Leonardo Boselli <boselli@uno.it>

// Only a few functions definitions: No need to load long headers
void printf(const char* fmt, ...);

typedef struct Library Library;
Library* libraryLoad(const char* libName);
void libraryFree(Library* lib);
void* libraryGetProcAddress(Library* lib, const char* funcName);

typedef float (*NormFunc)(float x, float y, float z);
float norm(float x, float y, float z);

// function main() loaded and executed by LUA
int main(void) {
  printf("a) ... the use of libraryGetProcAddress()\n");
  Library* lib = libraryLoad("SampleLibrary.dll");
  NormFunc normFunc = (NormFunc)libraryGetProcAddress(lib,"norm");
  // This way there is no need to use Compiler:addLibrary() from LUA
  float val = normFunc(2,3,4);
  libraryFree(lib);
  printf("The norm of (2,3,4) is %f\n",val);
  //
  printf("b) ... the use of the addLibrary() method\n");
  // The linker looks for norm() in the DLLs added by LUA with Compiler:addLibrary()
  val = norm(2,3,4);
  printf("The norm of (2,3,4) is %f\n",val);
  //
  // Since the function does not return any argument to the LUA caller,
  // it specifies that zero argument were pushed on the LUA stack.
  // That's why this function MUST return zero.
  return 0;
}
