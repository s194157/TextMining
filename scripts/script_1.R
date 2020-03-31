#włączenie bibliotek
library(tm)
library(hunspell)
library(stringr)

#zmiana katalogu roboczego
workDir <- "C:\\Users\\BartekO\\PJN\\TextMining"
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
  "Literatura - streszczenia - orygina?",
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


removeChar <- content_transformer(
  function(x, pattern, replacement) 
  gsub(pattern, replacement, x)
  )

#usuni?cie "em dash" i 3/4 z tekst?w
corpus <- tm_map(corpus, removeChar, intToUtf8(8722), "")
corpus <- tm_map(corpus, removeChar, intToUtf8(190), "")

#lematyzacja - sprowadzenie do formy podstawowej
polish <- dictionary (lang = "pl_PL")

lemmatize <- function(text) {
  simpleText <- str_trim(as.character(text[1]))
  parsedText <- strsplit(simpleText, split = " ")
  new_text_vec <- hunspell_stem(parsedText[[1]], dict = polish)
  for (i in 1:length(newTextVec)){
    if (length(newTextVec[[i]]) == 0) newTextVec[i] <- parsedText[[1]][i]
    if (length(newTextVec[[i]]) > 1) newTextVec[i] <- newTextVec[[i]][1] 
  }
  newText <- paste(newTextVec, collapse = " ")
  return(newText)
}

corpus <- tm_map(corpus, content_transformer(lemmatize))

#usuni?cie rozszerze? z nazw dokument?w
cut_exstensions <- function(document){
  meta(document, "id") <- gsub(pattern = "\\.txt$", "",meta(document, "id"))
  return(document)
}

corpus <- tm_map(corpus, cut_exstensions)

#eksport korpusu przetworzonego do plik?w tekstowych
preprocessed_dir <- paste(
  ouputDir,
  "\\",
  "Literatura - streszczenia - przetworzone",
  sep = ""
)
dir.create(preprocessed_dir, showWarnings = FALSE)
writeCorpus(corpus, path = preprocessed_dir)




writeLines(as.character(corpus[[1]])) 
  