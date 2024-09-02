(lambda n. ((fix (lambda f. (lambda p. (if fst p = 0 then fst (snd p) else f ((fst p) - 1, (snd (snd p), (fst (snd p)) + (snd (snd p)))))))) (n, (0, 1)))) 5
