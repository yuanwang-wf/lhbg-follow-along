module Main where

import Convert
import Html
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
    askP action = do
      content <- getContents
      if content == "yes" then action else putStrLn "stop"

myhtml :: Html
myhtml =
  html_
    "My title"
    ( h1_ "Heading"
        <> ( p_ "Paragraph #1"
               <> p_ "Paragraph #3"
           )
    )
