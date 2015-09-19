quickSort :: [Float] -> [Float]
quickSort (n)
  | length n < 2    = n
  | otherwise       = quickSort (filter (<pivot) n ) ++ [ pivot ] ++ quickSort (filter (>pivot) n ) where
      pivot = head n
