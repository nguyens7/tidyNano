#' A Nanosight  Import Function
#'
#' This function allows you import and combine multiple data files into one data frame.
#' @param dir The directory where files are located, defaults to global working directory
#' @param auto_name Extracts sample and dilution data and appends to column header, defaults to FALSE.
#' @param custom_name Append custom name to column header, defaults to NULL.
#' @return Dataframe of NTA data.
#' @keywords import, load, extract
#' @import dplyr
#' @export



nanocombine <- function(dir = "", auto_name = FALSE, custom_name = NULL){

  csv_files <- here::here(dir = dir) %>%
    list.files(pattern = "*.csv",full.names = TRUE)

  # csv_files
  message(glue::glue("Detected the following files {csv_files}"))

  complete_df <- purrr::map(csv_files, ~tidyNano::nanoimport(file = .x,
                                         auto_name = auto_name,
                                         custom_name = custom_name) %>%
                                rename(particle_size = 1) # fixes first column
                            ) %>%
    dplyr::bind_cols(.name_repair = "minimal")


  complete_df
}
