Require Import Program.

Class Foo (A : Type) := foo : A.

Program Instance f1 : Foo nat := S _.
Next Obligation. exact 0. Defined.
