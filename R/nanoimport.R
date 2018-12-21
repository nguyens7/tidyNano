#' A Nanosight Data Import Function
#'
#' This function allows you aggregate or summarize your data by groups.
#' @param file A .csv file from a Malvern Nanosight machine.
#' @param range The range of values (nm) used during NTA data acquisition, defaults to 1000.
#' @param bin_width The bin width used during NTA data acquisition, defaults to 1.
#' @param nm_start Starting measurement value (nm), defaults to 0.5nm
#' @param auto_name Extracts sample and dilution data and appends to column header, defaults to FALSE.
#' @param custom_name Append custom name to column header, defaults to NULL.
#' @return Dataframe of NTA data.
#' @examples nanoimport(file = "nanofile.csv")
#' @keywords import, load, extract
#' @import dplyr
#' @export



nanoimport <- function(file,
                        range = 1000,
                        bin_width = 1,
                        nm_start = 0.5,
                        auto_name = FALSE,
                        custom_name = NULL){

  # NTA version
  NTA_version <- utils::read.csv(file, header = FALSE)[2,1] %>%
    stringr::str_sub(18,20) %>%
    as.numeric()

  message(glue::glue("NTA version: {NTA_version}"))

  # Sample name
  sample_name <- utils::read.csv(file, header = FALSE, blank.lines.skip = FALSE)[7,2]

  message(glue::glue("Sample name: {sample_name}"))

  # Detect number of parameters
  param <- suppressWarnings(readr::read_csv(file, skip = 71,
                                            n_max = 20,
                                            col_types = cols()))[,1] %>%
    dplyr::rename(data = `[Data Included]`) %>%
    tidyr::drop_na() %>%
    dplyr::mutate(num = row_number()) %>%
    dplyr::filter(data == "[Size Data]") %>%
    dplyr::select(num)

  param_num <- param$num - 1

  message(glue::glue("Number of parameters detected: {param_num}"))

  # Dilution factor
  dilution <- read.csv(file, header = FALSE, skip = 42, nrows = 1)[,2] %>%
    as.numeric()

  message(glue::glue("Dilution factor detected: {dilution}"))

  # Import
  if(NTA_version == 2.3){

    header_skip <- 71
    df_skip <- 73
    nm_start <- 0

  }else if(NTA_version == 3.1){

    header_skip <- 76
    df_skip <- 86

  }else if(NTA_version == 3.2 && auto_name == FALSE && is.null(custom_name) ){

    header_skip <- 76 + param_num
    df_skip <- header_skip + 10
    gen_auto_name <- ""
    dilution <- 1

    message(glue::glue("Auto name = FALSE
                       Custom name: NULL
                       Dilution value: {dilution} (Didn't parse)"))

  }else if(NTA_version == 3.2 && auto_name == FALSE ){

    header_skip <- 76 + param_num
    df_skip <- header_skip + 10
    gen_auto_name <- paste0("_", custom_name)
    dilution <- 1

    message(glue::glue("Auto name = FALSE
                       Custom name: {custom_name}
                       Dilution value: {dilution} (Didn't parse)"))

  }else if(NTA_version == 3.2 && auto_name == TRUE && is.null(custom_name) ){
    header_skip <- 76 + param_num
    df_skip <- header_skip + 10
    gen_auto_name <- paste0("_", sample_name, "_", dilution)

    message(glue::glue("Auto name: {gen_auto_name}
                       Custom name: NULL
                       Dilution value: {dilution}"))

  }else if(NTA_version == 3.2 && auto_name == TRUE ){

    header_skip <- 76 + param_num
    df_skip <- header_skip + 10
    gen_auto_name <- paste0("_", custom_name, "_", sample_name, "_", dilution)

    message(glue::glue("Auto name: {gen_auto_name}
                       Custom name: {custom_name}
                       Dilution value: {dilution}"))
  }

  # Generation of data frame
  num_rows <- length(seq(nm_start , range, bin_width))

  header <- read.csv(file, skip = header_skip, header = FALSE,
                     nrows = 1, as.is = T, stringsAsFactors = FALSE)

  df <-  read.csv(file, skip = df_skip, header = FALSE,
                  nrows = num_rows, stringsAsFactors = FALSE)

  colnames(df) <-  header

  df <-  df[!is.na(names(df))] # Remove NA column

  part_size <- df %>%
    dplyr::rename(particle_size = Filename) %>%
    dplyr::select(particle_size)

  NTA_data <- df %>%
    dplyr::select(-Filename, -Average, -`Standard Error`) %>%
    dplyr::rename_all( ~ paste0(., gen_auto_name)) %>%
    dplyr::as_tibble() %>%
    dplyr::mutate_all(funs( . / dilution))

  part_size %>%
    dplyr::bind_cols(NTA_data)

  }
