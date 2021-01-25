#! /usr/bin/env python

# =======
# Imports
# =======

from __future__ import print_function
import sys
from special_functions import lngamma
from scipy.special import gamma as scipy_gamma
from math import log, isnan, isinf, copysign
import warnings
warnings.filterwarnings(
        "ignore",
        message="invalid value encountered in double_scalars")
warnings.filterwarnings(
        "ignore",
        message="invalid value encountered in cdouble_scalars")


# ================
# validate lngamma
# ================

def validate_lngamma(x):
    """
    Compares the results of bessely function with scipy.special. If the return
    is zero, the result matches with scipy.special.

    .. note::

        Scipy cannot compute this special case: ``scipy.special.yvp(0,0,1)``.
        The correct answer is :math:`Y'_{0}(0) = + \\infty`. However, scipy
        runs into the ``RuntimeWarning`` (which we ingored, see top of this
        script). We ignore this special case.
    """

    # Compute using special_functions package
    g_specf = lngamma(x)

    # Compute using scipy.special package
    g_scipy = log(scipy_gamma(x))

    # Compare
    error = g_specf - g_scipy

    tolerance = 1e-14

    if isinstance(error, float) and isinf(g_specf) and isinf(g_scipy) \
            and (copysign(1, g_specf) == copysign(1, g_scipy)):
        error_detected = False

    elif isinstance(error, complex) and isinf(g_specf.real) and \
            isinf(g_scipy.real) and \
            (copysign(1, g_specf.real) == copysign(1, g_scipy.real)):
        error_detected = False

    elif isinstance(error, float) and isnan(g_specf) and isnan(g_scipy):
        error_detected = False

    elif isinstance(error, complex) and isnan(g_specf.real) and \
            isnan(g_scipy.real):
        error_detected = False

    elif error.real < tolerance and error.real > -tolerance and \
            error.imag < tolerance and error.imag > -tolerance:
        error_detected = False

    else:
        error_detected = True
        print('ERROR: x: %+0.2f, ' % (x), end=" ")
        print('g_nu: (%+0.3f,......) ' % (g_specf), end=" ")
        print('!= (%+0.3f,......), ' % (g_scipy), end=" ")
        print('error: (%+0.3e,..........)' % (error))

    return error_detected


# ============
# test lngamma
# ============

def test_lngamma():
    """
    Test for :mod:`special_functions.bessely` module.
    """

    x_list = [0.0, 1.0, 1.5, 1.6, 2.0, 2.5, 3.0]
    error_detected = False

    # Check all combinations of parameters
    for x in x_list:
        error = validate_lngamma(x)
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
    sys.exit(test_lngamma())
