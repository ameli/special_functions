#ifndef _AMOS_WRAPPER
#define _AMOS_WRAPPER

#include "fortran_defs.h"

// Declarations of wrapped functions
void F_FUNC(zbesk,ZBESK)(double* ZR,double* ZI,double* FNU,int* KODE,int* N,double* CYR,double* CYI,int* NZ,int* IERR);

#endif
