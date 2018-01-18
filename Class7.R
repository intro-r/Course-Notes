## ----setup, include = FALSE, cache = FALSE-------------------------------
knitr::opts_chunk$set(error = TRUE)
knitr::opts_chunk$set(warning=FALSE)
knitr::opts_chunk$set(message=FALSE)
knitr::opts_chunk$set(results="hold")

## ---- error=F------------------------------------------------------------
library(readr)
ree <- read_csv("ree.csv")
ree

## ------------------------------------------------------------------------
library(BSDA)
attach(ree)
SIGN.test(CF, Healthy)
detach()

## ------------------------------------------------------------------------
library(tidyverse)
ree <- ree %>%
mutate(diff = CF - Healthy)
ree

## ------------------------------------------------------------------------
binom.test(2,13)

## ------------------------------------------------------------------------
attach(ree)
wilcox.test(CF, Healthy, paired=T)

## ------------------------------------------------------------------------
library(tidyverse)
cars <- as_data_frame(mtcars)
cars

## ------------------------------------------------------------------------
attach(cars)
wilcox.test(mpg, am)
detach(cars)

## ------------------------------------------------------------------------
library(BSDA)
Arthriti

## ------------------------------------------------------------------------
kruskal.test(time~treatment, data=Arthriti)

## ---- echo=F-------------------------------------------------------------
library(ggplot2)
library(gridExtra)

x1 <- seq(1,100, length=1000)
x2 <- seq(1,5, length=1000)

y1 <- (1/4) * x1^2 + rnorm(1000,0,1) # Monotonically Increasing Function
y2 <- exp(-x2+ rnorm(1000,0,0.1)) # Montonically Decreasing
y3 <- sin(x1 / 5) + rnorm(1000,0,1) # Not Monotonic

df <- as_data_frame(cbind(x1,x2,y1,y2,y3))


p1 <- ggplot(df, aes(x1,y1)) +
  geom_point() + 
  ggtitle("Monotonic Increasing")
  
p2 <- ggplot(df, aes(x2,y2)) +
  geom_point() + 
  ggtitle("Monotonic Decreasing")
  
p3 <- ggplot(df, aes(x1,y3)) +
  geom_point() + 
  ggtitle("Non Monotonic")


grid.arrange(p1,p2,p3, nrow=1)

## ------------------------------------------------------------------------
#Pearson from Monotonic Decreasing
cor(x2,y2, method="pearson")

#Spearman from Monotonic Decreasing
cor(x2,y2, method="spearman")

## ---- eval=F-------------------------------------------------------------
## # Bootstrap 95% CI for regression coefficients
## library(boot)
## # function to obtain regression weights
## bs <- function(formula, data, indices) {
##   d <- data[indices,] # allows boot to select sample
##   fit <- lm(formula, data=d)
##   return(coef(fit))
## }
## # bootstrapping with 1000 replications
## results <- boot(data=mtcars, statistic=bs,
##   	R=1000, formula=mpg~wt+disp)
## 
## # view results
## results
## plot(results, index=1) # intercept
## plot(results, index=2) # wt
## plot(results, index=3) # disp
## 
## # get 95% confidence intervals
## boot.ci(results, type="bca", index=1) # intercept
## boot.ci(results, type="bca", index=2) # wt
## boot.ci(results, type="bca", index=3) # disp

## ---- eval=F-------------------------------------------------------------
## # Bootstrap 95% CI for R-Squared
## library(boot)
## # function to obtain R-Squared from the data
## rsq <- function(formula, data, indices) {
##   d <- data[indices,] # allows boot to select sample
##   fit <- lm(formula, data=d)
##   return(summary(fit)$r.square)
## }
## # bootstrapping with 1000 replications
## results <- boot(data=mtcars, statistic=rsq,
##   	R=1000, formula=mpg~wt+disp)
## 
## # view results
## results
## plot(results)
## 
## # get 95% confidence interval
## boot.ci(results, type="bca")

