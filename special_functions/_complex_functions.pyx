# =======
# Imports
# =======

from cython import boundscheck, wraparound
from libc.math cimport NAN, isnan, copysign, sqrt, exp, cos, sin


# ============
# complex sqrt
# ============

@boundscheck(False)
@wraparound(False)
cdef double complex complex_sqrt(const double complex z) nogil:
    """
    Returns the square root of a complex function. The branch-cut corresponding
    to :math:`|\\mathrm{arg}(z)| < \\pi` is considered.

    :param z: Complex number
    :type z: double complex
    :return: square root of ``z``.
    :rtype: double complex
    """

    if isnan(z.real) or isnan(z.imag):
        return NAN

    cdef double x = z.real
    cdef double y = z.imag
    cdef double radius = sqrt(x**2 + y**2)
    cdef double cos_angle = x / radius

    cdef double sin_half_angle = copysign(sqrt(0.5 * (1.0 - cos_angle)), y)
    cdef double cos_half_angle = sqrt(0.5 * (1.0 + cos_angle))
    cdef double radius_sqrt = sqrt(radius)

    return radius_sqrt * (cos_half_angle + 1j * sin_half_angle)


# ===========
# complex exp
# ===========

@boundscheck(False)
@wraparound(False)
cdef double complex complex_exp(double complex z) nogil:
    """
    Returns the exponental of a complex function.

    :param z: Complex number
    :type z: double complex
    :return: exponential of ``z``.
    :rtype: double complex
    """

    if isnan(z.real) or isnan(z.imag):
        return NAN

    return exp(z.real) * (cos(z.imag) + 1j * sin(z.imag))
