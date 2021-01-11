*************
Running Tests
*************

The package can be tested by running the `test scripts <https://github.com/ameli/special_functions/tree/main/tests>`_, which tests all `sub-packages <https://github.com/ameli/special_functions/tree/main/special_functions>`_ and the `examples <https://github.com/ameli/special_functions/tree/main/examples>`_.

=====================
Running Tests Locally
=====================

To run a test locally, clone the source code from the repository and install the required test packages by

::

    git clone https://github.com/ameli/special_functions.git
    cd special_functions
    python -m pip install -e .[test]

Then, run a test with ``pytest``:

::

    pytest

To run a test coverage:

::

    pytest --cov=tests/
   
=========================
Automated Build and Tests
=========================

|travis-devel| |codecov-devel|

The latest status of *automated tests* can be checked on `travis <https://travis-ci.com/github/ameli/special_functions>`_ continuous integration tool, which tests the package in the following platforms:

==============  =======================  ===============
Platform        Python versions          Build status
==============  =======================  ===============
Linux (Ubuntu)  2.7, 3.5, 3.6, 3.7, 3.8  |build-linux|
macOS           2.7, 3.5, 3.6, 3.7, 3.8  |build-macos|
Windows         2.7, 3.5, 3.6, 3.7, 3.8  |build-windows|
==============  =======================  ===============

Moreover, the latest *coverage* of tests can be checked on `codecov <https://codecov.io/gh/ameli/special_functions>`_ dashboard.

.. |travis-devel| image:: https://img.shields.io/travis/com/ameli/special_functions
   :target: https://travis-ci.com/github/ameli/special_functions
.. |codecov-devel| image:: https://img.shields.io/codecov/c/github/ameli/special_functions
   :target: https://codecov.io/gh/ameli/special_functions
.. |build-linux| image:: https://github.com/ameli/special_functions/workflows/build-linux/badge.svg
   :target: https://github.com/ameli/special_functions/actions?query=workflow%3Abuild-linux 
.. |build-macos| image:: https://github.com/ameli/special_functions/workflows/build-macos/badge.svg
   :target: https://github.com/ameli/special_functions/actions?query=workflow%3Abuild-macos
.. |build-windows| image:: https://github.com/ameli/special_functions/workflows/build-windows/badge.svg
   :target: https://github.com/ameli/special_functions/actions?query=workflow%3Abuild-windows
