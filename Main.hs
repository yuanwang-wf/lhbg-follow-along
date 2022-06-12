module Main where

import Convert
import Options.Applicative hiding (action)
import System.Directory (doesFileExist)
import System.Environment (getArgs)

main :: IO ()
main = do
  args <- getArgs
  case args of
    [] -> stdin
    [input, output] -> fileProcess input output
    _ -> putStrLn "incorrect input"

stdin :: IO ()
stdin = do
  content <- getContents
  putStrLn (Convert.process "Empty title" content)

fileProcess :: FilePath -> FilePath -> IO ()
fileProcess input output = do
  exist <- doesFileExist output
  content <- readFile input
  handleOutput exist (writeFile output content)
  where
    handleOutput :: Bool -> IO () -> IO ()
    handleOutput a action = if a then askP action else action

    askP :: IO () -> IO ()
    askP action_ = do
      content <- getContents
      if content == "yes" then action_ else putStrLn "stop"

data Options
  = ConvertSingle SingleInput SingleOutput
  | ConvertDir FilePath FilePath
  deriving (Show)

data SingleInput
  = Stdin
  | InputFile FilePath
  deriving (Show)

data SingleOutput
  = Stdout
  | OutputFile FilePath
  deriving (Show)

inp :: Parser FilePath
inp =
  strOption
    ( long "input"
        <> short 'i'
        <> metavar "FILE"
        <> help "Input file"
    )

out :: Parser FilePath
out =
  strOption
    ( long "output"
        <> short 'o'
        <> metavar "FILE"
        <> help "Output file"
    )
