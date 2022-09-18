.. _bessely:

**********************************
Bessel Function of the Second Kind
**********************************

This module computes the Bessel function of the second kind (Weber function) or its :math:`n`:superscript:`th` derivative

.. math::

    \frac{\partial^n Y_{\nu}(z)}{\partial z^n},

where

* :math:`n \in \mathbb{N}` is the order of the derivative (:math:`n = 0` indicates no derivative).
* :math:`\nu \in \mathbb{R}` is the order of the Bessel function.
* :math:`z \in \mathbb{C}` is the input argument.
  

======
Syntax
======

This function has the following syntaxes depending on whether it is used in Python or Cython, or the input argument ``z`` is complex or real.

+------------+-----------------+-----------------------------------------------------------------+
| Interface  | Input Type      | Function Signature                                              |
+============+=================+=================================================================+
| **Python** | Real or Complex | ``bessely(nu, z, n=0)``                                         |
+------------+-----------------+-----------------------------------------------------------------+
| **Cython** | Real            | ``double bessely(double nu, double z, int n)``                  |
+            +-----------------+-----------------------------------------------------------------+
|            | Complex         | ``double complex cbessely(double nu, double complex z, int n)`` |
+------------+-----------------+-----------------------------------------------------------------+

**Input Arguments:**

.. attribute:: nu
   :type: double
    
   The parameter :math:`\nu` of Bessel function.

.. attribute:: z
   :type: double or double complex

   The input argument :math:`z` of Bessel function.

   * In *Python*, the function ``bessely`` accepts ``double`` and ``double complex`` types.
   * In *Cython*, the function ``bessely`` accepts ``double`` type.
   * In *Cython*, the function ``cbessely`` accepts ``double complex`` type.

.. attribute:: n
   :type: int
   :value: 0

   The order :math:`n` of the derivative of Bessel function. Zero indicates no derivative.

   * For the *Python* interface, the default value is ``0`` and this argument may not be provided.
   * For the *Cython* interfaces, no default value is defined and this argument should be provided.


.. seealso::

   * :ref:`Bessel function of the first kind <besselj>`.
   * :ref:`Bessel function of the third kind <besselh>`.


========
Examples
========
 
--------------------
Using in Cython Code
--------------------

The codes below should be used in a ``.pyx`` file and compiled with Cython.

As shown in the codes below, the python's global lock interpreter, or ``gil``, can be optionally released inside the scope of ``with nogil:`` statement. This is especially useful in parallel OpenMP environments.

~~~~~~~~~~~~~
Real Function
~~~~~~~~~~~~~

This example shows the real function ``bessely`` to compute the Bessel function of the second kind for a real argument ``z``. The output variables ``d0y``, ``d1y``, and ``d2y`` represent the values of Bessel function and its second and second derivatives, respectively.

.. code-block:: python

    >>> # cimport module in a *.pyx file
    >>> from special_functions cimport bessely

    >>> # Declare typed variables
    >>> cdef double nu = 2.5
    >>> cdef double z = 2.0
    >>> cdef double d0y, d1y, d2y

    >>> # Releasing gil to secure maximum cythonic speedup
    >>> with nogil:
    ...     d0y = bessely(nu, z, 0)    # no derivative
    ...     d1y = bessely(nu, z, 1)    # 1st derivative
    ...     d2y = bessely(nu, z, 2)    # 2nd derivative

~~~~~~~~~~~~~~~~
Complex Function
~~~~~~~~~~~~~~~~

The example below is similar to the above, except, the *complex* function ``cbessely`` with complex argument ``z`` is used. The output variables ``d0y``, ``d1y``, and ``d2y`` are also complex.

.. code-block:: python

    >>> # cimport module in a *.pyx file
    >>> from special_functions cimport cbessely

    >>> # Declare typed variables
    >>> cdef double nu = 2.5
    >>> cdef double complex z = 2.0 + 1.0j
    >>> cdef double complex d0y, d1y, d2y

    >>> # Releasing gil to secure maximum cythonic speedup
    >>> with nogil:
    ...     d0y = cbessely(nu, z, 0)    # no derivative
    ...     d1y = cbessely(nu, z, 1)    # 1st derivative
    ...     d2y = cbessely(nu, z, 2)    # 2nd derivative

--------------------
Using in Python Code
--------------------

The codes below should be used in a ``.py`` file and no compilation is required. The python's global lock interpreter, or ``gil``, cannot be released.

~~~~~~~~~~~~~
Real Function
~~~~~~~~~~~~~

The example below uses the function ``bessely`` with the real argument ``z`` to compute the Bessel function of the second kind and its second and second derivatives.

.. code-block:: python

    >>> # import module in a *.py file
    >>> from special_functions import bessely

    >>> nu = 2.5
    >>> z = 2.0

    >>> d0y = bessely(nu, z)       # no derivative
    >>> d1y = bessely(nu, z, 1)    # 1st derivative
    >>> d2y = bessely(nu, z, 2)    # 2nd derivative

~~~~~~~~~~~~~~~~
Complex Function
~~~~~~~~~~~~~~~~

To use a complex input argument ``z`` in the Python interface, the same function ``bessely`` as the previous example can be used. This is unlike the Cython interface in which ``cbessely`` should be used.

.. code-block:: python

    >>> # import module in a *.py file
    >>> from special_functions import bessely

    >>> nu = 2.5
    >>> z = 2.0 + 1.0j

    >>> d0y = bessely(nu, z)       # no derivative
    >>> d1y = bessely(nu, z, 1)    # 1st derivative
    >>> d2y = bessely(nu, z, 2)    # 2nd derivative


======================
Differences with Scipy
======================

There are very few differences between numerical results of this package compared to scipy. In the real domain :math:`z \in \mathbb{Z}`, it holds:

.. math::
    
    \lim_{z \to 0^+} Y_{\nu}(z) = 0, \qquad \nu < 0 \quad \text{and} \quad \nu + \frac{1}{2} \in \mathbb{Z},

 
The above value is returned correctly with this package. However, scipy always returns :math:`(-1)^{\lceil \nu \rceil}\infty` where :math:`\lceil \nu \rceil` is the ceil function. That is:

.. code-block:: python

   >>> # This returns correct value
   >>> from special_functions import bessely
   >>> bessely(-1.5, 0)
   0.0

   >>> # This returns incorrect value
   >>> from scipy.special import yv
   >>> yv(-1.5 ,0)
   inf

However, in the complex domain :math:`z \in \mathbb{C}` at :math:`z = 0`, the answer to the above function value is ``nan`` and both this package and scipy return similar answers.


=====
Tests
=====

The test script of this module is located at |tests/test_bessely.py|_. The test compares the results of this module with |scipy.special|_ package (functions ``yn``, ``yv``, and ``yvp``) for several combinations of input parameters with multiple values. Run the test by

.. prompt:: bash

    git clone https://github.com/ameli/special_functions.git
    cd special_functions/tests
    python test_bessely.py

.. |tests/test_bessely.py| replace:: ``tests/test_bessely.py``
.. _tests/test_bessely.py: https://github.com/ameli/special_functions/blob/main/tests/test_bessely.py

.. |scipy.special| replace:: ``scipy.special``
.. _scipy.special: https://docs.scipy.org/doc/scipy/reference/special.html

=========
Algorithm
=========

Depending on the values of the input parameters :math:`(\nu, z, n)`, one of the following three algorithms is employed.

* If :math:`z \in \mathbb{R}` (that is, ``z`` is of type ``double``) and :math:`\nu \in \mathbb{Z}`, the computation is carried out by Cephes C library (see [Cephes-1989]_), respectively using ``yn`` functions in that library.
* If :math:`\nu + \frac{1}{2} \in \mathbb{Z}`, the Bessel function is computed using :ref:`half-integer formulas <half_int_bessely>` in terms of elementary functions.
* For other cases, the computation is carried out by Amos Fortran library (see [Amos-1986]_) using ``zbesy`` subroutine in that library.

-------------
Special Cases
-------------

In the special cases below, the computation is performed by taking advantage of some of the known formulas and properties of the Bessel functions.

~~~~~~~~~~
Branch-Cut
~~~~~~~~~~

* In the real domain where :math:`z \in\mathbb{R}`, if :math:`z < 0`, the value of ``NAN`` is returned.
* However, in the complex domain :math:`z \in\mathbb{C}` and on the branch-cut of the function, :math:`\Re(z) < 0` and :math:`\Im(z) = 0`, its *principal value* corresponding to the branch
  
  .. math::
      
      \mathrm{arg}(z) \in (-\pi, \pi]
      
  is returned. This value may be finite, infinity or undefined depending on :math:`\nu` and :math:`z`.

~~~~~~~~~~~~~~~~~~~~
Negative :math:`\nu`
~~~~~~~~~~~~~~~~~~~~

When :math:`\nu < 0` and for the two cases below, the Bessel function is related to the Bessel function of the positive parameter :math:`-\nu`.

* If :math:`\nu \in \mathbb{Z}` (see [DLMF]_ Eq. `10.4.1 <https://dlmf.nist.gov/10.4#E1>`_):

  .. math::

      Y_{\nu}(z) = (-1)^{\nu} Y_{-\nu}(z)

* If :math:`\nu + \frac{1}{2} \in \mathbb{Z}` (see [DLMF]_ Eq. `10.2.3 <https://dlmf.nist.gov/10.2#E3>`_):

  .. math::

      Y_{\nu}(z) = \cos(\pi \nu) Y_{-\nu}(z) - \sin(\pi \nu) J_{-\nu}(z),

  where :math:`J_{\nu}(z)` is the :ref:`Bessel function of the first kind <besselj>`.

~~~~~~~~~~~
Derivatives
~~~~~~~~~~~

If :math:`n > 0`, the following relation for the derivative is applied (see [DLMF]_ Eq. `10.6.7 <https://dlmf.nist.gov/10.6#E7>`_):

.. math::
   
   \frac{\partial^n Y_{\nu}(z)}{\partial z^n} = \frac{1}{2^n} \sum_{i = 0}^n (-1)^i \binom{n}{i} Y_{\nu - n + 2i}(z).

.. _half_int_bessely:

~~~~~~~~~~~~~~~~~~~~~~~~
Half-Integer :math:`\nu`
~~~~~~~~~~~~~~~~~~~~~~~~

When :math:`\nu` is half-integer, the Bessel function is computed in terms of elementary functions as follows.

* If :math:`z = 0`:

  * If :math:`\nu > 0`, then :math:`Y_{\nu}(0) = -\infty`.
  * If :math:`\nu = -\frac{1}{2}`, then :math:`\lim_{z \to 0^+} Y_{\nu}(z) = 0`.
  * If :math:`-\frac{1}{2} \neq \nu \leq 0`:
    
    * If :math:`z \in \mathbb{R}`, then :math:`Y_{\nu}(0) = \mathrm{sign}(\sin(\pi \nu)) \times \infty`.
    * If :math:`z \in \mathbb{C}`, then ``NAN`` is returned.

* If :math:`z < 0` and :math:`z \in \mathbb{R}`, then ``NAN`` is returned.

* If :math:`\nu = \pm \frac{1}{2}` (see [DLMF]_ Eq. `10.16.1 <https://dlmf.nist.gov/10.16#E1>`_)

  .. math::

      Y_{\frac{1}{2}}(z) = -\sqrt{\frac{2}{\pi z}} \cos(z), \\
      Y_{-\frac{1}{2}}(z) = \sqrt{\frac{2}{\pi z}} \sin(z).

  Depending on :math:`z`, the above relations are computed using the real or complex implementation of the elementary functions.

* Higher-order half-integer parameter :math:`\nu` is related to the above relation for :math:`\nu = \pm \frac{1}{2}` using recursive formulas (see [DLMF]_ Eq. `10.6.1 <https://dlmf.nist.gov/10.6#E1>`_):

.. math::

    Y_{\nu}(z) = \frac{2 (\nu - 1)}{z} Y_{\nu - 1}(z) - Y_{\nu - 2}(z), \qquad \nu > 0, \\
    Y_{\nu}(z) = \frac{2 (\nu + 1)}{z} Y_{\nu + 1}(z) - Y_{\nu + 2}(z), \qquad \nu < 0.


==========
References
==========

.. [Cephes-1989] Moshier, S. L. (1989). C language library with special functions for mathematical physics. Available at `http://www.netlib.org/cephes <http://www.netlib.org/cephes>`_.

.. [Amos-1986] Amos, D. E. (1986). Algorithm 644: A portable package for Bessel functions of a complex argument and nonnegative order. ACM Trans. Math. Softw. 12, 3 (Sept. 1986), 265-273. DOI: `https://doi.org/10.1145/7921.214331 <https://doi.org/10.1145/7921.214331>`_. Available at `http://netlib.org/amos/ <http://netlib.org/amos/>`_.

.. [DLMF]
   Olver, F. W. J., Olde Daalhuis, A. B., Lozier, D. W., Schneider, B. I., Boisvert, R. F., Clark, C. W., Miller, B. R., Saunders, B. V., Cohl, H. S., and McClain, M. A., eds. NIST Digital Library of Mathematical Functions. `http://dlmf.nist.gov/ <http://dlmf.nist.gov/>`_, Release 1.1.0 of 2020-12-15.
