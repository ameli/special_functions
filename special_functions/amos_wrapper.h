/*
 *  SPDX-FileCopyrightText: Copyright 2021, Siavash Ameli <sameli@berkeley.edu>
 *  SPDX-License-Identifier: BSD-3-Clause
 *  SPDX-FileType: SOURCE
 *
 *  This program is free software: you can redistribute it and/or modify it
 *  under the terms of the license found in the LICENSE.txt file in the root
 *  directory of this source tree.
 */


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
