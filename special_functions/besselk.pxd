# ============
# Declarations
# ============

cdef double besselk(
        const double nu,
        const double z,
        const int n) nogil

cdef double _real_besselk_half_integer_order(
        const double nu,
        const double z) nogil

cdef double _real_besselk_integer_order(
        const int nu,
        const double z) nogil

cdef double _real_besselk_derivative(
        const double nu,
        const double z,
        const int n) nogil
