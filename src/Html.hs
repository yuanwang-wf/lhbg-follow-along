module Html
  ( Html,
    Title,
    Structure,
    html_,
    p_,
    h1_,
    render,
    ul_,
    ol_,
    code_,
  )
where

import Html.Internal
  ( Html,
    Structure,
    Title,
    code_,
    h1_,
    html_,
    ol_,
    p_,
    render,
    ul_,
  )

-- replicate' :: Int -> a -> [a]
-- replicate' num a = if num <= 0 then [] else a : replicate' (num - 1) a

even' :: Int -> Bool
even' 0 = True
even' n = odd' (n -1)

odd' :: Int -> Bool
odd' 0 = False
odd' n = even' (n -1)
