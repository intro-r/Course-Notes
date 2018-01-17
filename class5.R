## ----setup, include = FALSE, cache = FALSE-------------------------------
knitr::opts_chunk$set(error = TRUE)
knitr::opts_chunk$set(warning=FALSE)
knitr::opts_chunk$set(message=FALSE)
knitr::opts_chunk$set(results="hold")

## ------------------------------------------------------------------------
library(TH.data)
library(tidyverse)

cnt <- wpbc %>% 
  group_by(status) %>%
  tally()
mn<- wpbc %>% 
  group_by(status) %>%
  summarise(mean_time=mean(time))
full_join(cnt,mn)


## ------------------------------------------------------------------------
t.test(time~status, data=wpbc)

## ------------------------------------------------------------------------
library(broom)
tidy(aov(time~status, data=wpbc))

## ------------------------------------------------------------------------
t.test(time~status, data=wpbc, var.equal=TRUE)

## ------------------------------------------------------------------------
model <- lm(time~status, data=wpbc)
tidy(model)
glance(model)

## ---- echo=F-------------------------------------------------------------
ggplot(wpbc, aes(worst_area, time)) + 
  geom_point() + 
  xlab("Worst Area") + 
  ylab("Time")

## ---- echo=F-------------------------------------------------------------
ggplot(wpbc, aes(worst_area, time)) + 
  geom_point() + 
  geom_smooth(method="lm", se=FALSE) + 
  xlab("Worst Area") + 
  ylab("Time")

## ---- echo=FALSE---------------------------------------------------------
n <- 10000
x <- seq(1,10, by =0.00090009)
y <- rnorm(n, 3 + 5*x, 1)
Data <- data.frame(x, y)

plot(x,y, type='n')
lines(lowess(y~x), )
segments(3,0,3,40)
points(3,40, pch=16)
points(3, 18, pch=16)
segments(-2,40, 3,40, lty=2)
segments(-2,18, 3,18, lty=2)
text(1.7 , 30, label= "Error E")
arrows(1.7, 30.7, 1.7, 40)
arrows(1.7, 29.3, 1.7, 18)
text(4,50, label= "Observed")
text(4,48, label = "value Y at X")
arrows(4,47, 3,40)
text(4, 15, label=expression(mu["Y|X"]))
arrows(3.7,15, 3.1, 18)
text(8, 30, label="Population Regression Line")
text(8,27, label= expression( mu["Y|X"] ~ "=" ~beta[0] + ~ beta[1]~X  ))

## ---- echo=FALSE---------------------------------------------------------
plot(x,y, type='n')
lines(lowess(y~x))
segments(2, 20, 2, 13, lty=2)
points(2,20, pch=16)
segments(4, 10, 4, 23, lty=2)
points(4,10, pch=16)
segments(7, 45, 7, 38, lty=2)
points(7,45, pch=16)
segments(9, 32, 9, 48, lty=2)
points(9,32, pch=16)
text(1.6, 16, label = expression(hat(epsilon)[1]))
text(4.4, 16, label = expression(hat(epsilon)[2]))
text(6.6, 41, label = expression(hat(epsilon)[3]))
text(9.4, 41, label = expression(hat(epsilon)[4]))

## ------------------------------------------------------------------------

model <- lm(time~worst_area, data=wpbc)
tidy(model, conf.int=TRUE)[,-c(3:4)]
glance(model)

## ------------------------------------------------------------------------
phil_disp <- read.table("https://drive.google.com/uc?export=download&id=0B8CsRLdwqzbzOXlIRl9VcjNJRFU", header=TRUE, sep=",")

## ------------------------------------------------------------------------
prost_race <- glm(surgery ~ race, weight=number, data= phil_disp,
                  family="binomial")
tidy(prost_race, exponentiate=T, conf.int=T)[,-c(3:4)]

## ------------------------------------------------------------------------
prost_hosp <- glm(surgery ~ hospital, weight=number, data= phil_disp,
                  family="binomial")
tidy(prost_hosp, exponentiate =T, conf.int=T)[,-c(3:4)]

## ------------------------------------------------------------------------
prost <- glm(surgery ~ hospital + race, weight=number, data= phil_disp,
             family="binomial")
tidy(prost, exponentiate=T, conf.int=T)[,-c(3:4)]

## ------------------------------------------------------------------------
wpbc <- wpbc %>% 
    mutate(tsize_bin = tsize > median(tsize))

## ------------------------------------------------------------------------
mod1 <- lm(time~status, data=wpbc)
mod2 <- lm(time~tsize_bin, data=wpbc)
tidy1 <- tidy(mod1, conf.int=T)[,-c(3:4)]
tidy2 <- tidy(mod2, conf.int=T)[,-c(3:4)]
rbind(tidy1, tidy2)

## ------------------------------------------------------------------------
mod3 <- lm(time~status + tsize_bin, data=wpbc)
tidy3 <- tidy(mod3, conf.int=T)[,-c(3:4)]
tidy3

## ---- echo=FALSE---------------------------------------------------------
plot(mod3,1)

## ---- echo=FALSE---------------------------------------------------------
plot(mod3,2)

## ---- results='hide'-----------------------------------------------------
###################
##     RUN THIS IN R FOR CLASS    ##
###################

 library(leaps)
 leaps <- regsubsets(time~ ., force.in=1,data=wpbc, nbest=1)
summary(leaps)

## ---- echo=FALSE, size="tiny"--------------------------------------------
library(dplyr)
summ <- summary(leaps)
summ$which

## ------------------------------------------------------------------------

names(summ)

## ------------------------------------------------------------------------

library(car)
# Adjusted R2
res.legend <- subsets(leaps, statistic="adjr2", legend = FALSE, min.size = 3,
main = "Adjusted R^2")


## ------------------------------------------------------------------------

plot(leaps, scale="adjr2", main="")


## ------------------------------------------------------------------------
library(glmnet)
wpbc2 <- wpbc %>%
    filter(complete.cases(.))

x  <- wpbc2 %>%
    mutate(status= status=="R") %>%
    select(-time) %>%
    as.matrix()
    
y <- wpbc2 %>%
    select(time) %>%
    as.matrix() %>%
    as.numeric()

## ---- eval=F-------------------------------------------------------------
## 
## library(glmnet)
## 
## set.seed(999)
## cv.ridge <- cv.glmnet(x, y, alpha=0, parallel=TRUE, standardize=TRUE)
## 
## # Results
## plot(cv.ridge)
## cv.ridge$lambda.min
## cv.ridge$lambda.1se
## coef(cv.ridge, s=cv.ridge$lambda.min)
## 

## ------------------------------------------------------------------------
set.seed(999)
cv.ridge <- cv.glmnet(x, y, alpha=0, parallel=TRUE, standardize=TRUE)
names(cv.ridge)

## ---- echo=F-------------------------------------------------------------
plot(cv.ridge)

## ------------------------------------------------------------------------
# minimum MSE
cv.ridge$lambda.min
# 1 Standard Deviation lower MSE
cv.ridge$lambda.1se



## ---- echo=F-------------------------------------------------------------
coef(cv.ridge, s=cv.ridge$lambda.min)

## ---- eval=F-------------------------------------------------------------
## require(glmnet)
## 
## # Fitting the model (Lasso: Alpha = 1)
## set.seed(999)
## cv.lasso <- cv.glmnet(x, y, family='gaussian', alpha=1,
##                       parallel=TRUE, standardize=TRUE)
## 
## # Results
## plot(cv.lasso)
## plot(cv.lasso$glmnet.fit, xvar="lambda", label=TRUE)
## cv.lasso$lambda.min
## cv.lasso$lambda.1se
## coef(cv.lasso, s=cv.lasso$lambda.min)

## ---- echo=F-------------------------------------------------------------
# Fitting the model (Lasso: Alpha = 1)
set.seed(999)
cv.lasso <- cv.glmnet(x, y, family='gaussian', alpha=1,
                      parallel=TRUE, standardize=TRUE)

## ---- echo=F-------------------------------------------------------------
require(glmnet)

# Fitting the model (Lasso: Alpha = 1)
set.seed(999)
cv.lasso <- cv.glmnet(x, y, family='gaussian', alpha=1,
                      parallel=TRUE, standardize=TRUE)

# Results
plot(cv.lasso)

## ---- echo=F-------------------------------------------------------------

plot(cv.lasso$glmnet.fit, xvar="lambda", label=TRUE)


## ------------------------------------------------------------------------
cv.lasso$lambda.min
cv.lasso$lambda.1se


## ---- echo=F-------------------------------------------------------------
coef(cv.lasso, s=cv.lasso$lambda.min)

