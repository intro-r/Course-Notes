---
title: "Day 3: ANOVA Lab"
author: ""
date: "January 11, 2018"
output: pdf_document
---




## Download the R Markdown File for this:

You can access the R Markdown File [here](https://raw.githubusercontent.com/intro-r/Course-Notes/gh-pages/day3-anova.pdf)

## R Markdown

This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

When you click the **Knit** button a document will be generated that includes both content as well as the output of any embedded R code chunks within the document. You can embed an R code chunk like this:


```r
summary(cars)
```

```
##      speed           dist       
##  Min.   : 4.0   Min.   :  2.00  
##  1st Qu.:12.0   1st Qu.: 26.00  
##  Median :15.0   Median : 36.00  
##  Mean   :15.4   Mean   : 42.98  
##  3rd Qu.:19.0   3rd Qu.: 56.00  
##  Max.   :25.0   Max.   :120.00
```

## Including Plots

You can also embed plots, for example:

![plot of chunk pressure](figure/pressure-1.png)

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.


You can also print the code but not run it by using the `eval=FALSE` command:


```r
plot(pressure)
```


To display your work you can create space in the `.Rmd` file and then add:


```r
# Type code in here
```

In your first lines of this file there is something called `.yaml` it currently output to: `html_document. You can output to:

- `html_document`
- `pdf_document`
- `word_document`

If you have a windows computer you will need [miktex](https://miktex.org/) to knit to a pdf. Knitting to word causes a delay so only do this after you are pleased with your output and are ready for your final document. 


## Pre-lab work

Consider the `comic_characters` data that we encountered previously. 

1. Perform ANOVA of `appearances` on the original form of `sex`. Besure to address the following:
    a. Can you perfrom this with all categories? 
    b. What are the results?
    c. How do the assumptions hold?
    d. Do the results change if you consider `log_app` instead?

2. Considering the same data, are their similar relationships between `log_app` and eye color or `log_app` and hair color? Perform ANOVAs of `log_app` on `eye` and `hair`. 


## The Data

This lab will use data from the [HERS](https://www.ncbi.nlm.nih.gov/pubmed/9683309) study. There are various data files for this and you can load them as follows, there are other files at the [VGSM site](http://www.biostat.ucsf.edu/vgsm/1st_ed/data.html):



```r
library(haven)
hers <- read.delim("http://www.biostat.ucsf.edu/vgsm/1st_ed/data/hersdata.txt")
```


You will need to consider the codebook that can be found [here](http://www.biostat.ucsf.edu/vgsm/1st_ed/data/warfarin.codebook.txt). 

3. Explore this data using the tools of `dplyr` and the `summarise()` function. 
4. Create some plots to compare things like Blood pressure, cholesterol and glucose in different races. Make sure to comment on what you notice. 
5. From your above summaries and plots, choose continuous variables to perform ANOVAs on in different races. Comment on your findings as well. 
