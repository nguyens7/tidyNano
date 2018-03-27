#' A Tidy Function
#'
#' This function allows you tidy Nanosight data.  It will make the data go from
#' 'wide' to 'long'.
#' @param df A dataframe.
#' @param ... Specify the range of columns to tidy (x:z).
#' @return Gathers values from 'wide' to 'long' format. Returns a dataframe with a
#' Sample and Count column.
#' @examples
#' nanotidy(data, 2:12)
#' @keywords aggregate, summarize, summary statistics
#' @export


nanotidy <- function(df, ..., col_names, sep = "_") {

  cols <- quos(...)

df %>%
    gather(Sample, Count,!!!cols) %>%
    mutate(Count = as.numeric(Count))

}
