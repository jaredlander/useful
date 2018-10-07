#' @title load_pacakges
#' @description Loads multiple packages
#' @details Allows the user to load multiple packages with one line of code. Delivers a message saying which packages have been loaded. If a user requests packages that are not installed there is an error.
#' @author Jared P. Lander
#' @param packages A `charcter` vector of packages to be installed
#' @return Nothing, loads packages
#' @export
#' @examples 
#' 
#' load_packages('ggplot2')
#' load_packages(c('ggplot2', 'dplyr'))
load_packages <- function(packages)
{
    # be sure it is a character vector
    assertthat::assert_that(is.character(packages))
    
    ## check that the packages are installed
    # get list of installed packages
    installedPackages <- rownames(installed.packages())
    # see which of our packages are installed
    installedIndex <- packages %in% installedPackages
    # get the installed ones
    installedPackages <- packages[installedIndex]
    # get the not installed ones
    notInstalledPackages <- packages[!installedIndex]
    
    # warn which packages are installed
    if(length(notInstalledPackages))
    {
        stop(
            sprintf(
                'The following packages are not installed: {%s}', 
                paste(notInstalledPackages, collapse=', ')
            )
        )
    }
    
    purrr::walk(installedPackages, .f=library, character.only=TRUE)
    
    message(
        sprintf(
            'The following packages were loaded: {%s}',
            paste(installedPackages, collapse=', ')
        )
    )
}
