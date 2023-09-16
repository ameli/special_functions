#! /usr/bin/env python

# =======
# Imports
# =======

from __future__ import print_function
import sys
from special_functions import bessely
from scipy.special import yn, yv, yvp
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
# validate bessely
# ================

def validate_bessely(nu, z, n):
    """
    Compares the results of bessely function with scipy.special. If the return
    is zero, the result matches with scipy.special.
    """

    # Compute using special_functions package
    y_specf = bessely(nu, z, n)

    # Compute using scipy.special package
    if n == 0:
        if not isinstance(z, complex) and (round(nu) == nu):
            y_scipy = yn(nu, z)
        else:
            y_scipy = yv(nu, z)
    else:
        y_scipy = yvp(nu, z, n)

    # Whitelist false scipy results. See note in docstring above.
    ignore_scipy = False
    if (nu == 0) and (z.real == 0) and (z.imag == 0) and (n == 1):
        ignore_scipy = True
    elif (nu + 0.5 == round(nu + 0.5)) and (nu < 0) and isinstance(z, float) \
            and (z == 0):
        ignore_scipy = True

    # Compare
    error = y_specf - y_scipy

    tolerance = 1e-14
    if ignore_scipy:
        error_detected = False

    elif isinstance(error, float) and isinf(y_specf) and isinf(y_scipy) \
            and (copysign(1, y_specf) == copysign(1, y_scipy)):
        error_detected = False

    elif isinstance(error, complex) and isinf(y_specf.real) and \
            isinf(y_scipy.real) and \
            (copysign(1, y_specf.real) == copysign(1, y_scipy.real)):
        error_detected = False

    elif isinstance(error, float) and isnan(y_specf) and isnan(y_scipy):
        error_detected = False

    elif isinstance(error, complex) and isnan(y_specf.real) and \
            isnan(y_scipy.real):
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

        if isinstance(y_specf, complex):
            print('y_nu: (%+0.3f,%+0.3f) '
                  % (y_specf.real, y_specf.imag), end=" ")
        else:
            print('y_nu: (%+0.3f,......) ' % (y_specf), end=" ")

        if isinstance(y_scipy, complex):
            print('!= (%+0.3f,%+0.3f), '
                  % (y_scipy.real, y_scipy.imag), end=" ")
        else:
            print('!= (%+0.3f,......), ' % (y_scipy), end=" ")

        if isinstance(error, complex):
            print('error: (%+0.3e,%+0.3e)'
                  % (error.real, error.imag))
        else:
            print('error: (%+0.3e,..........)' % (error))

    return error_detected


# ============
# test bessely
# ============

def test_bessely():
    """
    Test for :mod:`special_functions.bessely` module.
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
                error = validate_bessely(nu, z, n)
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
    sys.exit(test_bessely())
