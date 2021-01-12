# distutils: language = c++

# =======
# Imports
# =======

from cython import boundscheck, wraparound
from libc.stdio cimport printf
from libc.stdlib cimport exit
from libc.math cimport INFINITY, NAN, M_PI_2, isnan, round, exp, sqrt

# Importing from cython/includes/libcpp/complex.pxd
# Note: since complex.h is imported from libcpp, as a cpp library, this *.pyx
# file should be cythonized into a *.cpp file (not *.c). To instruct cython to
# translate this file into a cpp file, add "# distutils: language = c++" on the
# first line of this file.
cdef extern from "<complex.h>":
    double complex exp(double complex z) nogil
    double complex sqrt(double complex z) nogil


# ==================
# External libraries
# ==================

# Externs from AMOS library
cdef extern from "amos_wrapper.h":
    void zbesk "F_FUNC(zbesk,ZBESK)"(
            double * ZR,
            double* ZI,
            double* FNU,
            int* KODE,
            int* N,
            double* CYR,
            double* CYI,
            int* NZ,
            int* IERR) nogil

# Externs from Cephes library
cdef extern from "cephes_wrapper.h":
    double k0(double z) nogil
    double k1(double z) nogil
    double kn(int nn, double z) nogil


# ==========
# py besselk
# ==========

def py_besselk(nu, z, n=0):
    """
    Computes Bessel function or its derivative,
    :math:`\\partial K_{\\nu}(z) / \\partial z`. This function is the pythonic
    interface of this module and is called by
    :funct:`besselk.wrapper.py_besselk`. For the cythonic interface, see
    :func:`besselk` function.

    **Example:**

    This example compute Bessel function :math:`K_{\\nu}(z)` and its first and
    second derivatives for a complex argument. Note, this function uses the
    global lock interpreter (``gil``).

    .. code-block:: python

        >>> # import module in a *.py file
        >>> from special_functions import besselk

        >>> # Declare typed variables
        >>> nu = 2.5
        >>> z = 1+2j

        >>> d0k = besselk(nu, z)       # no derivative
        >>> d1k = besselk(nu, z, 1)    # 1st derivative
        >>> d2k = besselk(nu, z, 2)    # 2nd derivative
    """

    # Check nu is real
    if nu.imag != 0.0:
        raise ValueError('nu should be a real number.')

    # Check derivative order is integer
    if int(n) != n:
        raise ValueError('Derivative order should be an integer.')

    # Call pure cythonic function without gil
    output = besselk(nu, z, n)

    # Return real or complex
    if z.imag == 0.0:
        return output.real
    else:
        return output


# =======
# besselk
# =======

@boundscheck(False)
@wraparound(False)
cdef double complex besselk(
        double nu,
        const double complex z,
        const int n) nogil:
    """
    Computes Bessel function or its derivative,
    :math:`\\partial K_{\\nu}(z) / \\partial z`. This function is the cythonic
    interface of this module. For the pythonic interface, see
    :func:`besselk_wrapper` function.

    Depending on the argument :math:`\\nu`, one of the following libraries are
    used:

    * If :math:`\\nu` is real and :math:`z` is complex (or real), the Fortran
        library `amos <https://dl.acm.org/doi/10.1145/7921.214331>`_ is
        employed.
    * If :math:`\\nu` is integer and :math:`z` is real, the C library
    `cephes <https://www.netlib.org/cephes/>` is used.
    * If :math:`\\nu` is half integer, the Bessel functions are expressed and
        calculated using trigonometric or exponential functions.

    **Example:**

    This example compute Bessel function :math:`K_{\\nu}(z)` and its first and
    second derivatives for a complex argument. The python's ``gil`` can be
    optionally released, especially when this feature is needed during parallel
    OpenMP environments.

    .. code-block:: python

        >>> # cimport module in a *.pyx file
        >>> from special_functions cimport besselk

        >>> # Declare typed variables
        >>> cdef double nu = 2.5
        >>> cdef double complex z = 1+2j
        >>> cdef double complex d0k, d1k, d2k

        >>> # Releasing gil to secure maximum cythonic speedup
        >>> with nogil:
        ...     d0k = besselk(nu, z, 0)    # no derivative
        ...     d1k = besselk(nu, z, 1)    # 1st derivative
        ...     d2k = besselk(nu, z, 2)    # 2nd derivative
    """

    # Check nan
    if isnan(nu) or isnan(z.real) or isnan(z.imag):
        return NAN

    # Check positive derivative order
    if n < 0:
        printf('Derivative order should be non-negative integer.\n')
        exit(1)

    # Check negative nu
    if nu < 0:
        nu = -nu

    if n == 0:

        if round(nu) == nu and z.imag == 0:
            return _real_besselk_integer_order(int(nu), z.real)
        elif round(nu + 0.5) == nu + 0.5 and nu < 100:
            return _complex_besselk_half_integer_order(nu, z)
        else:
            return _complex_besselk_real_order(nu, z)

    else:
        return _besselk_derivative(nu, z, n)


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


# ==================================
# complex besselk half integer order
# ==================================

@boundscheck(False)
@wraparound(False)
cdef double complex _complex_besselk_half_integer_order(
        double nu,
        const double complex z) nogil:
    """
    Complex Bessel functon of half integer order
    :math:`\\nu = m + \\frac{1}{2}`.

    The recursive formula for half-integer order can be found in
    `DLMF, equation 10.29.5 <https://dlmf.nist.gov/10.29#E1>`_.
    """

    if nu < 0:
        nu = -nu

    cdef double complex k_nu_1
    cdef double complex k_nu_2

    if nu == 0.5:

        if z.imag == 0:
            return sqrt(M_PI_2 / z.real) * exp(-z.real)
        else:
            return sqrt(M_PI_2 / z) * exp(-z)

    else:

        # Using recusrive formula
        k_nu_1 = _complex_besselk_half_integer_order(nu-1, z)
        k_nu_2 = _complex_besselk_half_integer_order(nu-2, z)
        return ((2.0 * (nu-1)) / z) * k_nu_1 + k_nu_2


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
    if IERR == 2:
        cy.real = INFINITY
        cy.imag = 0.0
    else:
        cy.real = CYR[0]
        cy.imag = CYI[0]

    return cy


# ===================
# _besselk derivative
# ===================

@boundscheck(False)
@wraparound(False)
cdef double complex _besselk_derivative(
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
    cdef double complex summand = besselk(nu-n, z, 0)

    for i in range(1, n+1):
        combination *= phase * (n-i+1) / i
        summand += combination * besselk(nu-n + 2*i, z, 0)

    return (-1.0)**n * summand / (2.0**n)
