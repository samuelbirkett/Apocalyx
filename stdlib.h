#ifndef STDLIB_H
#define STDLIB_H
#define NULL ((void*)0)
//// random
void randomize(void);
int rand(void);
void srand(unsigned seed);
//// memory
void* malloc(int size);
void* realloc(void* block, int size);
void free(void *block);
//// environment
char *getenv(const char *name);
int putenv(const char *name);
#endif // STDLIB_H