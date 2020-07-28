(************************************************************************)
(*         *   The Coq Proof Assistant / The Coq Development Team       *)
(*  v      *         Copyright INRIA, CNRS and contributors             *)
(* <O___,, * (see version control and CREDITS file for authors & dates) *)
(*   \VV/  **************************************************************)
(*    //   *    This file is distributed under the terms of the         *)
(*         *     GNU Lesser General Public License Version 2.1          *)
(*         *     (see LICENSE file for the text of the license)         *)
(************************************************************************)

val set_indirect_accessor : Opaqueproof.indirect_accessor -> unit

val check_module : Environ.env -> Names.Cset.t Names.Cmap.t -> Names.ModPath.t -> Declarations.module_body -> Names.Cset.t Names.Cmap.t
