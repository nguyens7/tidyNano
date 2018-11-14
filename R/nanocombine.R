#' A Nanosight  Import Function
#'
#' This function allows you import and combine multiple data files into one data frame.
#' @param dir The directory where files are located, defaults to global working directory
#' @param range The range of values used during NTA data acquisition, defaults to 1000.
#' @param bin_width The bin width used during NTA data acquisition, defaults to 1.
#' @param nm_start Starting measurement value (nm), defaults to 0.5nm
#' @param auto_name Extracts sample and dilution data and appends to column header, defaults to FALSE.
#' @param custom_name Append custom name to column header, defaults to NULL.
#' @return Dataframe of NTA data.
#' @examples nanocombine(dir = "file_folder")
#' @keywords import, load, extract
#' @import tidyr
#' @export



nanocombine <- function(dir = "",
                         range = 1000,
                         bin_width = 1,
                         nm_start = 0.5,
                         auto_name = FALSE,
                         custom_name = NULL ){

  csv_files <- here::here(dir = dir) %>%
    list.files(pattern = "*.csv",full.names = TRUE)

  message(glue::glue("Detected the following files {csv_files}"))

  complete_df <- purrr::map(csv_files, ~nanoimport(file = .x,
                                                    range = range,
                                                    bin_width = bin_width,
                                                    nm_start = nm_start,
                                                    auto_name = auto_name,
                                                    custom_name = custom_name)) %>%
    dplyr::bind_cols()

  part_size_df <- complete_df %>%
    select(particle_size)

  sample_df <- complete_df %>%
    dplyr::select(-starts_with("particle_size"))

  final_df <- part_size_df %>%
    dplyr::bind_cols(sample_df)

  final_df
}
