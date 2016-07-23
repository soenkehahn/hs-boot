#!/usr/bin/env bash

set -o errexit

test-hs-boot scaffold A.hs

ghc --make Main.hs
./Main
