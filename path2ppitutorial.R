#install Path2PPI package via Bioconductor
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("Path2PPI")
library("Path2PPI")
data()
data(ai)
#reference species proteins UnitProt ID and Protein Names for a biological process of interest
human.ai.proteins
yeast.ai.proteins

#irefindex --> Published PPIs for model organisms. Used to find relevant PPIs 
#for reference species proteins
str(human.ai.irefindex)
str(yeast.ai.irefindex)

#homology files using ncbi+ toolkit
#Blast searches of Podospora anserina proteins against the proteome of yeast and human proteins
head(pa2yeast.ai.homologs)
head(pa2human.ai.homologs)

#V1 is P.anserina proteins V2 is uniprot protein names of reference species that V1 is homologous.
#Predict PPI in target species - P.anserina
#Makes Path2PPI object first
ppi<- Path2PPI("Autophagy Induction","Podospora anserina","5145")
ppi

#No reference has been added yet. So add reference.addReference function does
#search for relevant interactions for the list of reference species proteins.
ppi <- addReference(ppi, "Homo sapiens", "9606", human.ai.proteins, 
                    human.ai.irefindex, pa2human.ai.homologs)
ppi <- addReference(ppi, "Saccharomyces cerevisiae (S288c)", "559292", 
                    yeast.ai.proteins, yeast.ai.irefindex, 
                    pa2yeast.ai.homologs) 
#We can also get the processed information by using showReference
showReferences(ppi)
#this shows a total of relevant protein-protein interactions for the reference protein list we generated.

#Time to predict protein-protein interactions of the target species P.anserina
ppi<-predictPPI(ppi,h.range = c(1e-60,1e-20))
#h.range sets an upper and lower boundary E values. This filters and retains proteins that has e value within this range.
#e value --> The lower --> The more homology there is between target and reference protein
#predictPPI function 'transfers' the interactions between published proteins that are highly homologous to target species protein

#show the constructed ppi
ppi
#We can plot the result by using the igraph packge and function 'plot'
set.seed(8) #creates a random number for reproducibility (helps to generate repetable dataset)

coordinates<-plot(ppi,return,coordinate = TRUE)
plot(ppi,multiple.edges = TRUE, vertices.coordinates=coordinates)
