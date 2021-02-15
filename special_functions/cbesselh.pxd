# ============
# Declarations
# ============

cdef double complex cbesselh(
        const double nu,
        const int k,
        const double complex z,
        const int n) nogil

cdef double complex _complex_besselh_half_integer_order(
        const double nu,
        const int k,
        const double complex z) nogil

cdef double complex _complex_besselh_real_order(
        const double nu,
        const int k,
        const double complex z) nogil

cdef double complex _complex_besselh_derivative(
        const double nu,
        const int k,
        const double complex z,
        const int n) nogil
