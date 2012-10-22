ecore2doc
=========

Tool for creating documentation (e.g. xdoc format) from ecore and genmodel files


This tool reads a genmodel file and its ecore and extracts documentation from those.
It converts this information into some markup format. The tool and its backend might
be configured by some injected classes. Currently only xdoc format is supported as
a backend.

The package org.nanosite.ecore2xdoc.franca contains the configuration for generating
the Franca API documentation chapter from the Franca User Guide. The org.franca.core
plugin has to be available to do this.
