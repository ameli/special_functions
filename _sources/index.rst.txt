*****************
special_functions
*****************

|licence| |platforms| |conda-version| |conda| |format| |pypi| |implementation| |pyversions|

This package provides both Python and Cython interfaces for Bessel functions and a few other special functions. 

========
Features
========

* **Lightweight:** This package requires *no python dependency* at runtime.
* **Cythonic interface:** Both pythonic and cythonic interfaces are provided.
* **Releasing GIL:** Most importantly, the functions can be used in ``with nogil:`` environment, which is essential in parallel OpenMP using Cython.

=========================
Interactive Live Tutorial
=========================

|binder|

Launch a live tutorial in browser with `Jupyter notebook <https://mybinder.org/v2/gh/ameli/special_functions/HEAD?filepath=notebooks%2FSpecial%20Functions.ipynb>`_ to interact with the modules of the package.

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
..    special_functions

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
   :target: https://mybinder.org/v2/gh/ameli/special_functions/HEAD?filepath=notebooks%2FSpecial%20Functions.ipynb
