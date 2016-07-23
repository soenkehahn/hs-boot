
module MainSpec where

import           System.Directory
import           System.Environment
import           System.FilePath
import           System.IO.Silently
import           System.Process
import           Test.Hspec
import           Test.Mockery.Directory

import           Run

spec :: Spec
spec = do
  describe "run" $ do
    it ("performs the happy flow") $ do
      let project = "01"
      projectDir <- canonicalizePath $ "test/projects" </> project
      addHsBootToPath
      inTempDirectory $ do
        callCommand ("cp -r " ++ projectDir </> "* .")
        run $ words "scaffold A.hs"
        callCommand "ghc --make Main.hs"
        output <- capture_ $ callCommand "./Main"
        output `shouldContain` (project ++ "-success")

addHsBootToPath :: IO ()
addHsBootToPath = do
  path <- getEnv "PATH"
  dir <- getCurrentDirectory
  setEnv "PATH" (dir </> "test/fake-bin/" ++ ":" ++ path)

-- fixme: test in temp directory
-- fixme: write readme
-- fixme: add ci
