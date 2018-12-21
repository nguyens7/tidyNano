#' A Function for Nesting Data
#'
#' This function allows you aggregate or summarize your data by groups.
#' @param df A dataframe.
#' @param ... Columns to group by.
#' @return A nested data frame grouped by \code{...} , suitable for using mutate and map to
#' perform statistical tests.
#' @examples
#' nanonest(mtcars, cyl)
#' nanonest(iris, Species)
#' @keywords statistics, nesting, nested
#' @import dplyr
#' @export


nanonest <- function(df, ...) {

  group_var <- dplyr::quos(...)

  df %>%
    dplyr::group_by(!!! group_var) %>%
    tidyr::nest()

}


