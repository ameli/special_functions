# SPDX-FileCopyrightText: Copyright 2021, Siavash Ameli <sameli@berkeley.edu>
# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileType: SOURCE
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the license found in the LICENSE.txt file in the root
# directory of this source tree.


# ============
# Declarations
# ============

cdef double complex cbesselj(
        const double nu,
        const double complex z,
        const int n) noexcept nogil

cdef double complex _complex_besselj_half_integer_order(
        const double nu,
        const double complex z) noexcept nogil

cdef double complex _complex_besselj_real_order(
        const double nu,
        const double complex z) noexcept nogil

cdef double complex _complex_besselj_derivative(
        const double nu,
        const double complex z,
        const int n) noexcept nogil
