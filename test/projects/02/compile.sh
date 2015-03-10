#!/usr/bin/env bash

set -o errexit

rm -f *.hs-boot
hs-boot scaffold A.hs

ghc --make Main.hs
./Main
