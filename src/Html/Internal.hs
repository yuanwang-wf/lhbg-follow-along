module Html.Internal where

import GHC.Natural (Natural)

newtype Html
  = Html String

newtype Structure
  = Structure String

type Title =
  String

html_ :: Title -> Structure -> Html
html_ title content =
  Html
    ( el
        "html"
        ( el "head" (el "title" (escape title))
            <> el "body" (getStructureString content)
        )
    )

p_ :: String -> Structure
p_ = Structure . el "p" . escape

h_ :: Natural -> String -> Structure
h_ n = Structure . el ("h" <> show n) . escape

h1_ :: String -> Structure
h1_ = h_ 1

el :: String -> String -> String
el tag content =
  "<" <> tag <> ">" <> content <> "</" <> tag <> ">"

getStructureString :: Structure -> String
getStructureString content =
  case content of
    Structure str -> str

instance Semigroup Structure where
  s1 <> s2 = Structure (getStructureString s1 <> getStructureString s2)

instance Monoid Structure where
  mempty = empty_

render :: Html -> String
render html =
  case html of
    Html str -> str

escape :: String -> String
escape =
  let escapeChar c =
        case c of
          '<' -> "&lt;"
          '>' -> "&gt;"
          '&' -> "&amp;"
          '"' -> "&quot;"
          '\'' -> "&#39;"
          _ -> [c]
   in concatMap escapeChar

ul_ :: [Structure] -> Structure
ul_ = Structure . el "ul" . concatMap li_
  where
    li_ = el "li" . getStructureString

ol_ :: [Structure] -> Structure
ol_ = Structure . el "ol" . concatMap li_
  where
    li_ = el "li" . getStructureString

code_ :: String -> Structure
code_ = Structure . el "pre" . escape

empty_ :: Structure
empty_ = Structure ""
