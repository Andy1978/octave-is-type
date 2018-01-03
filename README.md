  // einfach mal alle "is"
  // egrep "bool is_[a-z_]* (void)" libinterp/octave-value/ov.h | sed s/bool//g
  
  
  
  
\documentclass{article}
\usepackage{array,graphicx}
\usepackage{booktabs}
\usepackage{pifont}

\newcommand*\rot{\rotatebox{90}}
\newcommand*\OK{\ding{51}}

\begin{document}

\begin{table} \centering
    \begin{tabular}{@{} cl*{10}c @{}}
        & & \multicolumn{10}{c}{Knowledge Areas} \\[2ex]
        & & \rot{Integration} & \rot{Scope} & \rot{Time} & \rot{Cost} 
        & \rot{Quality} & \rot{Human Resource} & \rot{Communication} 
        & \rot{Risk} & \rot{Procurement} & \rot{\shortstack[l]{Stakeholder\\Management}} \\
        \cmidrule{2-12}
        %insert here
        & Initiating             & \OK &   &   &   &   &   & \OK &   &   & \OK \\
        & Planning               & \OK & \OK & \OK & \OK & \OK & \OK & \OK & \OK & \OK & \OK \\
        & Executing              & \OK &   &   &   & \OK & \OK & \OK &   & \OK & \OK \\
        & Monitoring and Control & \OK & \OK & \OK & \OK & \OK &   & \OK & \OK & \OK & \OK \\
 \rot{\rlap{~Processes}}
        & Closing                & \OK &   &   &   &   &   & \OK &   & \OK & \OK \\
        \cmidrule[1pt]{2-12}
    \end{tabular}
    \caption{Some caption}
\end{table}

\end{document}
