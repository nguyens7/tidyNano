#' A Nanosight  Import Function
#'
#' This function allows you import and combine multiple data files into one data frame.
#' @param dir The directory where files are located, defaults to global working directory
#' @bin_width The bin width used during NTA data acquisition, defaults to 1.
#' @NTA_version Version of NTA software (3.1,3.2)
#' @return Dataframe of nanosight values.
#' @examples nanoimport(file = "nanofile.csv", bin_width = 1, NTA_version = 3.2)
#' @keywords import, load, extract
#' @import tidyverse
#' @export

nanocombine <- function(dir = "", bin_width, NTA_version){

  csv_files <- here::here(dir, list.files(here::here(dir), pattern = "*.csv"))

  message(paste("Reading in file",csv_files))
  message(paste("bin_width =",bin_width))
  message(paste("NTA_version =",NTA_version))

  complete_df <- purrr::map(csv_files, ~nanoimport(file = .x,
                                                   bin_width = bin_width,
                                                   NTA_version = NTA_version)) %>%
    dplyr::bind_cols()

  part_size_df <- complete_df[,1]

  sample_df <- complete_df %>%
    dplyr::select(-starts_with("particle_size"))

  final_df <- part_size_df %>%
    dplyr::bind_cols(sample_df)

  final_df
}

