# ============
# Declarations
# ============

cdef double complex cbesselk(
        const double nu,
        const double complex z,
        const int n) nogil

cdef double complex _complex_besselk_half_integer_order(
        const double nu,
        const double complex z) nogil

cdef double complex _complex_besselk_real_order(
        const double nu,
        const double complex z) nogil

cdef double complex _complex_besselk_derivative(
        const double nu,
        const double complex z,
        const int n) nogil
