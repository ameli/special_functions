/*
 *  SPDX-FileCopyrightText: Copyright 2021, Siavash Ameli <sameli@berkeley.edu>
 *  SPDX-License-Identifier: BSD-3-Clause
 *  SPDX-FileType: SOURCE
 *
 *  This program is free software: you can redistribute it and/or modify it
 *  under the terms of the license found in the LICENSE.txt file in the root
 *  directory of this source tree.
 */


#ifndef _CEPHES_WRAPPER
#define _CEPHES_WRAPPER

// Declarations of Cephes library
double k0(double x);
double k1(double x);
double kn(int nu, double x);
double i0(double x);
double i1(double x);
double j0(double x);
double j1(double x);
double jn(int nu, double x);
double yn(int nu, double x);
// double gamma(double x);
double lgam(double x);

#endif
