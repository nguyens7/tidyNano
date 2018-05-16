#' A Nanosight Data Import Function
#'
#' This function allows you aggregate or summarize your data by groups.
#' @param file A .csv file from a Malvern Nanosight machine.
#' @bin_width The bin width used during NTA data acquisition, defaults to 1.
#' @NTA_version Version of NTA software (3.1,3.2)
#' @return Dataframe of nanosight values.
#' @examples nanoimport(file = "nanofile.csv", bin_width = 1, NTA_version = 3.2)
#' @keywords import, load, extract
#' @import tidyverse
#' @export


nanoimport <- function(file, bin_width = 1, NTA_version) {

  if(NTA_version == 3.2){

    header_skip <- 77
    df_skip <- 87

  }else if(NTA_version == 3.1){

    header_skip <- 76
    df_skip <- 86

  }else{stop("Error: Please specify NTA version.")
  }

  num_rows <- length(seq(0.5 ,1000, bin_width))

  header <- read.csv(file, skip = header_skip, header = F,
                     nrows = 1, as.is = T, stringsAsFactors = FALSE)

  df <-  read.csv(file, skip = df_skip, header = F,
                  nrows = num_rows, stringsAsFactors = FALSE)

  colnames(df) <-  header

  df <-  df[!is.na(names(df))] # Remove NA column

  df %>%
    rename(particle_size = Filename) %>%
    select(-Average, -`Standard Error`) %>%
    as_tibble()
}
