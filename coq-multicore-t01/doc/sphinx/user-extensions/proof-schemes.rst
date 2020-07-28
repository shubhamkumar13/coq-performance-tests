.. _proofschemes:

Proof schemes
===============

.. _proofschemes-induction-principles:

Generation of induction principles with ``Scheme``
--------------------------------------------------------

The ``Scheme`` command is a high-level tool for generating automatically
(possibly mutual) induction principles for given types and sorts. Its
syntax follows the schema:

.. cmd:: Scheme @ident__1 := Induction for @ident__2 Sort @sort {* with @ident__i := Induction for @ident__j Sort @sort}

  This command is a high-level tool for generating automatically
  (possibly mutual) induction principles for given types and sorts.
  Each :n:`@ident__j` is a different inductive type identifier belonging to
  the same package of mutual inductive definitions.
  The command generates the :n:`@ident__i`\s to be mutually recursive
  definitions. Each term :n:`@ident__i` proves a general principle of mutual
  induction for objects in type :n:`@ident__j`.

.. cmdv:: Scheme @ident := Minimality for @ident Sort @sort {* with @ident := Minimality for @ident' Sort @sort}

   Same as before but defines a non-dependent elimination principle more
   natural in case of inductively defined relations.

.. cmdv:: Scheme Equality for @ident
   :name: Scheme Equality

   Tries to generate a Boolean equality and a proof of the decidability of the usual equality. If `ident`
   involves some other inductive types, their equality has to be defined first.

.. cmdv:: Scheme Induction for @ident Sort @sort {* with Induction for @ident Sort @sort}

   If you do not provide the name of the schemes, they will be automatically computed from the
   sorts involved (works also with Minimality).

.. example::

   Induction scheme for tree and forest.

   A mutual induction principle for tree and forest in sort ``Set`` can be defined using the command

    .. coqtop:: none

       Axiom A : Set.
       Axiom B : Set.

    .. coqtop:: all

     Inductive tree : Set := node : A -> forest -> tree
     with forest : Set :=
         leaf : B -> forest
       | cons : tree -> forest -> forest.

     Scheme tree_forest_rec := Induction for tree Sort Set
       with forest_tree_rec := Induction for forest Sort Set.

  You may now look at the type of tree_forest_rec:

  .. coqtop:: all

    Check tree_forest_rec.

  This principle involves two different predicates for trees andforests;
  it also has three premises each one corresponding to a constructor of
  one of the inductive definitions.

  The principle `forest_tree_rec` shares exactly the same premises, only
  the conclusion now refers to the property of forests.

.. example::

  Predicates odd and even on naturals.

  Let odd and even be inductively defined as:

   .. coqtop:: all

      Inductive odd : nat -> Prop := oddS : forall n:nat, even n -> odd (S n)
      with even : nat -> Prop :=
        | evenO : even 0
        | evenS : forall n:nat, odd n -> even (S n).

  The following command generates a powerful elimination principle:

   .. coqtop:: all

    Scheme odd_even := Minimality for odd Sort Prop
    with even_odd := Minimality for even Sort Prop.

  The type of odd_even for instance will be:

  .. coqtop:: all

    Check odd_even.

  The type of `even_odd` shares the same premises but the conclusion is
  `(n:nat)(even n)->(P0 n)`.


Automatic declaration of schemes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. flag:: Elimination Schemes

   Enables automatic declaration of induction principles when defining a new
   inductive type.  Defaults to on.

.. flag:: Nonrecursive Elimination Schemes

   Enables automatic declaration of induction principles for types declared with the :cmd:`Variant` and
   :cmd:`Record` commands.  Defaults to off.

.. flag:: Case Analysis Schemes

   This flag governs the generation of case analysis lemmas for inductive types,
   i.e. corresponding to the pattern matching term alone and without fixpoint.

.. flag:: Boolean Equality Schemes
          Decidable Equality Schemes

   These flags control the automatic declaration of those Boolean equalities (see
   the second variant of ``Scheme``).

.. warning::

   You have to be careful with these flags since Coq may now reject well-defined
   inductive types because it cannot compute a Boolean equality for them.

.. flag:: Rewriting Schemes

   This flag governs generation of equality-related schemes such as congruence.

Combined Scheme
~~~~~~~~~~~~~~~~~~~~~~

.. cmd:: Combined Scheme @ident from {+, @ident__i}

   This command is a tool for combining induction principles generated
   by the :cmd:`Scheme` command.
   Each :n:`@ident__i` is a different inductive principle that must  belong
   to the same package of mutual inductive principle definitions.
   This command generates :n:`@ident` to be the conjunction of the
   principles: it is built from the common premises of the principles
   and concluded by the conjunction of their conclusions.
   In the case where all the inductive principles used are in sort
   ``Prop``, the propositional conjunction ``and`` is used, otherwise
   the simple product ``prod`` is used instead.

.. example::

  We can define the induction principles for trees and forests using:

  .. coqtop:: all

    Scheme tree_forest_ind := Induction for tree Sort Prop
    with forest_tree_ind := Induction for forest Sort Prop.

  Then we can build the combined induction principle which gives the
  conjunction of the conclusions of each individual principle:

  .. coqtop:: all

    Combined Scheme tree_forest_mutind from tree_forest_ind,forest_tree_ind.

  The type of tree_forest_mutind will be:

  .. coqtop:: all

    Check tree_forest_mutind.

.. example::

   We can also combine schemes at sort ``Type``:

  .. coqtop:: all

     Scheme tree_forest_rect := Induction for tree Sort Type
     with forest_tree_rect := Induction for forest Sort Type.

  .. coqtop:: all

     Combined Scheme tree_forest_mutrect from tree_forest_rect, forest_tree_rect.

  .. coqtop:: all

     Check tree_forest_mutrect.

.. seealso:: :ref:`functional-scheme`

.. _derive-inversion:

Generation of inversion principles with ``Derive`` ``Inversion``
-----------------------------------------------------------------

.. cmd:: Derive Inversion @ident with @ident Sort @sort
         Derive Inversion @ident with (forall {* @binder }, @ident @term) Sort @sort

   This command generates an inversion principle for the
   :tacn:`inversion ... using ...` tactic.  The first :token:`ident` is the name
   of the generated principle.  The second :token:`ident` should be an inductive
   predicate, and :token:`binders` the variables occurring in the term
   :token:`term`. This command generates the inversion lemma for the sort
   :token:`sort` corresponding to the instance :n:`forall {* @binder }, @ident @term`.
   When applied, it is equivalent to having inverted the instance with the
   tactic :g:`inversion`.

.. cmdv:: Derive Inversion_clear @ident with @ident Sort @sort
          Derive Inversion_clear @ident with (forall {* @binder }, @ident @term) Sort @sort

   When applied, it is equivalent to having inverted the instance with the
   tactic inversion replaced by the tactic `inversion_clear`.

.. cmdv:: Derive Dependent Inversion @ident with @ident Sort @sort
          Derive Dependent Inversion @ident with (forall {* @binder }, @ident @term) Sort @sort

   When applied, it is equivalent to having inverted the instance with
   the tactic `dependent inversion`.

.. cmdv:: Derive Dependent Inversion_clear @ident with @ident Sort @sort
          Derive Dependent Inversion_clear @ident with (forall {* @binder }, @ident @term) Sort @sort

   When applied, it is equivalent to having inverted the instance
   with the tactic `dependent inversion_clear`.

.. example::

  Consider the relation `Le` over natural numbers and the following
  parameter ``P``:

  .. coqtop:: all

    Inductive Le : nat -> nat -> Set :=
    | LeO : forall n:nat, Le 0 n
    | LeS : forall n m:nat, Le n m -> Le (S n) (S m).

    Parameter P : nat -> nat -> Prop.

  To generate the inversion lemma for the instance :g:`(Le (S n) m)` and the
  sort :g:`Prop`, we do:

  .. coqtop:: all

    Derive Inversion_clear leminv with (forall n m:nat, Le (S n) m) Sort Prop.
    Check leminv.

  Then we can use the proven inversion lemma:

  .. the original LaTeX did not have any Coq code to setup the goal

  .. coqtop:: none

    Goal forall (n m : nat) (H : Le (S n) m), P n m.
    intros.

  .. coqtop:: all

    Show.

    inversion H using leminv.
