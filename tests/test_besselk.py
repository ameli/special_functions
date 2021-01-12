#! /usr/bin/env python

# =======
# Imports
# =======

import sys
from special_functions import besselk


# ============
# test besselk
# ============

def test_besselk():
    """
    Test for :mod:`special_functions.besselk` module.
    """

    # Test real nu
    nu1 = 1.6
    z1 = 2.0
    print(besselk(nu1, z1, 0))
    print(besselk(nu1, z1, 1))
    print(besselk(nu1, z1, 2))

    # Test half integer nu
    nu2 = 1.5
    z2 = 2.0
    print(besselk(nu2, z2, 0))
    print(besselk(nu2, z2, 1))
    print(besselk(nu2, z2, 2))

    # Test integer nu
    nu3 = 1
    z3 = 2.0
    print(besselk(nu3, z3, 0))
    print(besselk(nu3, z3, 1))
    print(besselk(nu3, z3, 2))

    # Test complex z
    nu4 = -1.6
    z4 = 2.0 + 0.3j
    print(besselk(nu4, z4, 0))
    print(besselk(nu4, z4, 1))
    print(besselk(nu4, z4, 2))


# =============
# Script's Main
# =============

if __name__ == "__main__":
    sys.exit(test_besselk())
