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
from ._complex_functions cimport complex_sqrt, complex_cos, complex_sin


# ==================
# External libraries
# ==================

# Externs from AMOS library
cdef extern from "amos_wrapper.h":
    void zbesh "F_FUNC(zbesh, ZBESH)"(
            double * ZR,
            double* ZI,
            double* FNU,
            int* KODE,
            int* M,
            int* N,
            double* CYR,
            double* CYI,
            int* NZ,
            int* IERR) nogil


# ===========
# py cbesselh
# ===========

def py_cbesselh(nu, k, z, n=0):
    """
    Wrapper for :func:`cbesselh`.

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
    return cbesselh(nu, k, z, n)


# ========
# cbesselh
# ========

@boundscheck(False)
@wraparound(False)
cdef double complex cbesselh(
        const double nu,
        const int k,
        const double complex z,
        const int n) nogil:
    """
    Computes Bessel function or its derivative,
    :math:`\\partial H^{(k)}_{\\nu}(z) / \\partial z`. This function is the
    cythonic interface of this module.

    **Example:**

    This example computes Bessel function :math:`H^{(k)}_{\\nu}(z)` and its
    first and second derivatives for a complex argument. The python's ``gil``
    can be optionally released, especially when this feature is needed during
    parallel OpenMP environments.

    .. code-block:: python

        >>> # cimport module in a *.pyx file
        >>> from special_functions cimport cbesselh

        >>> # Declare typed variables
        >>> cdef double nu = 2.5
        >>> cdef int k = 1
        >>> cdef double complex z = 1+2j
        >>> cdef double complex d0h, d1h, d2h

        >>> # Releasing gil to secure maximum cythonic speedup
        >>> with nogil:
        ...     d0h = besselh(nu, k, z, 0)    # no derivative
        ...     d1h = besselh(nu, k, z, 1)    # 1st derivative
        ...     d2h = besselh(nu, k, z, 2)    # 2nd derivative

    .. seealso::

        * :func:`py_cbesselh`: python wrapper to this function.
        * :func:`besselh`: cython interface for real numbers.
    """

    # Check nan
    if isnan(nu) or isnan(z.real) or isnan(z.imag):
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
    if (z.real == 0) and (z.imag == 0):
        return NAN

    # Handling negative nu
    # Note that half-integer nu (negative or positive) has a formula later.
    cdef double c
    cdef double s
    cdef double sign
    if nu < 0:
        if round(nu) == nu:
            return ((-1)**nu) * cbesselh(-nu, k, z, n)
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
            return cbesselh(-nu, k, z, n) * (c - sign * 1j * s)

    # Dispatch to internal functions
    if n == 0:

        if round(nu + 0.5) == nu + 0.5:
            return _complex_besselh_half_integer_order(nu, k, z)
        else:
            return _complex_besselh_real_order(nu, k, z)

    else:
        return _complex_besselh_derivative(nu, k, z, n)


# ==================================
# complex besselh half integer order
# ==================================

@boundscheck(False)
@wraparound(False)
cdef double complex _complex_besselh_half_integer_order(
        const double nu,
        const int k,
        const double complex z) nogil:
    """
    Complex Bessel functon of half integer order
    :math:`\\nu = m + \\frac{1}{2}`.

    The recursive formula for half-integer order can be found in
    `DLMF, equation 10.29.5 <https://dlmf.nist.gov/10.29#E1>`_.
    """

    cdef double sign
    cdef double complex h_nu_1    # used for nu-1
    cdef double complex h_nu_2    # used for nu-2
    cdef double complex h_nu      # output

    # First or second Hankel function
    if k == 1:
        sign = 1.0
    elif k == 2:
        sign = -1.0
    else:
        printf('ERROR: Index k = %d is invalid.\n', k)
        exit(1)

    if (z.imag == 0) and (z.real == 0):
        return NAN

    if nu == 0.5:
        h_nu = (sqrt(M_2_PI) / complex_sqrt(z)) * \
                (complex_sin(z) - sign * 1j * complex_cos(z))

    elif nu == -0.5:
        h_nu = (sqrt(M_2_PI) / complex_sqrt(z)) * \
                (complex_cos(z) + sign * 1j * complex_sin(z))

    else:

        # Using recursive formula
        if nu > 0:
            h_nu_1 = _complex_besselh_half_integer_order(nu-1, k, z)
            h_nu_2 = _complex_besselh_half_integer_order(nu-2, k, z)
            h_nu = ((2.0 * (nu-1)) / z) * h_nu_1 - h_nu_2
        elif nu < 0:
            h_nu_1 = _complex_besselh_half_integer_order(nu+1, k, z)
            h_nu_2 = _complex_besselh_half_integer_order(nu+2, k, z)
            h_nu = ((2.0 * (nu+1)) / z) * h_nu_1 - h_nu_2

    return h_nu


# ==========================
# complex besselh real order
# ==========================

@boundscheck(False)
@wraparound(False)
cdef double complex _complex_besselh_real_order(
        const double nu,
        const int k,
        const double complex z) nogil:
    """
    Wrapper using `amos <https://dl.acm.org/doi/10.1145/7921.214331>`_ library
    which implements Bessel functions with real orders of :math:`\\nu` and for
    complex argument :math:`z`.
    """

    # Declare output
    cdef double complex cy

    # Inputs to ZBESK
    cdef double ZR = z.real
    cdef double ZI = z.imag
    cdef double FNU = nu
    cdef int KODE = 1
    cdef int M = k
    cdef int N = 1

    # Outputs of ZBESK
    cdef double CYR[1]
    cdef double CYI[1]
    cdef int NZ
    cdef int IERR

    # Calling Fortran
    zbesh(&ZR, &ZI, &FNU, &KODE, &M, &N, CYR, CYI, &NZ, &IERR)

    # Output
    if IERR == 2:
        cy.real = -INFINITY
        cy.imag = 0.0
    else:
        cy.real = CYR[0]
        cy.imag = CYI[0]

    return cy


# ==========================
# complex besselh derivative
# ==========================

@boundscheck(False)
@wraparound(False)
cdef double complex _complex_besselh_derivative(
        const double nu,
        const int k,
        const double complex z,
        const int n) nogil:
    """
    Derivative of Bessel function: :math:`\\partial H^{(k)}_v(z) / \\partial z`
    for :math:`k = 1, 2`.

    The derivative formula can be found in
    `DLMF, equation 10.29.5 <https://dlmf.nist.gov/10.29#E5>`_.
    """

    cdef int i
    cdef double phase = -1.0
    cdef double combination = 1.0
    cdef double complex summand = cbesselh(nu-n, k, z, 0)

    for i in range(1, n+1):
        combination *= phase * (n-i+1) / i
        summand += combination * cbesselh(nu-n + 2*i, k, z, 0)

    return summand / (2.0**n)
