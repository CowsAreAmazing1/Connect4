

badsum :: Int -> Int
badsum 0 = 0
badsum n = n + badsum (n-1)