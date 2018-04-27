{-# LANGUAGE Safe #-}
-- Definiujemy moduł zawierający rozwiązanie.
-- Należy zmienić nazwę modułu na {Imie}{Nazwisko}Compiler gdzie
-- za {Imie} i {Nazwisko} należy podstawić odpowiednio swoje imię
-- i nazwisko zaczynające się wielką literą oraz bez znaków diakrytycznych.
module LukaszKlasinskiCompiler(compile) where

import AST
import MacroAsm

--
-- WERSJA 4
--

-- Funkcja kompilująca program
-- Dla pracowni nr 4 należy zignorować pierwszy argument
-- UWAGA: to nie jest jeszcze rozwiązanie; należy zmienić jej definicje
compile :: [FunctionDef p] -> [Var] -> Expr p -> [MInstr]
compile _ vars expr = fst(compile' vars expr 0 0) ++ [MRet]

-- zmienne -> expr -> padding dla zmiennych -> nr etykiery -> ([instrukcje], nowy nr etykiety)
compile' :: [Var] -> Expr p -> Int -> Int -> ([MInstr],Int)
compile' vars (EVar p var) pd l = ([getVarNum vars var 0 pd],l)
compile' vars (ENum p val) pd l = ([MConst val],l)
compile' vars (EBool p val) pd l = if(val == True) then ([MConst 1],l)
                                   else ([MConst 0],l)
compile' vars (EUnary p UNot p1) pd l     = let c = (compile' vars p1 pd l) in
                                            ((fst c) ++ [MNot], snd c)
compile' vars (EUnary p UNeg p1) pd l     = let c = (compile' vars p1 pd l) in
                                            ((fst c) ++ [MNeg], snd c)
-- obliczamy lewa czesc, wrzucamy na stos i wykonujemy dzialanie na prawej czesci
compile' vars (EBinary p BAdd p1 p2) pd l = ((fst c1)++ [MPush] ++ (fst c2) ++ [MAdd], snd c2)
                                            where c1 = (compile' vars p1 pd l)
                                                  c2 = (compile' vars p2 (pd+1) (snd c1))
compile' vars (EBinary p BSub p1 p2) pd l = ((fst c1)++ [MPush] ++ (fst c2) ++ [MSub], snd c2)
                                            where c1 = (compile' vars p1 pd l)
                                                  c2 = (compile' vars p2 (pd+1) (snd c1))
compile' vars (EBinary p BMul p1 p2) pd l = ((fst c1)++ [MPush] ++ (fst c2) ++ [MMul], snd c2)
                                            where c1 = (compile' vars p1 pd l)
                                                  c2 = (compile' vars p2 (pd+1) (snd c1))
compile' vars (EBinary p BDiv p1 p2) pd l = ((fst c1)++ [MPush] ++ (fst c2) ++ [MDiv], snd c2)
                                            where c1 = (compile' vars p1 pd l)
                                                  c2 = (compile' vars p2 (pd+1) (snd c1))
compile' vars (EBinary p BMod p1 p2) pd l = ((fst c1)++ [MPush] ++ (fst c2) ++ [MMod], snd c2)
                                            where c1 = (compile' vars p1 pd l)
                                                  c2 = (compile' vars p2 (pd+1) (snd c1))
compile' vars (EBinary p BAnd p1 p2) pd l = ((fst c1)++ [MPush] ++ (fst c2) ++ [MAnd], snd c2)
                                            where c1 = (compile' vars p1 pd l)
                                                  c2 = (compile' vars p2 (pd+1) (snd c1))
compile' vars (EBinary p BOr p1 p2) pd l  = ((fst c1)++ [MPush] ++ (fst c2) ++ [MOr] , snd c2)
                                            where c1 = (compile' vars p1 pd l)
                                                  c2 = (compile' vars p2 (pd+1) (snd c1))
-- obliczamy lewa i prawa czesc i tworzymy brancha czy nadac true albo false
compile' vars (EBinary p BEq p1 p2) pd l = ((fst c1)++ [MPush] ++ (fst c2) ++ 
                                            [(MBranch MC_EQ (snd c2)),(MConst 0),(MJump ((snd c2)+1)),(MLabel (snd c2)),
                                             (MConst 1),(MLabel ((snd c2)+1))], ((snd c2)+2))
                                            where c1 = (compile' vars p1 pd l)
                                                  c2 = (compile' vars p2 (pd+1) (snd c1))
compile' vars (EBinary p BNeq p1 p2) pd l = ((fst c1)++ [MPush] ++ (fst c2) ++ 
                                            [(MBranch MC_NE (snd c2)),(MConst 0),(MJump ((snd c2)+1)),(MLabel (snd c2)),
                                             (MConst 1),(MLabel ((snd c2)+1))], ((snd c2)+2))
                                            where c1 = (compile' vars p1 pd l)
                                                  c2 = (compile' vars p2 (pd+1) (snd c1))
compile' vars (EBinary p BLt p1 p2) pd l = ((fst c1)++ [MPush] ++ (fst c2) ++ 
                                            [(MBranch MC_LT (snd c2)),(MConst 0),(MJump ((snd c2)+1)),(MLabel (snd c2)),
                                             (MConst 1),(MLabel ((snd c2)+1))], ((snd c2)+2))
                                            where c1 = (compile' vars p1 pd l)
                                                  c2 = (compile' vars p2 (pd+1) (snd c1))
compile' vars (EBinary p BGt p1 p2) pd l = ((fst c1)++ [MPush] ++ (fst c2) ++ 
                                            [(MBranch MC_GT (snd c2)),(MConst 0),(MJump ((snd c2)+1)),(MLabel (snd c2)),
                                             (MConst 1),(MLabel ((snd c2)+1))], ((snd c2)+2))
                                            where c1 = (compile' vars p1 pd l)
                                                  c2 = (compile' vars p2 (pd+1) (snd c1))
compile' vars (EBinary p BLe p1 p2) pd l = ((fst c1)++ [MPush] ++ (fst c2) ++ 
                                            [(MBranch MC_LE (snd c2)),(MConst 0),(MJump ((snd c2)+1)),(MLabel (snd c2)),
                                             (MConst 1),(MLabel ((snd c2)+1))], ((snd c2)+2))
                                            where c1 = (compile' vars p1 pd l)
                                                  c2 = (compile' vars p2 (pd+1) (snd c1))
compile' vars (EBinary p BGe p1 p2) pd l = ((fst c1)++ [MPush] ++ (fst c2) ++ 
                                            [(MBranch MC_GE (snd c2)),(MConst 0),(MJump ((snd c2)+1)),(MLabel (snd c2)),
                                             (MConst 1),(MLabel ((snd c2)+1))], ((snd c2)+2))
                                            where c1 = (compile' vars p1 pd l)
                                                  c2 = (compile' vars p2 (pd+1) (snd c1))

compile' vars (EIf p p1 p2 p3) pd l = ((fst c1) ++ [(MBranch MC_Z (snd c1))] ++ (fst c2) ++ [(MJump (snd c2)),
                                                    (MLabel (snd c1))] ++ (fst c3) ++ [(MLabel (snd c2))], (snd c3))
                                            where c1 = (compile' vars p1 pd l)
                                                  c2 = (compile' vars p2 pd ((snd c1)+1))
                                                  c3 = (compile' vars p3 pd ((snd c2)+1))

compile' vars (ELet p var p1 p2) pd l = ((fst c1) ++ [(fst setvar)] ++ (fst c2), (snd c2))
                                            where c1 = (compile' vars p1 pd l)
                                                  setvar = (setVar vars vars var 0 pd)
                                                  c2 = (compile' (snd setvar) p2 pd (snd c1))

-- zaktualizuj/utworz zmienna
setVar :: [Var] -> [Var] -> Var -> Int -> Int -> (MInstr,[Var])
setVar [] tbl var n pd = (MPush,(var:tbl))
setVar (x:xs) tbl var n pd = if(x == var) then
                               ((MSetLocal (n+pd)),tbl)
                             else setVar xs tbl var (n+1) pd
-- pobierz wartosc zmiennej
getVarNum :: [Var] -> Var -> Int -> Int -> MInstr
getVarNum (x:xs) var n pd = if(x == var) then
                              (MGetLocal (n+pd))
                            else getVarNum xs var (n+1) pd
