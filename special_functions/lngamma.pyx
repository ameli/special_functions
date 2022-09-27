# =======
# Imports
# =======

from cython import boundscheck, wraparound
from libc.math cimport INFINITY, NAN, isnan, round


# ==================
# External libraries
# ==================

# Externs from Cephes library
cdef extern from "cephes_wrapper.h":
    double lgam(double x) nogil


# ==========
# py lngamma
# ==========

def py_lngamma(x):
    """
    Python wrapper for :func:`lngamma` function.
    """

    # Call pure cythonic function without gil
    return lngamma(x)


# =======
# lngamma
# =======

@boundscheck(False)
@wraparound(False)
cdef double lngamma(double x) nogil:
    """
    Computes the natural logarithm of Gamma function. THis function is a
    wrapper for ``gamma`` function in cephes library.

    **Example:**

    This example computes :math:`\\ln \\Gamma(x)` for real argument. The
    python's ``gil`` can be optionally released, especially when this feature
    is needed during parallel OpenMP environments.

    .. code-block:: python

        >>> # cimport module in a *.pyx file
        >>> from special_functions cimport lngamma

        >>> # Declare typed variables
        >>> cdef double x = 2.0
        >>> cdef double y

        >>> # Releasing gil to secure maximum cythonic speedup
        >>> with nogil:
        ...     y = lngamma(x)

    .. seealso::

        * :func:`py_lngamma`: python wrapper to this function.
    """

    # Check nan
    if isnan(x):
        return NAN

    if (x <= 0) and (round(x) == x):
        return INFINITY

    return lgam(x)
