.. _thecoqcommands:

The |Coq| commands
====================

There are three |Coq| commands:

+ ``coqtop``: the |Coq| toplevel (interactive mode);
+ ``coqc``: the |Coq| compiler (batch compilation);
+ ``coqchk``: the |Coq| checker (validation of compiled libraries).


The options are (basically) the same for the first two commands, and
roughly described below. You can also look at the ``man`` pages of
``coqtop`` and ``coqc`` for more details.

.. _interactive-use:

Interactive use (coqtop)
------------------------

In the interactive mode, also known as the |Coq| toplevel, the user can
develop his theories and proofs step by step. The |Coq| toplevel is run
by the command ``coqtop``.

There are two different binary images of |Coq|: the byte-code one and the
native-code one (if OCaml provides a native-code compiler for
your platform, which is supposed in the following). By default,
``coqtop`` executes the native-code version; run ``coqtop.byte`` to get
the byte-code version.

The byte-code toplevel is based on an OCaml toplevel (to
allow dynamic linking of tactics). You can switch to the OCaml toplevel
with the command ``Drop.``, and come back to the |Coq|
toplevel with the command ``Coqloop.loop();;``.

.. flag:: Coqtop Exit On Error

   This flag, off by default, causes coqtop to exit with status code
   ``1`` if a command produces an error instead of recovering from it.

Batch compilation (coqc)
------------------------

The ``coqc`` command takes a name *file* as argument. Then it looks for a
vernacular file named *file*.v, and tries to compile it into a
*file*.vo file (See :ref:`compiled-files`).

.. caution::

   The name *file* should be a regular |Coq| identifier as defined in Section :ref:`lexical-conventions`.
   It should contain only letters, digits or underscores (_). For example ``/bar/foo/toto.v`` is valid,
   but ``/bar/foo/to-to.v`` is not.


Customization at launch time
---------------------------------

By resource file
~~~~~~~~~~~~~~~~~~~~~~~

When |Coq| is launched, with either ``coqtop`` or ``coqc``, the
resource file ``$XDG_CONFIG_HOME/coq/coqrc.xxx``, if it exists, will
be implicitly prepended to any document read by Coq, whether it is an
interactive session or a file to compile. Here, ``$XDG_CONFIG_HOME``
is the configuration directory of the user (by default it's ``~/.config``)
and ``xxx`` is the version number (e.g. 8.8). If
this file is not found, then the file ``$XDG_CONFIG_HOME/coqrc`` is
searched. If not found, it is the file ``~/.coqrc.xxx`` which is searched,
and, if still not found, the file ``~/.coqrc``. If the latter is also
absent, no resource file is loaded.
You can also specify an arbitrary name for the resource file
(see option ``-init-file`` below).

The resource file may contain, for instance, ``Add LoadPath`` commands to add
directories to the load path of |Coq|. It is possible to skip the
loading of the resource file with the option ``-q``.

.. _customization-by-environment-variables:

By environment variables
~~~~~~~~~~~~~~~~~~~~~~~~~

Load path can be specified to the |Coq| system by setting up ``$COQPATH``
environment variable. It is a list of directories separated by
``:`` (``;`` on Windows). |Coq| will also honor ``$XDG_DATA_HOME`` and
``$XDG_DATA_DIRS`` (see Section :ref:`libraries-and-filesystem`).

Some |Coq| commands call other |Coq| commands. In this case, they look for
the commands in directory specified by ``$COQBIN``. If this variable is
not set, they look for the commands in the executable path.

.. _COQ_COLORS:

The ``$COQ_COLORS`` environment variable can be used to specify the set
of colors used by ``coqtop`` to highlight its output. It uses the same
syntax as the ``$LS_COLORS`` variable from GNU’s ls, that is, a colon-separated
list of assignments of the form :n:`name={*; attr}` where
``name`` is the name of the corresponding highlight tag and each ``attr`` is an
ANSI escape code. The list of highlight tags can be retrieved with the
``-list-tags`` command-line option of ``coqtop``.

The string uses ANSI escape codes to represent attributes.  For example:

        ``export COQ_COLORS=”diff.added=4;48;2;0;0;240:diff.removed=41”``

sets the highlights for added text in diffs to underlined (the 4) with a background RGB
color (0, 0, 240) and for removed text in diffs to a red background.
Note that if you specify ``COQ_COLORS``, the predefined attributes are ignored.


.. _command-line-options:

By command line options
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command-line options are recognized by the commands ``coqc``
and ``coqtop``, unless stated otherwise:

:-I *directory*, -include *directory*: Add physical path *directory*
  to the OCaml loadpath.

  .. seealso::

     :ref:`names-of-libraries` and the
     command Declare ML Module Section :ref:`compiled-files`.
:-Q *directory* *dirpath*: Add physical path *directory* to the list of
  directories where |Coq| looks for a file and bind it to the logical
  directory *dirpath*. The subdirectory structure of *directory* is
  recursively available from |Coq| using absolute names (extending the
  :n:`@dirpath` prefix) (see Section :ref:`qualified-names`). Note that only those
  subdirectories and files which obey the lexical conventions of what is
  an :n:`@ident` are taken into account. Conversely, the
  underlying file systems or operating systems may be more restrictive
  than |Coq|. While Linux’s ext4 file system supports any |Coq| recursive
  layout (within the limit of 255 bytes per filename), the default on
  NTFS (Windows) or HFS+ (MacOS X) file systems is on the contrary to
  disallow two files differing only in the case in the same directory.

  .. seealso:: Section :ref:`names-of-libraries`.
:-R *directory* *dirpath*: Do as ``-Q`` *directory* *dirpath* but make the
  subdirectory structure of *directory* recursively visible so that the
  recursive contents of physical *directory* is available from |Coq| using
  short or partially qualified names.

  .. seealso:: Section :ref:`names-of-libraries`.
:-top *dirpath*: Set the toplevel module name to :n:`@dirpath` instead of ``Top``.
  Not valid for `coqc` as the toplevel module name is inferred from the
  name of the output file.
:-exclude-dir *directory*: Exclude any subdirectory named *directory*
  while processing options such as -R and -Q. By default, only the
  conventional version control management directories named CVS
  and_darcs are excluded.
:-nois, -noinit: Start from an empty state instead of loading the `Init.Prelude`
  module.
:-init-file *file*: Load *file* as the resource file instead of
  loading the default resource file from the standard configuration
  directories.
:-q: Do not to load the default resource file.
:-l *file*, -load-vernac-source *file*: Load and execute the |Coq|
  script from *file.v*.
:-lv *file*, -load-vernac-source-verbose *file*: Load and execute the
  |Coq| script from *file.v*. Write its contents to the standard output as
  it is executed.
:-load-vernac-object *qualid*: Load |Coq| compiled library :n:`@qualid`. This
  is equivalent to running :cmd:`Require` :n:`@qualid`.

  .. _interleave-command-line:

  .. note::

     Note that the relative order of this command-line option and its
     variants (`-rfrom`, `-ri`, `-re`, etc.)  and of the `-set` and
     `-unset` options matters since the various :cmd:`Require`,
     :cmd:`Require Import`, :cmd:`Require Export`, :cmd:`Set` and
     :cmd:`Unset` commands will be executed in the order specified on
     the command-line.

:-rfrom *dirpath* *qualid*: Load |Coq| compiled library :n:`@qualid`.
  This is equivalent to running :cmd:`From <From … Require>`
  :n:`@dirpath` :cmd:`Require <From … Require>` :n:`@qualid`.
  See the :ref:`note above <interleave-command-line>` regarding the order
  of command-line options.
:-ri *qualid*, -require-import *qualid*: Load |Coq| compiled library :n:`@qualid` and import it.
  This is equivalent to running :cmd:`Require Import` :n:`@qualid`.
  See the :ref:`note above <interleave-command-line>` regarding the order
  of command-line options.
:-re *qualid*, -require-export *qualid*: Load |Coq| compiled library :n:`@qualid` and transitively import it.
  This is equivalent to running :cmd:`Require Export` :n:`@qualid`.
  See the :ref:`note above <interleave-command-line>` regarding the order
  of command-line options.
:-rifrom *dirpath* *qualid*, -require-import-from *dirpath* *qualid*:
  Load |Coq| compiled library :n:`@qualid` and import it.  This is
  equivalent to running :cmd:`From <From … Require>` :n:`@dirpath`
  :cmd:`Require Import <From … Require>` :n:`@qualid`.  See the
  :ref:`note above <interleave-command-line>` regarding the order of
  command-line options.
:-refrom *dirpath* *qualid*, -require-export-from *dirpath* *qualid*:
  Load |Coq| compiled library :n:`@qualid` and transitively import it.
  This is equivalent to running :cmd:`From <From … Require>`
  :n:`@dirpath` :cmd:`Require Export <From … Require>` :n:`@qualid`.
  See the :ref:`note above <interleave-command-line>` regarding the
  order of command-line options.
:-batch: Exit just after argument parsing. Available for ``coqtop`` only.
:-verbose: Output the content of the input file as it is compiled.
  This option is available for ``coqc`` only.
:-vos: Indicate |Coq| to skip the processing of opaque proofs
  (i.e., proofs ending with :cmd:`Qed` or :cmd:`Admitted`), output a ``.vos`` files
  instead of a ``.vo`` file, and to load ``.vos`` files instead of ``.vo`` files
  when interpreting :cmd:`Require` commands.
:-vok: Indicate |Coq| to check a file completely, to load ``.vos`` files instead
  of ``.vo`` files when interpreting :cmd:`Require` commands, and to output an empty
  ``.vok`` files upon success instead of writing a ``.vo`` file.
:-w (all|none|w₁,…,wₙ): Configure the display of warnings. This
  option expects all, none or a comma-separated list of warning names or
  categories (see Section :ref:`controlling-display`).
:-color (on|off|auto): *Coqtop only*.  Enable or disable color output.
  Default is auto, meaning color is shown only if
  the output channel supports ANSI escape sequences.
:-diffs (on|off|removed): *Coqtop only*.  Controls highlighting of differences
  between proof steps.  ``on`` highlights added tokens, ``removed`` highlights both added and
  removed tokens.  Requires that ``-color`` is enabled.  (see Section
  :ref:`showing_diffs`).
:-beautify: Pretty-print each command to *file.beautified* when
  compiling *file.v*, in order to get old-fashioned
  syntax/definitions/notations.
:-emacs, -ide-slave: Start a special toplevel to communicate with a
  specific IDE.
:-impredicative-set: Change the logical theory of |Coq| by declaring the
   sort :g:`Set` impredicative.

   .. warning::

      This is known to be inconsistent with some
      standard axioms of classical mathematics such as the functional
      axiom of choice or the principle of description.
:-type-in-type: Collapse the universe hierarchy of |Coq|.

  .. warning:: This makes the logic inconsistent.
:-mangle-names *ident*: *Experimental.* Do not depend on this option. Replace
  Coq's auto-generated name scheme with names of the form *ident0*, *ident1*,
  etc. Within Coq, the :flag:`Mangle Names` flag turns this behavior on,
  and the :opt:`Mangle Names Prefix` option sets the prefix to use. This feature
  is intended to be used as a linter for developments that want to be robust to
  changes in the auto-generated name scheme. The options are provided to
  facilitate tracking down problems.
:-set *string*: Enable flags and set options. *string* should be
   :n:`@setting_name=value`, the value is interpreted according to the
   type of the option. For flags :n:`@setting_name` is equivalent to
   :n:`@setting_name=true`. For instance ``-set "Universe Polymorphism"``
   will enable :flag:`Universe Polymorphism`. Note that the quotes are
   shell syntax, Coq does not see them.
   See the :ref:`note above <interleave-command-line>` regarding the order
   of command-line options.
:-unset *string*: As ``-set`` but used to disable options and flags.
  *string* must be :n:`"@setting_name"`.
  See the :ref:`note above <interleave-command-line>` regarding the order
  of command-line options.
:-compat *version*: Load a file that sets a few options to maintain
  partial backward-compatibility with a previous version.  This is
  equivalent to :cmd:`Require Import` `Coq.Compat.CoqXXX` with `XXX`
  one of the last three released versions (including the current
  version).  Note that the :ref:`explanations above
  <interleave-command-line>` regarding the order of command-line
  options apply, and this could be relevant if you are resetting some
  of the compatibility options.
:-dump-glob *file*: Dump references for global names in file *file*
  (to be used by coqdoc, see :ref:`coqdoc`). By default, if *file.v* is being
  compiled, *file.glob* is used.
:-no-glob: Disable the dumping of references for global names.
:-image *file*: Set the binary image to be used by ``coqc`` to be *file*
  instead of the standard one. Not of general use.
:-bindir *directory*: Set the directory containing |Coq| binaries to be
  used by ``coqc``. It is equivalent to doing export COQBIN= *directory*
  before launching ``coqc``.
:-where: Print the location of |Coq|’s standard library and exit.
:-config: Print the locations of |Coq|’s binaries, dependencies, and
  libraries, then exit.
:-filteropts: Print the list of command line arguments that `coqtop` has
  recognized as options and exit.
:-v: Print |Coq|’s version and exit.
:-list-tags: Print the highlight tags known by |Coq| as well as their
  currently associated color and exit.
:-h, --help: Print a short usage and exit.


.. _compiled-interfaces:

Compiled interfaces (produced using ``-vos``)
----------------------------------------------

Compiled interfaces help saving time while developing Coq formalizations,
by compiling the formal statements exported by a library independently of
the proofs that it contains.

   .. warning::

      Compiled interfaces should only be used for development purposes.
      At the end of the day, one still needs to proof check all files
      by producing standard ``.vo`` files. (Technically, when using ``-vos``,
      fewer universe constraints are collected.)
      Moreover, this feature is still experimental, it may be subject to
      change without prior notice.

**Principle.**

The compilation using ``coqc -vos foo.v`` produces a file called ``foo.vos``,
which is similar to ``foo.vo`` except that all opaque proofs are skipped in
the compilation process.

The compilation using ``coqc -vok foo.v`` checks that the file ``foo.v``
correctly compiles, including all its opaque proofs. If the compilation
succeeds, then the output is a file called ``foo.vok``, with empty contents.
This file is only a placeholder indicating that ``foo.v`` has been successfully
compiled. (This placeholder is useful for build systems such as ``make``.)

When compiling a file ``bar.v`` that depends on ``foo.v`` (for example via
a ``Require Foo.`` command), if the compilation command is ``coqc -vos bar.v``
or ``coqc -vok bar.v``, then the file ``foo.vos`` gets loaded (instead of
``foo.vo``). A special case is if file ``foo.vos`` exists and has empty
contents, and ``foo.vo`` exists, then ``foo.vo`` is loaded.

Appart from the aforementioned case where ``foo.vo`` can be loaded in place
of ``foo.vos``, in general the ``.vos`` and ``.vok`` files live totally
independently from the ``.vo`` files.

**Dependencies generated by ``coq_makefile``.**

The files ``foo.vos`` and ``foo.vok`` both depend on ``foo.v``.

Furthermore, if a file ``foo.v`` requires ``bar.v``, then ``foo.vos``
and ``foo.vok`` also depend on ``bar.vos``.

Note, however, that ``foo.vok`` does not depend on ``bar.vok``.
Hence, as detailed further, parallel compilation of proofs is possible.

In addition, ``coq_makefile`` generates for a file ``foo.v`` a target
``foo.required_vos`` which depends on the list of ``.vos`` files that
``foo.vos`` depends upon (excluding ``foo.vos`` itself). As explained
next, the purpose of this target is to be able to request the minimal
working state for editing interactively the file ``foo.v``.

.. warning::

   When writing a custom build system, be aware that ``coqdep`` only
   produces dependencies related to ``.vos`` and ``.vok`` if the
   ``-vos`` command line flag is passed. This is to maintain
   compatibility with dune (see `ocaml/dune#2642 on github
   <https://github.com/ocaml/dune/issues/2842>`_).

**Typical compilation of a set of file using a build system.**

Assume a file ``foo.v`` that depends on two files ``f1.v`` and ``f2.v``. The
command ``make foo.required_vos`` will compile ``f1.v`` and ``f2.v`` using
the option ``-vos`` to skip the proofs, producing ``f1.vos`` and ``f2.vos``.
At this point, one is ready to work interactively on the file ``foo.v``, even
though it was never needed to compile the proofs involved in the files ``f1.v``
and ``f2.v``.

Assume a set of files ``f1.v ... fn.v`` with linear dependencies. The command
``make vos`` enables compiling the statements (i.e. excluding the proofs) in all
the files. Next, ``make -j vok`` enables compiling all the proofs in parallel.
Thus, calling ``make -j vok`` directly enables taking advantage of a maximal
amount of parallelism during the compilation of the set of files.

Note that this comes at the cost of parsing and typechecking all definitions
twice, once for the ``.vos`` file and once for the ``.vok`` file. However, if
files contain nontrivial proofs, or if the files have many linear chains of
dependencies, or if one has many cores available, compilation should be faster
overall.

**Need for ``Proof using``**

When a theorem is part of a section, typechecking the statement of this theorem
might be insufficient for deducing the type of this statement as of at the end
of the section. Indeed, the proof of the theorem could make use of section
variables or section hypotheses that are not mentioned in the statement of the
theorem.

For this reason, proofs inside section should begin with :cmd:`Proof using`
instead of :cmd:`Proof`, where after the ``using`` clause one should provide
the list of the names of the section variables that are required for the proof
but are not involved in the typechecking of the statement. Note that it is safe
to write ``Proof using.`` instead of ``Proof.`` also for proofs that are not
within a section.

.. warn:: You should use the “Proof using [...].” syntax instead of “Proof.” to enable skipping this proof which is located inside a section. Give as argument to “Proof using” the list of section variables that are not needed to typecheck the statement but that are required by the proof.

     If |Coq| is invoked using the ``-vos`` option, whenever it finds the
     command ``Proof.`` inside a section, it will compile the proof, that is,
     refuse to skip it, and it will raise a warning. To disable the warning, one
     may pass the flag ``-w -proof-without-using-in-section``.

**Interaction with standard compilation**

When compiling a file ``foo.v`` using ``coqc`` in the standard way (i.e., without
``-vos`` nor ``-vok``), an empty file ``foo.vos`` and an empty file ``foo.vok``
are created in addition to the regular output file ``foo.vo``.
If ``coqc`` is subsequently invoked on some other file ``bar.v`` using option
``-vos`` or ``-vok``, and that ``bar.v`` requires ``foo.v``, if |Coq| finds an
empty file ``foo.vos``, then it will load ``foo.vo`` instead of ``foo.vos``.

The purpose of this feature is to allow users to benefit from the ``-vos``
option even if they depend on libraries that were compiled in the traditional
manner (i.e., never compiled using the ``-vos`` option).


Compiled libraries checker (coqchk)
----------------------------------------

The ``coqchk`` command takes a list of library paths as argument, described either
by their logical name or by their physical filename, which must end in ``.vo``. The
corresponding compiled libraries (``.vo`` files) are searched in the path,
recursively processing the libraries they depend on. The content of all these
libraries is then type checked. The effect of ``coqchk`` is only to return with
normal exit code in case of success, and with positive exit code if an error has
been found. Error messages are not deemed to help the user understand what is
wrong. In the current version, it does not modify the compiled libraries to mark
them as successfully checked.

Note that non-logical information is not checked. By logical
information, we mean the type and optional body associated to names.
It excludes for instance anything related to the concrete syntax of
objects (customized syntax rules, association between short and long
names), implicit arguments, etc.

This tool can be used for several purposes. One is to check that a
compiled library provided by a third-party has not been forged and
that loading it cannot introduce inconsistencies [#]_. Another point is
to get an even higher level of security. Since ``coqtop`` can be extended
with custom tactics, possibly ill-typed code, it cannot be guaranteed
that the produced compiled libraries are correct. ``coqchk`` is a
standalone verifier, and thus it cannot be tainted by such malicious
code.

Command-line options ``-Q``, ``-R``, ``-where`` and ``-impredicative-set`` are supported
by ``coqchk`` and have the same meaning as for ``coqtop``. As there is no notion of
relative paths in object files ``-Q`` and ``-R`` have exactly the same meaning.

:-norec *module*: Check *module* but do not check its dependencies.
:-admit *module*: Do not check *module* and any of its dependencies,
  unless explicitly required.
:-o: At exit, print a summary about the context. List the names of all
  assumptions and variables (constants without body).
:-silent: Do not write progress information to the standard output.

Environment variable ``$COQLIB`` can be set to override the location of
the standard library.

The algorithm for deciding which modules are checked or admitted is
the following: assuming that ``coqchk`` is called with argument ``M``, option
``-norec N``, and ``-admit A``. Let us write :math:`\overline{S}` for the
set of reflexive transitive dependencies of set :math:`S`. Then:

+ Modules :math:`C = \overline{M} \backslash \overline{A} \cup M \cup N` are loaded and type checked before being added
  to the context.
+ And :math:`M \cup N \backslash C` is the set of modules that are loaded and added to the
  context without type checking. Basic integrity checks (checksums) are
  nonetheless performed.

As a rule of thumb, -admit can be used to tell Coq that some libraries
have already been checked. So ``coqchk A B`` can be split in ``coqchk A`` &&
``coqchk B -admit A`` without type checking any definition twice. Of
course, the latter is slightly slower since it makes more disk access.
It is also less secure since an attacker might have replaced the
compiled library ``A`` after it has been read by the first command, but
before it has been read by the second command.

.. [#] Ill-formed non-logical information might for instance bind
  Coq.Init.Logic.True to short name False, so apparently False is
  inhabited, but using fully qualified names, Coq.Init.Logic.False will
  always refer to the absurd proposition, what we guarantee is that
  there is no proof of this latter constant.
