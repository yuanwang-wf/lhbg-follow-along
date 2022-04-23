module Main where

main :: IO ()
main = putStrLn $ makeHtml "My page title" "My page content"

makeHtml :: String -> String -> String
makeHtml title content = html_  (head_ (title_ title) <> body_ ( h1_ (p_ content)))

html_ :: String -> String
html_ = el "html"

head_ :: String -> String
head_ = el "head"

title_ :: String -> String
title_ = el "title"

body_ :: String -> String
body_ = el "body"

p_ :: String -> String
p_ = el "p"

h1_ :: String -> String
h1_ = el "h1"

el :: String -> String -> String
el tag content =
  "<" <> tag <> ">" <> content <> "</" <> tag <> ">"
