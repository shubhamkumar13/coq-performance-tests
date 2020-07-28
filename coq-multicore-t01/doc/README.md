The Coq documentation
=====================

The Coq documentation includes

- A Reference Manual
- A document presenting the Coq standard library

The documentation of the latest released version is available on the Coq
web site at [coq.inria.fr/documentation](http://coq.inria.fr/documentation).

Additionally, you can view the reference manual for the development version
at <https://coq.github.io/doc/master/refman/>, and the documentation of the
standard library for the development version at
<https://coq.github.io/doc/master/stdlib/>.

The reference manual is written is reStructuredText and compiled
using Sphinx. See [`sphinx/README.rst`](sphinx/README.rst)
to learn more about the format that is used.

The documentation for the standard library is generated from
the `.v` source files using coqdoc.

Dependencies
------------

### HTML documentation

To produce the complete documentation in HTML, you will need Coq dependencies
listed in [`INSTALL.md`](../INSTALL.md). Additionally, the Sphinx-based
reference manual requires Python 3, and the following Python packages
(note the version constraints on Sphinx):

  - sphinx >= 2.3.1 & < 3.0.0
  - sphinx_rtd_theme >= 0.4.3
  - beautifulsoup4 >= 4.0.6
  - antlr4-python3-runtime >= 4.7.1
  - pexpect >= 4.2.1
  - sphinxcontrib-bibtex >= 0.4.2

To install them, you should first install pip and setuptools (for instance,
with `apt install python3-pip python3-setuptools` on Debian / Ubuntu) then run:

    pip3 install sphinx==2.3.1 sphinx_rtd_theme beautifulsoup4 \
                 antlr4-python3-runtime==4.7.1 pexpect sphinxcontrib-bibtex

Nix users should get the correct development environment to build the
HTML documentation from Coq's [`default.nix`](../default.nix) (note this
doesn't include the LaTeX packages needed to build the full documentation).

### Other formats

To produce the documentation in PDF and PostScript formats, the following
additional tools are required:

  - latex (latex2e)
  - pdflatex
  - dvips
  - makeindex
  - xelatex
  - latexmk

All of them are part of the TexLive distribution. E.g. on Debian / Ubuntu,
install them with:

    apt install texlive-full

Or if you want to use less disk space:

    apt install texlive-latex-extra texlive-fonts-recommended texlive-xetex \
                latexmk fonts-freefont-otf

Compilation
-----------

To produce all documentation about Coq in all formats, just run:

    ./configure           # (if you hadn't already)
    make doc


Alternatively, you can use some specific targets:

- `make doc-ps`
  to produce all PostScript documents

- `make doc-pdf`
  to produce all PDF documents

- `make doc-html`
  to produce all HTML documents

- `make refman`
  to produce the HTML and PDF versions of the reference manual

- `make refman-{html,pdf}`
  to produce only one format of the reference manual

- `make doc-stdlib`
  to produce all formats of the Coq standard library


Also note the `-with-doc yes` option of `./configure` to enable the
build of the documentation as part of the default make target.

To build the Sphinx documentation without stopping at the first
warning with the legacy Makefile, set `SPHINXWARNERROR` to 0 as such:

```
SPHINXWARNERROR=0 make refman-html
```

To do the same with the Dune build system, change the value of the
`SPHINXWARNOPT` variable (default is `-W`). The following will build
the Sphinx documentation without stopping at the first warning, and
store all the warnings in the file `/tmp/warn.log`:

```
SPHINXWARNOPT="-w/tmp/warn.log" dune build @refman-html
```

Installation
------------

To install all produced documents, do:

    make install-doc

This will install the documentation in `/usr/share/doc/coq` unless you
specify another value through the `-docdir` option of `./configure` or the
`DOCDIR` environment variable.
