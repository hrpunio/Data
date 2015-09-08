\documentclass[a4paper]{article}
\usepackage{url}
\usepackage[utf8]{inputenc}
\usepackage{fancyvrb}
\usepackage{hyperref}
\addtolength{\textheight}{1cm}

\title{Posłowie na Sejm RP 7 kadencji wg stażu}
\author{Tomasz Przechlewski}
\begin{document}
\maketitle

\section{Dane}
Plik \url{sejm7_wg_stazu_wieku.csv} zawiera m.in. informacja o~liczbie kadencji (staż)
na jaką został wybrany poseł (kolumna \texttt{kadencje}). 
Wartość minimalna w~tej kolumnie wynosi $1$ dla posła wybranego po raz pierwszy do Sejmu~7 kadencji.

<<>>=
library(ggplot2);
## Pierszy wiersz pliku CSV: imnz;rokur;klub;kadencje
poslowie <- read.csv("sejm7_wg_stazu_wieku.csv", sep = ';',  header=T);
@ %def 

%Dane zostały pobrane ze strony \url{http://www.sejm.gov.pl/Sejm7.nsf/poslowie.xsp}.

\section{Staż posłów wybranych do Sejmu}

Posłowie~7 kadencji wg.~średniego stażu (w~podziale wg przynależności klubowej):

<<>>= 
tapply (poslowie$kadencje, poslowie$klub, mean);
# http://ww2.coastal.edu/kingw/statistics/R-tutorials/descriptive.html
table(poslowie$klub, poslowie$kadencje)
@ %def

Średni staż posłów w~poszczególnych klubach przedstawia rysunek~\ref{srstaz}

\begin{figure}[!tbh]
<<label=srstaz,fig=true, echo=T, height=5, width=7 >>=
p0 <- ggplot(data=poslowie,aes(klub,kadencje))+geom_boxplot()
print(p0);
@ %def
\caption{Średni staż posłów (wykres pudełkowy) \label{srstaz}}
\end{figure}


%%
\section{Wiek a liczba kadencji posłów do Sejmu}

Wiek posłów jest liczony jako różnica między rokiem 2011, w~którym odbyły się wybory, a~rokiem urodzenia.
Na rysunku~\ref{wiekstazalt} przedstawiono zależność pomiędzy liczbą kadencji (łącznie z~tą, na którą poseł
został wybrany) a~wiekiem posła.

\begin{figure}[!tbh]
<<label=wiekstazalt,fig=true, echo=T, width=7>>=
p1 <- qplot(kadencje, wiek, data=poslowie, facets= klub ~ ., 
             position = position_jitter(w = 0.2, h = 0.2) );
print(p1);
@ %def
\caption{Zależność między wiekiem a liczbą kadencji\label{wiekstazalt}}
\end{figure}

Rysunek~\ref{wiekstazaltalt} przedstawia to samo co~rysunek~\ref{wiekstazalt} tylko wyłączono
parametr \texttt{jitter}. Pozostawiamy czytelnikowi decyzję, która wersja jest bardziej zrozumiała.

\begin{figure}[!tbh]
<<label=wiekstazaltalt,fig=true, echo=F, width=7>>=
p2 <- qplot(kadencje, wiek, data=poslowie, facets= klub ~ ., );
print(p2);
@ %def
\caption{Zależność między wiekiem a liczbą kadencji \label{wiekstazaltalt}}
\end{figure}

Rysunek~\ref{wiekstaz} zawiera 
wszystkie dane z~rysunków~\ref{wiekstazalt} na jednym wykresie. Poszczególne
kluby są oznaczone kolorami i~różnymi symbolami. Rysunek jest nieczytelny -- zawiera zbyt dużo danych.

\begin{figure}[!tbh]
<<label=wiekstaz,fig=true, echo=T, width=7 >>=
p3 <- qplot(wiek, kadencje, data=poslowie, shape=klub, color=klub, 
            position = position_jitter(w = 0.2, h = 0.2));
print(p3);
@ %def
\caption{Zależność między wiekiem a liczbą kadencji\label{wiekstaz}}
\end{figure}

\end{document}
