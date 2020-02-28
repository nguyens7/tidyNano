#' A Summarization Function
#'
#' This function allows you aggregate or summarize your data by groups.
#' @param df A dataframe.
#' @param ... Columns to group by.
#' @param name Prefix name to summary statistics
#' @param param_var The numerical value that you want to summarize.
#' @param na.rm Argument to ignore 'NA' values, defaults to TRUE.
#' @param sci_not Argument to return a separate column with scientific notation, defaults to FALSE.
#' @return Summarized values \code{parm_var} grouped by \code{...}.
#' Output of tidy dataframe of grouped by \code{...} variables, N, mean,
#' standard deviation and standard error labeled according to 'name' argument.
#' @examples
#' nanolyze(mtcars, cyl ,name = "hp", param_var = hp)
#' nanolyze(iris,Species, name = "Sepal_Width", param_var = Sepal.Width)
#' @keywords aggregate, summarize, summary statistics
#' @import dplyr
#' @export


nanolyze <- function(df, ..., name = "Param", param_var, na.rm = TRUE, sci_not = FALSE) {


  group_var <- dplyr::quos(...)
  param_var <- dplyr::enquo(param_var)
  N <- paste(name, "N" , sep = "_")
  cust_mean <- paste(name, "mean" , sep = "_")
  sci_cust_mean <- paste(name, "sci_no_mean" , sep = "_")
  sd <- paste(name, "sd" , sep = "_")
  se <- paste(name, "se" , sep = "_")

  if(sci_not == FALSE){

  df %>%
      dplyr::group_by(!!! group_var) %>%
      dplyr::summarise(   !! N := length(na.omit(!! param_var)),
                          !! cust_mean := mean(!! param_var, na.rm = na.rm),
                          !! sd := sd(!! param_var, na.rm = na.rm),
                          !! se := sd(!! param_var, na.rm = na.rm) /
                            sqrt(length(na.omit(!!param_var)))
      ) %>%
      dplyr::ungroup()

  }else if (sci_not == TRUE){

    df %>%
      dplyr::group_by(!!! group_var) %>%
      dplyr::summarise(   !! N := length(na.omit(!! param_var)),
                          !! cust_mean := mean(!! param_var, na.rm = na.rm),
                          !! sci_cust_mean := mean(!! param_var,na.rm = na.rm) %>%
                                                scales::scientific(digits = 3),
                          !! sd := sd(!! param_var, na.rm = na.rm),
                          !! se := sd(!! param_var, na.rm = na.rm) /
                            sqrt(length(na.omit(!!param_var)))
      ) %>%
      dplyr::ungroup()


  }

    }

