#! /usr/bin/env python

# =======
# Imports
# =======

import sys
from special_functions import besselk
import scipy
from scipy.special import kn, kv, kvp


# ================
# validate besselk
# ================

def validate_besselk(nu, z, n):
    """
    Compares thr results of besselk function with scipy.special. If the return
    is zero, the result matches with scipy.special.
    """

    # Compute using special_functions package
    k_specf = besselk(nu, z, n)

    # Compute using scipy.special package
    if n == 0:
        if int(nu) == nu and z.imag == 0:
            k_scipy = scipy.special.kn(nu, z)
        else:
            k_scipy = scipy.special.kv(nu, z)
    else:
        k_scipy = scipy.special.kvp(nu, z, n)

    # Compare
    error = k_specf - k_scipy

    tolerance = 1e-15
    if error.real < tolerance and error.real > -tolerance and \
       error.imag < tolerance and error.imag > -tolerance:
        error_detected = False
    else:
        error_detected = True
        print('ERROR: nu: %0.2f, z: (%0.2f,%0.2f), n: %d'
              % (nu, z.real, z.imag, n), end=" ")
        print(' k_nu: (%f,%f)' % (k_specf.real, k_specf.imag), end=" ")
        print(' != (%f,%f)' % (k_scipy.real, k_scipy.imag))

    return error_detected


# ============
# test besselk
# ============

def test_besselk():
    """
    Test for :mod:`special_functions.besselk` module.
    """

    nu_real = 1.6
    nu_half = 2.5
    nu_intg = 1.0

    z_real = 2.0
    z_cmpl = 2.0 - 1j

    n_0 = 0
    n_1 = 1
    n_2 = 2

    error_detected = []

    # Test real nu
    error_detected.append(validate_besselk(nu_real, z_real, n_0))
    error_detected.append(validate_besselk(nu_real, z_real, n_1))
    error_detected.append(validate_besselk(nu_real, z_real, n_2))
    error_detected.append(validate_besselk(nu_real, z_cmpl, n_0))
    error_detected.append(validate_besselk(nu_real, z_cmpl, n_1))
    error_detected.append(validate_besselk(nu_real, z_cmpl, n_2))

    # Test half-integer nu
    error_detected.append(validate_besselk(nu_half, z_real, n_0))
    error_detected.append(validate_besselk(nu_half, z_real, n_1))
    error_detected.append(validate_besselk(nu_half, z_real, n_2))
    error_detected.append(validate_besselk(nu_half, z_cmpl, n_0))
    error_detected.append(validate_besselk(nu_half, z_cmpl, n_1))
    error_detected.append(validate_besselk(nu_half, z_cmpl, n_2))

    # Test integer nu
    error_detected.append(validate_besselk(nu_intg, z_real, n_0))
    error_detected.append(validate_besselk(nu_intg, z_real, n_1))
    error_detected.append(validate_besselk(nu_intg, z_real, n_2))
    error_detected.append(validate_besselk(nu_intg, z_cmpl, n_0))
    error_detected.append(validate_besselk(nu_intg, z_cmpl, n_1))
    error_detected.append(validate_besselk(nu_intg, z_cmpl, n_2))

    if any(error_detected):
        raise RuntimeError('A mismatch of calculation with scipy detected.')
    else:
        print('OK')


# =============
# Script's Main
# =============

if __name__ == "__main__":
    sys.exit(test_besselk())
