# =======
# Imports
# =======

# External modules
from cython import boundscheck, wraparound
from libc.stdio cimport printf
from libc.stdlib cimport exit
from libc.math cimport INFINITY, NAN, M_PI, M_2_PI, isnan
from libc.math cimport round, sqrt, cos, sin

# Internal modules
from .cbesselh cimport _complex_besselh_half_integer_order, \
                       _complex_besselh_real_order, \
                       _complex_besselh_derivative


# ==========
# py besselh
# ==========

def py_besselh(nu, k, z, n=0):
    """
    Wrapper for :func:`besselh`.

    :param nu: Parameter :math:`\\nu` of Bessel function.
    :type nu: double

    :param k: Can be ``1`` or ``2`` and sets the type of Hankel function.
    :type k: int

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

    # Check index k is integer
    if not isinstance(n, int):
        raise ValueError('Index k should be an integer.')

    # Check derivative order is integer
    if not isinstance(n, int):
        raise ValueError('Derivative order should be an integer.')

    # Call pure cythonic function
    return besselh(nu, k, z, n)


# =======
# besselh
# =======

@boundscheck(False)
@wraparound(False)
cdef double complex besselh(
        const double nu,
        const int k,
        const double z,
        const int n) nogil:
    """
    Computes Bessel function or its derivative,
    :math:`\\partial H^{(k)}_{\\nu}(z) / \\partial z`. This function is the
    cythonic interface of this module.

    **Example:**

    This example computes Bessel function :math:`H^{(k)}_{\\nu}(z)` and its
    first and second derivatives for a real argument. The python's ``gil``
    can be optionally released, especially when this feature is needed during
    parallel OpenMP environments.

    .. code-block:: python

        >>> # cimport module in a *.pyx file
        >>> from special_functions cimport besselh

        >>> # Declare typed variables
        >>> cdef double nu = 2.5
        >>> cdef int k = 1
        >>> cdef double complex z = 2.0
        >>> cdef double complex d0h, d1h, d2h

        >>> # Releasing gil to secure maximum cythonic speedup
        >>> with nogil:
        ...     d0h = besselh(nu, k, z, 0)    # no derivative
        ...     d1h = besselh(nu, k, z, 1)    # 1st derivative
        ...     d2h = besselh(nu, k, z, 2)    # 2nd derivative

    .. seealso::

        * :func:`py_besselh`: python wrapper to this function.
        * :func:`cbesselh`: cython interface for real numbers.
    """

    # Check nan
    if isnan(nu) or isnan(z):
        return NAN

    # Check k is 1 or 2
    if (k != 1) and (k != 2):
        printf('ERROR: Index k should be 1 or 2.\n')
        exit(1)

    # Check positive derivative order
    if n < 0:
        printf('ERROR: Derivative order should be non-negative integer.\n')
        exit(1)

    # H function is undefined at zero
    if z == 0:
        return NAN

    # Handling negative nu
    # Note that half-integer nu (negative or positive) has a formula later.
    cdef double c
    cdef double s
    cdef double sign
    if nu < 0:
        if round(nu) == nu:
            return ((-1)**nu) * besselh(-nu, k, z, n)
        elif round(nu + 0.5) != nu + 0.5:
            c = cos(M_PI * nu)
            s = sin(M_PI * nu)
            if k == 1:
                sign = 1.0
            elif k == 2:
                sign = -1.0
            else:
                printf('ERROR: Index k = %d is invalid\n.', k)
                exit(1)
            return besselh(-nu, k, z, n) * (c - sign * 1j * s)

    # Dispatch to internal functions
    if n == 0:

        if round(nu + 0.5) == nu + 0.5:
            return _complex_besselh_half_integer_order(nu, k, z + 0j)
        else:
            return _complex_besselh_real_order(nu, k, z + 0j)

    else:
        return _complex_besselh_derivative(nu, k, z + 0j, n)
