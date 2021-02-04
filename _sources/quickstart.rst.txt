***********
Quick Start
***********

=================
List of Functions
=================

----------------
Python Interface
----------------

========================  ==============================  =========  =============================================================================
Syntax                    Return type                     Symbol     Description
========================  ==============================  =========  =============================================================================
``besselj(nu, z, n)``     ``double``, ``double complex``  |image06|  :ref:`Bessel function of the first kind<besselj>`
``bessely(nu, z, n)``     ``double``, ``double complex``  |image07|  :ref:`Bessel function of the second kind of order <bessely>` (Weber function)
``besseli(nu, z, n)``     ``double``, ``double complex``  |image08|  :ref:`Modified Bessel function of the first kind <besseli>`
``besselk(nu, z, n)``     ``double``, ``double complex``  |image09|  :ref:`Modified Bessel function of the second kind <besselk>`
``besselh(nu, k, z, n)``  ``double complex``              |image10|  :ref:`Bessel function of the third kind<besselh>` (Hankel function)
``loggamma(x)``           ``double``                      |image11|  :ref:`Natural logarithm of Gamma function <loggamma>`
========================  ==============================  =========  =============================================================================

**Function Arguments:**

========  ==============================  =========  ==============================================================
Argument   Type                           Symbol     Description
========  ==============================  =========  ==============================================================
``nu``    ``double``                      |image01|  Parameter of Bessel functions.
``k``     ``int``                         |image02|  Can be ``1`` or ``2`` and sets the type of Hankel function.
``z``     ``double``, ``double complex``  |image03|  Real or complex argument of the Bessel functions.
``x``     ``double``                      |image04|  Real argument of the functions.
``n``     ``int``                         |image05|  Order of derivative of function. Zero indicates no derivative.
========  ==============================  =========  ==============================================================

.. |image01| replace:: :math:`\nu`
.. |image02| replace:: :math:`k`
.. |image03| replace:: :math:`z`
.. |image04| replace:: :math:`x`
.. |image05| replace:: :math:`n`
.. |image06| replace:: :math:`\partial^n J_{\nu}(z) / \partial z^n`
.. |image07| replace:: :math:`\partial^n Y_{\nu}(z) / \partial z^n`
.. |image08| replace:: :math:`\partial^n I_{\nu}(z) / \partial z^n`
.. |image09| replace:: :math:`\partial^n K_{\nu}(z) / \partial z^n`
.. |image10| replace:: :math:`\partial^n H^{(k)}_{\nu}(z) / \partial z^n`
.. |image11| replace:: :math:`\log \Gamma(x)`


----------------
Cython Interface
----------------

In Cython interface, the syntax of the **real** functions are similar to the Python interface. However, the syntax of **complex** functions start with the letter ``c`` in the beginign of each function as shown in the table below.

=========  ========================  =========================
Symbol     Real Function             Complex Function          
=========  ========================  =========================
|image06|  ``besselj(nu, x, n)``     ``cbesselj(nu, z, n)``    
|image07|  ``bessely(nu, x, n)``     ``cbessely(nu, z, n)``    
|image08|  ``besseli(nu, x, n)``     ``cbesseli(nu, z, n)``    
|image09|  ``besselk(nu, x, n)``     ``cbesselk(nu, z, n)``    
|image10|  ``besselh(nu, k, x, n)``  ``cbesselh(nu, k, z, n)`` 
|image11|  ``loggamma(x)``           N/A
=========  ========================  =========================

In the above table:

* ``x`` is of type ``double``. Real functions return ``double``, with the exception of the function ``besselh`` that always returns ``double complex``.
* ``z`` is of type ``double complex``. Complex functions return ``double complex``.
