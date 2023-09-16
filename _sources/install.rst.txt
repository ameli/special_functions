.. _Install_Package:

*******
Install
*******

===================
Supported Platforms
===================

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

.. note::

    * For the Python/PyPy versions indicated by |y| in the above, this package can be installed using either ``pip`` or ``conda`` (see :ref:`installation instructions <InstallationMethods>` below.)
    * This package cannot be installed via ``pip`` or ``conda`` on the Python/PyPy versions indicated by |n| in the above table.
    * To install on the older Python 3 versions that are not listed in the above (for example Python 3.5), you should *build* this package from the source code (see :ref:`build instructions <Build_Locally>`).


============
Dependencies
============

* **At runtime:** This package does not have any dependencies at runtime.
* **For tests:** To :ref:`run tests <Run_Tests>`, ``scipy`` package is required and can be installed by

  .. prompt:: bash

      python -m pip install -r tests/requirements.txt

.. _InstallationMethods:

===============
Install Package
===============

Install by either through :ref:`PyPi <Install_PyPi>`, :ref:`Conda <Install_Conda>`, or :ref:`build locally <Build_Locally>`.

.. _Install_PyPi:

-----------------
Install from PyPi
-----------------

|pypi| |format| |implementation| |pyversions|

The recommended installation method is through the package available at `PyPi <https://pypi.org/project/special_functions>`_ using ``pip``.

1. Ensure ``pip`` is installed within Python and upgrade the existing ``pip`` by

   .. prompt:: bash

       python -m ensurepip
       python -m pip install --upgrade pip

   If you are using PyPy instead of Python, ensure ``pip`` is installed and upgrade the existing ``pip`` by

   .. prompt:: bash

       pypy -m ensurepip
       pypy -m pip install --upgrade pip

2. Install this package in Python by
   
   .. prompt:: bash
       
       python -m pip install special_functions

   or, in PyPy by

   .. prompt:: bash
       
       pypy -m pip install special_functions

.. _Install_Conda:

---------------------------
Install from Anaconda Cloud
---------------------------

|conda-version| |conda-platform|

Alternatively, the package can be installed through `Anaconda could <https://anaconda.org/s-ameli/special_functions>`_.

* In **Linux** and **Windows**:
  
  .. prompt:: bash
      
      conda install -c s-ameli special_functions

* In **macOS**:
  
  .. prompt:: bash
      
      conda install -c s-ameli -c conda-forge special_functions

.. _Build_Locally:

----------------------------------
Build and Install from Source Code
----------------------------------

|release|

**Build dependencies:** To build the package from the source code, ``numpy`` and ``cython`` are required. These dependencies are installed automatically during the build process and no action is needed.

1. Install both C and Fortran compilers as follows.

   * **Linux:** Install ``gcc``, for instance, by ``apt`` (or any other package manager on your Linux distro)

     .. prompt:: bash

         sudo apt install gcc gfortran

   * **macOS:** Install ``gcc`` via Homebrew:

     .. prompt:: bash

         sudo brew install gcc

     .. note::
         
         If ``gcc`` is already installed, but Fortran compiler is yet not available on macOS, you may resolve this issue by reinstalling:
         
         .. prompt:: bash

             sudo brew reinstall gcc

   * **Windows:** Install both `Microsoft Visual C++ compiler <https://visualstudio.microsoft.com/vs/features/cplusplus/>`_ and Intel Fortran compiler (`Intel oneAPI <https://software.intel.com/content/www/us/en/develop/tools/oneapi/components/fortran-compiler.html>`_). Open the command prompt (where you will enter the installation commands in the next step) and load the Intel compiler variables by

     .. prompt:: powershell

         C:\Program Files (x86)\Intel\oneAPI\setvars.bat

     Here, we assumed the Intel Fortran compiler is installed in ``C:\Program Files (x86)\Intel\oneAPI``. You may set this directory accordingly to the directory of your Intel compiler.


2. Clone the source code and install this package by
   
   .. prompt:: bash

       git clone https://github.com/ameli/special_functions.git
       cd special_functions
       python -m pip install .

.. warning::

    After the package is built and installed from the source code, the package cannot be imported properly if the current working directory is the same as the source code directory.
    To properly import the package, change the current working directory to a directory anywhere else **outside** of the source code directory. For instance:

    .. prompt:: bash

        cd ..
        python -c "import special_functions"


==============================
Install in Virtual Environment
==============================

If you do not want the installation to occupy your main python's site-packages, you may install the package in an isolated virtual environment. Below we describe the installation procedure in two common virtual environments, namely, :ref:`virtualenv <virtualenv_env>` and :ref:`conda <conda_env>`.

.. _virtualenv_env:

-------------------------------------
Install in ``virtualenv`` Environment
-------------------------------------

1. Install ``virtualenv``:

   .. prompt:: bash

       python -m pip install virtualenv

2. Create a virtual environment and give it a name, such as ``special_functions_env``

   .. prompt:: bash

       python -m virtualenv special_functions_env

3. Activate python in the new environment

   .. prompt:: bash

       source special_functions_env/bin/activate

4. Install ``special_functions`` package with any of the :ref:`above methods <InstallationMethods>`. For instance:

   .. prompt:: bash

       python -m pip install special_functions
   
   Then, use the package in this environment.

5. To exit from the environment

   .. prompt:: bash

       deactivate

.. _conda_env:

--------------------------------
Install in ``conda`` Environment
--------------------------------

In the following, it is assumed `anaconda <https://www.anaconda.com/products/individual#Downloads>`_ (or `miniconda <https://docs.conda.io/en/latest/miniconda.html>`_) is installed.

1. Initialize conda (if it was not initialized before)

   .. prompt:: bash

       conda init

   You may need to close and reopen the terminal after the above command. Alternatively, instead of the above, you can do

   .. prompt:: bash

       sudo sh $(conda info --root)/etc/profile.d/conda.sh

2. Create a virtual environment and give it a name, such as ``special_functions_env``

   .. prompt:: bash

       conda create --name special_functions_env -y

   The command ``conda info --envs`` shows the list of all environments. The current environment is marked by an asterisk in the list, which should be the default environment at this stage. In the next step, we will change the current environment to the one we created.

3. Activate the new environment

   .. prompt:: bash

       conda activate special_functions_env

4. Install ``special_functions`` with any of the :ref:`above methods <InstallationMethods>`. For instance:

   .. prompt:: bash

       conda install -c s-ameli special_functions
   
   Then, use the package in this environment.

5. To exit from the environment

   .. prompt:: bash

       conda deactivate

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
