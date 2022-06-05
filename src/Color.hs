-- | https://lhbg-book.link/04-markup/04-parsing_02.html
module Color where

import Data.Maybe (isNothing, listToMaybe)
import Data.Word (Word8)

-- | A data type representing colors
data Color
  = RGB Word8 Word8 Word8

getBluePart :: Color -> Word8
getBluePart color =
  case color of
    RGB _ _ blue -> blue

data Brightness
  = Dark
  | Bright

data EightColor
  = Black
  | Red
  | Green
  | Yellow
  | Blue
  | Magenta
  | Cyan
  | White

data AnsiColor
  = AnsiColor Brightness EightColor

ansiColorToVGA :: AnsiColor -> Color
ansiColorToVGA ansicolor =
  case ansicolor of
    AnsiColor Dark Black ->
      RGB 0 0 0
    AnsiColor Bright Black ->
      RGB 85 85 85
    AnsiColor Dark Red ->
      RGB 170 0 0
    AnsiColor Bright Red ->
      RGB 255 85 85
    _ -> undefined

-- and so on

isBright :: AnsiColor -> Bool
isBright (AnsiColor Bright _) = True
isBright _ = False

-- https://en.wikipedia.org/wiki/ANSI_escape_code#3-bit_and_4-bit
ansiToUbuntu :: AnsiColor -> Color
ansiToUbuntu ansicolor =
  case ansicolor of
    AnsiColor Dark Black ->
      RGB 1 1 1
    AnsiColor Bright Black ->
      RGB 128 128 128
    AnsiColor Dark Red ->
      RGB 170 0 0
    AnsiColor Bright Red ->
      RGB 255 85 85
    _ -> undefined

isEmpty :: [a] -> Bool
isEmpty = isNothing . listToMaybe

isEmpty' :: [a] -> Bool
isEmpty' ls =
  case ls of
    [] -> True
    _ -> False
