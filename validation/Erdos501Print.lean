import Flypitch4.Erdos501.Sentence
import Flypitch4.PrintFormula

/-!
Pretty-print the building blocks of `Erdos501_f` (run with `lake env lean validation/Erdos501Print.lean`).
Free variables are the de Bruijn levels `0, 1, 2, …`, printed as `x1, x2, x3, …`.
-/

open Flypitch.Erdos501

/-- print a depth-polymorphic formula with `n` free variables `x1 … xn` (levels `0 … n-1`) -/
def pr (φ : Fm) (n : ℕ) : IO Unit := IO.println (str_formula (φ n) n ++ "\n")

-- x1 = n, x2 = m :  m = n ∪ {n}
#eval pr (succF (varT 0) (varT 1)) 2
-- x1 = lt, x2 = x, x3 = y
#eval pr (ltF (varT 0) (varT 1) (varT 2)) 3
#eval pr (leF (varT 0) (varT 1) (varT 2)) 3
-- x1 = f, x2 = x, x3 = y
#eval pr (appF (varT 0) (varT 1) (varT 2)) 3
-- x1 = op, x2 = x, x3 = y, x4 = z
#eval pr (app2F (varT 0) (varT 1) (varT 2) (varT 3)) 4
-- x1 = dom, x2 = cod, x3 = f
#eval pr (isFunF (varT 0) (varT 1) (varT 2)) 3
-- x1 = R, x2 = op
#eval pr (isOp2F (varT 0) (varT 1)) 2
-- x1 = R, x2 = lt, x3 = S
#eval pr (BoundedF (varT 0) (varT 1) (varT 2)) 3
-- x1 = X
#eval pr (InfiniteF (varT 0)) 1
-- x1 = A, x2 = X
#eval pr (IndependentF (varT 0) (varT 1)) 2
-- x1 = R, x2 = plus, x3 = lt, x4 = zero, x5 = one, x6 = S
#eval pr (OuterMeasureLtOneF (varT 0) (varT 1) (varT 2) (varT 3) (varT 4) (varT 5)) 6
-- x1 = R, x2 = plus, x3 = times, x4 = lt, x5 = zero, x6 = one
#eval pr (CompleteOrderedFieldF (varT 0) (varT 1) (varT 2) (varT 3) (varT 4) (varT 5)) 6
-- x1 = R, x2 = plus, x3 = lt, x4 = zero, x5 = one
#eval pr (ErdosPropertyF (varT 0) (varT 1) (varT 2) (varT 3) (varT 4)) 5
-- the whole sentence: number of characters of its printed form
#eval IO.println s!"|Erdos501_f| = {(print_formula Erdos501_f).length} characters"
