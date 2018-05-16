#' A Sum Function
#'
#' This function allows you aggregate or summarize your data by groups.
#' @param df A dataframe.
#' @param ... Columns to group by.
#' @param name Prefix name to sum function.
#' @param param_var The numerical value that you want to sum.
#' @param na.rm Argument for ignore 'NA' values
#' @return Sum of particle count \code{parm_var} grouped by \code{...}.
#' Output of tidy dataframe of sums grouped by \code{...} labeled according to 'name' argument.
#' @examples
#' nanocount(starwars, species,name = "mass", param_var = mass)
#' nanocount(starwars, gender,name = "height", param_var = height)
#' @keywords count, sum
#' @import tidyverse
#' @export

nanocount <- function(df, ..., name = "Particle", param_var, na.rm = TRUE) {

  group_var <- dplyr::quos(...)
  param_var <- dplyr::enquo(param_var)
  N <- paste(name, "N" , sep = "_")
  total <- paste(name, "count" , sep = "_")

  df %>%
    dplyr::group_by(!!! group_var) %>%
    dplyr::summarise(!!N := length(na.omit(!!param_var)),
              !!total := sum(!!param_var, na.rm = na.rm))

}

