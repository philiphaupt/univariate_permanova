# Univariate PERMANOVA

Ecologists often use multivariate PERMANOVA to analyse communities for differences across some factor, 
e.g. bait treatment, alongside a number of covariates, e.g. temperature, which may exlpain the variation in a community.
Just as often univariate permutation of ANOVA is needed to assess a particular species across the same covariates. 
I.e. isolate the individual, and rerun the analysis to test fror significant differences.

There are very useful statistical packages set up to carry out multivariate PERMANOVA, e.g. vegan in R, 
and can easily carry out univariate PERMANOVA. 
The problem faced by analysts is dealing with large community matrices, 
or multiple matrices requiring a significant amount of time to isolate, 
and analyse each species.

This function aims to carry out Univariate PERMANOVA (sequential) for each species within a community matrix, 
and write the results to a csv file. 

-PLEASE NOTE THAT YOU MAY NEED TO MAKE MINOR MODIFICATIONS TO MAKE THIS WORK FOR YOUR DATA- I HOPE TO COMPLETELY FUNCTIONALISE THIS, BUT IT NEEDS A BIT OF WORK STILL

We made use of the existing functionality of the vegan community ecology (https://CRAN.R-project.org/package=vegan) 
and dplyr (https://CRAN.R-project.org/package=dplyr) packages in R,
and added some code to isolate and loop through the matrix, carrying out univariate PERMANOVA on each column. 
The results are then written to a file specified by the user.

The principles are based on Anderson and Millar. 2004. 
All stastiscal methods draw from adonis2 in vegan Oksanen et al 2016. 

At this stage the user has to ensure having installed the vegan and dplyr pacakges in R.
The user has to supply community data matrix (com.dat), covariate data (covar.dat), formula (frml),
and number of permutations (nperm), and a filename.

References
Anderson and Millar 2004. Spatial variation and effects of habitat on temperate reef fish assemblages in northeastern New Zealand. Journal of Experimental Marine Biology and Ecology. Vol. 305. Issue 2. pp 191 - 221.
Oksanen, J., Blanchet, G.F., Kindt, R., Legendre, P., Minchin, P.R., O’Hara, R.B., Simpson, G.L., Solymos, P., Stevens, H., Wagner, H., 2016. vegan: Community Ecology Package.
Wickham, H., Francois, R., 2016. dplyr: A Grammar of Data Manipulation.
