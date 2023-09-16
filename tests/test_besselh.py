#! /usr/bin/env python

# =======
# Imports
# =======

from __future__ import print_function
import sys
from special_functions import besselh
from scipy.special import hankel1, hankel2, jvp, yvp
from math import isnan
import warnings
import numpy
warnings.filterwarnings(
        "ignore",
        message="invalid value encountered in cdouble_scalars")
numpy.seterr(divide='ignore', invalid='ignore')


# ================
# validate besselh
# ================

def validate_besselh(nu, k, z, n):
    """
    Compares the results of besselh function with scipy.special. If the return
    is zero, the result matches with scipy.special.
    """

    if k == 1:
        hankel = hankel1
        sign = 1
    elif k == 2:
        hankel = hankel2
        sign = -1
    else:
        raise ValueError('k should be 1 or 2.')

    # Compute using special_functions package
    h_specf = besselh(nu, k, z, n)

    # Compute using scipy.special package
    if n == 0:
        h_scipy = hankel(nu, z)
    else:
        h_scipy = jvp(nu, z + 0j, n) + sign * 1j * yvp(nu, z + 0j, n)

    # Compare
    error = h_specf - h_scipy

    tolerance = 1e-14
    if isinstance(error, float) and isnan(h_specf) and isnan(h_scipy):
        error_detected = False

    elif isinstance(error, complex) and isnan(h_specf.real) and \
            isnan(h_scipy.real):
        error_detected = False

    elif error.real < tolerance and error.real > -tolerance and \
            error.imag < tolerance and error.imag > -tolerance:
        error_detected = False

    else:
        error_detected = True
        if isinstance(z, complex):
            print('ERROR: k: %d, nu: %+0.2f, z: (%+0.2f,%+0.2f), n: %d, '
                  % (k, nu, z.real, z.imag, n), end=" ")
        else:
            print('ERROR: k: %d, nu: %+0.2f, z: (%+0.2f,.....), n: %d, '
                  % (k, nu, z.real, n), end=" ")

        if isinstance(h_specf, complex):
            print('h_nu: (%+0.3f,%+0.3f) '
                  % (h_specf.real, h_specf.imag), end=" ")
        else:
            print('h_nu: (%+0.3f,......) ' % (h_specf), end=" ")

        if isinstance(h_scipy, complex):
            print('!= (%+0.3f,%+0.3f), '
                  % (h_scipy.real, h_scipy.imag), end=" ")
        else:
            print('!= (%+0.3f,......), ' % (h_scipy), end=" ")

        if isinstance(error, complex):
            print('error: (%+0.3e,%+0.3e)'
                  % (error.real, error.imag))
        else:
            print('error: (%+0.3e,..........)' % (error))

    return error_detected


# ============
# test besselh
# ============

def test_besselh():
    """
    Test for :mod:`special_functions.besselh` module.
    """

    k_list = [1, 2]
    nu_list = [1.4, -1.6, -1.4, -2.6, 1.5, -1.5, 2.5, -2.5, 1, -1, 0, 2, -3]
    z_list = [0.0, 0.0 + 0.0j, 2.0, -2.0, 2.0j, -2.0j, -2.0 + 0.0j, 2.0 + 0.0j,
              -2.0 - 1.0j, -2.0 + 1.0j, 2.0 + 1.0j, 2.0 - 1.0j]
    max_derivative = 4
    error_detected = False

    # Check all combinations of parameters
    for k in k_list:
        for nu in nu_list:
            for z in z_list:
                for n in range(max_derivative):
                    error = validate_besselh(nu, k, z, n)
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
    sys.exit(test_besselh())
