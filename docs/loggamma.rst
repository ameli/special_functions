.. _loggamma:

**************************
Logrithm of Gamma Function
**************************

This module computes the natural logarithm of Gamma function, :math:`\log \Gamma(x)`, where :math:`x \in \mathbb{R}`.

======
Syntax
======

This function has the following syntaxes depending on whether it is used in Python or Cython interface, or the input argument ``z`` is complex or real.

+------------+-------------------------------+
| Interface  | Function Signature            |
+============+===============================+
| **Python** | ``loggamma(x)``               |
+------------+-------------------------------+
| **Cython** | ``double loggamma(double x)`` |
+------------+-------------------------------+

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
    >>> from special_functions cimport loggamma

    >>> # Declare typed variables
    >>> cdef double x = 2.0
    >>> cdef double lg

    >>> # Releasing gil to secure maximum cythonic speedup
    >>> with nogil:
    ...     lg = loggamma(x)

--------------------
Using in Python Code
--------------------

The codes below should be used in a ``.py`` file and no compilation is required. The python's global lock interpreter, or ``gil``, cannot be released.

.. code-block:: python

    >>> # import module in a *.py file
    >>> from special_functions import loggamma

    >>> x = 2.0
    >>> lg = loggamma(x)

=====
Tests
=====

The test script of this module is located at |tests/test_loggamma.py|_. The test compares the results of this module with |scipy.special|_ package (function ``gamma``) for several combinations of input parameters with multiple values. Run the test by

.. code::

    git clone https://github.com/ameli/special_functions.git
    cd special_functions/tests
    python test_loggamma.py

.. |tests/test_loggamma.py| replace:: ``tests/test_loggamma.py``
.. _tests/test_loggamma.py: https://github.com/ameli/special_functions/blob/main/tests/test_loggamma.py

.. |scipy.special| replace:: ``scipy.special``
.. _scipy.special: https://docs.scipy.org/doc/scipy/reference/special.html


=========
Algorithm
=========

This module is a wrapper around ``gamma`` function in the Cephes C library (see [Cephes-1989]_).

==========
References
==========

.. [Cephes-1989] Moshier, S. L. (1989). C language library with special functions for mathematical physics. Available at `http://www.netlib.org/cephes/index.html <http://www.netlib.org/cephes/index.html>`_.
