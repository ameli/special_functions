# =======
# Imports
# =======

from cython import boundscheck, wraparound
from libc.stdio cimport printf
from libc.stdlib cimport exit
from libc.math cimport INFINITY, NAN, M_PI_2, isnan
from libc.math cimport round, fabs, exp, sqrt

# Internal modules
from .cbesselk cimport _complex_besselk_real_order


# ==================
# External libraries
# ==================

# Externs from Cephes library
cdef extern from "cephes_wrapper.h":
    double k0(double z) nogil
    double k1(double z) nogil
    double kn(int nu, double z) nogil


# ==========
# py besselk
# ==========

def py_besselk(nu, z, n=0):
    """
    Wrapper for :func:`besselk`.

    :param nu: Parameter :math:`\\nu` of Bessel function.
    :type nu: double

    :param z: Input argument of function.
    :type z: double or double complex

    :param n: Order of the derivative of function. Zero means no derivative.
    :type n: int

    :return: Value of Bessel function.
    :rtype: double or double complex
    """

    # Check nu is real
    if isinstance(nu, complex):
        raise ValueError('nu should be a real number.')

    # Check derivative order is integer
    if not isinstance(n, int):
        raise ValueError('Derivative order should be an integer.')

    # Call pure cythonic function
    return besselk(nu, z, n)


# =======
# besselk
# =======

@boundscheck(False)
@wraparound(False)
cdef double besselk(
        const double nu,
        const double z,
        const int n) nogil:
    """
    Computes real Bessel function or its derivative,
    :math:`\\partial K_{\\nu}(z) / \\partial z`. This function is the cythonic
    interface of this module.

    **Example:**

    This example computes Bessel function :math:`K_{\\nu}(z)` and its first and
    second derivatives for a real argument. The python's ``gil`` can be
    optionally released, especially when this feature is needed during parallel
    OpenMP environments.

    .. code-block:: python

        >>> # cimport module in a *.pyx file
        >>> from special_functions cimport besselk

        >>> # Declare typed variables
        >>> cdef double nu = 2.5
        >>> cdef double z = 2.0
        >>> cdef double d0k, d1k, d2k

        >>> # Releasing gil to secure maximum cythonic speedup
        >>> with nogil:
        ...     d0k = besselk(nu, z, 0)    # no derivative
        ...     d1k = besselk(nu, z, 1)    # 1st derivative
        ...     d2k = besselk(nu, z, 2)    # 2nd derivative

    .. seealso::

        * :func:`py_besselk`: python wrapper to this function.
        * :func:`cbesselk`: cython interface for real numbers.
    """

    # Check nan
    if isnan(nu) or isnan(z):
        return NAN

    # Check positive derivative order
    if n < 0:
        printf('ERROR: Derivative order should be non-negative integer.\n')
        exit(1)

    # Check domain of function
    if z < 0:
        return NAN

    # Handling negative nu
    if nu < 0:
        return besselk(-nu, z, n)

    # Dispatch to internal functions
    cdef double complex output
    cdef double tolerance = 1e-16
    if n == 0:

        if z == 0:
            return INFINITY
        elif round(nu) == nu:
            return _real_besselk_integer_order(int(nu), z)
        elif round(nu + 0.5) == nu + 0.5:
            return _real_besselk_half_integer_order(nu, z)
        else:
            output = _complex_besselk_real_order(nu, z + 0j)

            # Check if the complex functions returned zero imaginary part
            if fabs(output.imag) > tolerance:
                printf('ERROR: ')
                printf('Mismatch of real input and complex output detected. ')
                printf('input: %f, output: %e + %ej.\n',
                       z, output.real, output.imag)
                exit(1)
            else:
                return output.real

    else:
        return _real_besselk_derivative(nu, z, n)


# ===============================
# real besselk half integer order
# ===============================

@boundscheck(False)
@wraparound(False)
cdef double _real_besselk_half_integer_order(
        const double nu,
        const double z) nogil:
    """
    Real Bessel functon of half integer order
    :math:`\\nu = m + \\frac{1}{2}`.

    The recursive formula for half-integer order can be found in
    `DLMF, equation 10.29.5 <https://dlmf.nist.gov/10.29#E1>`_.
    """

    cdef double k_nu_1    # used for nu-1
    cdef double k_nu_2    # used for nu-2
    cdef double k_nu      # output

    if z == 0:
        return INFINITY
    elif z < 0:
        return NAN

    if fabs(nu) == 0.5:
        k_nu = sqrt(M_PI_2 / z) * exp(-z)
    else:

        # Using recursive formula
        k_nu_1 = _real_besselk_half_integer_order(nu-1, z)
        k_nu_2 = _real_besselk_half_integer_order(nu-2, z)
        k_nu = ((2.0 * (nu-1)) / z) * k_nu_1 + k_nu_2

    return k_nu


# ==========================
# real besselk integer order
# ==========================

@boundscheck(False)
@wraparound(False)
cdef double _real_besselk_integer_order(
        const int nu,
        const double z) nogil:
    """
    Wrapper using `cephes <https://www.netlib.org/cephes/>`_ library which
    implements Bessel functions with integer orders of :math:`\\nu` and for
    real argument :math:`z`.
    """

    if nu == 0:
        return k0(z)
    elif nu == 1:
        return k1(z)
    else:
        return kn(nu, z)


# =======================
# real besselk derivative
# =======================

@boundscheck(False)
@wraparound(False)
cdef double _real_besselk_derivative(
        const double nu,
        const double z,
        const int n) nogil:
    """
    Derivative of Bessel function: :math:`\\partial K_v(z) / \\partial z`.

    The derivative formula can be found in
    `DLMF, equation 10.29.5 <https://dlmf.nist.gov/10.29#E5>`_.
    """

    cdef int i
    cdef double phase = 1.0
    cdef double combination = 1.0
    cdef double summand = besselk(nu-n, z, 0)

    for i in range(1, n+1):
        combination *= phase * (n-i+1) / i
        summand += combination * besselk(nu-n + 2*i, z, 0)

    return (-1.0)**n * summand / (2.0**n)
