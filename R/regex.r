## make getting regex results easier
regex <- function(pattern, text, ignore.case=FALSE, perl=FALSE, fixed=FALSE, useBytes=FALSE)
{
    # run the regex
    theResult <- regexpr(pattern=pattern, text=text, ignore.case=ignore.case, perl=perl, fixed=fixed, useBytes=useBytes)

    # find the start and stop positions
    theResult <- data.frame(Start=theResult, Stop=theResult + attr(theResult, "match.length") - 1, Text=text, stringsAsFactors=FALSE)

    # just keep the text where the pattern was found
    theResult <- theResult[theResult$Start != -1, ]
    
    # extract the desired text and return it
    return(with(theResult, substr(Text, Start, Stop)))
}

# same as regex but for global pattern recognition
gregex <- function(pattern, text, ignore.case=FALSE, perl=FALSE, fixed=FALSE, useBytes=FALSE)
{
    # run the regex
    theResult <- regexpr(pattern=pattern, text=text, ignore.case=ignore.case, perl=perl, fixed=fixed, useBytes=useBytes)

    # find the start and stop positions
    theResult <- data.frame(Start=theResult, Stop=theResult + attr(theResult, "match.length") - 1, Text=text, stringsAsFactors=FALSE)

    # just keep the text where the pattern was found
    theResult <- theResult[theResult$Start != -1, ]
    
    # extract the desired text and return it
    return(with(theResult, substr(Text, Start, Stop)))
}
holder <- regex("^Jared|Bob", c("Jared and Dave and Bob", "David", "Jared", "BenandJared"))
holder
regex("Jared|Bob", c("Jared and Dave and Bob", "David", "Jared", "BenandJared"))
gregexpr("Jared|Bob", c("Jared and Dave and Bob", "David", "Jared", "BenandJared"))