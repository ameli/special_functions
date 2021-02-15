# ============
# Declarations
# ============

cdef double complex cbesseli(
        const double nu,
        const double complex z,
        const int n) nogil

cdef double complex _complex_besseli_half_integer_order(
        const double nu,
        const double complex z) nogil

cdef double complex _complex_besseli_real_order(
        const double nu,
        const double complex z) nogil

cdef double complex _complex_besseli_derivative(
        const double nu,
        const double complex z,
        const int n) nogil
