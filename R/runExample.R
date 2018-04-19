#' Run shinyNano app
#'
#' This function allows you open an instance of shinyNano.
#' @param
#' @return shinyNano web app
#' @examples runExample()
#' @keywords shinyNano, shiny, tidyNano
#' @import tidyverse, shiny, shinythemes, plotly, DT
#' @export



runExample <- function() {

  appDir <- system.file("shiny-examples", "shinyNano", package = "tidyNano")
  if(appDir == "") {
    stop("Could not find example directory. Try re-installing `tidyNano`",
         call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")
}
