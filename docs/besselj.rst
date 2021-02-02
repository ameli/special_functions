*********************************
Bessel Function of the First Kind
*********************************

This module computes the Bessel function of the first kind or its :math:`n`:superscript:`th` derivative

.. math::

    \frac{\partial^n J_{\nu}(z)}{\partial z^n},

where

* :math:`n \in \mathbb{N}` is the order of the derivative (:math:`n = 0` indicates no derivative).
* :math:`\nu \in \mathbb{R}` is the order of the Bessel function.
* :math:`z \in \mathbb{C}` is the input argument.
  

======
Syntax
======

This module has the following interfaces depending on whether it is used in Python or Cython environments, or the input argument ``z`` is complex or real.

+------------+-----------------+-----------------------------------------------------------------+
| Interface  | Input Type      | Function Signature                                              |
+============+=================+=================================================================+
| **Python** | Real or Complex | ``besselj(nu, z, n=0)``                                         |
+------------+-----------------+-----------------------------------------------------------------+
| **Cython** | Real            | ``double besselj(double nu, double z, int n)``                  |
+            +-----------------+-----------------------------------------------------------------+
|            | Complex         | ``double complex cbesselj(double nu, double complex z, int n)`` |
+------------+-----------------+-----------------------------------------------------------------+

**Input Arguments:**

.. attribute:: nu
   :type: double
    
   The parameter :math:`\nu` of Bessel function.

.. attribute:: z
   :type: double or double complex

   The input argument :math:`z` of Bessel function.

   * In *Python*, the function ``besselj`` accepts ``double`` and ``double complex`` types.
   * In *Cython*, the function ``besselj`` accepts ``double`` type.
   * In *Cython*, the function ``cbesselj`` accepts ``double complex`` type.

.. attribute:: n
   :type: int
   :value: 0

   Order of derivative of Bessel function.

   * For the *Python* interface, the default value is ``0`` and this argument may not be provided.
   * For the *Cython* interfaces, no default value is defined and this argument should be provided.


.. seealso::

   :ref:`Bessel function of the second kind <bessely>`.


========
Examples
========
 
--------------------
Using in Cython Code
--------------------

The codes below should be used in a ``.pyx`` file and compiled with Cython. The python's global lock interpreter, or ``gil``, can be optionally released inside the scope of ``with nogil:`` statement. This is especially useful in parallel OpenMP environments.

~~~~~~~~~~~~~
Real Function
~~~~~~~~~~~~~

This example shows the real function ``besselj`` to compute the Bessel function of the first kind for a real argument ``z``. The output variables ``d0j``, ``d1j``, and ``d2j`` represent the values of Bessel function and its first and second derivatives, respectively.

.. code-block:: python

    >>> # cimport module in a *.pyx file
    >>> from special_functions cimport besselj

    >>> # Declare typed variables
    >>> cdef double nu = 2.5
    >>> cdef double z = 2.0
    >>> cdef double d0j, d1j, d2j

    >>> # Releasing gil to secure maximum cythonic speedup
    >>> with nogil:
    ...     d0j = besselj(nu, z, 0)    # no derivative
    ...     d1j = besselj(nu, z, 1)    # 1st derivative
    ...     d2j = besselj(nu, z, 2)    # 2nd derivative

~~~~~~~~~~~~~~~~
Complex Function
~~~~~~~~~~~~~~~~

The example below is similar to the above, except, the *complex* function ``cbesselj`` with complex argument ``z`` is used. The output variables ``d0j``, ``d1j``, and ``d2j`` are also complex.

.. code-block:: python

    >>> # cimport module in a *.pyx file
    >>> from special_functions cimport cbesselj

    >>> # Declare typed variables
    >>> cdef double nu = 2.5
    >>> cdef double complex z = 2.0 + 1.0j
    >>> cdef double complex d0j, d1j, d2j

    >>> # Releasing gil to secure maximum cythonic speedup
    >>> with nogil:
    ...     d0j = cbesselj(nu, z, 0)    # no derivative
    ...     d1j = cbesselj(nu, z, 1)    # 1st derivative
    ...     d2j = cbesselj(nu, z, 2)    # 2nd derivative

--------------------
Using in Python Code
--------------------

The codes below should be used in a ``.py`` file and no compilation is required. The python's global lock interpreter, or ``gil``, cannot be released.

~~~~~~~~~~~~~
Real Function
~~~~~~~~~~~~~

The example below shows using ``besselj`` function with a real argument to compute the Bessel function of the first kind and its first and second derivatives.

.. code-block:: python

    >>> # import module in a *.py file
    >>> from special_functions import besselj

    >>> nu = 2.5
    >>> z = 2.0

    >>> d0j = besselj(nu, z)       # no derivative
    >>> d1j = besselj(nu, z, 1)    # 1st derivative
    >>> d2j = besselj(nu, z, 2)    # 2nd derivative

~~~~~~~~~~~~~~~~
Complex Function
~~~~~~~~~~~~~~~~

To use a complex input argument, the same function ``besselj`` can be used (unlike in Cython, in which ``cbesselj`` should be used.)

.. code-block:: python

    >>> # import module in a *.py file
    >>> from special_functions import besselj

    >>> nu = 2.5
    >>> z = 2.0 + 1.0j

    >>> d0j = besselj(nu, z)       # no derivative
    >>> d1j = besselj(nu, z, 1)    # 1st derivative
    >>> d2j = besselj(nu, z, 2)    # 2nd derivative


=====
Tests
=====

Tests of this module can be found in |tests/test_besselj.py|_ script, where the results are compared with the |scipy.special|_ package (functions ``j0``, ``j1``, ``jn``, ``jv``, and ``jvp``) for various combinations of input parameters. To run the test:

.. code::

    git clone https://github.com/ameli/special_functions.git
    cd special_functions/tests
    python test_besselj.py

.. |tests/test_besselj.py| replace:: ``tests/test_besselj.py``
.. _tests/test_besselj.py: https://github.com/ameli/special_functions/blob/main/tests/test_besselj.py

.. |scipy.special| replace:: ``scipy.special``
.. _scipy.special: https://docs.scipy.org/doc/scipy/reference/special.html


=========
Algorithm
=========

Depending on the values of the input parameters :math:`(\nu, z, n)`, different algorithms are employed in this module.

* If :math:`z \in \mathbb{R}` and :math:`\nu = 0` or :math:`\nu = 1`, the computation is carried out by Cephes C library (see [Cephes-1989]_) using ``j0`` and ``j1`` functions, respectively.
* If :math:`\nu + \frac{1}{2} \in \mathbb{Z}`, the :ref:`half-integer formulas <half_int_besselj>` using elementary functions are used.
* For other cases, the computation is carried out by the Amos Fortran library (see [Amos-1986]_) using ``zbesj`` subroutine.

-------------
Special Cases
-------------

In the special cases below, the computation is performed by taking advantage of some of the known formulas for the Bessel functions.

~~~~~~~~~~
Branch-Cut
~~~~~~~~~~

* In the real domain where :math:`z \in\mathbb{R}`, if :math:`z < 0` and :math:`\nu \notin \mathbb{Z}`, the value of ``NAN`` is returned.
* However, in the complex domain :math:`z \in\mathbb{C}` and on the branch-cut of the function, :math:`\Re(z) < 0` and :math:`\Im(z) = 0`, its *principal value* corresponding to the branch
  
  .. math::
      
      \mathrm{arg}(z) \in (-\pi, \pi]
      
  is returned. This value may be finite, infinity or undefined depending on :math:`\nu` and :math:`z`.

~~~~~~~~~~~~~~~~~~~~
Negative :math:`\nu`
~~~~~~~~~~~~~~~~~~~~

When :math:`\nu < 0` and for the following special cases, the Bessel function is computed using the positive parameter :math:`-\nu`.

* If :math:`\nu \in \mathbb{Z}`, then

  .. math::

      J_{\nu}(z) = (-1)^{\nu} J_{-\nu}(z)

* If :math:`\nu + \frac{1}{2} \in \mathbb{Z}`:

  .. math::

      J_{\nu}(z) = \cos(\pi \nu) J_{-\nu}(z) + \sin(\pi \nu) Y_{-\nu}(z),

  where :math:`Y_{\nu}(z)` is the :ref:`Bessel function of the second kind <bessely>`. In the above, the functions :math:`J_{-\nu}(z)` and :math:`Y_{-\nu}(z)` are computed by :ref:`half-integer formulas <half_int_besselj>`.

~~~~~~~~~~~
Derivatives
~~~~~~~~~~~

If :math:`n > 0`, the following relation for the derivative is applied:

.. math::
   
   \frac{\partial^n J_{\nu}(z)}{\partial z^n} = \frac{1}{2^n} \sum_{i = 0}^n (-1)^i \binom{n}{i} J_{\nu - n + 2i}(z).

.. _half_int_besselj:

~~~~~~~~~~~~~~~~~~~~~~~~
Half-Integer :math:`\nu`
~~~~~~~~~~~~~~~~~~~~~~~~

When :math:`\nu` is half-integer, the Bessel function is computed with the elementary functions as follows.

* If :math:`z = 0`:

  * If :math:`\nu > 0`, then :math:`J_{\nu}(0) = 0`.
  * If :math:`\nu \leq 0`:
    
    * If :math:`z \in \mathbb{R}`, then :math:`J_{\nu}(0) = -\mathrm{sign}(\sin(\pi \nu)) \times \infty`.
    * If :math:`z \in \mathbb{C}`, then ``NAN`` is returned.

* If :math:`z < 0` and :math:`z \in \mathbb{R}`, then ``NAN`` is returned.

* If :math:`\nu = \pm \frac{1}{2}`:

  .. math::

      J_{\frac{1}{2}}(z) = \sqrt{\frac{2}{\pi z}} \sin(z), \\
      J_{-\frac{1}{2}}(z) = \sqrt{\frac{2}{\pi z}} \cos(z).

  Depending on :math:`z`, the above relations are computed using the real or complex implementation of the elementary functions.

* For other half-integer orders of :math:`\nu`, the following recursive formulas are used:

.. math::

    J_{\nu}(z) = \frac{2 (\nu - 1)}{z} J_{\nu - 1}(z) - J_{\nu - 2}(z), \qquad \nu > 0, \\
    J_{\nu}(z) = \frac{2 (\nu + 1)}{z} J_{\nu + 1}(z) - J_{\nu + 2}(z), \qquad \nu < 0.


==========
References
==========

.. [Cephes-1989] Moshier, S. L. (1989). C language library with special functions for mathematical physics. Available at `http://www.netlib.org/cephes/index.html <http://www.netlib.org/cephes/index.html>`_.

.. [Amos-1986] Amos, D. E. (1986). Algorithm 644: A portable package for Bessel functions of a complex argument and nonnegative order. ACM Trans. Math. Softw. 12, 3 (Sept. 1986), 265-273. DOI: `https://doi.org/10.1145/7921.214331 <https://doi.org/10.1145/7921.214331>`_. Available at `http://netlib.org/amos/ <http://netlib.org/amos/>`_.

.. |DLMF| 