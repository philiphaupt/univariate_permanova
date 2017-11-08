# subset community data matrix, one column at a time, perform PERMANOVA, and write resutls to file
# user has to supply com.dat, covar.dat, formula and number of perm and a filename (at this stage the formula uses Euclidean distance as per Anderson & Millar 2004)
# function requires vegan 4.1or higher , and dplyr pacakges (Oksanen et al 2016, Wickham et al 2017)
# formula should be written as if for full community data frame, which is then subsetted withi the function

univariate.permanova.each.column <- function(com.dat, covar.dat, frml, nperm, filename){
        tbl.results <- data.frame(matrix(NA,nrow = (ncol(covar.dat)+1), ncol = 4)) # create table in which results will be stored
        row.names(tbl.results) <- c(colnames(covar.dat),"Residual") # generate row.names
        colnames(tbl.results) <-  c("Df", "SumOfSqs", "F", "Pr(>F)") # generate col names
        com.taxa <- data.frame(matrix(rep(NA,ncol(covar.dat)+1))) # create table for taxa table - to bound to results at end
        names(com.taxa) <- "taxa" # set column bane for taxa table

        
        #subset: # use one column ata time starting at 1, cycling through to the toal number of columns.
        for (i in 1:ncol(com.dat)) {
                com.dat.subset <- com.dat[i] #subsetted data
                #dis.comm.ctroph.maxn.subset <- vegan::vegdist(com.dat.subset, method = "euclidean") # determined in adonis - not required, not used, but kept for future use
                
                # declare formula, repalcing user provided with subset
                frmla.tmp <- frml
                frmla <- as.formula(paste0("com.dat.subset ~", frmla.tmp[3]))
                set.seed(0204) # fix permutation point starting point to obtain consistent results
                univariate.permanova <- vegan::adonis2(formula = frmla, data = covar.dat, method = "euclidean", permutations = nperm, by = "terms")  # Run univariate PERMANOVA
                tbl.results <- rbind(tbl.results, as.data.frame(univariate.permanova[c(1:7), c(1:4)])) # add results to table
                com.taxa.univariate.permanova <- data.frame(matrix(rep(names(com.dat.subset), nrow(univariate.permanova)))) %>% rename(taxa = `matrix.rep.names.com.dat.subset...nrow.univariate.permanova...`) #generate list copying teh taxa name the number of times required for table
                com.taxa <- rbind(com.taxa, com.taxa.univariate.permanova[1])  # add above to taxa table
        }
        #add stars for significance
        tbl.results$'Pr(>F)' <- as.numeric(tbl.results$'Pr(>F)')
        tbl.results$sign <- NA
        tbl.results$sign <- replace(tbl.results$sign, which(tbl.results$'Pr(>F)' <= 0.1 & tbl.results$'Pr(>F)' > 0.05), ".")
        tbl.results$sign <- replace(tbl.results$sign, which(tbl.results$'Pr(>F)' <= 0.05 & tbl.results$'Pr(>F)' > 0.01), "*")
        tbl.results$sign <- replace(tbl.results$sign, which(tbl.results$'Pr(>F)' <= 0.01 & tbl.results$'Pr(>F)' > 0.001), "**")
        tbl.results$sign <- replace(tbl.results$sign, which(tbl.results$'Pr(>F)' <= 0.001), "***")
        tbl.results <- cbind(tbl.results,com.taxa)
        tbl.results <- tbl.results[-c(1:7),] # remove NA rows at start of table (used to create table dimesions)
        tbl.results$covar <- rep(c(colnames(covar.dat),"Residual"),ncol(com.dat)) # add acolumn with covriates to allow for easy analysis and filtering
        write.csv(tbl.results, file=filename, append=TRUE) # write table
        return(head(tbl.results))
}
