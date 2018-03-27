#' A nested ANOVA Function
#'
#' This function allows you aggregate or summarize your data by groups.
#' @param df A dataframe.
#' @param ... Columns to group by.
#' @param value The numerical value that you want to summarize.
#' @param variable The variable you wish to compare between.
#' @return A nested data frame grouped by \code{...} and columns for Shapiro Test,
#' ANOVA and Tukey HSD post hoc test.
#' @examples
#' nanoANOVA(starwars, species, param_var = mass)
#' nanoANOVA(starwars, gender, param_var = height)
#' @keywords statistics, ANOVA, nested
#' @export


nanoANOVA <- function(df, ..., name = "Param", value, variables) {

  group_var <- quos(...)
  numeric <- enquo(value)
  factor <- enquo(variables)

  anova <- function(df){
    numeric <- enquo(value)
    factor <- enquo(variables)
    aov(!!value ~ !!variables, data = df)
  }


  df %>%
   group_by(!!! group_var) %>%
   nest() %>%
   mutate( ANOVA = map(data, anova)) # calculate the ANOVA for time values

}
