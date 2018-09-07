# Racism Detection in Dutch with R

Racism Detection in Dutch with R based on the CLiPS HAte speech DEtection System dataset. The dataset provides a dictionary of racist language used in Dutch, provided under the [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/) license.

- The  **hatespeech.dutch** package provides the dataset in R format and provides R functions to easily work detect racism in the Dutch language. 

- The package allows to **detect the 16 categories of hatespeech**: 
Neutral-Country, Neutral-Migration, Neutral-Nationality, Neutral-Religion, Neutral-Skin_color, Racist-Animals, Racist-Country, Racist-Crime, Racist-Culture, Racist-Diseases, Racist-Migration, Racist-Nationality, Racist-Race, Racist-Religion, Racist-Skin_color, Racist-Stereotypes



## Example


```r
library(hatespeech.dutch)
library(tau)
racismtypes <- racism_detector(type = "expanded")

x <- "Kan je niets aan doen dat je behoort tot het ras dat nog minder verstand en gevoelens heeft in uw hersenen dan het stinkend gat van een VARKEN ! :-p"
detect_racism(x, detector = racismtypes)
```

```
$`Neutral-Country`
[1] 0

$`Neutral-Migration`
[1] 0

$`Neutral-Nationality`
[1] 0

$`Neutral-Religion`
[1] 0

$`Neutral-Skin_color`
[1] 0

$`Racist-Animals`
[1] 0

$`Racist-Country`
[1] 0

$`Racist-Crime`
[1] 0

$`Racist-Culture`
[1] 0

$`Racist-Diseases`
[1] 0

$`Racist-Migration`
[1] 0

$`Racist-Nationality`
[1] 0

$`Racist-Race`
[1] 1

$`Racist-Religion`
[1] 0

$`Racist-Skin_color`
[1] 0

$`Racist-Stereotypes`
[1] 0
```


```r
library(hatespeech.dutch)
library(udpipe)
x <- "Omdat SF het woord hoer vaak benoemt, heb ik er maar halal hoer van gemaakt :zozo: Ik vond 'hoer zo onbeschoft om te benoemen, dus wat verzacht met halal..
Halal hoer bestaat toch niet? :vreemd:"
detection <- detect_racism(x, detector = racismtypes, type = "udpipe", detailed = TRUE)
detection[, c("token", "lemma", "Racist-Culture", "Racist-Religion", "Racist-Skin_color")]
```

```
        token      lemma Racist-Culture Racist-Religion Racist-Skin_color
1       Omdat      omdat          FALSE           FALSE             FALSE
2          SF         SF          FALSE           FALSE             FALSE
3         het        het          FALSE           FALSE             FALSE
4       woord      woord          FALSE           FALSE             FALSE
5        hoer       hoer          FALSE           FALSE              TRUE
6        vaak       vaak          FALSE           FALSE             FALSE
7     benoemt     benoem          FALSE           FALSE             FALSE
8           ,          ,          FALSE           FALSE             FALSE
9         heb        heb          FALSE           FALSE             FALSE
10         ik         ik          FALSE           FALSE             FALSE
11         er         er          FALSE           FALSE             FALSE
12       maar       maar          FALSE           FALSE             FALSE
13      halal      halal           TRUE            TRUE             FALSE
14       hoer       hoer          FALSE           FALSE              TRUE
15        van        van          FALSE           FALSE             FALSE
...
```

## How does this work?

A tokeniser (tau R package or udpipe R package) tokenises the full text in words. The `detect_racism` function next looks for each word or lemma of the word if it is part of the racismtypes dictionary or it looks if it finds a more complex regular expression in the tokenised data.
An example dictionary for racist-religion looks as follows:


```r
racismtypes[["Racist-Religion"]]
```

```
$term_asis
  [1] "abdel"                 "ahmad"                
  [3] "ahmed"                 "alah"                 
  [5] "alevieten"             "allah"                
  [7] "allahs"                "arabieren"            
  [9] "athe?st"               "aziz"                 
 [11] "boeddhist"             "boerka"               
 [13] "boodschapper"          "booslimschoft"        
 [15] "burka"                 "christen"             
 [17] "christenen"            "communist"            
 [19] "dhimmit"               "extremist"            
 [21] "fanaticus"             "fascist"              
 [23] "fitnah"                "fundamentalisme"      
 [25] "fundamentalist"        "fundamentalistische"  
 [27] "gelovige"              "gezalfde"             
 [29] "ghazi"                 "godsdienstverkrachter"
 [31] "hadji"                 "halal"                
 [33] "halalvlees"            "hallal"               
 [35] "haram"                 "hindus"               
 [37] "hoofddoek"             "hoofddoekje"          
 [39] "hoofdoek"              "ibrahim"              
 [41] "ieten"                 "infidels"             
 [43] "islaam"                "islam"                
 [45] "islamiet"              "islamieten"           
 [47] "islamisme"             "islamist"             
 [49] "islamitische"          "israel"               
 [51] "israeli"               "israeliet"            
 [53] "isra?li"               "isra?liet"            
 [55] "jeremia"               "jesaja"               
 [57] "jewish"                "jezus"                
 [59] "jihaad"                "jihad"                
 [61] "jihadist"              "joden"                
 [63] "jodin"                 "jood"                 
 [65] "joodse"                "kaafir"               
 [67] "kafirs"                "koosjer"              
 [69] "koosjere"              "koran"                
 [71] "kosher"                "kosjer"               
 [73] "kuffar"                "kufr"                 
 [75] "maleachi"              "marokaan"             
 [77] "marokkaan"             "marxist"              
 [79] "messias"               "mohamed"              
 [81] "mohammad"              "mohammed"             
 [83] "mohammedaan"           "mohammedaanse"        
 [85] "mohammedanen"          "mohammedist"          
 [87] "moslem"                "moslems"              
 [89] "moslim"                "moslima"              
 [91] "moslimman"             "moslims"              
 [93] "moslimvrouw"           "moslimvrouwen"        
 [95] "muselman"              "muslim"               
 [97] "muslims"               "muzelman"             
 [99] "muzzie"                "nationalist"          
[101] "nepgeloof"             "niet-joden"           
[103] "niet-jood"             "niet-moslim"          
[105] "niqaab"                "palestijnen"          
[107] "populist"              "profeet"              
[109] "profeten"              "rabbis"               
[111] "racist"                "scharrelvlees"        
[113] "sharia"                "sji"                  
[115] "slachten"              "soeniet"              
[117] "soenieten"             "soenniet"             
[119] "soennieten"            "soennitisch"          
[121] "soennitische"          "sunni"                
[123] "terrorist"             "ummah"                
[125] "varkensvlees"          "vrome"                
[127] "vzmh"                  "yusuf"                
[129] "zandgod"               "zionism"              
[131] "zionist"               "zionisten"            
[133] "zwartrok"             

$regex
[1] "^.*islamiet|^.+islam|^.+jood|^.+moslim|^.+moslima|^.+profeet|^.+soeniet|^.+soenniet|^.+zionist|dhimmit.*$|halal.+$|islam.+$|joden.+$|moslim.+$|profeet.+$"
```

## Installation


```r
install.packages("tau")
devtools::install_github("bnosac/udpipe")
devtools::install_github("weRbelgium/hatespeech.dutch")
```

## Notes on CC BY-SA 4.0

The original data in the hatespeech.dutch R package is provided at  https://github.com/clips/hades.
Importing this data in R has been done based on the scripts available at the inst/dev directory.

## Support in text mining

Need support in text mining. 
Contact BNOSAC: http://www.bnosac.be

