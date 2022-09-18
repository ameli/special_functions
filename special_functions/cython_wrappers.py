# =======
# Imports
# =======

from .besselj import py_besselj
from .bessely import py_bessely
from .besseli import py_besseli
from .besselk import py_besselk
from .besselh import py_besselh

from .cbesselj import py_cbesselj
from .cbessely import py_cbessely
from .cbesseli import py_cbesseli
from .cbesselk import py_cbesselk
from .cbesselh import py_cbesselh

from .lngamma import py_lngamma


# =======
# besselj
# =======

def besselj(nu, z, n=0):
    """
    Computes Bessel function or its derivative,
    :math:`\\partial J_{\\nu}(z) / \\partial z`.

    :param nu: Parameter :math:`\\nu` of Bessel function.
    :type nu: double

    :param z: Input argument of function.
    :type z: double or double complex

    :param n: Order of the derivative of function. Zero means no derivative.
    :type n: int

    :return: Value of Bessel function.
    :rtype: double or double complex

    **Example:**

    The two example computes Bessel function :math:`J_{\\nu}(z)` and its first
    and second derivatives. Note, this function uses the global lock
    interpreter (``gil``).

    The example below demonstrates real argument.

    .. code-block:: python

        >>> # import module in a *.py file
        >>> from special_functions import besselj

        >>> nu = 2.5
        >>> z = 2.0

        >>> d0j = besselj(nu, z)       # no derivative
        >>> d1j = besselj(nu, z, 1)    # 1st derivative
        >>> d2j = besselj(nu, z, 2)    # 2nd derivative

    The example below demonstrates complex argument.

    .. code-block:: python

        >>> nu = 2.5
        >>> z = 2.0+1.0j

        >>> d0j = besselj(nu, z)       # no derivative
        >>> d1j = besselj(nu, z, 1)    # 1st derivative
        >>> d2j = besselj(nu, z, 2)    # 2nd derivative
    """

    # Call pure cythonic function
    if isinstance(z, complex):
        return py_cbesselj(nu, z, n)
    else:
        return py_besselj(nu, z, n)


# =======
# bessely
# =======

def bessely(nu, z, n=0):
    """
    Computes Bessel function or its derivative,
    :math:`\\partial Y_{\\nu}(z) / \\partial z`.

    :param nu: Parameter :math:`\\nu` of Bessel function.
    :type nu: double

    :param z: Input argument of function.
    :type z: double or double complex

    :param n: Order of the derivative of function. Zero means no derivative.
    :type n: int

    :return: Value of Bessel function.
    :rtype: double or double complex

    **Example:**

    The two example computes Bessel function :math:`Y_{\\nu}(z)` and its first
    and second derivatives. Note, this function uses the global lock
    interpreter (``gil``).

    The example below demonstrates real argument.

    .. code-block:: python

        >>> # import module in a *.py file
        >>> from special_functions import bessely

        >>> nu = 2.5
        >>> z = 2.0

        >>> d0y = bessely(nu, z)       # no derivative
        >>> d1y = bessely(nu, z, 1)    # 1st derivative
        >>> d2y = bessely(nu, z, 2)    # 2nd derivative

    The example below demonstrates complex argument.

    .. code-block:: python

        >>> nu = 2.5
        >>> z = 2.0+1.0j

        >>> d0y = bessely(nu, z)       # no derivative
        >>> d1y = bessely(nu, z, 1)    # 1st derivative
        >>> d2y = bessely(nu, z, 2)    # 2nd derivative
    """

    # Call pure cythonic function
    if isinstance(z, complex):
        return py_cbessely(nu, z, n)
    else:
        return py_bessely(nu, z, n)


# =======
# besseli
# =======

def besseli(nu, z, n=0):
    """
    Computes Bessel function or its derivative,
    :math:`\\partial I_{\\nu}(z) / \\partial z`.

    :param nu: Parameter :math:`\\nu` of Bessel function.
    :type nu: double

    :param z: Input argument of function.
    :type z: double or double complex

    :param n: Order of the derivative of function. Zero means no derivative.
    :type n: int

    :return: Value of Bessel function.
    :rtype: double or double complex

    **Example:**

    The two example computes Bessel function :math:`I_{\\nu}(z)` and its first
    and second derivatives. Note, this function uses the global lock
    interpreter (``gil``).

    The example below demonstrates real argument.

    .. code-block:: python

        >>> # import module in a *.py file
        >>> from special_functions import besseli

        >>> nu = 2.5
        >>> z = 2.0

        >>> d0i = besseli(nu, z)       # no derivative
        >>> d1i = besseli(nu, z, 1)    # 1st derivative
        >>> d2i = besseli(nu, z, 2)    # 2nd derivative

    The example below demonstrates complex argument.

    .. code-block:: python

        >>> nu = 2.5
        >>> z = 2.0+1.0j

        >>> d0i = besseli(nu, z)       # no derivative
        >>> d1i = besseli(nu, z, 1)    # 1st derivative
        >>> d2i = besseli(nu, z, 2)    # 2nd derivative
    """

    # Call pure cythonic function
    if isinstance(z, complex):
        return py_cbesseli(nu, z, n)
    else:
        return py_besseli(nu, z, n)


# =======
# besselk
# =======

def besselk(nu, z, n=0):
    """
    Computes Bessel function or its derivative,
    :math:`\\partial K_{\\nu}(z) / \\partial z`.

    :param nu: Parameter :math:`\\nu` of Bessel function.
    :type nu: double

    :param z: Input argument of function.
    :type z: double or double complex

    :param n: Order of the derivative of function. Zero means no derivative.
    :type n: int

    :return: Value of Bessel function.
    :rtype: double or double complex

    **Example:**

    The two example computes Bessel function :math:`K_{\\nu}(z)` and its first
    and second derivatives. Note, this function uses the global lock
    interpreter (``gil``).

    The example below demonstrates real argument.

    .. code-block:: python

        >>> # import module in a *.py file
        >>> from special_functions import besselk

        >>> nu = 2.5
        >>> z = 2.0

        >>> d0k = besselk(nu, z)       # no derivative
        >>> d1k = besselk(nu, z, 1)    # 1st derivative
        >>> d2k = besselk(nu, z, 2)    # 2nd derivative

    The example below demonstrates complex argument.

    .. code-block:: python

        >>> nu = 2.5
        >>> z = 2.0+1.0j

        >>> d0k = bessely(nu, k)       # no derivative
        >>> d1k = bessely(nu, k, 1)    # 1st derivative
        >>> d2k = bessely(nu, k, 2)    # 2nd derivative
    """

    # Call pure cythonic function
    if isinstance(z, complex):
        return py_cbesselk(nu, z, n)
    else:
        return py_besselk(nu, z, n)


# =======
# besselh
# =======

def besselh(nu, k, z, n=0):
    """
    Computes Bessel function or its derivative,
    :math:`\\partial H^{(1)}_{\\nu}(z) / \\partial z` and
    :math:`\\partial H^{(2)}_{\\nu}(z) / \\partial z`.

    :param nu: Parameter :math:`\\nu` of Bessel function.
    :type nu: double

    :param k: Can be ``1`` or ``2`` and sets the type of Hankel function.
    :type k: int

    :param z: Input argument of function.
    :type z: double or double complex

    :param n: Order of the derivative of function. Zero means no derivative.
    :type n: int

    :return: Value of Bessel function.
    :rtype: double or double complex

    **Example:**

    The two example computes Bessel function :math:`H^{(k)}_{\\nu}(z)` and its
    first and second derivatives for :math:`k = 1, 2`. Note, this function uses
    the global lock interpreter (``gil``).

    The example below demonstrates real argument and :math:`k = 1`. Note that
    the output variables are compelx, despite the input ``z`` is real.

    .. code-block:: python

        >>> # import module in a *.py file
        >>> from special_functions import besselh

        >>> nu = 2.5
        >>> k = 1
        >>> z = 2.0

        >>> d0h = besselh(nu, k, z)       # no derivative
        >>> d1h = besselh(nu, k, z, 1)    # 1st derivative
        >>> d2h = besselh(nu, k, z, 2)    # 2nd derivative

    The example below demonstrates complex argument and :math:`k = 2`.

    .. code-block:: python

        >>> nu = 2.5
        >>> k = 2
        >>> z = 2.0+1.0j

        >>> d0h = besselh(nu, k, z)       # no derivative
        >>> d1h = besselh(nu, k, z, 1)    # 1st derivative
        >>> d2h = besselh(nu, k, z, 2)    # 2nd derivative
    """

    # Call pure cythonic function
    if isinstance(z, complex):
        return py_cbesselh(nu, k, z, n)
    else:
        return py_besselh(nu, k, z, n)


# =======
# lngamma
# =======

def lngamma(x):
    """
    Computes the natural logarithm of Gamma function. This function is a
    wrapper for ``gamma`` function in cephes library.

    :param x: Input argument of function.
    :type x: double

    :return: Value of the function.
    :rtype: double

    **Example:**

    This example computes :math:`\\ln \\Gamma(x)` for real argument. Note, this
    function uses python's  global lock interpreter (``gil``).

    .. code-block:: python

        >>> # cimport module in a *.py file
        >>> from special_functions import lngamma

        >>> x = 2.0
        >>> y = lngamma(x)

    .. seealso::

        * :func:`lngamma`: cython wrapper to this function.
    """

    # Call pure cythonic function
    return py_lngamma(x)
