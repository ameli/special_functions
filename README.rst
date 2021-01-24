*****************
special functions
*****************

|licence|

A package to provide both cython and python API for special functions (currently Bessel functions).

.. For users
..     * `Documentation <https://ameli.github.io/special_functions/index.html>`_
..     * `PyPi package <https://pypi.org/project/special_functions/>`_
..     * `Source code <https://github.com/ameli/special_functions>`_
..
.. For developers
..     * `API <https://ameli.github.io/special_functions/_modules/modules.html>`_
..     * `Travis-CI <https://travis-ci.com/github/ameli/special_functions>`_
..     * `Codecov <https://codecov.io/gh/ameli/special_functions>`_

+---------------------------------------------------------------------------+----------------------------------------------------------------------------+
|    For users                                                              | For developers                                                             |
+===========================================================================+============================================================================+
| * `Documentation <https://ameli.github.io/special_functions/index.html>`_ | * `API <https://ameli.github.io/special_functions/_modules/modules.html>`_ |
| * `PyPi package <https://pypi.org/project/special_functions/>`_           | * `Travis-CI <https://travis-ci.com/github/ameli/special_functions>`_      |
| * `Anaconda Cloud <https://anaconda.org/s-ameli/special_functions>`_      | * `Codecov <https://codecov.io/gh/ameli/special_functions>`_               |
+---------------------------------------------------------------------------+----------------------------------------------------------------------------+

*******
Install
*******

This package does not have any dependencies at runtime, and can be installed on Linux, macOS, and Windows platforms and supports both python 2 and 3.

-----------------
Install from PyPi
-----------------

|pypi| |format| |implementation| |pyversions|

The recommended installation method is through the package available at `PyPi <https://pypi.org/project/special_functions>`_ by

::
      
    python -m pip install special_functions

.. _Install_Conda:

---------------------------
Install from Anaconda Cloud
---------------------------

|conda| |conda-version| |conda-platform|

Install through the package available at `Conda <https://anaconda.org/s-ameli/special_functions>`_ by

::

    conda install -c s-ameli special_functions

.. _Build_Locally:

--------------------
Build Source Locally
--------------------

|release|

1. Install the build dependencies ``cython``, and ``numpy``:

   ::
         
       python -m pip install cython
       python -m pip install numpy>1.11

2. Clone the source code
   
   ::
       
       git clone https://github.com/ameli/special_functions.git
       cd special_functions

3. Build the package locally

   ::
       
       python setup build

4. Install the package

   ::
       
       python setup install

   The above command may need to be run with ``sudo``.

****
Test
****

|codecov-devel|

To test package, install ``tox``:

::

    python -m pip install tox

and test the package with

::

    tox

*****************
List of Functions
*****************

**Bessel Functions** of order |image01|, real or complex argument |image02|, or their |image03| derivative.

========================  ==============================  =========  =============================================================================
Syntax                    Return type                     Symbol     Description
========================  ==============================  =========  =============================================================================
``besselj(nu, z, n)``     ``double``, ``double complex``  |image04|  `Bessel function of the first kind <besselj>`_
``bessely(nu, z, n)``     ``double``, ``double complex``  |image05|  `Bessel function of the second kind <bessely>`_ (Weber function)
``besseli(nu, z, n)``     ``double``, ``double complex``  |image06|  `Modified Bessel function of the first kind <besseli>`_
``besselk(nu, z, n)``     ``double``, ``double complex``  |image07|  `Modified Bessel function of the second kind <besselk>`_
``besselh(nu, k, z, n)``  ``double``, ``double complex``  |image08|  `Bessel function of the third kind <besselh>`_ (Hankel function)
``lngamma(x)``            ``double````                    |image09|  `Natural logarithm of Gamma function <lngamma>`_
========================  ==============================  =========  =============================================================================

**Function Arguments:**

========  ==============================  =========  =====================================================================================================
Argument   Type                           Symbol     Description
========  ==============================  =========  =====================================================================================================
``nu``    ``double``, ``int``             |image01|  Parameter of functions (such as order of Bessel functions). Real number.
``z``     ``double``, ``double complex``  |image02|  Argument of the functions. Can be real or complex number.
``n``     ``int``                         |image03|  Derivative of function with respect to |image02|. Non-negative integer. Zero indicates no derivative.
========  ==============================  =========  =====================================================================================================

.. |image01| image:: https://raw.githubusercontent.com/ameli/special_functions/main/docs/images/image01.svg
.. |image02| image:: https://raw.githubusercontent.com/ameli/special_functions/main/docs/images/image02.svg
.. |image03| image:: https://raw.githubusercontent.com/ameli/special_functions/main/docs/images/image03.svg
.. |image04| image:: https://raw.githubusercontent.com/ameli/special_functions/main/docs/images/image04.svg
.. |image05| image:: https://raw.githubusercontent.com/ameli/special_functions/main/docs/images/image05.svg
.. |image06| image:: https://raw.githubusercontent.com/ameli/special_functions/main/docs/images/image06.svg
.. |image07| image:: https://raw.githubusercontent.com/ameli/special_functions/main/docs/images/image07.svg
.. |image08| image:: https://raw.githubusercontent.com/ameli/special_functions/main/docs/images/image08.svg
.. |image09| image:: https://raw.githubusercontent.com/ameli/special_functions/main/docs/images/image09.svg

*******
Example
*******

It is possible to ``import`` and/or ``cimport`` the functions, respectively in *python* or *cython* environment as shown in the two examples below.

--------------------
Use in a Cython Code
--------------------

This example uses ``besselk`` to compute the modified Bessel function of the second kind and its first and second derivatives for a complex argument. The python's ``gil`` can be optionally released, especially when this feature is needed during parallel OpenMP environments.

.. code-block:: python

    >>> # cimport module in a *.pyx file
    >>> from special_functions cimport besselk

    >>> # Declare typed variables
    >>> cdef double nu = 2.5
    >>> cdef double complex z = 1+2j
    >>> cdef double complex d0k, d1k, d2k

    >>> # Releasing gil to secure maximum cythonic speedup
    >>> with nogil:
    ...     d0k = besselk(nu, z, 0)    # no derivative
    ...     d1k = besselk(nu, z, 1)    # 1st derivative
    ...     d2k = besselk(nu, z, 2)    # 2nd derivative

--------------------
Use in a Python Code
--------------------

This example uses ``besselk`` to compute the modified Bessel function of the second kind and its first and second derivatives for a complex argument. Note, this function uses the global lock interpreter (``gil``).

.. code-block:: python

    >>> # import module in a *.py file
    >>> from special_functions import besselk

    >>> # Declare typed variables
    >>> nu = 2.5
    >>> z = 1+2j

    >>> d0k = besselk(nu, z)       # no derivative
    >>> d1k = besselk(nu, z, 1)    # 1st derivative
    >>> d2k = besselk(nu, z, 2)    # 2nd derivative

***************
Technical Notes
***************

The package is (an almost) replica of ``scipy.special`` implementation of special functions and wraps around the following libraries:

* `Cephes Mathematical Library <https://www.netlib.org/cephes/>`_: A C library used for the Bessel functions of integer order |image01| and real argument |image02|.
* `Amos <https://dl.acm.org/doi/10.1145/7921.214331>`_: A Fortran library (available on `Netlib <http://www.netlib.org/amos/>`_) used for the Bessel functions of real order |image01| and complex argument |image02|.

The Bessel functions of half-integer order |image01| do not use the above-mentioned libraries, rather they are computed directly using their recursive formulas and basic functions representation.


****************
Acknowledgements
****************

* National Science Foundation #1520825
* American Heart Association #18EIA33900046

.. |codecov-devel| image:: https://img.shields.io/codecov/c/github/ameli/special_functions
   :target: https://codecov.io/gh/ameli/special_functions
.. |licence| image:: https://img.shields.io/github/license/ameli/special_functions
   :target: https://opensource.org/licenses/MIT
.. |implementation| image:: https://img.shields.io/pypi/implementation/special_functions
.. |pyversions| image:: https://img.shields.io/pypi/pyversions/special_functions
.. |format| image:: https://img.shields.io/pypi/format/special_functions
.. |pypi| image:: https://img.shields.io/pypi/v/special_functions
.. |conda| image:: https://anaconda.org/s-ameli/special_functions/badges/installer/conda.svg
   :target: https://anaconda.org/s-ameli/special_functions
.. |platforms| image:: https://img.shields.io/conda/pn/s-ameli/special_functions?color=orange?label=platforms
   :target: https://anaconda.org/s-ameli/special_functions
.. |conda-version| image:: https://img.shields.io/conda/v/s-ameli/special_functions
   :target: https://anaconda.org/s-ameli/special_functions
.. |release| image:: https://img.shields.io/github/v/tag/ameli/special_functions
   :target: https://github.com/ameli/special_functions/releases/
.. |conda-platform| image:: https://anaconda.org/s-ameli/special_functions/badges/platforms.svg
   :target: https://anaconda.org/s-ameli/special_functions
