
#' @title Detect Dutch Racist Speech
#' @description Detect Dutch Racist Speech in a character vector
#' @param x a character vector of length 1 in UTF-8 encoding
#' @param detector an object of class \code{dutch_racism_terms} as returned by \code{racism_detector}
#' @param language the language. Defaults to 'dutch'
#' @param type character either udpipe or tau indicating to tokenise text with the udpipe R package or using the tau R package. Defaults to the tau package.
#' @param anno a data.frame with 1 row per term in \code{x} containing the columns token and lemma. Only used if type is set to udpipe.
#' @param detailed logical indicating to return a detailed description of each word in the character vector if it was racist + how many times it occurred (if type is tau).
#' Or to return the annotated udpipe dataset which indicates the 16 categories next to the whole text.
#' @export
#' @return a list with 16 elements indicating the counting of words in 16 racist categories
#' @seealso \code{\link{racism_detector}}
#' @examples
#' data(dutch_racistspeech)
#' racismtypes <- racism_detector(dutch_racistspeech, type = "original")
#' 
#' x <- "Eigen volk gaat voor, want die vuile manieren van de
#' EU moeten wij vanaf. Geen EU en geen VN. Waardeloos
#' en tegen onze mensen."
#' detect_hatespeech(x, detector = racismtypes, type = "tau")
#' detect_hatespeech(x, detector = racismtypes, type = "udpipe")
#' 
#' x <- "Burgemeester Termont is voor de zwartzakken die kiezen voor hem"
#' detect_hatespeech(x, detector = racismtypes, type = "tau")
#' detect_hatespeech(x, detector = racismtypes, type = "udpipe")
#' 
#' x <- "Oprotten die luizegaards"
#' detect_hatespeech(x, detector = racismtypes, type = "tau")
#' detect_hatespeech(x, detector = racismtypes, type = "udpipe")
#' 
#' x <- "Wil weer eens lukken dat wij met het vuilste krapuul
#' zitten, ik verschiet er zelfs niet van!"
#' detect_hatespeech(x, detector = racismtypes, type = "tau")
#' detect_hatespeech(x, detector = racismtypes, type = "udpipe")
#' 
#' x <- "Kan je niets aan doen dat je behoort tot het ras dat
#' nog minder verstand en gevoelens heeft in uw hersenen
#' dan het stinkend gat van een VARKEN ! :-p"
#' detect_hatespeech(x, detector = racismtypes, type = "tau")
#' detect_hatespeech(x, detector = racismtypes, type = "udpipe")
#' 
#' x <- "Het zijn precies de vreemden die de haat of het racisme
#' opwekken bij de autochtonen"
#' detect_hatespeech(x, detector = racismtypes, type = "tau")
#' detect_hatespeech(x, detector = racismtypes, type = "udpipe")
detect_hatespeech <- function(x, detector = racism_detector(), 
                          language = "dutch", type = c("tau", "udpipe"), anno = udpipe(x, language), detailed = FALSE){
  stopifnot(length(x) == 1)
  stopifnot(language == "dutch")
  type <- match.arg(type)
  if(type == "udpipe"){
    x <- lapply(detector, FUN=function(type, lemma, token){
      is_racism <- lemma %in% type$term_asis | token %in% type$term_asis
      if(length(type$regex) > 0){
        is_racism <- is_racism | grepl(pattern = type$regex, lemma) | grepl(pattern = type$regex, token)
      }
      is_racism
    }, lemma = anno$lemma, token = anno$token)
    x <- data.frame(x, stringsAsFactors = FALSE, check.names = FALSE)
    if(detailed){
      anno[, names(x)] <- x
      result <- anno
    }else{
      result <- as.list(colSums(x))
    }
  }else if(type == "tau"){
    wordfreq <- tau::textcnt(x = x, n = 1L, tolower = TRUE, method = "string", split = "[[:space:][:punct:][:digit:]]+")
    result <- lapply(detector, FUN=function(type, wordfreq, detailed){
      found <- names(wordfreq)[wordfreq %in% type$term_asis]
      if(length(type$regex) > 0){
        found <- append(found, grep(pattern = type$regex, names(wordfreq), value = TRUE))  
      }
      idx <- which(!names(wordfreq) %in% found)
      wordfreq[idx] <- 0L
      if(detailed == TRUE){
        return(wordfreq)
      }else{
        return(sum(wordfreq))
      }
    }, wordfreq = wordfreq, detailed = detailed)
  }
  result
}




#' @title Create a racism detector
#' @description Create a racism detector. This is basically a set of regular expressions
#' @param x a data.frame like the \code{dutch_racistspeech} inside this package
#' @param type either one of 'original', 'cleaned', 'expanded' to work on either one of the data
#' @export
#' @return an object of class \code{dutch_racism_terms} which is basically a list of words
#' which need to be found in the text as is and a regular expression containing hatespeech terms
#' @seealso \code{\link{detect_hatespeech}}, \code{\link{dutch_racistspeech}}
#' @examples
#' racismtypes <- racism_detector(type = "expanded")
#' 
#' data(dutch_racistspeech)
#' racismtypes <- racism_detector(dutch_racistspeech, type = "original")
racism_detector <- function(x, type = c("original", "cleaned", "expanded")){
  if(missing(x)){
    myenv <- new.env()
    utils::data("dutch_racistspeech", envir = myenv)
    x <- myenv$dutch_racistspeech
  }
  
  type <- match.arg(type)
  x <- x[x$data_type %in% type, ]
  x <- split(x, x$category)
  x <- lapply(x, FUN=function(x) x$term)
  ## Handle * and +
  ## * is an inclusive wildcard, it's optional; it matches the word with or without any affixes moslim* matches both moslim and moslims
  ## + is an exclusive wildcard, it's required; it only matches words when an affix is attached, e.g. +moslim will match rotmoslim but not moslim by itself
  x <- lapply(x, FUN=function(term){
    original <- term
    firstletter <- substr(term, 1, 1)
    lastletter <- substr(term, nchar(term), nchar(term))
    term <- ifelse(!firstletter %in% c("*", "+"), term,
                   ifelse(firstletter == "*", sprintf("^.*%s", substr(term, 2, nchar(term))), 
                   ifelse(firstletter == "+", sprintf("^.+%s", substr(term, 2, nchar(term))), NA)))
    term <- ifelse(!lastletter %in% c("*", "+"), term,
                   ifelse(lastletter == "*", sprintf("%s.*$", substr(term, 1, nchar(term)-1)), 
                   ifelse(lastletter == "+", sprintf("%s.+$", substr(term, 1, nchar(term)-1)), NA)))
    out <- list(terms = original, 
         term_asis = grep("\\*|\\+", term, value = TRUE, invert = TRUE),
         term_infixsuffix = grep("\\*|\\+", term, value = TRUE, invert = FALSE))
    if(length(out$term_infixsuffix) > 0){
      out$regex <- paste(out$term_infixsuffix, collapse="|")  
    }else{
      out$regex <- c()
    }
    out[c("term_asis", "regex")]
  })
  class(x) <- c("dutch_racism_terms", "list")
  x
}