##
##      RandomFieldsDocker
##
##  This file is shown on launch and illustrates 
##  some functions in RandomFields
##
##  To enable the graphical device in VS Code,
##  scripts MUST be run through the "Run Source"
##  button at the top of this window


library(RandomFields) 

# These settings allow plotting and prevent install dialogues
RFoptions(install="no",always_open_device=F)

# Since the GUI won't work in Codespaces, we disable it
RFgui <- function(...) NULL 


## The code below is taken from the help page of the 
## soil dataset 
help(soil)

data(soil)
str(soil)
soil <- RFspatialPointsDataFrame(
 coords = soil[ , c("x.coord", "y.coord")],
 data = soil[ , c("moisture", "NO3.N", "Total.N", "NH4.N", "DOC", "N20N")],
 RFparams=list(vdim=6, n=1)
)
dta <- soil["moisture"]
## plot the data first
colour <- rainbow(100)
plot(dta, col=colour)
## fit by eye
gui.model <- RFgui(dta) ## DISABLED - see above
 
## fit by ML
model <- ~1 + RMwhittle(scale=NA, var=NA, nu=NA) + RMnugget(var=NA)
(fit <- RFfit(model, data=dta))
plot(fit, method=c("ml", "plain", "sqrt.nr", "sd.inv"),
     model = gui.model, col=1:8)
## Kriging ...
x <- seq(min(dta@coords[, 1]), max(dta@coords[, 1]), l=121)
k <- RFinterpolate(fit, x=x, y=x, data=dta)
plot(x=k, col=colour)
plot(x=k, y=dta, col=colour)
## what is the probability that at no point of the
## grid given by x and y the moisture is greater than 24 percent?
cs <- RFsimulate(model=fit@ml, x=x, y=x, data=dta, n=50)
plot(cs, col=colour)
plot(cs, y=dta, col=colour)
Print(mean(apply(as.array(cs) <= 24, 3, all)))
