
module MainSpec where

import           Control.Exception
import           Data.Foldable
import           System.Directory
import           System.Environment
import           System.FilePath
import           System.IO.Silently
import           System.Process
import           Test.Hspec

spec :: Spec
spec = do
  describe "run" $ do
    forM_ ["01"] $ \ project -> do
      it ("performs the happy flow for project " ++ project) $ do
        addHsBootToPath
        withCurrentDirectory ("test/projects" </> project) $ do
          output <- capture_ $ callCommand "./compile.sh"
          output `shouldContain` (project ++ "-success")

addHsBootToPath :: IO ()
addHsBootToPath = do
  path <- getEnv "PATH"
  dir <- getCurrentDirectory
  setEnv "PATH" (dir </> "test/fake-bin/" ++ ":" ++ path)

-- fixme: test in temp directory
-- fixme: write readme
-- fixme: add ci

-- fixme: use mockery
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
