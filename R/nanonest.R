#' A Function for Nesting Data
#'
#' This function allows you aggregate or summarize your data by groups.
#' @param df A dataframe.
#' @param ... Columns to group by.
#' @return A nested data frame grouped by \code{...} , suitable for using mutate and map to
#' perform statistical tests.
#' @examples
#' nanonest(starwars, species)
#' nanonest(starwars, gender)
#' @keywords statistics, nesting, nested
#' @export


nanonest <- function(df, ...) {

  group_var <- quos(...)

  df %>%
    group_by(!!! group_var) %>%
    nest()

}
