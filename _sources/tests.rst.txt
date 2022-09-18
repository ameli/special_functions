.. _Run_Tests:

*************
Running Tests
*************

|codecov-devel|

The package can be tested by running the `test scripts <https://github.com/ameli/special_functions/tree/main/tests>`_, which tests all `modules <https://github.com/ameli/special_functions/tree/main/special_functions>`_. 

=============================
Running Tests with ``pytest``
=============================

1. Install ``pytest-cov``:

   .. prompt:: bash

       python -m pip install pytest-cov

2. Install this package by either of the methods described in the :ref:`installation instructions <Install_Package>`.

2. Clone the package source code and install the test dependencies:

   .. prompt:: bash

       git clone https://github.com/ameli/special_functions.git
       cd special_functions
       python -m pip install -r tests/requirements.txt

3. Test the package by:

   .. prompt:: bash

       cd tests
       pytest

   .. warning::

       Do not run tests in the root directory of the package ``/special_functions``. To properly run tests, change current working directory to ``/special_functions/tests`` sub-directory.

==========================
Running Tests with ``tox``
==========================

To run a test in a virtual environment, use ``tox`` as follows:

1. Clone the source code from the repository:
   
   .. prompt:: bash
       
       git clone https://github.com/ameli/special_functions.git

2. Install ``tox``:
   
   .. prompt:: bash
       
       python -m pip install tox

3. Run tests by
   
   .. prompt:: bash
       
       cd special_functions
       tox
  
.. |codecov-devel| image:: https://img.shields.io/codecov/c/github/ameli/special_functions
   :target: https://codecov.io/gh/ameli/special_functions
.. |build-linux| image:: https://github.com/ameli/special_functions/workflows/build-linux/badge.svg
   :target: https://github.com/ameli/special_functions/actions?query=workflow%3Abuild-linux 
.. |build-macos| image:: https://github.com/ameli/special_functions/workflows/build-macos/badge.svg
   :target: https://github.com/ameli/special_functions/actions?query=workflow%3Abuild-macos
.. |build-windows| image:: https://github.com/ameli/special_functions/workflows/build-windows/badge.svg
   :target: https://github.com/ameli/special_functions/actions?query=workflow%3Abuild-windows
