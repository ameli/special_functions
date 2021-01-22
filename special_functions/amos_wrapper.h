#ifndef _AMOS_WRAPPER
#define _AMOS_WRAPPER

#include "fortran_defs.h"

// Declarations of wrapped functions
void F_FUNC(zbesj, ZBESJ)(
        double* ZR, double* ZI, double* FNU, int* KODE, int* N, double* CYR,
        double* CYI, int* NZ, int* IERR);

void F_FUNC(zbesy, ZBESY)(
        double* ZR, double* ZI, double* FNU, int* KODE, int* N, double* CYR,
        double* CYI, int* NZ, double* CWRKR, double* CWRKI, int* IERR);

void F_FUNC(zbesi, ZBESI)(
        double* ZR, double* ZI, double* FNU, int* KODE, int* N, double* CYR,
        double* CYI, int* NZ, int* IERR);

void F_FUNC(zbesk, ZBESK)(
        double* ZR, double* ZI, double* FNU, int* KODE, int* N, double* CYR,
        double* CYI, int* NZ, int* IERR);

void F_FUNC(zbesh, ZBESH)(
        double* ZR, double* ZI, double* FNU, int* KODE, int* M, int* N,
        double* CYR, double* CYI, int* NZ, int* IERR);

#endif
