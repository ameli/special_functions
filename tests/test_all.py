#! /usr/bin/env python

# =======
# Imports
# =======

import sys
from test_besselj import test_besselj
from test_bessely import test_bessely
from test_besseli import test_besseli
from test_besselk import test_besselk
from test_besselh import test_besselh
from test_lngamma import test_lngamma


# ========
# test all
# ========

def test_all():
    """
    Test for all modules.
    """

    test_besselj()
    test_bessely()
    test_besseli()
    test_besselk()
    test_besselh()
    test_lngamma()


# =============
# Script's Main
# =============

if __name__ == "__main__":
    sys.exit(test_all())
