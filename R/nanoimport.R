#' A Nanosight Data Import Function
#'
#' This function allows you aggregate or summarize your data by groups.
#' @param file A .csv file from a Malvern Nanosight machine.
#' @param bin_width The bin width used during NTA data acquisition, defaults to 1.
#' @param range The range of values used during NTA data acquisition, defaults to 1000.
#' @param NTA_version Version of NTA software (2.3,3.1,3.2).
#' @param extra_param Presence of additional data beside counts (Surface Area and Volume weighting)
#' @return Dataframe of nanosight values.
#' @examples nanoimport(file = "nanofile.csv", bin_width = 1,, range = 1000, NTA_version = 3.2)
#' @keywords import, load, extract
#' @import dplyr
#' @export


nanoimport <- function(file, bin_width = 1,
                        range = 1000,
                        NTA_version,
                        extra_param = NULL){

  if(NTA_version == 2.3){

    header_skip <- 71
    df_skip <- 73
    nm_start <- 0

    num_rows <- length(seq(nm_start , range, bin_width))

    header <- read.csv(file, skip = header_skip, header = F,
                       nrows = 1, as.is = T, stringsAsFactors = FALSE)

    df <-  read.csv(file, skip = df_skip, header = F,
                    nrows = num_rows, stringsAsFactors = FALSE)

    colnames(df) <-  header

    df <-  df[!is.na(names(df))] # Remove NA column

    df2.3 <- df %>%
      dplyr::rename(particle_size = Filename) %>%
      dplyr::select(-`NA`) %>%
      dplyr::as_tibble()

    return(df2.3)

  }else if(NTA_version == 3.2 & is.null(extra_param)){

    header_skip <- 77
    df_skip <- 87
    nm_start <- 0.5

  }else if(NTA_version == 3.1){

    header_skip <- 76
    df_skip <- 86
    nm_start <- 0.5

  }else if(NTA_version == 3.2 & extra_param == TRUE ){

    header_skip <- 82
    df_skip <- 92
    nm_start <- 0.5


  }else{stop("Error: Please specify NTA version.")

  }

  num_rows <- length(seq(nm_start , range, bin_width))

  header <- read.csv(file, skip = header_skip, header = F,
                     nrows = 1, as.is = T, stringsAsFactors = FALSE)

  df <-  read.csv(file, skip = df_skip, header = F,
                  nrows = num_rows, stringsAsFactors = FALSE)

  colnames(df) <-  header

  df <-  df[!is.na(names(df))] # Remove NA column

  df %>%
    dplyr::rename(particle_size = Filename) %>%
    dplyr::select(-Average, -`Standard Error`) %>%
    dplyr::as_tibble()
}


