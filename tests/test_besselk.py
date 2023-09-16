#! /usr/bin/env python

# =======
# Imports
# =======

from __future__ import print_function
import sys
from special_functions import besselk
from scipy.special import k0, k1, kn, kv, kvp
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
# validate besselk
# ================

def validate_besselk(nu, z, n):
    """
    Compares the results of besselk function with scipy.special. If the return
    is zero, the result matches with scipy.special.
    """

    # Compute using special_functions package
    k_specf = besselk(nu, z, n)

    # Compute using scipy.special package
    if n == 0:
        if not isinstance(z, complex) and nu == 0:
            k_scipy = k0(z)
        elif not isinstance(z, complex) and nu == 1:
            k_scipy = k1(z)
        elif not isinstance(z, complex) and round(nu) == nu:
            k_scipy = kn(nu, z)
        else:
            k_scipy = kv(nu, z)
    else:
        k_scipy = kvp(nu, z, n)

    # Compare
    error = k_specf - k_scipy

    tolerance = 1e-14
    if isinstance(error, float) and isinf(k_specf) and isinf(k_scipy) \
            and (copysign(1, k_specf) == copysign(1, k_scipy)):
        error_detected = False

    elif isinstance(error, complex) and isinf(k_specf.real) and \
            isinf(k_scipy.real) and \
            (copysign(1, k_specf.real) == copysign(1, k_scipy.real)):
        error_detected = False

    elif isinstance(error, float) and isnan(k_specf) and isnan(k_scipy):
        error_detected = False

    elif isinstance(error, complex) and isnan(k_specf.real) and \
            isnan(k_scipy.real):
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

        if isinstance(k_specf, complex):
            print('k_nu: (%+0.3f,%+0.3f) '
                  % (k_specf.real, k_specf.imag), end=" ")
        else:
            print('k_nu: (%+0.3f,......) ' % (k_specf), end=" ")

        if isinstance(k_scipy, complex):
            print('!= (%+0.3f,%+0.3f), '
                  % (k_scipy.real, k_scipy.imag), end=" ")
        else:
            print('!= (%+0.3f,......), ' % (k_scipy), end=" ")

        if isinstance(error, complex):
            print('error: (%+0.3e,%+0.3e)'
                  % (error.real, error.imag))
        else:
            print('error: (%+0.3e,..........)' % (error))

    return error_detected


# ============
# test besselk
# ============

def test_besselk():
    """
    Test for :mod:`special_functions.besselk` module.
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
                error = validate_besselk(nu, z, n)
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
    sys.exit(test_besselk())
