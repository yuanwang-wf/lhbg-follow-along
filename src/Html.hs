module Html
  ( Html,
    Title,
    Structure,
    html_,
    p_,
    h_,
    h1_,
    render,
    ul_,
    ol_,
    code_,
    empty_,
    getStructureString,
  )
where

import Html.Internal
  ( Html,
    Structure,
    Title,
    code_,
    empty_,
    getStructureString,
    h1_,
    h_,
    html_,
    ol_,
    p_,
    render,
    ul_,
  )

-- replicate' :: Int -> a -> [a]
-- replicate' num a = if num <= 0 then [] else a : replicate' (num - 1) a
