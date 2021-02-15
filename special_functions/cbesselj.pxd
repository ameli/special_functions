# ============
# Declarations
# ============

cdef double complex cbesselj(
        const double nu,
        const double complex z,
        const int n) nogil

cdef double complex _complex_besselj_half_integer_order(
        const double nu,
        const double complex z) nogil

cdef double complex _complex_besselj_real_order(
        const double nu,
        const double complex z) nogil

cdef double complex _complex_besselj_derivative(
        const double nu,
        const double complex z,
        const int n) nogil
