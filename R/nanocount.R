#' A Sum Function
#'
#' This function allows you aggregate or summarize your data by groups.
#' @param df A dataframe.
#' @param ... Columns to group by.
#' @param name Prefix name to sum function.
#' @param param_var The numerical value that you want to summarize.
#' @return Sum of particle count \code{parm_var} grouped by \code{...}.
#' Output of tidy dataframe of  sums grouped by \code{...} labeled according to 'name' argument.
#' @examples
#' nanocount(starwars, species,name = "mass", param_var = mass)
#' nanocount(starwars, gender,name = "height", param_var = height)
#' @keywords count, sum
#' @export

nanocount <- function(df, ..., name = "Particle", param_var, na.rm = TRUE) {

  param_var <- enquo(param_var)
  N <- paste(name, "N" , sep = "_")
  total <- paste(name, "count" , sep = "_")

  df %>%
    group_by_(.dots = lazyeval::lazy_dots(...)) %>%
    summarise(!!N := length(na.omit(!!param_var)),
              !!total := sum(!!param_var, na.rm = na.rm))

}

