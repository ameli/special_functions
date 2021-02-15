# ============
# Declarations
# ============

cdef double besseli(
        const double nu,
        const double z,
        const int n) nogil

cdef double _real_besseli_half_integer_order(
        const double nu,
        const double z) nogil

cdef double _real_besseli(
        const double nu,
        const double z) nogil

cdef double _real_besseli_derivative(
        const double nu,
        const double z,
        const int n) nogil
