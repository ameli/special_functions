# =======
# Imports
# =======

# External modules
from cython import boundscheck, wraparound
from libc.stdio cimport printf
from libc.stdlib cimport exit
from libc.math cimport INFINITY, NAN, M_PI, M_2_PI, isnan
from libc.math cimport round, fabs, sqrt, sin, cosh, sinh

# Internal modules
from .besselk cimport besselk
from .cbesseli cimport _complex_besseli_real_order


# ==================
# External libraries
# ==================

# Externs from Cephes library
cdef extern from "cephes_wrapper.h":
    double i0(double z) nogil
    double i1(double z) nogil


# ==========
# py besseli
# ==========

def py_besseli(nu, z, n=0):
    """
    Wrapper for :func:`besseli`.

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
    return besseli(nu, z, n)


# =======
# besseli
# =======

@boundscheck(False)
@wraparound(False)
cdef double besseli(
        const double nu,
        const double z,
        const int n) nogil:
    """
    Computes Bessel function or its derivative,
    :math:`\\partial I_{\\nu}(z) / \\partial z`. This function is the cythonic
    interface of this module.

    **Example:**

    This example computes Bessel function :math:`I_{\\nu}(z)` and its first and
    second derivatives for a real argument. The python's ``gil`` can be
    optionally released, especially when this feature is needed during parallel
    OpenMP environments.

    .. code-block:: python

        >>> # cimport module in a *.pyx file
        >>> from special_functions cimport besseli

        >>> # Declare typed variables
        >>> cdef double nu = 2.5
        >>> cdef double z = 2.0
        >>> cdef double d0i, d1i, d2i

        >>> # Releasing gil to secure maximum cythonic speedup
        >>> with nogil:
        ...     d0i = besseli(nu, z, 0)    # no derivative
        ...     d1i = besseli(nu, z, 1)    # 1st derivative
        ...     d2i = besseli(nu, z, 2)    # 2nd derivative

    .. seealso::

        * :func:`py_besseli`: python wrapper to this function.
        * :func:`cbesseli`: cython interface for real numbers.
    """

    # Check nan
    if isnan(nu) or isnan(z):
        return NAN

    # Check domain of function
    if (z < 0) and (round(nu) != nu):
        return NAN

    # Check positive derivative order
    if n < 0:
        printf('ERROR: Derivative order should be non-negative integer.\n')
        exit(1)

    # Handling negative nu
    # Note that half-integer nu (negative or positive) has a formula later.
    cdef double s
    if nu < 0:
        if round(nu) == nu:
            return besseli(-nu, z, n)
        elif round(nu + 0.5) != nu + 0.5:
            s = M_2_PI * sin(M_PI * nu)
            return besseli(-nu, z, n) - s * besselk(-nu, z, n)

    # Dispatch to internal functions
    cdef double complex output
    cdef double tolerance = 1e-16
    if n == 0:

        if (nu == 0) or (nu == 1):
            return _real_besseli(nu, z)
        elif round(nu + 0.5) == nu + 0.5:
            return _real_besseli_half_integer_order(nu, z)
        else:
            output = _complex_besseli_real_order(nu, z + 0j)

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
        return _real_besseli_derivative(nu, z, n)


# ===============================
# real besseli half integer order
# ===============================

@boundscheck(False)
@wraparound(False)
cdef double _real_besseli_half_integer_order(
        const double nu,
        const double z) nogil:
    """
    Real Bessel functon of half integer order
    :math:`\\nu = m + \\frac{1}{2}`.

    The recursive formula for half-integer order can be found in
    `DLMF, equation 10.29.5 <https://dlmf.nist.gov/10.29#E1>`_.
    """

    cdef double i_nu_1    # used for nu-1
    cdef double i_nu_2    # used for nu-2
    cdef double i_nu      # output

    if z == 0:

        if nu > 0:
            return 0.0
        else:
            return INFINITY

    if nu == 0.5:
        i_nu = sqrt(M_2_PI / z) * sinh(z)
    elif nu == -0.5:
        i_nu = sqrt(M_2_PI / z) * cosh(z)
    else:

        # Using recursive formula
        if nu > 0:
            i_nu_1 = _real_besseli_half_integer_order(nu-1, z)
            i_nu_2 = _real_besseli_half_integer_order(nu-2, z)
            i_nu = -((2.0 * (nu-1)) / z) * i_nu_1 + i_nu_2
        elif nu < 0:
            i_nu_1 = _real_besseli_half_integer_order(nu+1, z)
            i_nu_2 = _real_besseli_half_integer_order(nu+2, z)
            i_nu = ((2.0 * (nu+1)) / z) * i_nu_1 + i_nu_2

    return i_nu


# ============
# real besseli
# ============

@boundscheck(False)
@wraparound(False)
cdef double _real_besseli(
        const double nu,
        const double z) nogil:
    """
    Wrapper using `cephes <https://www.netlib.org/cephes/>`_ library which
    implements Bessel functions with integer orders of :math:`\\nu` and for
    real argument :math:`z`.

    .. note:

        The Cephes library also has ``double iv(double z)`` function for real
        parameter :math:`\\nu` and real argument :math:`z`. However, after
        seevral testings, I came to the conclusion that ``iv()`` gives wrong
        results. For instance, the putput of ``iv(0, z)`` and ``i0(z)`` do not
        match. Because of this, we do not use ``iv`` from Cephes library.
    """

    if nu == 0:
        return i0(z)
    elif nu == 1:
        return i1(z)
    else:
        printf('ERROR: The parameter nu should be 0 or 1 in this function.\n')
        exit(1)


# =======================
# real besseli derivative
# =======================

@boundscheck(False)
@wraparound(False)
cdef double _real_besseli_derivative(
        const double nu,
        const double z,
        const int n) nogil:
    """
    Derivative of Bessel function: :math:`\\partial I_v(z) / \\partial z`.

    The derivative formula can be found in
    `DLMF, equation 10.29.5 <https://dlmf.nist.gov/10.29#E5>`_.
    """

    cdef int i
    cdef double phase = 1.0
    cdef double combination = 1.0
    cdef double summand = besseli(nu-n, z, 0)

    for i in range(1, n+1):
        combination *= phase * (n-i+1) / i
        summand += combination * besseli(nu-n + 2*i, z, 0)

    return summand / (2.0**n)
