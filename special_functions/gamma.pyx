# =======
# Imports
# =======

from cython import boundscheck, wraparound
from libc.math cimport NAN, isnan


# ==================
# External libraries
# ==================

# Externs from Cephes library
cdef extern from "cephes_wrapper.h":
    double gamma(double x) nogil


# =============
# gamma wrapper
# =============

def gamma_wrapper(x):
    """
    Python wrapper for :funct:`besselk` function.
    """

    # Call pure cythonic function without gil
    return gamma(x)

# =====
# gamma
# =====

# @boundscheck(False)
# @wraparound(False)
# cdef double gamma(
#         double x) nogil:
#     """
#     A wrapper for gamma in cephes library.
#     """
#
#     # Check nan
#     if isnan(x):
#         return NAN
#
#     return gamma(x)
