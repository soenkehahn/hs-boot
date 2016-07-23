{-# LANGUAGE QuasiQuotes #-}

module MainSpec where

import           Data.String.Interpolate
import           Data.String.Interpolate.Util
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
    it "works for recursive functions" $ do
      withProject "01" $ do
        run $ words "scaffold A.hs"
        output <- capture_ $ callCommand "runhaskell Main.hs"
        output `shouldContain` "01-success"

    it "works for recursive functions with custom datatypes" $ do
      pending
      withProject "02" $ do
        run $ words "scaffold A.hs"
        output <- capture_ $ callCommand "runhaskell Main.hs"
        output `shouldContain` "bllll"

  describe "bootCode" $ do
    it "extracts value types" $ do
      let code = unindent [i|
            foo :: Int
            foo = 42
          |]
      bootCode code `shouldBe` "foo :: Int\n"

    it "extracts type declarations" $ do
      let code = unindent [i|
            data Foo = Foo
            foo = 42
          |]
      bootCode code `shouldBe` "data Foo = Foo\n"

withProject :: String -> IO a -> IO a
withProject project action = do
  projectDir <- canonicalizePath $ "test/projects" </> project
  addHsBootToPath
  inTempDirectory $ do
    callCommand ("cp -r " ++ projectDir </> "* .")
    action

addHsBootToPath :: IO ()
addHsBootToPath = do
  path <- getEnv "PATH"
  dir <- getCurrentDirectory
  setEnv "PATH" (dir </> "test/fake-bin/" ++ ":" ++ path)

-- fixme: write readme
-- fixme: add ci
