*****************
special functions
*****************

|codecov-devel| |licence| |format| |pypi| |implementation| |pyversions|

A package to provide both cython and python API for special functions.

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

***********
Description
***********

This package computes the trace of inverse of two forms of matrices:

1. **Fixed Matrix:** For an invertible matrix |image01| (sparse of dense), this package computes |image02|.
2. **One-Parameter Affine Matrix Function:** |image05|, where |image01| and |image03| are symmetric and positive-definite matrices and ``t`` is a real parameter. This package can interpolate the function

.. image:: https://raw.githubusercontent.com/ameli/special_functions/main/docs/images/image06.svg
   :align: center

**Application:**
    The above function is featured in a wide range of applications in statistics and machine learning. Particular applications are in model selection and optimizing hyperparameters with gradient-based maximum likelihood methods. In such applications, computing the above function is often a computational challenge for large matrices. Often, this function is evaluated for a wide range of the parameter |image00| while |image01| and |image03| remain fixed. As such, an interpolation scheme enables fast computation of the function.

These interpolation methods are described in [Ameli-2020]_. 

.. |image00| image:: https://raw.githubusercontent.com/ameli/special_functions/main/docs/images/image00.svg
.. |image01| image:: https://raw.githubusercontent.com/ameli/special_functions/main/docs/images/image01.svg
.. |image02| image:: https://raw.githubusercontent.com/ameli/special_functions/main/docs/images/image02.svg
.. |image03| image:: https://raw.githubusercontent.com/ameli/special_functions/main/docs/images/image03.svg
.. |image04| image:: https://raw.githubusercontent.com/ameli/special_functions/main/docs/images/image04.svg
.. |image05| image:: https://raw.githubusercontent.com/ameli/special_functions/main/docs/images/image05.svg
.. |image06| image:: https://raw.githubusercontent.com/ameli/special_functions/main/docs/images/image06.svg

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

*****
Usage
*****

You can ``import`` or ``cimport`` this package respectively in python or cython code, as shown in the two examples below.

=======================
1. Use in a Cython Code
=======================

This example compute Bessel function :math:`K_{\nu}(z)` and its first and
second derivatives for a complex argument. The python's ``gil`` can be
optionally released, especially when this feature is needed during parallel
OpenMP environments.

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

=========================
2. Usage in a Python Code
=========================

This example compute Bessel function :math:`K_{\nu}(z)` and its first and
second derivatives for a complex argument. Note, this function uses the
global lock interpreter (``gil``).

.. code-block:: python

    >>> # import module in a *.py file
    >>> from special_functions import besselk

    >>> # Declare typed variables
    >>> nu = 2.5
    >>> z = 1+2j

    >>> d0k = besselk(nu, z)       # no derivative
    >>> d1k = besselk(nu, z, 1)    # 1st derivative
    >>> d2k = besselk(nu, z, 2)    # 2nd derivative

****************
Acknowledgements
****************

* National Science Foundation #1520825
* American Heart Association #18EIA33900046

.. |examplesdir| replace:: ``/examples`` 
.. _examplesdir: https://github.com/ameli/special_functions/blob/main/examples
.. |example1| replace:: ``/examples/Plot_special_functions_FullRank.py``
.. _example1: https://github.com/ameli/special_functions/blob/main/examples/Plot_special_functions_FullRank.py
.. |example2| replace:: ``/examples/Plot_special_functions_IllConditioned.py``
.. _example2: https://github.com/ameli/special_functions/blob/main/examples/Plot_special_functions_IllConditioned.py
.. |example3| replace:: ``/examples/Plot_GeneralizedCorssValidation.py``
.. _example3: https://github.com/ameli/special_functions/blob/main/examples/Plot_GeneralizedCrossValidation.py

.. |codecov-devel| image:: https://img.shields.io/codecov/c/github/ameli/special_functions
   :target: https://codecov.io/gh/ameli/special_functions
.. |licence| image:: https://img.shields.io/github/license/ameli/special_functions
   :target: https://opensource.org/licenses/MIT
.. |travis-devel-linux| image:: https://img.shields.io/travis/com/ameli/special_functions?env=BADGE=linux&label=build&branch=main
   :target: https://travis-ci.com/github/ameli/special_functions
.. |travis-devel-osx| image:: https://img.shields.io/travis/com/ameli/special_functions?env=BADGE=osx&label=build&branch=main
   :target: https://travis-ci.com/github/ameli/special_functions
.. |travis-devel-windows| image:: https://img.shields.io/travis/com/ameli/special_functions?env=BADGE=windows&label=build&branch=main
   :target: https://travis-ci.com/github/ameli/special_functions
.. |implementation| image:: https://img.shields.io/pypi/implementation/special_functions
.. |pyversions| image:: https://img.shields.io/pypi/pyversions/special_functions
.. |format| image:: https://img.shields.io/pypi/format/special_functions
.. |pypi| image:: https://img.shields.io/pypi/v/special_functions
