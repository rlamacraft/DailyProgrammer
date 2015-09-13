quickSort :: [Float] -> [Float]
quickSort (n)
  | length n < 2    = n
  | otherwise       = quickSort (filterList n (<pivot)) ++ [ pivot ] ++ quickSort (filterList n (>pivot)) where
      pivot = head n
      filterList list condition = filter condition list
