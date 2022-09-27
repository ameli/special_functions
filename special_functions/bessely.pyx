# =======
# Imports
# =======

# External modules
from cython import boundscheck, wraparound
from libc.stdio cimport printf
from libc.stdlib cimport exit
from libc.math cimport INFINITY, NAN, M_PI, M_2_PI, isnan
from libc.math cimport round, fabs, sqrt, cos, sin, copysign

# Internal modules
from ._complex_functions cimport complex_sqrt, complex_cos, complex_sin
from .besselj cimport besselj
from .cbessely cimport _complex_bessely_real_order


# ==================
# External libraries
# ==================

# Externs from Cephes library
cdef extern from "cephes_wrapper.h":
    double yn(int nu, double z) nogil


# ==========
# py bessely
# ==========

def py_bessely(nu, z, n=0):
    """
    Wrapper for :func:`bessely`.

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
    return bessely(nu, z, n)


# =======
# bessely
# =======

@boundscheck(False)
@wraparound(False)
cdef double bessely(
        const double nu,
        const double z,
        const int n) nogil:
    """
    Computes real Bessel function or its derivative,
    :math:`\\partial Y_{\\nu}(z) / \\partial z`. This function is the cythonic
    interface of this module.

    **Example:**

    This example computes Bessel function :math:`Y_{\\nu}(z)` and its first and
    second derivatives for real argument. The python's ``gil`` can be
    optionally released, especially when this feature is needed during parallel
    OpenMP environments.

    .. code-block:: python

        >>> # cimport module in a *.pyx file
        >>> from special_functions cimport bessely

        >>> # Declare typed variables
        >>> cdef double nu = 2.5
        >>> cdef double z = 2.0
        >>> cdef double d0y, d1y, d2y

        >>> # Releasing gil to secure maximum cythonic speedup
        >>> with nogil:
        ...     d0y = bessely(nu, z, 0)    # no derivative
        ...     d1y = bessely(nu, z, 1)    # 1st derivative
        ...     d2y = bessely(nu, z, 2)    # 2nd derivative

    .. seealso::

        * :func:`py_bessely`: python wrapper to this function.
        * :func:`cbessely`: cython interface for complex numbers.
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
    # Note that half-integer nu (negative or positive) has a formula later.
    cdef double c
    cdef double s
    if nu < 0:
        if round(nu) == nu:
            return ((-1)**nu) * bessely(-nu, z, n)
        elif (round(nu + 0.5) != nu + 0.5):
            c = cos(M_PI * nu)
            s = sin(M_PI * nu)
            return c * bessely(-nu, z, n) - s * besselj(-nu, z, n)

    # Dispatch to internal functions
    cdef double complex output
    cdef double tolerance = 1e-16
    if n == 0:

        if round(nu) == nu:
            return _real_bessely_integer_order(int(nu), z)
        elif round(nu + 0.5) == nu + 0.5:
            return _real_bessely_half_integer_order(nu, z)
        else:
            output = _complex_bessely_real_order(nu, z + 0j)

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
        return _real_bessely_derivative(nu, z, n)


# ===============================
# real bessely half integer order
# ===============================

@boundscheck(False)
@wraparound(False)
cdef double _real_bessely_half_integer_order(
        const double nu,
        const double z) nogil:
    """
    Real Bessel functon of half integer order
    :math:`\\nu = m + \\frac{1}{2}`.

    The recursive formula for half-integer order can be found in
    `DLMF, equation 10.29.5 <https://dlmf.nist.gov/10.29#E1>`_.
    """

    cdef double y_nu_1    # used for nu-1
    cdef double y_nu_2    # used for nu-2
    cdef double y_nu      # output

    # Handling singularity
    if z == 0:

        if nu > 0:
            return -INFINITY
        elif nu == -0.5:
            return 0
        else:
            return INFINITY * copysign(1, sin(M_PI * nu))

    elif z < 0:
        return NAN

    if nu == 0.5:
        y_nu = -sqrt(M_2_PI / z) * cos(z)
    elif nu == -0.5:
        y_nu = sqrt(M_2_PI / z) * sin(z)
    else:

        # Using recursive formula
        if nu > 0:
            y_nu_1 = _real_bessely_half_integer_order(nu-1, z)
            y_nu_2 = _real_bessely_half_integer_order(nu-2, z)
            y_nu = ((2.0 * (nu-1)) / z) * y_nu_1 - y_nu_2
        elif nu < 0:
            y_nu_1 = _real_bessely_half_integer_order(nu+1, z)
            y_nu_2 = _real_bessely_half_integer_order(nu+2, z)
            y_nu = ((2.0 * (nu+1)) / z) * y_nu_1 - y_nu_2

    return y_nu


# ==========================
# real bessely integer order
# ==========================

@boundscheck(False)
@wraparound(False)
cdef double _real_bessely_integer_order(
        const int nu,
        const double z) nogil:
    """
    Wrapper using `cephes <https://www.netlib.org/cephes/>`_ library which
    implements Bessel functions with integer orders of :math:`\\nu` and for
    real argument :math:`z`.
    """

    if z == 0:
        if nu >= 0:
            return -INFINITY
        else:
            return (-1)**nu * INFINITY
    else:
        return yn(nu, z)


# =======================
# real bessely derivative
# =======================

@boundscheck(False)
@wraparound(False)
cdef double _real_bessely_derivative(
        const double nu,
        const double z,
        const int n) nogil:
    """
    Derivative of real Bessel function: :math:`\\partial I_v(z) / \\partial z`.

    The derivative formula can be found in
    `DLMF, equation 10.29.5 <https://dlmf.nist.gov/10.29#E5>`_.
    """

    cdef int i
    cdef double phase = -1.0
    cdef double combination = 1.0
    cdef double summand = bessely(nu-n, z, 0)

    for i in range(1, n+1):
        combination *= phase * (n-i+1) / i
        summand += combination * bessely(nu-n + 2*i, z, 0)

    return summand / (2.0**n)
