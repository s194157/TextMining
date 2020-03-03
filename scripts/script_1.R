#włączenie bibliotek
library(tm)

#zmiana katalogu roboczego
workDir <- "D:\\BO_WZISS22412IS\\PJN\\TextMining"
setwd(workDir)

#definicja katalogów projektu
inputDir <- ".\\data"
outputDir <- ".\\results"
scriptDir <- ".\\scripts"
workspaceDir <- ".\\workspaces"

#utworzenie katalogu wyjściowego
dir.create(outputDir, showWarnings = FALSE)
dir.create(workspaceDir, showWarnings = FALSE)

#uworzenie korspusu dokumentów
corpusDir <- paste(
  inputDir,
  "\\",
  "Literatura - streszczenia - oryginał",
  sep = ""
  )
corpus <- VCorpus(
  DirSource(
    corpusDir, 
    pattern = "*.txt",
    encoding = "UTF-8"
    ),
  readerControl = list(
    language = "pl_PL"
  )
)

#wstępne przerwarzanie
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, content_transformer(tolower))
stoplistFile <- paste(
  inputDir,
  "\\",
  "stopwords_pl.txt",
  sep = ""
)
stoplist <- readLines(
  stoplistFile,
  encoding = "UTF-8"
)
corpus <- tm_map(corpus, removeWords, stoplist)
corpus <- tm_map(corpus, stripWhitespace)

writeLines(as.character(corpus[[1]]))  
  