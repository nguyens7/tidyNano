#' A Nanosight Data Import Function
#'
#' This function allows you aggregate or summarize your data by groups.
#' @param file A .csv file from a Malvern Nanosight machine.
#' @param auto_name Extracts sample and dilution data and appends to column header, defaults to FALSE.
#' @param custom_name Append custom name to column header, defaults to NULL.
#' @return Dataframe of NTA data.
#' @keywords import, load, extract
#' @import dplyr
#' @export



nanoimport <- function(file,
                        auto_name = FALSE,
                        custom_name = NULL){

  # NTA version
  NTA_Version <- read.csv(file, header = FALSE)[2,1] %>%
    stringr::str_sub(18,20)

  message(glue::glue("NTA version: {NTA_Version}"))

  # Sample name
  sample_name <- utils::read.csv(file, header = FALSE, blank.lines.skip = FALSE)[7,2]

  message(glue::glue("Sample name: {sample_name}"))

  # Dilution factor

  NTA_text <- readLines(file)

  dilution_line_no <- grep("^\\[Results\\]", NTA_text)

  message(glue::glue("Dilution line no: {dilution_line_no}"))

  dilution <- read.csv(file, header = FALSE, skip = dilution_line_no, nrows = 1)[,2] %>%
    as.numeric()

  message(glue::glue("Dilution factor detected: {dilution}"))

  # Autoname

  if(auto_name == FALSE && is.null(custom_name) ){

    gen_auto_name <- ""
    dilution <- 1

    message(glue::glue("Auto name = FALSE
                       Custom name: NULL
                       Dilution value: {dilution} (Didn't parse)"))

  }else if(auto_name == FALSE){

    gen_auto_name <- paste0("_", custom_name)
    dilution <- 1

    message(glue::glue("Auto name = FALSE
                       Custom name: {custom_name}
                       Dilution value: {dilution} (Didn't parse)"))

  }else if(auto_name == TRUE && is.null(custom_name) ){

    gen_auto_name <- base::paste0("_", dilution)

    message(glue::glue("Auto name: {gen_auto_name}
                       Custom name: NULL
                       Dilution value: {dilution}"))

  }else if(auto_name == TRUE ){

    gen_auto_name <- base::paste0("_",custom_name, "_", sample_name, dilution)

    message(glue::glue("Auto name: {gen_auto_name}
                       Custom name: {custom_name}
                       Dilution value: {dilution}"))
  }

  # Import data

  header_skip <- base::grep("^Filename", NTA_text)[2] - 1

  df_skip <- base::grep("^Bin centre", NTA_text)

  df_end <- base::grep("^Percentile", NTA_text) - 2

  num_rows <- df_end - df_skip

  header <- utils::read.csv(file, skip = header_skip, header = FALSE,
                     nrows = 1, as.is = T, stringsAsFactors = FALSE)

  df <-  utils::read.csv(file, skip = df_skip, header = FALSE, nrows = num_rows,
                  stringsAsFactors = FALSE)

  base::colnames(df) <-  header

  df <-  df[!is.na(names(df))] # Remove NA column

  part_size <- df %>%
    dplyr::rename(particle_size = Filename) %>%
    dplyr::select(particle_size)

  dilute_correction <- function(x){x/dilution}

  NTA_data <- df %>%
    dplyr::select(-Filename, -Average, -`Standard Error`) %>%
    dplyr::rename_all( ~ paste0(., gen_auto_name)) %>%
    dplyr::as_tibble() %>%
    dplyr::mutate_all(dilute_correction) #adjust dilution factor if entered in during acquisition
  # nanotidy() will correct for this with the `True_count` column
  part_size %>%
    dplyr::bind_cols(NTA_data)

}
