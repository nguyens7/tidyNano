#' A nested Normality Test
#'
#' This function allows you aggregate or summarize your data by groups.
#' @param df A dataframe.
#' @param ... Columns to group by.
#' @param value The numerical value that you want to summarize.
#' @return A nested data frame grouped by \code{...} and columns for Shapiro Test.
#' @keywords statistics, parametric test, normality, nested
#' @import broom
#' @export


nanoShapiro <- function(df, ..., value) {

  group_var <- rlang::quos(...)
  value <- enquo(value)


  Shapiro_df <- df %>%
    dplyr::group_by(!!! group_var) %>%
    tidyr::nest() %>%
    dplyr::mutate(
      Shapiro = purrr::map(data, ~stats::shapiro.test(pull(.x, quo_name(value)))),
      Shapiro_glance = purrr::map(Shapiro, broom::glance)) %>%
    tidyr::unnest(Shapiro_glance, .drop = TRUE) %>%
    dplyr::mutate(Normal_dist = dplyr::case_when(p.value > 0.05 ~ TRUE,
                                                 p.value < 0.05 ~ FALSE),
                  Statistical_test = dplyr::case_when(Normal_dist == TRUE ~ "Perform parametric test",
                                                      Normal_dist == FALSE ~ "Perform non-parametric test")) %>%
    dplyr::ungroup()

  return(Shapiro_df)

}
