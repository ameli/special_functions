*****************
special functions
*****************

|licence| |docs|

This package provides both Python and Cython interfaces for Bessel functions and a few other special functions. 

========
Features
========

* **Lightweight:** This package requires *no python dependency* at runtime.
* **Cython interface:** Both Python and Cython interfaces are available.
* **Releasing GIL:** Most importantly, the functions can be used in ``with nogil:`` environment, which is essential in parallel OpenMP applications with Cython.

========
Tutorial
========

|binder|

Launch `online interactive notebook <https://mybinder.org/v2/gh/ameli/special_functions/HEAD?filepath=notebooks%2Fspecial_functions.ipynb>`_ with Binder.


=====
Links
=====

* `Documentation <https://ameli.github.io/special_functions/index.html>`_
* `Package on Anaconda Cloud <https://anaconda.org/s-ameli/special_functions>`_
* `Package on PyPI <https://pypi.org/project/special_functions/>`_
* `Github <https://ameli.github.io/special_functions>`_

=======
Install
=======

-------------------
Supported Platforms
-------------------

Successful installation and tests have been performed on the following platforms and Python/PyPy versions shown in the table below.

.. |y| unicode:: U+2714
.. |n| unicode:: U+2716

+----------+------+------+------+------+------+-------+-----------------+
| Platform | Python version     | PyPy version        | Status          |
+          +------+------+------+------+------+-------+                 +
|          | 3.9  | 3.10 | 3.11 | 3.8  | 3.9  | 3.10  |                 |
+==========+======+======+======+======+======+=======+=================+
| Linux    | |y|  | |y|  | |y|  | |y|  | |y|  | |y|   | |build-linux|   |
+----------+------+------+------+------+------+-------+-----------------+
| macOS    | |y|  | |y|  | |y|  | |n|  | |n|  | |n|   | |build-macos|   |
+----------+------+------+------+------+------+-------+-----------------+
| Windows  | |y|  | |y|  | |y|  | |n|  | |n|  | |n|   | |build-windows| |
+----------+------+------+------+------+------+-------+-----------------+

.. |build-linux| image:: https://github.com/ameli/special_functions/workflows/build-linux/badge.svg
   :target: https://github.com/ameli/special_functions/actions?query=workflow%3Abuild-linux 
.. |build-macos| image:: https://github.com/ameli/special_functions/workflows/build-macos/badge.svg
   :target: https://github.com/ameli/special_functions/actions?query=workflow%3Abuild-macos
.. |build-windows| image:: https://github.com/ameli/special_functions/workflows/build-windows/badge.svg
   :target: https://github.com/ameli/special_functions/actions?query=workflow%3Abuild-windows


* For the Python/PyPy versions indicated by |y| in the above, this package can be installed using either ``pip`` or ``conda`` (see `Install Package`_ below.)
* This package cannot be installed via ``pip`` or ``conda`` on the Python/PyPy versions indicated by |n| in the above table.
* To install on the older Python 3 versions that are not listed in the above (for example Python 3.5), you should *build* this package from the source code (see `Build and Install from Source Code`_).


------------
Dependencies
------------

* **At runtime:** This package does not have any dependencies at runtime.
* **For tests:** To run `Test`_, ``scipy`` package is required and can be installed by

  ::

      python -m pip install -r tests/requirements.txt

---------------
Install Package
---------------

Either `Install from PyPi`_, `Install from Anaconda Cloud`_, or `Build and Install from Source Code`_.

.. _Install_PyPi:

~~~~~~~~~~~~~~~~~
Install from PyPi
~~~~~~~~~~~~~~~~~

|pypi| |format| |implementation| |pyversions|

The recommended installation method is through the package available at `PyPi <https://pypi.org/project/special_functions>`_ using ``pip``.

1. Ensure ``pip`` is installed within Python and upgrade the existing ``pip`` by

   ::

       python -m ensurepip
       python -m pip install --upgrade pip

   If you are using PyPy instead of Python, ensure ``pip`` is installed and upgrade the existing ``pip`` by

   ::

       pypy -m ensurepip
       pypy -m pip install --upgrade pip

2. Install this package in Python by
   
   ::
       
       python -m pip install special_functions

   or, in PyPy by

   ::
       
       pypy -m pip install special_functions

.. _Install_Conda:

~~~~~~~~~~~~~~~~~~~~~~~~~~~
Install from Anaconda Cloud
~~~~~~~~~~~~~~~~~~~~~~~~~~~

|conda-version| |conda-platform|

Alternatively, the package can be installed through `Anaconda could <https://anaconda.org/s-ameli/special_functions>`_.

* In **Linux** and **Windows**:
  
  ::
      
      conda install -c s-ameli special_functions

* In **macOS**:
  
  ::
      
      conda install -c s-ameli -c conda-forge special_functions

.. _Build_Locally:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Build and Install from Source Code
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

|release|

**Build dependencies:** To build the package from the source code, ``numpy`` and ``cython`` are required. These dependencies are installed automatically during the build process and no action is needed.

1. Install both C and Fortran compilers as follows.

   * **Linux:** Install ``gcc``, for instance, by ``apt`` (or any other package manager on your Linux distro)

     ::

         sudo apt install gcc gfortran

   * **macOS:** Install ``gcc`` via Homebrew:

     ::

         sudo brew install gcc

     *Note:* If ``gcc`` is already installed, but Fortran compiler is yet not available on macOS, you may resolve this issue by reinstalling:
     
     ::
         
         sudo brew reinstall gcc

   * **Windows:** Install both `Microsoft Visual C++ compiler <https://visualstudio.microsoft.com/vs/features/cplusplus/>`_ and Intel Fortran compiler (`Intel oneAPI <https://software.intel.com/content/www/us/en/develop/tools/oneapi/components/fortran-compiler.html>`_). Open the command prompt (where you will enter the installation commands in the next step) and load the Intel compiler variables by

     ::

         C:\Program Files (x86)\Intel\oneAPI\setvars.bat

     Here, we assumed the Intel Fortran compiler is installed in ``C:\Program Files (x86)\Intel\oneAPI``. You may set this directory accordingly to the directory of your Intel compiler.


2. Clone the source code and install this package by
   
   ::

       git clone https://github.com/ameli/special_functions.git
       cd special_functions
       python -m pip install .

**Warning:** After the package is built and installed from the source code, the package cannot be imported properly if the current working directory is the same as the source code directory. To properly import the package, change the current working directory to a directory anywhere else **outside** of the source code directory. For instance:
    
.. code-block:: python
   
   cd ..
   python
   >>> import special_functions

====
Test
====

|codecov-devel|

To test package, install ``tox``:

::

    python -m pip install tox

and test the package with

::

    tox

=================
List of Functions
=================

----------
Python API
----------

========================  =========  ===================================================================================================================
Syntax                    Symbol     User guide
========================  =========  ===================================================================================================================
``besselj(nu, z, n)``     |image06|  `Bessel function of the first kind <https://ameli.github.io/special_functions/api/besselj.html>`_
``bessely(nu, z, n)``     |image07|  `Bessel function of the second kind <https://ameli.github.io/special_functions/api/bessely.html>`_ (Weber function)
``besseli(nu, z, n)``     |image08|  `Modified Bessel function of the first kind <https://ameli.github.io/special_functions/api/besseli.html>`_
``besselk(nu, z, n)``     |image09|  `Modified Bessel function of the second kind <https://ameli.github.io/special_functions/api/besselk.html>`_
``besselh(nu, k, z, n)``  |image10|  `Bessel function of the third kind <https://ameli.github.io/special_functions/api/besselh.html>`_ (Hankel function)
``lngamma(x)``            |image11|  `Natural logarithm of Gamma function <https://ameli.github.io/special_functions/api/lngamma.html>`_
========================  =========  ===================================================================================================================

**Typed Arguments:**

========  ==============================  =========  ==============================================================
Argument   Type                           Symbol     Description
========  ==============================  =========  ==============================================================
``nu``    ``double``                      |image01|  Parameter of Bessel functions.
``k``     ``int``                         |image02|  Can be ``1`` or ``2`` and sets the type of Hankel function.
``z``     ``double``, ``double complex``  |image03|  Real or complex argument of the Bessel functions.
``x``     ``double``                      |image04|  Real argument of the functions.
``n``     ``int``                         |image05|  Order of derivative of function. Zero indicates no derivative.
========  ==============================  =========  ==============================================================

----------
Cython API
----------

In Cython interface, the syntax of the **real** functions are similar to the Python interface. However, the syntax of **complex** functions start with the letter ``c`` in the beginning of each function as shown in the table below.

=========  ========================  =========================
Symbol     Real Function             Complex Function          
=========  ========================  =========================
|image06|  ``besselj(nu, x, n)``     ``cbesselj(nu, z, n)``    
|image07|  ``bessely(nu, x, n)``     ``cbessely(nu, z, n)``    
|image08|  ``besseli(nu, x, n)``     ``cbesseli(nu, z, n)``    
|image09|  ``besselk(nu, x, n)``     ``cbesselk(nu, z, n)``    
|image10|  ``besselh(nu, k, x, n)``  ``cbesselh(nu, k, z, n)`` 
|image11|  ``lngamma(x)``            N/A
=========  ========================  =========================

.. |image01| image:: https://raw.githubusercontent.com/ameli/special_functions/main/docs/source/_static/images/formulas/image01.svg
.. |image02| image:: https://raw.githubusercontent.com/ameli/special_functions/main/docs/source/_static/images/formulas/image02.svg
.. |image03| image:: https://raw.githubusercontent.com/ameli/special_functions/main/docs/source/_static/images/formulas/image03.svg
.. |image04| image:: https://raw.githubusercontent.com/ameli/special_functions/main/docs/source/_static/images/formulas/image04.svg
.. |image05| image:: https://raw.githubusercontent.com/ameli/special_functions/main/docs/source/_static/images/formulas/image05.svg
.. |image06| image:: https://raw.githubusercontent.com/ameli/special_functions/main/docs/source/_static/images/formulas/image06.svg
.. |image07| image:: https://raw.githubusercontent.com/ameli/special_functions/main/docs/source/_static/images/formulas/image07.svg
.. |image08| image:: https://raw.githubusercontent.com/ameli/special_functions/main/docs/source/_static/images/formulas/image08.svg
.. |image09| image:: https://raw.githubusercontent.com/ameli/special_functions/main/docs/source/_static/images/formulas/image09.svg
.. |image10| image:: https://raw.githubusercontent.com/ameli/special_functions/main/docs/source/_static/images/formulas/image10.svg
.. |image11| image:: https://raw.githubusercontent.com/ameli/special_functions/main/docs/source/_static/images/formulas/image11.svg

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

This example shows the real function ``besselk`` to compute the modified Bessel function of the second kind for a real argument ``z``. The output variables ``d0k``, ``d1k``, and ``d2k`` represent the values of modified Bessel function and its first and second derivatives, respectively.

.. code-block:: python

    >>> # cimport module in a *.pyx file
    >>> from special_functions cimport besselk

    >>> # Declare typed variables
    >>> cdef double nu = 2.5
    >>> cdef double z = 2.0
    >>> cdef double d0k, d1k, d2k

    >>> # Releasing gil to secure maximum cythonic speedup
    >>> with nogil:
    ...     d0k = besselk(nu, z, 0)    # no derivative
    ...     d1k = besselk(nu, z, 1)    # 1st derivative
    ...     d2k = besselk(nu, z, 2)    # 2nd derivative

~~~~~~~~~~~~~~~~
Complex Function
~~~~~~~~~~~~~~~~

The example below is similar to the above, except, the *complex* function ``cbesselk`` with complex argument ``z`` is used. The output variables ``d0k``, ``d1k``, and ``d2k`` are also complex.

.. code-block:: python

    >>> # cimport module in a *.pyx file
    >>> from special_functions cimport cbesselk

    >>> # Declare typed variables
    >>> cdef double nu = 2.5
    >>> cdef double complex z = 2.0 + 1.0j
    >>> cdef double complex d0k, d1k, d2k

    >>> # Releasing gil to secure maximum cythonic speedup
    >>> with nogil:
    ...     d0k = cbesselk(nu, z, 0)    # no derivative
    ...     d1k = cbesselk(nu, z, 1)    # 1st derivative
    ...     d2k = cbesselk(nu, z, 2)    # 2nd derivative

--------------------
Using in Python Code
--------------------

The codes below should be used in a ``.py`` file and no compilation is required. The python's global lock interpreter, or ``gil``, cannot be released.

~~~~~~~~~~~~~
Real Function
~~~~~~~~~~~~~

The example below uses the function ``besselk`` with the real argument ``z`` to compute the modified Bessel function of the second kind and its first and second derivatives.

.. code-block:: python

    >>> # import module in a *.py file
    >>> from special_functions import besselk

    >>> nu = 2.5
    >>> z = 2.0

    >>> d0k = besselk(nu, z)       # no derivative
    >>> d1k = besselk(nu, z, 1)    # 1st derivative
    >>> d2k = besselk(nu, z, 2)    # 2nd derivative

~~~~~~~~~~~~~~~~
Complex Function
~~~~~~~~~~~~~~~~

To use a complex input argument ``z`` in the Python interface, the same function ``besselk`` as the previous example can be used. This is unlike the Cython interface in which ``cbesselk`` should be used.

.. code-block:: python

    >>> # import module in a *.py file
    >>> from special_functions import besselk

    >>> nu = 2.5
    >>> z = 2.0 + 1.0j

    >>> d0k = besselk(nu, z)       # no derivative
    >>> d1k = besselk(nu, z, 1)    # 1st derivative
    >>> d2k = besselk(nu, z, 2)    # 2nd derivative

================
Related Packages
================

* `scipy.special <https://docs.scipy.org/doc/scipy/reference/special.html>`_: Many special functions were implemented in Scipy's special sub-package. This package is reimplements Bessel functions similar to ``scipy.special``, but with simplified python and cython different interfaces.
* `G-Learn <https://github.com/ameli/glearn>`_: A python package for machine learning using Gaussian process regression. This package makes use of ``special_functions``.

================
Acknowledgements
================

* National Science Foundation #1520825
* American Heart Association #18EIA33900046

========
Citation
========

* Ameli, S. (2022). ameli/special_functions: (v0.1.0). Zenodo. |code-doi|

======
Credit
======

This package uses the following libraries:

* Amos, D. E. (1986). Algorithm 644: A portable package for Bessel functions of a complex argument and nonnegative order. ACM Trans. Math. Softw. 12, 3 (Sept. 1986), 265-273. DOI: `https://doi.org/10.1145/7921.214331 <https://doi.org/10.1145/7921.214331>`_. Available at `http://netlib.org/amos/ <http://netlib.org/amos/>`_.
* Moshier, S. L. (1989). C language library with special functions for mathematical physics. Available at `http://www.netlib.org/cephes/index.html <http://www.netlib.org/cephes>`_.


.. |codecov-devel| image:: https://img.shields.io/codecov/c/github/ameli/special_functions
   :target: https://codecov.io/gh/ameli/special_functions
.. |docs| image:: https://github.com/ameli/special_functions/workflows/docs/badge.svg
   :target: https://ameli.github.io/special_functions/index.html
.. |licence| image:: https://img.shields.io/github/license/ameli/special_functions
   :target: https://opensource.org/licenses/BSD-3-Clause
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
   :target: https://pypi.org/project/special-functions/
.. |conda| image:: https://anaconda.org/s-ameli/special_functions/badges/installer/conda.svg
   :target: https://anaconda.org/s-ameli/special_functions
.. |platforms| image:: https://img.shields.io/conda/pn/s-ameli/special_functions?color=orange?label=platforms
   :target: https://anaconda.org/s-ameli/special_functions
.. |conda-version| image:: https://img.shields.io/conda/v/s-ameli/special_functions
   :target: https://anaconda.org/s-ameli/special_functions
.. |conda-platform| image:: https://anaconda.org/s-ameli/special_functions/badges/platforms.svg
   :target: https://anaconda.org/s-ameli/special_functions
.. |release| image:: https://img.shields.io/github/v/tag/ameli/special_functions
   :target: https://github.com/ameli/special_functions/releases/
.. |binder| image:: https://mybinder.org/badge_logo.svg
   :target: https://mybinder.org/v2/gh/ameli/special_functions/HEAD?filepath=notebooks%2Fspecial_functions.ipynb
.. |downloads| image:: https://pepy.tech/badge/special-functions
   :target: https://pepy.tech/project/special_functions
.. |code-doi| image:: https://zenodo.org/badge/DOI/10.5281/zenodo.6395374.svg
   :target: https://doi.org/10.5281/zenodo.6395374
