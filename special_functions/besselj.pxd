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

cdef double besselj(
        const double nu,
        const double z,
        const int n) noexcept nogil

cdef double _real_besselj_half_integer_order(
        const double nu,
        const double z) noexcept nogil

cdef double _real_besselj_integer_order(
        const int nu,
        const double z) noexcept nogil

cdef double _real_besselj_derivative(
        const double nu,
        const double z,
        const int n) noexcept nogil
