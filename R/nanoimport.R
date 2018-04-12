#' A Nanosight Data Import Function
#'
#' This function allows you aggregate or summarize your data by groups.
#' @param csv A .csv file from a Malvern Nanosight machine.
#' @return Dataframe of nanosight values.
#' @examples
#' nanoimport("nanofile.csv")
#' @keywords aggregate, summarize, summary statistics
#' @import tidyverse
#' @export

nanoimport <- function(file) {

  file <- file

  header <- read.csv(file, skip = 77,
                     header = F, nrows = 1, as.is = T, stringsAsFactors = FALSE)

  df <-  read.csv(file, skip = 87,
                   header = F, nrows = 1000, stringsAsFactors = FALSE)

  colnames(df) <-  header

  df %>%
    rename(particle_size = Filename) %>%
    select(-Average, -`Standard Error`) %>%
    as_tibble()
}

