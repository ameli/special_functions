# ============
# Declarations
# ============

cdef double complex cbessely(
        const double nu,
        const double complex z,
        const int n) nogil

cdef double complex _complex_bessely_half_integer_order(
        const double nu,
        const double complex z) nogil

cdef double complex _complex_bessely_real_order(
        const double nu,
        const double complex z) nogil

cdef double complex _complex_bessely_derivative(
        const double nu,
        const double complex z,
        const int n) nogil
