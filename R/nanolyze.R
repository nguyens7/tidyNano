#' A Summarization Function
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
#' @export

# nanolyze <- function(df, ..., name = "Param", param_var, na.rm = TRUE) {
#
#   param_var <- enquo(param_var)
#   N <- paste(name, "N" , sep = "_")
#   mean <- paste(name, "mean" , sep = "_")
#   sd <- paste(name, "sd" , sep = "_")
#   se <- paste(name, "se" , sep = "_")
#
#   df %>%
#     group_by_(.dots = lazyeval::lazy_dots(...)) %>%
#     summarise(!!N := length(na.omit(!!param_var)),
#               !!mean := mean(!!param_var, na.rm = na.rm),
#               !!sd := sd(!!param_var, na.rm = na.rm),
#               !!se := sd(!!param_var, na.rm = na.rm) /
#                         sqrt(length(na.omit(!!param_var)))
#               )
#   }


nanolyze <- function(df, ..., name = "Param", param_var, na.rm = TRUE) {


  group_var <- quos(...)
  param_var <- enquo(param_var)
  N <- paste(name, "N" , sep = "_")
  mean <- paste(name, "mean" , sep = "_")
  sd <- paste(name, "sd" , sep = "_")
  se <- paste(name, "se" , sep = "_")

  df %>%
    group_by(!!! group_var) %>%
    summarise(   !! N := length(na.omit(!! param_var)),
              !! mean := mean(!! param_var, na.rm = na.rm),
                !! sd := sd(!! param_var, na.rm = na.rm),
                !! se := sd(!! param_var, na.rm = na.rm) /
                          sqrt(length(na.omit(!!param_var)))
              )

    }

