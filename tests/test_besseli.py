#! /usr/bin/env python

# =======
# Imports
# =======

from __future__ import print_function
import sys
from special_functions import besseli
from scipy.special import i0, i1, iv, ivp
from math import isnan, isinf, copysign
import numpy
import warnings
warnings.filterwarnings(
        "ignore",
        message="invalid value encountered in double_scalars")
warnings.filterwarnings(
        "ignore",
        message="invalid value encountered in cdouble_scalars")
numpy.seterr(divide='ignore', invalid='ignore')


# ================
# validate besseli
# ================

def validate_besseli(nu, z, n):
    """
    Compares the results of besseli function with scipy.special. If the return
    is zero, the result matches with scipy.special.

    .. note::

        Scipy cannot compute this special case: ``scipy.special.iv(nu, 0)``,
        where nu is negative and non-integer. The correct answer is -inf, but
        scipy's result is +inf. This issue also affects derivatives of the
        iv function at ``z = 0``. For example, ``scipy.special.ivp(nu, 0, n)``.
        However, the results for *complex* argument ``z = 0j`` is correctly
        returned by scipy (which is ``nan``).
    """

    # Compute using special_functions package
    i_specf = besseli(nu, z, n)

    # Compute using scipy.special package
    if n == 0:
        if not isinstance(z, complex) and nu == 0:
            i_scipy = i0(z)
        elif not isinstance(z, complex) and nu == 1:
            i_scipy = i1(z)
        else:
            i_scipy = iv(nu, z)
    else:
        i_scipy = ivp(nu, z, n)

    # Whitelist false scipy results. See note in docstring above.
    ignore_scipy = False
    if (nu < 0) and (round(nu) != nu) and (z.real == 0) and (z.imag == 0):
        ignore_scipy = True
    if (round(nu) != nu) and (z.real == 0) and (z.imag == 0) and (n > 0):
        ignore_scipy = True

    # Compare
    error = i_specf - i_scipy

    tolerance = 1e-14
    if ignore_scipy:
        error_detected = False

    elif isinstance(error, float) and isinf(i_specf) and isinf(i_scipy) \
            and (copysign(1, i_specf) == copysign(1, i_scipy)):
        error_detected = False

    elif isinstance(error, complex) and isinf(i_specf.real) and \
            isinf(i_scipy.real) and \
            (copysign(1, i_specf.real) == copysign(1, i_scipy.real)):
        error_detected = False

    elif isinstance(error, float) and isnan(i_specf) and isnan(i_scipy):
        error_detected = False

    elif isinstance(error, complex) and isnan(i_specf.real) and \
            isnan(i_scipy.real):
        error_detected = False

    elif error.real < tolerance and error.real > -tolerance and \
            error.imag < tolerance and error.imag > -tolerance:
        error_detected = False

    else:
        error_detected = True
        if isinstance(z, complex):
            print('ERROR: nu: %+0.2f, z: (%+0.2f,%+0.2f), n: %d, '
                  % (nu, z.real, z.imag, n), end=" ")
        else:
            print('ERROR: nu: %+0.2f, z: (%+0.2f,.....), n: %d, '
                  % (nu, z.real, n), end=" ")

        if isinstance(i_specf, complex):
            print('i_nu: (%+0.3f,%+0.3f) '
                  % (i_specf.real, i_specf.imag), end=" ")
        else:
            print('i_nu: (%+0.3f,......) ' % (i_specf), end=" ")

        if isinstance(i_scipy, complex):
            print('!= (%+0.3f,%+0.3f), '
                  % (i_scipy.real, i_scipy.imag), end=" ")
        else:
            print('!= (%+0.3f,......), ' % (i_scipy), end=" ")

        if isinstance(error, complex):
            print('error: (%+0.3e,%+0.3e)'
                  % (error.real, error.imag))
        else:
            print('error: (%+0.3e,..........)' % (error))

    return error_detected


# ============
# test besseli
# ============

def test_besseli():
    """
    Test for :mod:`special_functions.besseli` module.
    """

    nu_list = [1.4, -1.6, -1.4, -2.6, 1.5, -1.5, 2.5, -2.5, 1, -1, 0, 2, -3]
    z_list = [0.0, 0.0 + 0.0j, 2.0, -2.0, 2.0j, -2.0j, -2.0 + 0.0j, 2.0 + 0.0j,
              -2.0 - 1.0j, -2.0 + 1.0j, 2.0 + 1.0j, 2.0 - 1.0j]
    max_derivative = 4
    error_detected = False

    # Check all combinations of parameters
    for nu in nu_list:
        for z in z_list:
            for n in range(max_derivative):
                error = validate_besseli(nu, z, n)
                if error:
                    error_detected = True

    if error_detected:
        raise RuntimeError('A mismatch of calculation with scipy detected.')
    else:
        print('OK')


# =============
# Script's Main
# =============

if __name__ == "__main__":
    sys.exit(test_besseli())
