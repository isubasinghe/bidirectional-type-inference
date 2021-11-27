

\documentclass[a4paper,11pt]{article}

\usepackage[margin=2.5cm]{geometry}
\usepackage{hyperref}
\usepackage[altpo]{backnaur}

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

\begin{code}
module Eval where 
import qualified Data.Set as S 
import qualified Data.Map as M
\end{code}

In addition to the above code we need another module called ``Main'' to function as our entry point. We mostly don't have to worry about this Module, it is a simple interface to 
interact with the ``Eval'' module. 
\begin{verbatim}
module Main where
\end{verbatim}

\section{Lambda Calculus}
Knowledge of lambda calculus is required to understand some of the type theory needed to understand the paper referenced previously. Here we 
provide a quick, mediocre introduction to lambda calculus. Lambda Calculus is simply a mathematical model of expressing computation based on function abstraction and application. 
It is as poweful as turing completeness for the task of describing computation as noted in the Church-Turing thesis. Interestingly, there seems to also be a relationship between lambda caclulus and proof theory 
as we can observe through the `Curry-Howard correspondence``, even more surprisingly, this observation can be extended to Category Theory as `Curry-Howard-Lambek correspondence`.

\subsection{$\alpha$ conversion}
$\alpha$ conversion is. 

\subsection{$\beta$ reductions}
$\beta$ reductions are 

\subsection{$\eta$ reductions}
$\eta$ reductions

\section{Set Theory}

\section{First Order Logic}

\section{Type Theory}


\section{\bf{Simply Typed Lambda Calculus}}
Simply Typed Lambda Calculus can be given by the following grammar presented in BNF form. 
\begin{bnf*}
  \bnfprod{\textit{t}}
  \bnfts{x} \bnfsk \bnfts{z} \bnftd{ -- Variables} \\ 
  \bnfmore \bnfor \bnfpn{\textit{t} \textit{t}} \bnftd{ -- Application} \\
  \bnfmore \bnfor \bnfpn{$\lambda$ x . \textit{t}} \bnftd{ -- Abstraction} \\ 
  \bnfmore \bnfor true \bnfor false \\ 
  \bnfmore \bnfor \textbf{if} \textit{ t } \textbf{then} \textit{ t } \textbf{else} \textit{ t } \\ 
  \bnfmore \bnfor t : \tau \\ 
  \bnfprod{$\tau$} 
  \bnfpn{Bool} \\ 
  \bnfmore \bnfor \bnfpn{$\tau \rightarrow \tau$} 
\end{bnf*}


The data structures used for evaluating the presented lambda calculus is provided below.
Note that the grammar has been slighly augmented 
to account for typing judgements, the constructor `TypeAnnotation` is this augmentation. 
\begin{code}

data T 
  = Var String 
  | Application T T 
  | TTrue --  Avoid conflict with Haskell's `True'
  | TFalse  --  Avoid conflict with Haskell's `False'
  | IfElse T T T -- If [Expr] Then [T1] Else [T2] where T1 == T2
  | TypeAnnotation T Type -- Type annotation to mark that `T' is of type `Type'
  deriving(Show, Eq)

data Type 
  = TBool 
  | TApp Type Type 
  deriving(Show, Eq)

\end{code}

Now we can finally start on type inference. First let's define our type signature for our inference function. 

\begin{code}
inferType :: M.Map String Type -> T -> Maybe Type
\end{code}
The above definition is quite simple, it defines a function that accepts a `Context' (`M.Map String Type'), an expression (`T') and returns an algebraic data structure wrapping a type(`Type'), this ADT is `Maybe Type'. The usage of the `Maybe' 
ADT is because the return value of the function could be nothing (`Nothing' is the function that constructs the Maybe ADT in this case) or something (`Just(x)' is the function that constructs the Maybe ADT in this case). 
This `Context' corresponds directly to the $\Gamma$ symbol seen in type theory literature. 
\paragraph{Note}
It is important to note two symbols that are needed to understand literature on bidirectional type inference/checking. 
\begin{itemize}
  \item $\Rightarrow$ This is used in the form of x $\Rightarrow$ ty, it means ``x is infered to be of type ty''.
  \item $\Leftarrow$ This is used in the form of x $\Leftarrow$ ty, it means "x type checks against type ty".
\end{itemize}
\paragraph{Variables}
Let's define the rule for synthesis of a type of a variable. 
$$\frac{(x : \tau) \in \Gamma}{\Gamma \vdash x \Rightarrow \tau }$$
This is quite simple to infer the type for, since the type annotation already exists in our context. 

> inferType ctx (Var s) = lookupTy s ctx

\paragraph{Booleans}
Another simple construct to type check are the boolean literals `true' and false'. The rules for inference are given below. 
$$\frac{}{\Gamma \vdash \textbf{true} \Rightarrow \textbf{Bool}}$$ \vspace{1pt}
$$\frac{}{\Gamma \vdash \textbf{false} \Rightarrow \textbf{Bool}}$$ 

The below code is all we need for dealing with boolean literals. 
\begin{code}
inferType ctx (TTrue) = Just TBool
inferType ctx (TFalse) = Just TBool
\end{code}
`lookupTy' is given by the below code:
\begin{code}
lookupTy :: String -> M.Map String Type -> Maybe Type
lookupTy x ctx = M.lookup x ctx
\end{code}

Finally we can define type checking by the simple function below:

\begin{code}
checkType :: M.Map String Type -> T -> Type -> Maybe Type 
checkType ctx t ty = case inferType ctx t of
                       Just ty' -> if ty' == ty then 
                                     Just ty' 
                                   else Nothing 
                       Nothing -> Nothing


\end{code}

\paragraph{Annotation}
Now we examine how we can verify type annotated expression. 
The grammar for inference/checking is shown below. 
$$\frac{\Gamma \vdash t \Leftarrow \tau}{\Gamma \vdash : \tau \Rightarrow}$$
\begin{code}
inferType ctx (TypeAnnotation t ty) = checkType ctx t ty
\end{code}

\paragraph{IfElse}
Here we observe how `IfElse' may be checked/infered. 
$$\frac{\Gamma \vdash t_1 \Leftarrow \textbf{Bool } \ \ \ \ \Gamma \vdash t_2 \Leftarrow \tau \ \ \ \ \Gamma \vdash t_3 \Leftarrow \tau}{\Gamma \vdash \textbf{if } t_1 \textbf{ then } t_2 \textbf{ else } t_3 \Leftarrow \tau }$$

\begin{code}
checkType ctx (IfElse t1 t2 t3) ty = 
  case ( checkType ctx t1 TBool
       , checkType ctx t2 ty
       , checkType ctx t3 ty) of 
         (Just bty, Just ty2, Just ty3) -> Just ty 
         _ -> Nothing
\end{code}

\appendix 
\section{\bf{Appendix}}
\subsection{\bf{Notation}}

\end{document}
