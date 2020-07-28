#!/usr/bin/env bash

ci_dir="$(dirname "$0")"
. "${ci_dir}/ci-common.sh"

install_ssreflect

# Setup lambda_rust first
git_download lambda_rust

# Extract required version of Iris (avoiding "+" which does not work on MacOS :( *)
iris_CI_REF=$(grep -F coq-iris < "${CI_BUILD_DIR}/lambda_rust/opam" | sed 's/.*"dev\.[0-9][0-9.-]*\.\([0-9a-z][0-9a-z]*\)".*/\1/')

# Setup Iris
git_download iris

# Extract required version of std++
stdpp_CI_REF=$(grep -F coq-stdpp < "${CI_BUILD_DIR}/iris/opam" | sed 's/.*"dev\.[0-9][0-9.-]*\.\([0-9a-z][0-9a-z]*\)".*/\1/')

# Setup std++
git_download stdpp

# Build std++
( cd "${CI_BUILD_DIR}/stdpp" && make && make install )

# Build and validate Iris
( cd "${CI_BUILD_DIR}/iris" && make && make validate && make install )

# Build lambda_rust
( cd "${CI_BUILD_DIR}/lambda_rust" && make && make install )
