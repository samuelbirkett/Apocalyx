#ifndef CORE_H
#define CORE_H
//// stdlib
#include "stdlib.h"
//// string
#include "string.h"
//// math
double acos(double x);
double asin(double x);
double atan(double x);
double atan2(double y, double x);
double ceil(double x);
double cos(double x);
double exp(double x);
double fabs(double x);
double floor(double x);
double fmod(double x, double y);
double log(double x);
double log10(double x);
double modf(double x, double *ipart);
double pow(double x, double y);
double sin(double x);
double sqrt(double x);
double tan(double x);
//// I/O
// standard
void printf(const char* format, ...);
int putchar(int c);
// string
int sprintf(char *buffer, const char *format, ...);
int sscanf(const char *buffer, const char *format, ...);
// file
typedef struct FILE FILE;
FILE* fopen(const char *file_name, const char *mode);
int fprintf(FILE *file, const char *format, ...);
int fscanf(FILE *file, const char *format, ...);
int fwrite(const void *buffer, int itemSize, int itemCount, FILE *file);
int fread(void *buffer, int itemSize, int itemCount, FILE *file);
int fseek(FILE* file, int offset, int whence);
int ftell(FILE *file);
int fclose(FILE *file);
//// memory
void* memset(void *s, int c, int n);
void* memcpy(void *dest, const void *src, int size);
////time
int time(int *timer);
int clock(void);
//// DLLs
typedef struct Library Library;
Library* libraryLoad(const char* libName);
int libraryFree(Library* lib);
void* libraryGetProcAddress(Library* lib, const char* funcName);
//// opengl
void* oglGetProcAddress(const char* funcName);
int oglIsExtensionSupported(const char* extName);
//// exit C mode
void exitC(void);
#endif // CORE_H