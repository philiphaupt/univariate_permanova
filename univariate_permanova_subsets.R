#Author: Philip Haupt
#Date: 2017-11-08
#Aim: Perform Univariate permanova cycling one column at a time through test.
# Subset community data matrix, one column at a time, perform PERMANOVA, and write resutls to file
# User has to supply community data matrix (com.dat), covariate data (covar.dat), formula (frml) and number of permutations (nperm) and a filename 
# The formula uses Euclidean distance as per (Anderson & Millar 2004)
# Function requires vegan 4.1 or higher and dplyr pacakges (Oksanen et al 2016, Wickham et al 2017)
# The formula should be written as if for full community data frame, which is then subsetted within the function

univariate.permanova <- function(com.dat, covar.dat, frml, nperm, filename){
        tbl.results <- data.frame(matrix(NA,nrow = (ncol(covar.dat)+1), ncol = 4)) # create table in which results will be stored
        row.names(tbl.results) <- c(colnames(covar.dat),"Residual") # generate row names
        colnames(tbl.results) <-  c("Df", "SumOfSqs", "F", "Pr(>F)") # generate col names
        com.taxa <- data.frame(matrix(rep(NA,ncol(covar.dat)+1))) # create table for taxa table - to bound to results at end
        names(com.taxa) <- "taxa" # set column name for taxa table

        
        #subset: # use one column at a time starting at 1, cycling through to the total number of columns.
        for (i in 1:ncol(com.dat)) {
                com.dat.subset <- com.dat[i] #subsetted data
                #dis.comm.ctroph.maxn.subset <- vegan::vegdist(com.dat.subset, method = "euclidean") # determined in adonis - not required, not used, but kept for future use
                
                # declare formula to implement in adonis2: change user-formula by repalcing the user provided data set with subsetted data set
                frmla.tmp <- frml # set up temporary variable
                frmla <- as.formula(paste0("com.dat.subset ~", frmla.tmp[3])) # concatenate subsetted data with rest of formula
                #set.seed(0204) # fix permutation point starting point to obtain consistent results
                univariate.permanova <- vegan::adonis2(formula = frmla, data = covar.dat, method = "euclidean", permutations = nperm, by = "terms")  # Run univariate PERMANOVA with Euclidean distance
                tbl.results <- rbind(tbl.results, as.data.frame(univariate.permanova[c(1:7), c(1:4)])) # add output to Results table
                com.taxa.univariate.permanova <- data.frame(matrix(rep(names(com.dat.subset), nrow(univariate.permanova)))) %>% rename(taxa = `matrix.rep.names.com.dat.subset...nrow.univariate.permanova...`) #generate list copying the taxa name the number of times required for table
                com.taxa <- rbind(com.taxa, com.taxa.univariate.permanova[1])  # add above to taxa table
        }
        # add stars for significance
        tbl.results$'Pr(>F)' <- as.numeric(tbl.results$'Pr(>F)')
        tbl.results$sign <- NA
        tbl.results$sign <- replace(tbl.results$sign, which(tbl.results$'Pr(>F)' <= 0.1 & tbl.results$'Pr(>F)' > 0.05), ".")
        tbl.results$sign <- replace(tbl.results$sign, which(tbl.results$'Pr(>F)' <= 0.05 & tbl.results$'Pr(>F)' > 0.01), "*")
        tbl.results$sign <- replace(tbl.results$sign, which(tbl.results$'Pr(>F)' <= 0.01 & tbl.results$'Pr(>F)' > 0.001), "**")
        tbl.results$sign <- replace(tbl.results$sign, which(tbl.results$'Pr(>F)' <= 0.001), "***")
        tbl.results <- cbind(tbl.results,com.taxa)
        tbl.results <- tbl.results[-c(1:7),] # remove NA rows at start of table (used to create table dimesions)
        tbl.results$covar <- rep(c(colnames(covar.dat),"Residual"),ncol(com.dat)) # add a column with covariates to allow for easy analysis and filtering
        write.csv(tbl.results, file=filename, append=TRUE) # write table
        return(head(tbl.results)) # display results to user
}
