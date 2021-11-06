% gatechthesis class - for use in preparation of Theses and Dissertations at BYU
% Adapted from Georgia Tech thesis class, revised May 2020

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{byuthesis}[2021/11/01 BYU Tech MS/PhD Thesis Class]

% based on report class, so pass options to it
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}
\ProcessOptions\relax
\LoadClass{report}

% package imports - add your own in preamble to the document file with \usepackage{}
\RequirePackage{graphicx}  % for images and plots
\RequirePackage[letterpaper, left=1in, right=1in, top=1in, bottom=1in]{geometry}
\RequirePackage{multicol} % for multicolumn environments
\RequirePackage{setspace}  % use this package to set linespacing as desired
\RequirePackage{newtxtext} % use times new roman font
\RequirePackage{newtxmath}
\RequirePackage{booktabs}
\RequirePackage{indentfirst}
\RequirePackage[explicit]{titlesec}  % title control and formatting
\RequirePackage[titles]{tocloft}  % table of contents control and formatting
\RequirePackage{ifoddpage} % logical page parity checking, used with rotating
\RequirePackage{rotating}  % for rotated, landscape images
\RequirePackage[backend=biber,sorting=none,bibstyle=ieee]{biblatex}  % reference manager
\RequirePackage[toc,page]{appendix}  % for appendices
\RequirePackage[normalem]{ulem}  % for underlining text
\RequirePackage{url} % in case explicit URL's are needed
\RequirePackage{siunitx} % several functions related to expressing units
\RequirePackage[bookmarks=true,hidelinks]{hyperref} % should be last(ish)
\RequirePackage{bookmark} % allows reformatting of pdf bookmarks
\RequirePackage{caption} % captions for figures
\RequirePackage{subcaption} % allows subfigures in a reasonable way, plays nice with caption
\RequirePackage[acronym,nogroupskip,nopostdot]{glossaries} % only for list of acronyms
\RequirePackage{doi} % and this is laster, makes easier hyperlinking for doi sources

\parindent=0.25in

\sisetup{
    sticky-per=true,
    detect-mode=true,
    per-mode = symbol-or-fraction
}

\doublespacing  % set line spacing
\AtBeginDocument{\renewcommand{\ref}[1]{\autoref{#1}}} % for concision, but can be removed if you know what you're doing
\makeglossaries % process glossaries
\urlstyle{same} % uses the text font, not a monospace one, for URLs
\hbadness=9000 % suppress some hbox warnings
\setcounter{biburlnumpenalty}{99999} % ensure bibliography URLs don't run far outside margins)

% hyperlink coloring, or lack thereof
\hypersetup{
    colorlinks,
    linkcolor={black},
    citecolor={black},
    urlcolor={black}
}

\makeatletter

% formatting of chapter numbers in bookmarks
\bookmarksetup{%
    depth=1, % bookmark depth - 1 goes to section depth, 2 to subsection, etc.
    addtohook={%
    \ifnum 0=\bookmarkget{level}\relax
      \renewcommand*{\numberline}[1]{#1 | }%
    \fi
    \ifnum 0<\bookmarkget{level}\relax
      \renewcommand*{\numberline}[1]{}%
    \fi
    }
}

% so that using ref with algorithms works correctly
\newcommand{\ALC@uniqueautorefname}{Line}
\newcommand{\algorithmautorefname}{Algorithm}

% set up rotatepage environment - this will make landscape figures with awareness of page parity and whether the document is set up as single- or two-sided
\@ifclasswith{report}{twoside}{%
    \newenvironment{rotatepage}{%
        \checkoddpage\ifoddpage
            \clearpage\pagebreak[4]\global\pdfpageattr\expandafter{\the\pdfpageattr/Rotate 270}%
        \else
            \clearpage\pagebreak[4]\global\pdfpageattr\expandafter{\the\pdfpageattr/Rotate 90}%
        \fi
        }%
        {\clearpage\pagebreak[4]\global\pdfpageattr\expandafter{\the\pdfpageattr/Rotate 0}}%
    }{
    \newenvironment{rotatepage}%
        {\clearpage\pagebreak[4]\global\pdfpageattr\expandafter{\the\pdfpageattr/Rotate 90}}%
        {\clearpage\pagebreak[4]\global\pdfpageattr\expandafter{\the\pdfpageattr/Rotate 0}}%
    }

% tokens for author info
\newcommand{\doctype}[1]{\gdef\@doctype{#1}}
\newcommand{\degree}[1]{\gdef\@degree{#1}}
\newcommand{\keywords}[1]{\gdef\@keywords{#1}}
\newcommand{\committeeMembers}[1]{\gdef\@committeeMembers{#1}}
\newcommand{\approvaldate}[1]{\gdef\@approvaldate{#1}}%
\newcommand{\@approvaldate}{\@latex@warning@no@line{No \noexpand\approvaldate given}}
\newcommand{\department}[1]{\gdef\@department{#1}}%
\newcommand{\@department}{\@latex@warning@no@line{No \noexpand\department given}}
\makeatother

% frontmatter environment, only handles title formatting
\newenvironment{frontmatter}{%
    \cleardoublepage
    \pagestyle{plain}
    \titleformat{\chapter}[display]{\normalfont\filcenter}{\chaptertitlename\ \thechapter}{0pt}{\MakeUppercase{##1}}
    \titlespacing*{\chapter}
      {0pt}{0pt}{30pt}	% controls vertical margins on title
}%
{%
    \clearpage
}

% thesisbody environment, handles text and other formatting
\newenvironment{thesisbody}{%
    \cleardoublepage
    \pagestyle{plain}
    \pagenumbering{arabic} % resumes page numbering after front matter
    \setcounter{page}{1} % set the page number appropriately
    \titleformat{\chapter}{\normalfont\bfseries}{\thechapter}{1em}{\MakeUppercase{##1}}  % spacing between titles
    \titlespacing*{\chapter}
      {0.25in}{1in}{1in}	% controls vertical margins on title
    \titleformat{\section}{\normalfont\bfseries}{\thesection}{1em}{##1}
    \titleformat{\subsection}{\normalfont\bfseries}{\thesubsection}{1em}{##1}
    \titleformat{\subsubsection}{\normalfont\itshape}{\thesubsection}{1em}{##1}
}%
{
    \cleardoublepage
}

% ------------------ Title Page ------------------
\makeatletter
% args:{year}
\newcommand{\makeTitlePage}[1]{
    \pagestyle{empty}
    \pagenumbering{roman}
    \currentpdfbookmark{Title Page}{titlePage}
    \phantomsection
    \begin{center}
    \@title\\
    \begin{singlespacing}
    \vspace{3\baselineskip}
    \@author\\
    \vspace{3\baselineskip}
    A \@doctype \ submitted to the faculty of\\
    Brigham Young University\\
    In partial fulfillment of the Requirements for the degree of\\
    \vspace{1\baselineskip}
    \@degree\\
    \vfill
    \@committeeMembers\\
    \vspace{6\baselineskip}
    \@department\\
    \vspace{\baselineskip}
    Brigham Young University\\
    \vfill
    Copyright \copyright \ #1 \ \@author \\
    All Rights Reserved
    \end{singlespacing}
    \end{center}
}


% ------------------- Abstract Page ------------------
\renewenvironment{abstract}{%
  \cleardoublepage
  \pagestyle{empty}
  \begin{singlespacing}
  \setlength{\parskip}{1em}
  \begin{center}
    \MakeUppercase{abstract}\\
    \vspace{\baselineskip}
    \@title\\
    \vspace{\baselineskip}
    \@author\\
    \@department, BYU\\
    \@degree\\
    \vspace{\baselineskip}
  \end{center}\hspace{\parindent}
}{
  \vfill
  \noindent Keywords: \@keywords
  \end{singlespacing}
  \setlength{\parskip}{0em}

}


\makeatother

% ------------------ Acknowledgments environment/formatting ------------------
\newenvironment{acknowledgments}
{
    \cleardoublepage
    \phantomsection
    \addcontentsline{toc}{chapter}{Acknowledgments}
    \begin{centering}
    ACKNOWLEDGMENTS\\
    \vspace{\baselineskip}
    \end{centering}
}
{
    \clearpage
}

% --------------- table of contents formatting and command creation ---------------
\renewcommand{\cftchapdotsep}{\cftdotsep}  % add dot separators
\renewcommand{\cftchapfont}{\bfseries}  % set title font weight
\renewcommand{\cftchappagefont}{}  % set page number font weight
\renewcommand{\cftchappresnum}{Chapter }
\renewcommand{\cftchapaftersnum}{:}
\renewcommand{\cftchapnumwidth}{5em}
\renewcommand{\cftchapafterpnum}{\vskip\baselineskip} % set correct spacing for entries in single space environment
\renewcommand{\cftsecafterpnum}{\vskip\baselineskip}  % set correct spacing for entries in single space environment
\renewcommand{\cftsubsecafterpnum}{\vskip\baselineskip} % set correct spacing for entries in single space environment
\renewcommand{\cftsubsubsecafterpnum}{\vskip\baselineskip} % set correct spacing for entries in single space environment
\newcommand{\makeTOC}{
    % format title font size and position (this also applies to list of figures and list of tables)
    \currentpdfbookmark{Table of Contents}{TOC}
    \renewcommand\contentsname{Table of Contents}
    \begin{singlespace}
    \tableofcontents
    \end{singlespace}
    \clearpage
}

% ------------------ List of Tables ------------------
\newcommand{\makeListOfTables}{
\phantomsection
\addcontentsline{toc}{chapter}{List of Tables}
\begin{singlespace}
\setlength\cftbeforetabskip{\baselineskip}  % manually set spacing between entries
\listoftables
\end{singlespace}
\clearpage
}

% ------------------ List of Figures ------------------
\newcommand{\makeListOfFigures}{
\phantomsection
\addcontentsline{toc}{chapter}{List of Figures}
\begin{singlespace}
\setlength\cftbeforefigskip{\baselineskip}  % manually set spacing between entries
\listoffigures
\end{singlespace}
\clearpage
}

% ------------------ List of Acronyms ------------------
\newcommand{\makeListOfAcronyms}{
\phantomsection
\singlespacing
\addcontentsline{toc}{chapter}{List of Acronyms}
\printacronyms[nonumberlist,title={List of Acronyms}]
\clearpage
\doublespacing
}

% ------------------ appendix environment definition ------------------
% A note on layout: in the Chicago (and by extension IEEE) style manual, appendices are first in the end matter, then bibliography or references. In APA, bibliography is first, then appendices. The thesis manual on which this template is based assumes the Chicago convention.

% remove the page number on the appendices cover and move bookmark up the page, create a group-subgroup structure for the appendices in the TOC/bookmarks
\makeatletter
\newenvironment{theappendices}{
    \bookmarksetup{depth=0,open}
    \addtocontents{toc}{\setcounter{tocdepth}{1}}
    \renewcommand{\@chap@pppage}{%
        \clear@ppage
        \addappheadtotoc
        \thispagestyle{empty}%
        \if@twocolumn\onecolumn\@tempswatrue\else\@tempswafalse\fi
        \null\vfil
        \markboth{}{}%
        {\centering
        \interlinepenalty \@M
        \normalfont
        \Huge \bfseries \appendixpagename\par}%
        \if@dotoc@pp
        \fi
    }
    \bookmarksetupnext{level=part}
    \begin{appendices}
    \addtocontents{toc}{\protect\renewcommand{\protect\cftsecpresnum}{\appendixname\space}}
    \addtocontents{toc}{\protect\renewcommand{\protect\cftsecnumwidth}{5.75em}}
    \addtocontents{toc}{\protect\renewcommand{\protect\cftsecaftersnum}{:}}
    \addtocontents{toc}{%
    \begingroup
        \let\protect\l@chapter\protect\l@section
        \let\protect\l@section\protect\l@subsection
    }
}{
    \addtocontents{toc}{\endgroup}
    \end{appendices}
}
\makeatother

% ------------------ bibliography formatting and command creation ------------------

% I am only leaving these \AtEveryBibitem lines in because they were in the original template when I downloaded it. Change these at your own leisure.

% prevent certain fields in references from printing in bibliography
\AtEveryBibitem{\clearfield{issn}}
\AtEveryBibitem{\clearlist{issn}}
\AtEveryBibitem{\clearfield{language}}
\AtEveryBibitem{\clearlist{language}}
\AtEveryBibitem{\clearfield{doi}}
\AtEveryBibitem{\clearlist{doi}}
\AtEveryBibitem{\clearfield{url}}
\AtEveryBibitem{\clearlist{url}}
\AtEveryBibitem{%
\ifentrytype{online}{}
    {\clearfield{urlyear}\clearfield{urlmonth}\clearfield{urlday}}}

\newcommand{\makeBibliography}{
    \clearpage
    \bookmarksetupnext{level=part}
    \phantomsection
    \addcontentsline{toc}{chapter}{References}
    \begin{centering}
    \textbf{REFERENCES}\\
    \end{centering}
    \begin{singlespace}  % use single-line spacing for multi-line text within a single reference
    \setlength\bibitemsep{\baselineskip}  % manually set separation between items in bibliography to double space
    \printbibliography[heading=none]
    \end{singlespace}
}

% ------------------ vita environment ------------------
\newenvironment{vita}{
    \bookmarksetupnext{level=part}
    \chapter*{Vita}
    \addcontentsline{toc}{chapter}{Vita}
}{
}
