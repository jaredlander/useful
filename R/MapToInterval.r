## maps a given set of numbers to the specified interval
## @nums: (vector) the numbers to be mapped
## @start (numeric) the beginging of the mapping
## @stop (numeric) the end of the mapping
MapToInterval <- function(nums, start=1, stop=10)
{
    #do the mapping: a + (x - min(x)) * (b - a) / (max(x) - min(x))
    mapped <- start + (nums - min(nums)) * (stop - start) / diff(range(nums))
    return(mapped)
}

# just a better name for the function
mapping <- function(nums, start=1, stop=10)
{
    return(MapToInterval(nums=nums, start=start, stop=stop))
}