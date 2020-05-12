#włączenie bibliotek
library(lsa)

#zmiana katalogu roboczego
workDir <- "C:\\Users\\BartekO\\PJN\\TextMining"
setwd(workDir)

#lokalizacja katalogu ze skryptami
scriptsDir <- ".\\scripts"

#załadowanie skryptu
sourceFile <- paste(
  scriptsDir,
  "\\",
  "frequency_matrix.R",
  sep = ""
)
source(sourceFile)

#analiza ukrytych wymiarów semantycznych (dekompozycja wg wartości osobliwych)
lsa <- lsa(tdmTfidfBoundsMatrix)
lsa$tk #odpowiednik macierzy U, współrzędne wyrazów
lsa$dk #odpowiednik macierzy V, współrzędne dokumentów
lsa$sk #odpowiednik macierzy D, znaczenie składowych

#przygotowanie współrzędnych do wykresu
coordDocs <- lsa$dk%*%diag(lsa$sk)
coordTerms <- lsa$tk%*%diag(lsa$sk)
words <- c("harry", "czarodziej", "dumbledore", "hermiona", "ron", "komnata", "powiedzieć", "chcieć", "dowiadywać", "albus", "syriusz", "lupin", "umbridge", "edmund", "kaspian", "łucja", "czarownica", "piotr", "zuzanna", "aslana", "narnii", "baron", "dziecko", "wyspa", "bell", "edward", "wampir", "jacob")
termsImportance <- diag(coordTerms%*%t(diag(lsa$sk))%*%t(lsa$tk))
importantWords <- names(tail(sort(termsImportance), 25))
coordWords <- coordTerms[importantWords,]
x1 <- coordDocs[,1]
y1 <- coordDocs[,2]
x2 <- coordWords[,1]
y2 <- coordWords[,2]

#przygotowanie legendy
legend <- paste(
  paste("d", 1:length(rownames(coordDocs)),sep = ""),
  rownames(coordDocs),
  sep = "<-"
)

#wykres dokumentów w przestrzeni dwuwymiarowej
plot(
  x1,
  y1,
  #xlim = c(-0.02,-0.01),
  #ylim = c(-0.05,0.05),
  xlab="Współrzędna syntetyczna 1", 
  ylab="Współrzędna syntetyczna 2",
  main="Analiza ukrytych wymiarów sematycznych", 
  col = "orange"
)
text(
  x1, 
  y1, 
  labels = paste("d", 1:length(rownames(coordDocs)),sep = ""), 
  pos = 4,
  col = "orange"
)
points(
  x2,
  y2,
  pch = 2,
  col = "brown"
)
text(
  x2, 
  y2, 
  labels = rownames(coordWords), 
  pos = 4,
  col = "brown"
)
legend("bottomleft", legend, cex=.6, text.col = "orange")

#eksport wykresu do pliku .png
plotFile <- paste(
  outputDir,
  "\\",
  "lsa.png",
  sep = ""
)
png(file = plotFile)
plot(
  x1,
  y1,
  #xlim = c(-0.02,-0.01),
  #ylim = c(-0.05,0.05),
  xlab="Współrzędna syntetyczna 1", 
  ylab="Współrzędna syntetyczna 2",
  main="Analiza ukrytych wymiarów sematycznych",
  col = "orange"
)
text(
  x1, 
  y1, 
  labels = paste("d", 1:length(rownames(coordDocs)),sep = ""), 
  pos = 4,
  col = "orange"
)
points(
  x2,
  y2,
  pch = 2,
  col = "brown"
)
text(
  x2, 
  y2, 
  labels = rownames(coordWords), 
  pos = 4,
  col = "brown"
)
legend("bottomleft", legend, cex=.5, text.col = "orange")
dev.off()