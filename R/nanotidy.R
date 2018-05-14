#' A Tidy Function
#'
#' This function allows you tidy Nanosight data.  It will make the data go from
#' 'wide' to 'long'.
#' @param df A dataframe.
#' @param col Specify the range of columns to tidy (x:z).
#' @param sep_var Numerical range of columns to tidy, specify "2:n" where n is the last column
#' @return Gathers values from 'wide' to 'long' format. Returns a dataframe with a
#' Sample and Count column.
#' @examples
#' nanotidy(data, col = 2:12, sep_var = c("Sample","Dilution","Treatment","Condition"))
#' @keywords aggregate, clean, tidy
#' @import tidyverse
#' @export

nanotidy <- function(df, col, sep_var){

  tidy_df <- df %>%
    gather(Sample, Count, col) %>%
    separate(Sample, into = sep_var, sep = "_", convert = TRUE) %>%
    mutate_at(vars(Count),as.numeric)

  if("Dilution" %in% colnames(tidy_df)){

    fac_var <- sep_var[!sep_var %in% "Dilution"]

    tidy_df %>%
      mutate_at(vars(fac_var),as.factor) %>%
      mutate(Dilution =  as.numeric(Dilution),
             True_count = Count * Dilution)

  } else{stop("Error: No \"Dilution\" column present.")
  }
}
