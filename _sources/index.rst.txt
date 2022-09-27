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

.. toctree::
    :maxdepth: 1
    :caption: Documentation

    Install <install>
    List of Functions <api/list>
    Jupyter Notebook <notebooks/special_functions.ipynb>

.. toctree::
    :maxdepth: 1
    :caption: Functions User Guide

    Bessel Function, First Kind <api/besselj>
    Bessel Function, Second Kind <api/bessely>
    Bessel Function, Third Kind <api/besselh>
    Modified Bessel Function, First Kind <api/besseli>
    Modified Bessel Function, Second Kind <api/besselk>
    Log Gamma Function <api/lngamma>


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

=====
Links
=====

* `Package on Anaconda Cloud <https://anaconda.org/s-ameli/special_functions>`_
* `Package on PyPI <https://pypi.org/project/special_functions/>`_
* `Source code on Github <https://github.com/ameli/special_functions>`_
.. * `Interactive Jupyter notebook <https://mybinder.org/v2/gh/ameli/special_functions/HEAD?filepath=notebooks%2FSpecial%20Functions.ipynb>`_.
.. * `API <https://ameli.github.io/special_functions/_modules/modules.html>`_

=================
How to Contribute
=================

We welcome contributions via `Github's pull request <https://github.com/ameli/special_functions/pulls>`_. If you do not feel comfortable modifying the code, we also welcome feature request and bug report as `Github issues <https://github.com/ameli/special_functions/issues>`_.

================
Related Packages
================

* `scipy.special <https://docs.scipy.org/doc/scipy/reference/special.html>`_: Many special functions are available in *scipy.special* package.
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

.. [Amos-1986] Amos, D. E. (1986). Algorithm 644: A portable package for Bessel functions of a complex argument and nonnegative order. ACM Trans. Math. Softw. 12, 3 (Sept. 1986), 265-273. DOI: `https://doi.org/10.1145/7921.214331 <https://doi.org/10.1145/7921.214331>`_. Available at `http://netlib.org/amos/ <http://netlib.org/amos/>`_.
.. [Cephes-1989] Moshier, S. L. (1989). C language library with special functions for mathematical physics. Available at `http://www.netlib.org/cephes <http://www.netlib.org/cephes>`_.

==================
Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`

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
.. |binder| image:: https://mybinder.org/badge_logo.svg
   :target: https://mybinder.org/v2/gh/ameli/special_functions/HEAD?filepath=notebooks%2Fspecial_functions.ipynb
.. |downloads| image:: https://pepy.tech/badge/special-functions
   :target: https://pepy.tech/project/special_functions
.. |code-doi| image:: https://zenodo.org/badge/DOI/10.5281/zenodo.6395374.svg
   :target: https://doi.org/10.5281/zenodo.6395374
