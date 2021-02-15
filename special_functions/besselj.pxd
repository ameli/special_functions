# ============
# Declarations
# ============

cdef double besselj(
        const double nu,
        const double z,
        const int n) nogil

cdef double _real_besselj_half_integer_order(
        const double nu,
        const double z) nogil

cdef double _real_besselj_integer_order(
        const int nu,
        const double z) nogil

cdef double _real_besselj_derivative(
        const double nu,
        const double z,
        const int n) nogil
