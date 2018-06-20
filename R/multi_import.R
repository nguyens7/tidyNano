#' A Nanosight Import Function from Multiple Folders
#'
#' This function allows for the import and combining of multiple csv files within multiple folders into a single data frame.
#' @param dir The parent directory where folder and subsequent files are located, defaults to global working directory
#' @param bin_width The bin width used during NTA data acquisition, defaults to 1.
#' @param range The range of values used during NTA data acquisition, defaults to 1000.
#' @param NTA_version Version of NTA software (2.3, 3.1, 3.2).
#' @return Dataframe of nanosight values.
#' @examples multi_import(dir = "parent_folder", bin_width = 1, range = 1000, NTA_version = 3.2)
#' @keywords import, load, extract
#' @import tidyverse
#' @export

multi_import <- function(dir,range, bin_width, NTA_version ){

  file_path <- here(dir) %>%
    list.files() %>%
    paste0(dir,"/", .) %>%
    as.list()

  file_path %>%
    map(~nanocombine(dir = ., range = range,
                     bin_width = bin_width,
                     NTA_version = NTA_version)) %>%
    as.data.frame()

}

