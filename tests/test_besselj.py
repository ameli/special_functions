#! /usr/bin/env python

# =======
# Imports
# =======

from __future__ import print_function
import sys
from special_functions import besselj
from scipy.special import j0, j1, jn, jv, jvp
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
# validate besselj
# ================

def validate_besselj(nu, z, n):
    """
    Compares the results of besselj function with scipy.special. If the return
    is zero, the result matches with scipy.special.
    """

    # Compute using special_functions package
    j_specf = besselj(nu, z, n)

    # Compute using scipy.special package
    if n == 0:
        if not isinstance(z, complex) and nu == 0:
            j_scipy = j0(z)
        elif not isinstance(z, complex) and nu == 1:
            j_scipy = j1(z)
        elif not isinstance(z, complex) and (round(nu) == nu):
            j_scipy = jn(nu, z)
        else:
            j_scipy = jv(nu, z)
    else:
        j_scipy = jvp(nu, z, n)

    # Compare
    error = j_specf - j_scipy

    tolerance = 1e-14
    if isinstance(error, float) and isinf(j_specf) and isinf(j_scipy) \
            and (copysign(1, j_specf) == copysign(1, j_scipy)):
        error_detected = False

    elif isinstance(error, complex) and isinf(j_specf.real) and \
            isinf(j_scipy.real) and \
            (copysign(1, j_specf.real) == copysign(1, j_scipy.real)):
        error_detected = False

    elif isinstance(error, float) and isnan(j_specf) and isnan(j_scipy):
        error_detected = False

    elif isinstance(error, complex) and isnan(j_specf.real) and \
            isnan(j_scipy.real):
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

        if isinstance(j_specf, complex):
            print('j_nu: (%+0.3f,%+0.3f) '
                  % (j_specf.real, j_specf.imag), end=" ")
        else:
            print('j_nu: (%+0.3f,......) ' % (j_specf), end=" ")

        if isinstance(j_scipy, complex):
            print('!= (%+0.3f,%+0.3f), '
                  % (j_scipy.real, j_scipy.imag), end=" ")
        else:
            print('!= (%+0.3f,......), ' % (j_scipy), end=" ")

        if isinstance(error, complex):
            print('error: (%+0.3e,%+0.3e)'
                  % (error.real, error.imag))
        else:
            print('error: (%+0.3e,..........)' % (error))

    return error_detected


# ============
# test besselj
# ============

def test_besselj():
    """
    Test for :mod:`special_functions.besselj` module.
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
                error = validate_besselj(nu, z, n)
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
    sys.exit(test_besselj())
