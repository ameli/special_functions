# =======
# Imports
# =======

# External modules
from cython import boundscheck, wraparound
from libc.stdio cimport printf
from libc.stdlib cimport exit
from libc.math cimport INFINITY, NAN, M_PI_2, isnan
from libc.math cimport round, fabs, exp, sqrt

# Internal modules
from ._complex_functions cimport complex_sqrt, complex_exp


# ==================
# External libraries
# ==================

# Externs from AMOS library
cdef extern from "amos_wrapper.h":
    void zbesk "F_FUNC(zbesk, ZBESK)"(
            double * ZR,
            double* ZI,
            double* FNU,
            int* KODE,
            int* N,
            double* CYR,
            double* CYI,
            int* NZ,
            int* IERR) nogil


# ===========
# py cbesselk
# ===========

def py_cbesselk(nu, z, n=0):
    """
    Wrapper for :func:`cbesselk`.

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
    return cbesselk(nu, z, n)


# ========
# cbesselk
# ========

@boundscheck(False)
@wraparound(False)
cdef double complex cbesselk(
        const double nu,
        const double complex z,
        const int n) nogil:
    """
    Computes complex Bessel function or its derivative,
    :math:`\\partial K_{\\nu}(z) / \\partial z`. This function is the cythonic
    interface of this module.

    **Example:**

    This example computes Bessel function :math:`K_{\\nu}(z)` and its first and
    second derivatives for a complex argument. The python's ``gil`` can be
    optionally released, especially when this feature is needed during parallel
    OpenMP environments.

    .. code-block:: python

        >>> # cimport module in a *.pyx file
        >>> from special_functions cimport cbesselk

        >>> # Declare typed variables
        >>> cdef double nu = 2.5
        >>> cdef double complex z = 1+2j
        >>> cdef double complex d0k, d1k, d2k

        >>> # Releasing gil to secure maximum cythonic speedup
        >>> with nogil:
        ...     d0k = besselk(nu, z, 0)    # no derivative
        ...     d1k = besselk(nu, z, 1)    # 1st derivative
        ...     d2k = besselk(nu, z, 2)    # 2nd derivative

    .. seealso::

        * :func:`py_cbesselk`: python wrapper to this function.
        * :func:`besselk`: cython interface for real numbers.
    """

    # Check nan
    if isnan(nu) or isnan(z.real) or isnan(z.imag):
        return NAN

    # Check positive derivative order
    if n < 0:
        printf('ERROR: Derivative order should be non-negative integer.\n')
        exit(1)

    # Check singularity
    if (z.real == 0) and (z.imag == 0):
        return NAN

    # Handling negative nu
    if nu < 0:
        return cbesselk(-nu, z, n)

    # Dispatch to internal functions
    if n == 0:

        if round(nu + 0.5) == nu + 0.5:
            return _complex_besselk_half_integer_order(nu, z)
        else:
            return _complex_besselk_real_order(nu, z)

    else:
        return _complex_besselk_derivative(nu, z, n)


# ==================================
# complex besselk half integer order
# ==================================

@boundscheck(False)
@wraparound(False)
cdef double complex _complex_besselk_half_integer_order(
        const double nu,
        const double complex z) nogil:
    """
    Complex Bessel functon of half integer order
    :math:`\\nu = m + \\frac{1}{2}`.

    The recursive formula for half-integer order can be found in
    `DLMF, equation 10.29.5 <https://dlmf.nist.gov/10.29#E1>`_.
    """

    cdef double complex k_nu_1    # used for nu-1
    cdef double complex k_nu_2    # used for nu-2
    cdef double complex k_nu      # output

    # Handling singularity
    if (z.real == 0) and (z.imag == 0):
        return NAN  # Note: this is different than the real case

    if fabs(nu) == 0.5:
        k_nu = (sqrt(M_PI_2) / complex_sqrt(z)) * complex_exp(-z)
    else:

        # Using recursive formula
        k_nu_1 = _complex_besselk_half_integer_order(nu-1, z)
        k_nu_2 = _complex_besselk_half_integer_order(nu-2, z)
        k_nu = ((2.0 * (nu-1)) / z) * k_nu_1 + k_nu_2

    return k_nu


# ==========================
# complex besselk real order
# ==========================

@boundscheck(False)
@wraparound(False)
cdef double complex _complex_besselk_real_order(
        const double nu,
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
    cdef int N = 1

    # Outputs of ZBESK
    cdef double CYR[1]
    cdef double CYI[1]
    cdef int NZ
    cdef int IERR

    # Calling Fortran
    zbesk(&ZR, &ZI, &FNU, &KODE, &N, CYR, CYI, &NZ, &IERR)

    # Output
    if (IERR == 2) and (CYR[0] >= 0) and (CYI[0] == 0):
        cy.real = INFINITY
        cy.imag = 0.0
    else:
        cy.real = CYR[0]
        cy.imag = CYI[0]

    return cy


# ==========================
# complex besselk derivative
# ==========================

@boundscheck(False)
@wraparound(False)
cdef double complex _complex_besselk_derivative(
        const double nu,
        const double complex z,
        const int n) nogil:
    """
    Derivative of Bessel function: :math:`\\partial K_v(z) / \\partial z`.

    The derivative formula can be found in
    `DLMF, equation 10.29.5 <https://dlmf.nist.gov/10.29#E5>`_.
    """

    cdef int i
    cdef double phase = 1.0
    cdef double combination = 1.0
    cdef double complex summand = cbesselk(nu-n, z, 0)

    for i in range(1, n+1):
        combination *= phase * (n-i+1) / i
        summand += combination * cbesselk(nu-n + 2*i, z, 0)

    return (-1.0)**n * summand / (2.0**n)
