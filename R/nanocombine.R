#' A Nanosight  Import Function
#'
#' This function allows you import and combine multiple data files into one data frame.
#' @param dir The directory where files are located, defaults to global working directory
#' @param bin_width The bin width used during NTA data acquisition, defaults to 1.
#' @param range The range of values used during NTA data acquisition, defaults to 1000.
#' @param NTA_version Version of NTA software (2.3, 3.1, 3.2).
#' @param extra_param Presence of additional data beside counts (Surface Area and Volume weighting)
#' @return Dataframe of nanosight values.
#' @examples nanocombine(dir = "file_folder", bin_width = 1, range = 1000, NTA_version = 3.2)
#' @keywords import, load, extract
#' @import tidyverse
#' @export

nanocombine <- function(dir = "",
                         bin_width = 1,
                         range = 1000,
                         NTA_version,
                         extra_param = NULL){

  csv_files <- here::here(dir, list.files(here::here(dir), pattern = "*.csv"))

  message(paste("Reading in file",csv_files))
  message(paste("bin_width =",bin_width))
  message(paste("NTA_version =",NTA_version))

  complete_df <- purrr::map(csv_files, ~nanoimport2(file = .x,
                                                    bin_width = bin_width,
                                                    range = range,
                                                    NTA_version = NTA_version,
                                                    extra_param = extra_param)) %>%
    dplyr::bind_cols()

  part_size_df <- complete_df[,1]

  sample_df <- complete_df %>%
    dplyr::select(-starts_with("particle_size"))

  final_df <- part_size_df %>%
    dplyr::bind_cols(sample_df)

  final_df
}

