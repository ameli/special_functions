.. _besselh:

*********************************
Bessel Function of the Third Kind
*********************************

This module computes the Bessel function of the third kind (Hankel function) or its :math:`n`:superscript:`th` derivative

.. math::

    \frac{\partial^n H^{(k)}_{\nu}(z)}{\partial z^n},

where

* :math:`n \in \mathbb{N}` is the order of the derivative (:math:`n = 0` indicates no derivative).
* :math:`k` can be :math:`1` or :math:`2` and indicates the Hankel function of the first or second type, respectively.
* :math:`\nu \in \mathbb{R}` is the order of the Bessel function.
* :math:`z \in \mathbb{C}` is the input argument.
  

======
Syntax
======

This function has the following syntaxes depending on whether it is used in Python or Cython, or the input argument ``z`` is complex or real.

+------------+-----------------+------------------------------------------------------------------------+
| Interface  | Input Type      | Function Signature                                                     |
+============+=================+========================================================================+
| **Python** | Real or Complex | ``besselh(nu, k, z, n=0)``                                             |
+------------+-----------------+------------------------------------------------------------------------+
| **Cython** | Real            | ``double complex besselh(double nu, int k, double z, int n)``          |
+            +-----------------+------------------------------------------------------------------------+
|            | Complex         | ``double complex cbesselh(double nu, int k, double complex z, int n)`` |
+------------+-----------------+------------------------------------------------------------------------+

**Input Arguments:**

.. attribute:: nu
   :type: double
    
   The parameter :math:`\nu` of Bessel function.

.. attribute:: k
   :type: int

   It can be either ``1`` or ``2`` and determines the Hankel function of the first or second kind, respectively.

.. attribute:: z
   :type: double or double complex

   The input argument :math:`z` of Bessel function.

   * In *Python*, the function ``besselh`` accepts ``double`` and ``double complex`` types.
   * In *Cython*, the function ``besselh`` accepts ``double`` type.
   * In *Cython*, the function ``cbesselh`` accepts ``double complex`` type.

.. attribute:: n
   :type: int
   :value: 0

   The order :math:`n` of the derivative of Bessel function. Zero indicates no derivative.

   * For the *Python* interface, the default value is ``0`` and this argument may not be provided.
   * For the *Cython* interfaces, no default value is defined and this argument should be provided.


.. seealso::

   * :ref:`Bessel function of the first kind <besselj>`.
   * :ref:`Bessel function of the second kind <bessely>`.


========
Examples
========
 
--------------------
Using in Cython Code
--------------------

The codes below should be used in a ``.pyx`` file and compiled with Cython.

As shown in the codes below, the python's global lock interpreter, or ``gil``, can be optionally released inside the scope of ``with nogil:`` statement. This is especially useful in parallel OpenMP environments.

~~~~~~~~~~
Real Input
~~~~~~~~~~

This example shows the real function ``besselh`` to compute the Bessel function of the third kind for a real argument ``z``. The output variables ``d0h``, ``d1h``, and ``d2h`` are complex variables and represent the values of Bessel function and its first and second derivatives, respectively.

.. code-block:: python

    >>> # cimport module in a *.pyx file
    >>> from special_functions cimport besselh

    >>> # Declare typed variables
    >>> cdef double nu = 2.5
    >>> cdef int k = 1
    >>> cdef double z = 2.0
    >>> cdef double complex d0h, d1h, d2h

    >>> # Releasing gil to secure maximum cythonic speedup
    >>> with nogil:
    ...     d0h = besselh(nu, k, z, 0)    # no derivative
    ...     d1h = besselh(nu, k, z, 1)    # 1st derivative
    ...     d2h = besselh(nu, k, z, 2)    # 2nd derivative

~~~~~~~~~~~~~
Complex Input
~~~~~~~~~~~~~

The example below is similar to the above, except, the *complex* function ``cbesselh`` with complex argument ``z`` is used. The output variables ``d0h``, ``d1h``, and ``d2h`` are complex.

.. code-block:: python

    >>> # cimport module in a *.pyx file
    >>> from special_functions cimport cbesselh

    >>> # Declare typed variables
    >>> cdef double nu = 2.5
    >>> cdef int k = 1
    >>> cdef double complex z = 2.0 + 1.0j
    >>> cdef double complex d0h, d1h, d2h

    >>> # Releasing gil to secure maximum cythonic speedup
    >>> with nogil:
    ...     d0h = cbesselh(nu, k, z, 0)    # no derivative
    ...     d1h = cbesselh(nu, k, z, 1)    # 1st derivative
    ...     d2h = cbesselh(nu, k, z, 2)    # 2nd derivative

--------------------
Using in Python Code
--------------------

The codes below should be used in a ``.py`` file and no compilation is required. The python's global lock interpreter, or ``gil``, cannot be released.

~~~~~~~~~~
Real Input
~~~~~~~~~~

The example below uses the function ``besselh`` with the real argument ``z`` to compute the Bessel function of the third kind and its first and second derivatives.

.. code-block:: python

    >>> # import module in a *.py file
    >>> from special_functions import besselh

    >>> nu = 2.5
    >>> k = 1
    >>> z = 2.0

    >>> d0h = besselh(nu, k, z)       # no derivative
    >>> d1h = besselh(nu, k, z, 1)    # 1st derivative
    >>> d2h = besselh(nu, k, z, 2)    # 2nd derivative

~~~~~~~~~~~~~
Complex Input
~~~~~~~~~~~~~

To use a complex input argument ``z`` in the Python interface, the same function ``besselh`` as the previous example can be used. This is unlike the Cython interface in which ``cbesselh`` should be used.

.. code-block:: python

    >>> # import module in a *.py file
    >>> from special_functions import besselh

    >>> nu = 2.5
    >>> k = 1
    >>> z = 2.0 + 1.0j

    >>> d0h = besselh(nu, k, z)       # no derivative
    >>> d1h = besselh(nu, k, z, 1)    # 1st derivative
    >>> d2h = besselh(nu, k, z, 2)    # 2nd derivative


=====
Tests
=====

The test script of this module is located at |tests/test_besselh.py|_. The test compares the results of this module with |scipy.special|_ package (functions ``j0``, ``j1``, ``jn``, ``jv``, and ``jvp``) for several combinations of input parameters with multiple values. Run the test by

.. prompt:: bash

    git clone https://github.com/ameli/special_functions.git
    cd special_functions/tests
    python test_besselh.py

.. |tests/test_besselh.py| replace:: ``tests/test_besselh.py``
.. _tests/test_besselh.py: https://github.com/ameli/special_functions/blob/main/tests/test_besselh.py

.. |scipy.special| replace:: ``scipy.special``
.. _scipy.special: https://docs.scipy.org/doc/scipy/reference/special.html


=========
Algorithm
=========

Depending on the values of the input parameters :math:`(\nu, z, n)`, one of the following two algorithms is employed.

* If :math:`\nu + \frac{1}{2} \in \mathbb{Z}`, the Bessel function is computed using :ref:`half-integer formulas <half_int_besselh>` in terms of elementary functions.
* For other cases, the computation is carried out by Amos Fortran library (see [Amos-1986]_) using ``zbesh`` subroutine in that library.

-------------
Special Cases
-------------

In the special cases below, the computation is performed by taking advantage of some of the known formulas and properties of the Bessel functions.

~~~~~~~~~~~~~~~~~~~~
Negative :math:`\nu`
~~~~~~~~~~~~~~~~~~~~

When :math:`\nu < 0` and for the two cases below, the Bessel function is related to the Bessel function of the positive parameter :math:`-\nu`.

* If :math:`\nu \in \mathbb{Z}` (see [DLMF]_ Eq. `10.4.1 <https://dlmf.nist.gov/10.4#E1>`_):

  .. math::

      H^{(k)}_{\nu}(z) = (-1)^{\nu} H^{(k)}_{-\nu}(z),

  where :math:`k = 1, 2`.

* If :math:`\nu + \frac{1}{2} \in \mathbb{Z}` (see [DLMF]_ Eq. `10.2.3 <https://dlmf.nist.gov/10.2#E3>`_):

  .. math::

      H^{(k)}_{\nu}(z) = \left( \cos(\pi \nu) - i \alpha(k) \sin(\pi \nu) \right) H^{(k)}_{-\nu}(z),

  where :math:`k = 1, 2`, :math:`\alpha(1) = 1`, and :math:`\alpha(2) = -1`.

~~~~~~~~~~~
Derivatives
~~~~~~~~~~~

If :math:`n > 0`, the following relation for the derivative is applied (see [DLMF]_ Eq. `10.6.7 <https://dlmf.nist.gov/10.6#E7>`_):

.. math::
   
   \frac{\partial^n H^{(k)}_{\nu}(z)}{\partial z^n} = \frac{1}{2^n} \sum_{i = 0}^n (-1)^i \binom{n}{i} H^{(k)}_{\nu - n + 2i}(z),

where :math:`k = 1, 2`.

.. _half_int_besselh:

~~~~~~~~~~~~~~~~~~~~~~~~
Half-Integer :math:`\nu`
~~~~~~~~~~~~~~~~~~~~~~~~

When :math:`\nu` is half-integer, the Bessel function is computed in terms of elementary functions as follows.

* If :math:`z = 0`, then ``NAN`` is returned.

* If :math:`z < 0` and :math:`z \in \mathbb{R}`, then ``NAN`` is returned.

* If :math:`\nu = \pm \frac{1}{2}` (see [DLMF]_ Eq. `10.16.1 <https://dlmf.nist.gov/10.16#E1>`_)

  .. math::

      H^{(k)}_{\frac{1}{2}}(z) = \sqrt{\frac{2}{\pi z}} \left( \sin(z) - i \alpha(k) \cos(z) \right), \\
      H^{(k)}_{-\frac{1}{2}}(z) = \sqrt{\frac{2}{\pi z}} \left( \cos(z) + i \alpha(k) \sin(z) \right),

  where :math:`k = 1, 2` and :math:`\alpha(1) = 1` and :math:`\alpha(2) = -1`. Depending on :math:`z`, the above relations are computed using the real or complex implementation of the elementary functions.

* Higher-order half-integer parameter :math:`\nu` is related to the above relation for :math:`\nu = \pm \frac{1}{2}` using recursive formulas (see [DLMF]_ Eq. `10.6.1 <https://dlmf.nist.gov/10.6#E1>`_):

.. math::

    H^{(k)}_{\nu}(z) = \frac{2 (\nu - 1)}{z} H^{(k)}_{\nu - 1}(z) - H^{(k)}_{\nu - 2}(z), \qquad \nu > 0, \\
    H^{(k)}_{\nu}(z) = \frac{2 (\nu + 1)}{z} H^{(k)}_{\nu + 1}(z) - H^{(k)}_{\nu + 2}(z), \qquad \nu < 0,

where :math:`k = 1, 2`.


==========
References
==========

.. [Cephes-1989] Moshier, S. L. (1989). C language library with special functions for mathematical physics. Available at `http://www.netlib.org/cephes <http://www.netlib.org/cephes>`_.

.. [Amos-1986] Amos, D. E. (1986). Algorithm 644: A portable package for Bessel functions of a complex argument and nonnegative order. ACM Trans. Math. Softw. 12, 3 (Sept. 1986), 265-273. DOI: `https://doi.org/10.1145/7921.214331 <https://doi.org/10.1145/7921.214331>`_. Available at `http://netlib.org/amos/ <http://netlib.org/amos/>`_.

.. [DLMF]
   Olver, F. W. J., Olde Daalhuis, A. B., Lozier, D. W., Schneider, B. I., Boisvert, R. F., Clark, C. W., Miller, B. R., Saunders, B. V., Cohl, H. S., and McClain, M. A., eds. NIST Digital Library of Mathematical Functions. `http://dlmf.nist.gov/ <http://dlmf.nist.gov/>`_, Release 1.1.0 of 2020-12-15.
