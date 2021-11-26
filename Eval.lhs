

\documentclass[a4paper,11pt]{article}

\usepackage[margin=2.5cm]{geometry}
\usepackage{hyperref}

%include polycode.fmt
%format alpha = "\alpha"
%format Set.empty = "\emptyset"
%format `Set.union` = "\cup"
%format `Set.difference` = "~\backslash~"
%format Set.singleton n = "\{" n "\}"
%format <+> = "\left<+\right>"

\title{\bf Bidirectional Type Checking and Inference (Draft)}
\author{Isitha Subasinghe}
\date{26th November 2021 (Draft)}

\begin{document}
\maketitle

\begin{abstract}\noindent
Type theory is infamously considered difficult to get started in. 
There is simply too much to learn and this information is scattered all over the place. 
This paper addresses this issue by providing the basics for building a state of the art type inference and checking 
algorithm based on bidirectional type inference as described by Dunfield and Krishnaswami.
\end{abstract}

\section{Introduction}
Type inference is at the core of modern langauges, yet the knowledge to implement these algorithms are 
not easily accessible. Understanding type inference requires the reader to have a grasp of Type Theory, Set Theory, Lambda Calculus and 
First Order Logic, this paper aims to reduce the burden of learning type inference and provides a central location for a reader to understand enough of these concepts 
to get started on programming their own implementation of the previously mentioned type inference algorithm. 

\section{Related Work}
Hindley-Milner type inference, discovered by Hindley and Milner independently have two known algorithms for type inference, Algorithm W and Algorithm J, both of which require 
a certain cognitive effort by the reader.

\section{Setup}
Let's define a module called ``Eval'' used to contain our algorithm. This is a simple but necessary step for any Haskell program. 

> module Eval where 

In addition to the above code we need another module called ``Main'' to function as our entry point. We mostly don't have to worry about this Module, it is a simple interface to 
interact with the ``Eval'' module. 
\begin{verbatim}
module Main where
\end{verbatim}

\section{Lambda Calculus}
Knowledge of lambda calculus is required to understand some of the type theory needed to understand the paper referenced previously. Here we 
provide a quick, mediocre introduction to lambda calculus. Lambda Calculus is simply a mathematical model of expressing computation based on function abstraction and application. 
It is as poweful as turing completeness for the task of describing computation as noted in the Church-Turing thesis. Interestingly there seems to also be a relationship between lambda caclulus and proof theory 
as we can observe through the `Curry-Howard correspondence``, even more surprisingly, this observation can be extended to Category Theory as `Curry-Howard-Lambek correspondence`.

\subsection{$\alpha$ conversion}
$\alpha$ conversion is. 

\subsection{$\beta$ reductions}
$\beta$ reductions are 

\subsection{$\eta$ reductions}
$\eta$ reductions

\subsection{\bf{Simply Typed Lambda Calculus}}
Simply Typed Lambda Calculus can be given by the following grammar presented in BNF form. 
The data structures used for evaluating the presented lambda calculus is provided below.
\begin{code}

data T 
  = Var String 
  | Application T T 
  | TTrue 
  | TFalse
  | IfElse T T T
  deriving(Show, Eq)

data Type 
  = TBool 
  | TApp Type Type 
  deriving(Show, Eq)

\end{code}

Now we can finally start on type inference. The rule for infering a ``IfElse'' is provided below. 
Please note that the first ``T'' is obviously required to be of type ``Bool'' while the next two ``T''s are only constrained 
by the fact that they have to be the same type.

\begin{code}
inferType ctx (IfElse t1 t2 t3) = 
  case (inferType ctx t1, inferType ctx t2, inferType, t3) of 
    (Some TBool, Some ty2, Some ty3) => 
      if ty2 == ty3 then 
        Some ty2 
      else Nothing 
    _ => Nothing
\end{code}


\appendix 
\section{\bf{Appendix}}
\subsection{\bf{Notation}}

\end{document}
