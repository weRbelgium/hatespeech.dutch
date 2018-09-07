
#' @name dutch_racistspeech
#' @title Dutch Racist Speech dataset
#' @description Dutch Racist Speech dataset. The dataset provides racist
#' speech of the following types
#' Neutral-Country, Neutral-Migration, Neutral-Nationality, Neutral-Religion, Neutral-Skin_color, 
#' Racist-Animals, Racist-Country, Racist-Crime, Racist-Culture, Racist-Diseases, Racist-Migration, Racist-Nationality, Racist-Race, Racist-Religion, Racist-Skin_color, Racist-Stereotypes
#' 
#' The dataset itself is a data.frame with columns 
#' 
#' \itemize{
#' \item data_type: either one of 'original', 'expanded', 'cleaned' corresponding to the paper of the authors
#' \item category: the type of racism (16 possibilities)
#' \item term: text with a regular expression in UTF-8. Mark that * and + have special meaning according to the authors. 
#' namely * matches any infix or suffix while + means match only if there is something added in front or after so not the word itself (more info see the reference)
#' }
#' 
#' @docType data
#' @source \url{https://github.com/clips/hades}
#' @references \url{http://www.ta-cos.org/sites/ta-cos.org/files/dictionary-based-approach.pdf}
#' @examples
#' data(dutch_racistspeech)
#' head(dutch_racistspeech)
#' table(dutch_racistspeech$category)
NULL

