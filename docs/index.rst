*****************
special_functions
*****************

|travis-devel| |codecov-devel| |docs| |licence| |platforms| |conda-version| |conda| |format| |pypi| |implementation| |pyversions|

This python package can perform the following matrix operations:

#. Compute the *log-determinant* of dense or sparse matrices.
#. Compute the *trace of the inverse* of dense or sparse matrices.
#. Interpolate the trace of the inverse of *one-parameter affine matrix functions*.

These matrix operations frequently appear in many applications in computational physics, computational biology, data analysis, and machine learning. A few examples are regularization in inverse problems, model-selection in machine learning, and more broadly, in parameter optimization of statistical models.

A common difficulty in such application is that the matrices are generally large and inverting them is impractical. Because of this, evaluation of their trace or log-determinant is a computational challenge. Many algorithms have been developed to address such computational challenge, such as efficient sparse matrix factorizations and randomized estimators. This package aims to implement some of these methods.

.. toctree::
    :maxdepth: 1
    :caption: Documentation

    Install <install>
    Quick Start <quickstart>

.. toctree::
    :maxdepth: 1
    :caption: Functions User Guide

    Bessel Function, First Kind <besselj>
    Bessel Function, Second Kind <bessely>
    Bessel Function, Third Kind <besselh>
    Modified Bessel Function, First Kind <besseli>
    Modified Bessel Function, Second Kind <besselk>
    Log Gamma Function <loggamma>


.. toctree::
    :maxdepth: 1
    :caption: Development
              
    Package API <_modules/modules>
    Running Tests <tests>
    Change Log <changelog>

.. =======
.. Modules
.. =======
..
.. .. autosummary::
..    :toctree: _autosummary
..    :recursive:
..    :nosignatures:
..
..    special_functions.ComputeTraceOfInverse
..    special_functions.InterpolateTraceOfInverse
..    special_functions.GenerateMatrix

*****************
List of Functions
*****************

**Bessel Functions** of order |image01|, real or complex argument |image02|, or their |image03| derivative.

========================  ==============================  =========  =============================================================================
Syntax                    Return type                     Symbol     Description
========================  ==============================  =========  =============================================================================
``besselj(nu, z, n)``     ``double``, ``double complex``  |image04|  :ref:`Bessel function of the first kind of order <besselj>`
``bessely(nu, z, n)``     ``double``, ``double complex``  |image05|  :ref:`Bessel function of the second kind of order <bessely>` (Weber function)
``besseli(nu, z, n)``     ``double``, ``double complex``  |image06|  :ref:`Modified Bessel function of the first kind <besseli>`
``besselk(nu, z, n)``     ``double``, ``double complex``  |image07|  :ref:`Modified Bessel function of the second kind <besselk>`
``besselh(nu, k, z, n)``  ``double``, ``double complex``  |image08|  :ref:`Bessel function of the third kind of order <besselh>` (Hankel function)
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

=========
Tutorials
=========

|binder|

A tutorial and demonstration of examples can be found with 

============
Useful Links
============

For users:
    + `Package on Anaconda Cloud <https://anaconda.org/s-ameli/special_functions>`_
    + `Package on PyPi <https://pypi.org/project/special_functions/>`_
    + `Source code on Github <https://github.com/ameli/special_functions>`_
    + `online interactive Jupyter notebook <https://mybinder.org/v2/gh/ameli/special_functions/HEAD?filepath=notebooks%2FInterpolateTraceOfInverse.ipynb>`_.

For developers:
    + `Test Coverage on Codecov <https://codecov.io/gh/ameli/special_functions>`_
    + `API <https://ameli.github.io/special_functions/_modules/modules.html>`_

=================
How to Contribute
=================

We welcome contributions via `Github's pull request <https://github.com/ameli/special_functions/pulls>`_. If you do not feel comfortable modifying the code, we also welcome feature request and bug report as `Github issues <https://github.com/ameli/special_functions/issues>`_.

================
Related Projects
================

* `scipy.special <https://docs.scipy.org/doc/scipy/reference/special.html>`_: Many special functions were implemented in Scipy's special sub-package. This package is reimplements Bessel functions similar to ``scipy.special``, but with simplified python and cython different interfaces.
* `Gaussian Process <https://github.com/ameli/gaussian-process-param-estimation>`_: A python package that makes use of ``special_functions``.


================
Acknowledgements
================

* National Science Foundation #1520825
* American Heart Association #18EIA33900046

======
Credit
======

This package uses the following libraries:

.. [Cephes-1989] Moshier, S. L. (1989). C language library with special functions for mathematical physics. Available at `http://www.netlib.org/cephes/index.html <http://www.netlib.org/cephes/index.html>`_.

.. [Amos-1986] Amos, D. E. (1986). Algorithm 644: A portable package for Bessel functions of a complex argument and nonnegative order. ACM Trans. Math. Softw. 12, 3 (Sept. 1986), 265-273. DOI: `https://doi.org/10.1145/7921.214331 <https://doi.org/10.1145/7921.214331>`_. Available at `http://netlib.org/amos/ <http://netlib.org/amos/>`_.

==================
Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`


.. |codecov-devel| image:: https://img.shields.io/codecov/c/github/ameli/special_functions
   :target: https://codecov.io/gh/ameli/special_functions
.. |docs| image:: https://github.com/ameli/special_functions/workflows/deploy-docs/badge.svg
   :target: https://github.com/ameli/special_functions/actions?query=workflow%3Adeploy-docs
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
.. |conda| image:: https://anaconda.org/s-ameli/special_functions/badges/installer/conda.svg
   :target: https://anaconda.org/s-ameli/special_functions
.. |platforms| image:: https://img.shields.io/conda/pn/s-ameli/special_functions?color=orange?label=platforms
   :target: https://anaconda.org/s-ameli/special_functions
.. |conda-version| image:: https://img.shields.io/conda/v/s-ameli/special_functions
   :target: https://anaconda.org/s-ameli/special_functions
.. |binder| image:: https://mybinder.org/badge_logo.svg
   :target: https://mybinder.org/v2/gh/ameli/special_functions/HEAD?filepath=notebooks%2FInterpolateTraceOfInverse.ipynb
