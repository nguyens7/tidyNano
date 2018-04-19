#' A Binning Function
#'
#' This function allows you aggregate or summarize your data by groups.
#' @param df A dataframe.
#' @param ... Columns to group by.
#' @param name Prefix name to summary statistics
#' @param param_var The numerical value that you want to summarize.
#' @return Summarized values \code{parm_var} grouped by \code{...}.
#' Output of tidy dataframe of grouped by \code{...} variables, N, mean,
#' standard deviation and standard error labeled according to 'name' argument.
#' @examples
#' nanolyze(starwars, species,name = "mass", param_var = mass)
#' nanolyze(starwars, gender,name = "height", param_var = height)
#' @keywords aggregate, summarize, summary statistics
#' @import tidyverse
#' @export


nanobin <- function(df, bin, ..., name = "Param", param_var, na.rm = TRUE) {


  group_var <- quos(...)
  param_var <- enquo(param_var)


  df %>%
    mutate(bins = bin)
    group_by(!!! group_var) %>%
    summarise(   N = length(na.omit(!! param_var)),
                 bin_sum = sum(!! param_var, na.rm = na.rm)
    )

}

# rep(seq(0,1000,10),each = 10)
# rep(seq(0,1000,5),each = 5)
