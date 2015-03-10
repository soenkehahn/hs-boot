
module MainSpec where

import           Control.Exception
import           System.Directory
import           System.Environment
import           System.FilePath
import           System.IO.Silently
import           System.Process
import           Test.Hspec

spec :: Spec
spec = do
  describe "run" $ do
    it "performs the happy flow" $ do
      addHsBootToPath
      withCurrentDirectory "test/01" $ do
        output <- capture_ $ callCommand "./compile.sh"
        output `shouldContain` "01-success"

addHsBootToPath :: IO ()
addHsBootToPath = do
  path <- getEnv "PATH"
  dir <- getCurrentDirectory
  setEnv "PATH" (dir </> "test/fake-bin/" ++ ":" ++ path)

withCurrentDirectory :: FilePath -> IO a -> IO a
withCurrentDirectory directory =
  bracket enter leave . const
 where
  enter = do
    outer <- getCurrentDirectory
    setCurrentDirectory directory
    return outer
  leave outer = do
    setCurrentDirectory outer
