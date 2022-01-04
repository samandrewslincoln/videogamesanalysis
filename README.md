# videogamesanalysis
This project looks at language in video games forums, analysing the propensity for extremism. 

The project uses data drawn from pushshift.io, and uses R for anlaysis. R packages used include tidytext and the tidyverse.

API Iterations.r contains the code used to draw data from the pushshift.io API. It is a simple R function that uses the jsonlite package.

The file tidyLexNew.csv contains a lexicon of extreme language, based on Farrell et. al.’s work - see https://dl.acm.org/doi/10.1145/3292522.3326045.

The file VideoGamesAnalysis.r has the code used for running the analysis. 




