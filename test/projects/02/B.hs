
module B where

import {-# SOURCE #-} A

data B = B String

two :: B
two = case one of
  A s -> B s
