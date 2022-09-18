.. _lngamma:

**************************
Logrithm of Gamma Function
**************************

This module computes the natural logarithm of Gamma function, :math:`\ln \Gamma(x)`, where :math:`x \in \mathbb{R}`.

======
Syntax
======

This function has the following syntaxes depending on whether it is used in Python or Cython interface.

+------------+------------------------------+
| Interface  | Function Signature           |
+============+==============================+
| **Python** | ``lngamma(x)``               |
+------------+------------------------------+
| **Cython** | ``double lngamma(double x)`` |
+------------+------------------------------+

**Input Arguments:**

.. attribute:: x
   :type: double

   The input argument :math:`x` of the function.

========
Examples
========
 
--------------------
Using in Cython Code
--------------------

The codes below should be used in a ``.pyx`` file and compiled with Cython.

As shown in the codes below, the python's global lock interpreter, or ``gil``, can be optionally released inside the scope of ``with nogil:`` statement. This is especially useful in parallel OpenMP environments.

.. code-block:: python

    >>> # cimport module in a *.pyx file
    >>> from special_functions cimport lngamma

    >>> # Declare typed variables
    >>> cdef double x = 2.0
    >>> cdef double lg

    >>> # Releasing gil to secure maximum cythonic speedup
    >>> with nogil:
    ...     lg = lngamma(x)

--------------------
Using in Python Code
--------------------

The codes below should be used in a ``.py`` file and no compilation is required. The python's global lock interpreter, or ``gil``, cannot be released.

.. code-block:: python

    >>> # import module in a *.py file
    >>> from special_functions import lngamma

    >>> x = 2.0
    >>> lg = lngamma(x)

=====
Tests
=====

The test script of this module is located at |tests/test_lngamma.py|_. The test compares the results of this module with |scipy.special|_ package (function ``gamma``) for several combinations of input parameters with multiple values. Run the test by

.. prompt:: bash

    git clone https://github.com/ameli/special_functions.git
    cd special_functions/tests
    python test_lngamma.py

.. |tests/test_lngamma.py| replace:: ``tests/test_lngamma.py``
.. _tests/test_lngamma.py: https://github.com/ameli/special_functions/blob/main/tests/test_lngamma.py

.. |scipy.special| replace:: ``scipy.special``
.. _scipy.special: https://docs.scipy.org/doc/scipy/reference/special.html


=========
Algorithm
=========

This module is a wrapper around ``gamma`` function in the Cephes C library (see [Cephes-1989]_).

==========
References
==========

.. [Cephes-1989] Moshier, S. L. (1989). C language library with special functions for mathematical physics. Available at `http://www.netlib.org/cephes <http://www.netlib.org/cephes>`_.
