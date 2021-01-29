*******
Install
*******

============
Dependencies
============

* **At runtime:** This package does not need any python dependencies at runtime.
* **For tests:** To run tests, ``scipy`` package is required, and can be installed by

  ::

      python -m pip install -r tests/requirements.txt

.. _InstallationMethods:

===============
Install Package
===============

The package can be installed on Linux, macOS, and Windows platforms and supports both python 2 and 3. Install by either of the following ways, namely, through :ref:`PyPi <Install_PyPi>`, :ref:`Conda <Install_Conda>`, or :ref:`build locally <Build_Locally>`.

.. _Install_PyPi:

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

------------------------
Install from Source Code
------------------------

|release|

Clone the source code and install by
   
::
       
    git clone https://github.com/ameli/special_functions.git
    cd special_functions
    python -m pip install .

.. note::

    To properly import the package, change the current working direcrtory to a directory *outside* of the source code.


==============================
Install in Virtual Environment
==============================

If you do not want the installation to occupy your main python's site-packages, you may install the package in an isolated virtual environment. Below describes the installation procedure in two common virtual environments, namely, :ref:`virtualenv <virtualenv_env>` and :ref:`conda <conda_env>`.

.. _virtualenv_env:

-------------------------------------
Install in ``virtualenv`` Environment
-------------------------------------

1. Install ``virtualenv``:

   ::

       python -m pip install virtualenv

2. Create a virtual environment and give it a name, such as ``special_functions_env``

   ::

       python -m virtualenv special_functions_env

3. Activate python in the new environment

   ::

       source special_functions_env/bin/activate

4. Install ``special_functions`` package with any of the :ref:`above methods <InstallationMethods>`. For instance:

   ::

       python -m pip install special_functions
   
   Then, use the package in this environment.

5. To exit from the environment

   ::

       deactivate

.. _conda_env:

--------------------------------
Install in ``conda`` Environment
--------------------------------

In the followings, it is assumed `anaconda <https://www.anaconda.com/products/individual#Downloads>`_ (or `miniconda <https://docs.conda.io/en/latest/miniconda.html>`_) is installed.

1. Initialize conda

   ::

       conda init

   You may need to close and reopen terminal after the above command. Alternatively, instead of the above, you can do

   ::

       sudo sh $(conda info --root)/etc/profile.d/conda.sh

2. Create a virtual environment and give it a name, such as ``special_functions_env``

   ::

       conda create --name special_functions_env -y

   The command ``conda info --envs`` shows the list of all environments. The current environment is marked by an asterisk in the list, which should be the default environment at this stage. In the next step, we will change the current environment to the one we created.

3. Activate the new environment

   ::

       source activate special_functions_env

4. Install ``special_functions`` with any of the :ref:`above methods <InstallationMethods>`. For instance:

   ::

       conda install -c s-ameli special_functions
   
   Then, use the package in this environment.

5. To exit from the environment

   ::

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
