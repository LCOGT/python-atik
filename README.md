python-atik
===========

This project [SWIG](http://www.swig.org) wraps the vendor supplied SDK for the ATIK camera (see [cloudmakers](http://cloudmakers.eu)).

Requirements
------------

* swig (v2.0.12)
* atikccdsdk (v0.41)


Install
-------

To install type:

   > python setup.py install


Usage
-----

To take a 5s exposure:-

```
import atik
import time

camera = atik.get_camera(0)
camera.open()

# Get dimensions
capabilities = camera.get_capabilities()
width, height = capabilities[7:9]

# Perform a manual timed exposure
camera.start_exposure(False)

time.sleep(5)

camera.read_ccd(0, 0, width, height, 1, 1)
success, data = camera.get_image(width, height)
```
