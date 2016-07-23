
module Run (run) where

import           Control.Monad         (when)
import           Data.Foldable         (forM_)
import           Data.List
import           System.Directory
import           System.Environment
import           System.Exit.Compat
import qualified System.Logging.Facade as Log

run :: [String] -> IO ()
run args = do
  case args of
    ("scaffold" : modules) -> scaffold modules
    [bootFile, _, outputFile] -> generateBootFile bootFile outputFile
    _ -> do
      progName <- getProgName
      die ("usage: " ++ progName ++ " scaffold MODULE_FILES |\n" ++
           progName ++ " something something outputfile\n" ++
           "(not " ++ show args ++ ")")

scaffold :: [FilePath] -> IO ()
scaffold haskellModules = do
  forM_ haskellModules $ \ file -> do
    exists <- doesFileExist file
    when (not exists) $
      die ("file not found: " ++ file)
    bootExists <- doesFileExist $ mkBoot file
    when bootExists $
      Log.warn ("file already exists: " ++ file)

  forM_ haskellModules $ \ file ->
    writeFile (mkBoot file) "{-# OPTIONS_GHC -F -pgmF hs-boot #-}\n"
 where
  mkBoot = (++ "-boot")

generateBootFile :: FilePath -> FilePath -> IO ()
generateBootFile bootFile outFile = do
  let hsFile = take (length bootFile - length "-boot") bootFile
  exists <- doesFileExist hsFile
  when (not exists) $
    die ("file not found: " ++ hsFile)
  code <- readFile hsFile
  let bootCode = unlines $
        filter (\ line -> any (`isInfixOf` line) ["module", "::"]) $
        lines code
  writeFile outFile bootCode
