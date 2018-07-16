#' A Function to Save Tidy Data Frames
#'
#' This function exports data frames into Rds files.
#' @param df file data frame.
#' @param name The name of the Rds file, defaults to "tidyNano.Rds".
#' @examples nanosave(stawars, name = "Star_Wars")
#' @keywords save, export
#' @export


nanosave <- function(df,name = "tidyNano") {

  file <- paste0(name, ".Rds")

  saveRDS(df, file)
}
