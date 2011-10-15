## subSpecials
## Written by Jared P. Lander
## See LISCENSE for copyright information

## Converts special characters in escaped special characters
## Meant to help out when doing regular expressions
## loops through all the special characters, subbing them out one by one with their escaped equivalent
## @toAlter:  vector of words to have their special characters subbed out
## @specialChars: the characters to be replaced
## returns the modified vector

subOut <- function(toAlter, specialChars=c("!", "(", ")", "-", "=", "*", "."))
{
    # put slashes in front of the characters
    specialChars <- paste("\\", specialChars, sep="")
    
    # put double slashes for the replacements
    modChars <- paste("\\", specialChars, sep="")
  
    # loop through the special characters and sub in the replacements
    for(i in 1:length(specialChars))
    {
        toAlter <- gsub(specialChars[i], modChars[i], toAlter)    # do the subbing
    }
  
    return(toAlter)
}


## Converts special characters in escaped special characters
## Meant to help out when doing regular expressions
## @...: 1 to n vectors to be subbed on
## @specialChars: the characters to be replaced
## calls .subOut to do the actual work
## returns list of the modified vectors
subSpecials <- function(..., specialChars=c("!", "(", ")", "-", "=", "*", "."), simplify=FALSE)
{
    return(llply(list(...), subOut, specialChars=specialChars))  # run .subOut on each vector, returning the resulting list
}