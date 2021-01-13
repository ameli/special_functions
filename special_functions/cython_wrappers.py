# =======
# Imports
# =======

from .besselk import py_besselk


# =======
# besselk
# =======

def besselk(nu, z, n=0):
    """
    Wrapper for the cython function :func:`besselk` at ``besselk.pyx``.

    This function calls ``py_besselk()`` in the file  ``besselk.pyx``,  which
    is a wrap for ``besselk()`` in that file. Thus, the python API also have
    the same name ``besselk`` as the cythin API does.
    """

    return py_besselk(nu, z, n)
