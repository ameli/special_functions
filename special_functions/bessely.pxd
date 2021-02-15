# ============
# Declarations
# ============

cdef double bessely(
        const double nu,
        const double z,
        const int n) nogil

cdef double _real_bessely_half_integer_order(
        const double nu,
        const double z) nogil

cdef double _real_bessely_integer_order(
        const int nu,
        const double z) nogil

cdef double _real_bessely_derivative(
        const double nu,
        const double z,
        const int n) nogil
