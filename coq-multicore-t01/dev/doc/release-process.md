# Release process #

## As soon as the previous version branched off master ##

In principle, these steps should be undertaken by the RM of the next
release. Unfortunately, we have not yet been able to nominate RMs
early enough in the process for this person to be known at that point
in time.

- [ ] Create a new issue to track the release process where you can copy-paste
  the present checklist from `dev/doc/release-process.md`.
- [ ] Change the version name to the next major version and the magic
  numbers (see [#7008](https://github.com/coq/coq/pull/7008/files)).

  Additionally, in the same commit, update the compatibility
  infrastructure, which consists of invoking
  [`dev/tools/update-compat.py`](../tools/update-compat.py) with the
  `--master` flag.

  Note that the `update-compat.py` script must be run twice: once
  *immediately after* branching with the `--master` flag (which sets
  up Coq to support four `-compat` flag arguments), *in the same
  commit* as the one that updates `coq_version` in
  [`configure.ml`](../../configure.ml), and once again later on before
  the next branch point with the `--release` flag (see next section).
- [ ] Put the corresponding alpha tag using `git tag -s`.
  The `VX.X+alpha` tag marks the first commit to be in `master` and not in the
  branch of the previous version. Note that this commit is the first commit
  in the first PR merged in master, not the merge commit for that PR.
  After tagging double check that `git describe` picks up
  the tag you just made (if not, you tagged the wrong commit).
- [ ] Create the `X.X+beta1` milestone if it did not already exist.
- [ ] Decide the release calendar with the team (freeze date, beta date, final
  release date) and put this information in the milestone (using the
  description and due date fields).

## Anytime after the previous version is branched off master ##

- [ ] Update the compatibility infrastructure to the next release,
  which consists of invoking
  [`dev/tools/update-compat.py`](../tools/update-compat.py) with the
  `--release` flag; this sets up Coq to support three `-compat` flag
  arguments.  To ensure that CI passes, you will have to decide what
  to do about all test-suite files which mention `-compat U.U` or
  `Coq.Comapt.CoqUU` (which is no longer valid, since we only keep
  compatibility against the two previous versions on releases), and
  you may have to prepare overlays for projects using the
  compatibility flags.

## About one month before the beta ##

- [ ] Create the `X.X.0` milestone and set its due date.
- [ ] Send an announcement of the upcoming freeze on Coqdev and ask people to
  remove from the beta milestone what they already know won't be ready on time
  (possibly postponing to the `X.X.0` milestone for minor bug fixes,
  infrastructure and documentation updates).
- [ ] Determine which issues should / must be fixed before the beta, add them
  to the beta milestone, possibly with a
  ["priority: blocker"](https://github.com/coq/coq/labels/priority%3A%20blocker)
  label. Make sure that all these issues are assigned (and that the assignee
  provides an ETA).
- [ ] Ping the development coordinator (**@mattam82**) to get him started on
  the update to the Credits chapter of the reference manual.
  See also [#7058](https://github.com/coq/coq/issues/7058).

  The command that was used in the previous versions to get the list
  of contributors for this version is `git shortlog -s -n
  VX.X+alpha..master | cut -f2 | sort -k 2`. Note that the ordering is
  approximative as it will misplace people with middle names. It is
  also probably not correctly handling `Co-authored-by` info that we
  have been using more lately, so should probably be updated to
  account for this.

## On the date of the feature freeze ##

- [ ] Create the new version branch `vX.X` (using this name will ensure that
  the branch will be automatically protected).
- [ ] Pin the versions of libraries and plugins in
  `dev/ci/ci-basic-overlays.sh` to use commit hashes or tag (or, if it
  exists, a branch dedicated to compatibility with the corresponding
  Coq branch). You can use the `dev/tools/pin-ci.sh` script to do this
  semi-automatically.
- [ ] Remove all remaining unmerged feature PRs from the beta milestone.
- [ ] Start a new project to track PR backporting. The project should
  have a "Request X.X+beta1 inclusion" column for the PRs that were
  merged in `master` that are to be considered for backporting, and a
  "Shipped in X.X+beta1" columns to put what was backported. A message
  to **@coqbot** in the milestone description tells it to
  automatically add merged PRs to the "Request ... inclusion" column
  and backported PRs to the "Shipped in ..." column. See previous
  milestones for examples. When moving to the next milestone
  (e.g. X.X.0), you can clear and remove the "Request X.X+beta1
  inclusion" column and create new "Request X.X.0 inclusion" and
  "Shipped in X.X.0" columns.

  The release manager is the person responsible for merging PRs that
  target the version branch and backporting appropriate PRs that are
  merged into `master`.
- [ ] Delay non-blocking issues to the appropriate milestone and ensure
  blocking issues are solved. If required to solve some blocking issues,
  it is possible to revert some feature PRs in the version branch only.
- [ ] Add a new link to the ``'versions'`` list of the refman (in
      ``html_context`` in ``doc/sphinx/conf.py``).

## Before the beta release date ##

- [ ] Ensure the Credits chapter has been updated.
- [ ] Prepare the release notes (see e.g.,
  [#10833](https://github.com/coq/coq/pull/10833)): in a PR against the `master`
  branch, move the contents from all files of `doc/changelog/` that appear in
  the release branch into the manual `doc/sphinx/changes.rst`. Merge that PR
  into the `master` branch and backport it to the version branch.
- [ ] Ensure that an appropriate version of the plugins we will distribute with
  Coq has been tagged.
- [ ] Have some people test the recently auto-generated Windows and MacOS
  packages.
- [ ] In a PR:
  - Change the version name from alpha to beta1 (see
  [#7009](https://github.com/coq/coq/pull/7009/files)).
  - We generally do not update the magic numbers at this point.
  - Set `is_a_released_version` to `true` in `configure.ml`.
- [ ] Put the `VX.X+beta1` tag using `git tag -s`.
- [ ] Check using `git push --tags --dry-run` that you are not
  pushing anything else than the new tag. If needed, remove spurious
  tags with `git tag -d`. When this is OK, proceed with `git push --tags`.
- [ ] Set `is_a_released_version` to `false` in `configure.ml`
  (if you forget about it, you'll be reminded whenever you try to
  backport a PR with a changelog entry).

### These steps are the same for all releases (beta, final, patch-level) ###

- [ ] Send an e-mail on Coqdev announcing that the tag has been put so that
  package managers can start preparing package updates (including a
  `coq-bignums` compatible version).
- [ ] When opening the corresponding PR for `coq` in the opam repository ([`coq/opam-coq-archive`](https://github.com/coq/opam-coq-archive) or [`ocaml/opam-repository`](https://github.com/ocaml/opam-repository)),
  the package managers can Cc `@erikmd` to request that he prepare the necessary configuration for the Docker release in [`coqorg/coq`](https://hub.docker.com/r/coqorg/coq)
  (namely, he'll need to make sure a `coq-bignums` opam package is available in [`extra-dev`](https://github.com/coq/opam-coq-archive/tree/master/extra-dev), respectively [`released`](https://github.com/coq/opam-coq-archive/tree/master/released), so the Docker image gathering `coq` and `coq-bignums` can be built).
- [ ] Draft a release on GitHub.
- [ ] Sign the Windows and MacOS packages and upload them on GitHub.
  + The Windows packages must be signed by the Inria IT security service. They
    should be sent as a link to the binary together with its SHA256 hash in a
    signed e-mail, via our local contact (currently `@maximedenes`).
  + The MacOS packages should be signed by our own certificate, by sending them
    to `@maximedenes`. A detailed step-by-step guide can be found [on the wiki](https://github.com/coq/coq/wiki/SigningReleases).
- [ ] Prepare a page of news on the website with the link to the GitHub release
  (see [coq/www#63](https://github.com/coq/www/pull/63)).
- [ ] Upload the new version of the reference manual to the website.
  *TODO: setup some continuous deployment for this.*
- [ ] Merge the website update, publish the release
  and send announcement e-mails.
- [ ] Close the milestone

## At the final release time ##

- [ ] Prepare the release notes (see above)
- [ ] In a PR:
  - Change the version name from X.X.0 and the magic numbers (see
  [#7271](https://github.com/coq/coq/pull/7271/files)).
  - Set `is_a_released_version` to `true` in `configure.ml`.
- [ ] Put the `VX.X.0` tag.
- [ ] Check using `git push --tags --dry-run` that you are not
  pushing anything else than the new tag. If needed, remove spurious
  tags with `git tag -d`. When this is OK, proceed with `git push --tags`.
- [ ] Set `is_a_released_version` to `false` in `configure.ml`
  (if you forget about it, you'll be reminded whenever you try to
  backport a PR with a changelog entry).

Repeat the generic process documented above for all releases.

Ping `@Zimmi48` to:

- [ ] Switch the default version of the reference manual on the website.
- [ ] Publish a new version on Zenodo.

## At the patch-level release time ##

We generally do not update the magic numbers at this point (see
[`2881a18`](https://github.com/coq/coq/commit/2881a18)).
