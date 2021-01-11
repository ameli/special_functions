cdef double complex besselk(
        double nu,
        const double complex z,
        const int n) nogil

cdef double _real_besselk_integer_order(
        const int nu,
        const double z) nogil

cdef double complex _complex_besselk_half_integer_order(
        double nu,
        const double complex z) nogil

cdef double complex _complex_besselk_real_order(
        const double nu,
        const double complex z) nogil

cdef double complex _besselk_derivative(
        const double nu,
        const double complex z,
        const int n) nogil
