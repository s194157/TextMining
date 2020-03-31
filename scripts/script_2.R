#włączenie bibliotek
library(tm)

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
  "Literatura - streszczenia - przetworzone",
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

#usunięcie rozszerzeń z nazw dokumentów
cut_exstensions <- function(document){
  meta(document, "id") <- gsub(pattern = "\\.txt$", "",meta(document, "id"))
  return(document)
}

corpus <- tm_map(corpus, cut_exstensions)

#utworzenie macierzy częstości
tdmTfAll <- TermDocumentMatrix(corpus) 
dtmTfAll <- DocumentTermMatrix(corpus)
tdmTfidfAll <- TermDocumentMatrix(       
  corpus,
  control = list(
    weighting = weightTfIdf()
  )
)

tdmBinAll <- TermDocumentMatrix(
  corpus,
  control = list(
    weighting = weightBin()
  )
)

tdmTfBounds <- TermDocumentMatrix(
  corpus,
  control = list(
    bounds = list(
      global = c(2,16)
    )
  )
)

tdmTfidfBounds <- TermDocumentMatrix(
  corpus,
  control = list(
    weighting = weightTfIdf,
    bounds = list(
      global = c(2,16)
    )
  )
)

#konwersja macierzy rzadkich do macierzy klasycznych
tdmTfAllMatrix <- as.matrix(tdmTfAll)
dtmTfAllMatrix <- as.matrix(dtmTfAll)
tdmTfidfAllMatrix <- as.matrix(tdmTfidfAll)
tdmBinAllMatrix <- as.matrix(tdmBinAll)
tdmTfBoundsMatrix <- as.matrix(tdmTfBounds)
tdmTfidfBoundsMatrix <- as.matrix(tdmTfidfBounds)

#eksport macierzy do pliku .csv
matrixFile <- paste(
  outputDir,
  "\\",
  "tdmTfidfBounds.csv",
  sep=""
)

write.table(tdmTfidfBoundsMatrix, file = matrixFile, sep = ";", dec = ",", col.names = NA)




