
module A where

import B

data A = A String

one :: A
one = A "02-success"

three :: A
three = case two of
  B s -> A s
