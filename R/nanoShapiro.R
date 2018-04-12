#' A nested Normality Test
#'
#' This function allows you aggregate or summarize your data by groups.
#' @param df A dataframe.
#' @param ... Columns to group by.
#' @param value The numerical value that you want to summarize.
#' @return A nested data frame grouped by \code{...} and columns for Shapiro Test.
#' @examples
#' nanoShapiro(starwars, species, param_var = mass)
#' nanoShapiro(starwars, gender, param_var = height)
#' @keywords statistics, parametric test, normality, nested
#' @import tidyverse
#' @export


nanoShapiro <- function(df, ..., value) {

  group_var <- quos(...)
  value <- enquo(value)


  df %>%
    group_by(!!! group_var) %>%
    nest() %>%
    mutate(
        Shapiro = map(data, ~shapiro.test(pull(.x, quo_name(value)))),  # perform a normality test
        glance = map(Shapiro, glance)) %>%
    unnest(glance, .drop = TRUE) %>%
    mutate(Normal_dist = case_when(p.value >.05 ~ TRUE,
                                   p.value <.05 ~ FALSE ),
           Statistical_test = case_when(Normal_dist == TRUE ~ "Perform parametric test",
                                        Normal_dist == FALSE ~ "Perform non-parametric test"))

}
