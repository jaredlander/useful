# Shift column
shift.column <- function(data, columns, newNames=sprintf("%S.Shifted", columns), len=1, up=TRUE)
{
    if(length(columns) != length(newNames))
    {
        stop("columns and newNames must be the same length")
    }
    
    # get the rows to keep based on how much to shift it by and weather to shift up or down
    rowsToKeep <- seq(from=1 + len*up, length.out=NROW(data) - len)
    
    # for the original dat ait needs to be shifted the other way
    dataRowsToKeep <- seq(from=1 + len*!up, length.out=NROW(data) - len)
    
    #create a df of the shifted rows
    shiftedDF <- data[rowsToKeep, columns]
    
    # give the right names to these new columns
    names(shiftedDF) <- newNames
    
    # data names
    dataNames <- names(data)
    
    # get rid of excess rows in data
    data <- data[dataRowsToKeep, ]
    
    # tack shifted data onto the end of the original (and cutoff) data
    data <- cbind(data, shiftedDF)
    names(data) <- c(dataNames, newNames)
    
    # return the data
    return(data)
}