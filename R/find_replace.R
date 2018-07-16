#' A Function to Edit Column Headers
#'
#' This function allows for finding and replacing patterns in column names.
#' @param df file data frame.
#' @param find A string from column names that will be replaced by the 'replace' string.
#' @param replace A string that should be substituted in place of the 'find' string.
#' @examples find_replace(df, find = "January 2018", replace = "2018-01")
#' @keywords find, replace, rename
#' @import purrr
#' @export


find_replace <- function(df, find, replace){

  df %>%
    purrr::set_names(~ (.) %>%
                       stringr::str_replace_all(find, replace))
}
