# Helper Functions
#-----------------
# Function to load libraries
loadLibraries <- function(x){
  for(i in seq_along(x)){
    library(x[i], character.only=TRUE)
  }
}

# Function to install and/or load packages from CRAN 
packagesCRAN <- function(requiredPackages, update=F){
  missingPackages <- requiredPackages[!(requiredPackages %in% installed.packages()[ ,"Package"])]
  
  if(length(missingPackages) > 0 || update){
    if(update){missingPackages <- requiredPackages} # Base (required)
    install.packages(missingPackages)
  }
  
  loadLibraries(requiredPackages)
}

# Function to install and/or load missing packages from Bioconductor 
packagesBioconductor <- function(requiredPackages, update=F){
  missingPackages <- requiredPackages[!(requiredPackages %in% installed.packages()[ ,"Package"])]
  
  if(length(missingPackages) > 0 || update){
    if(update){missingPackages <- requiredPackages} # Base (required)
    source("http://bioconductor.org/biocLite.R")
    for(i in seq_along(missingPackages)){
      biocLite(missingPackages[i], character.only=TRUE)
    }
  }
  
  loadLibraries(requiredPackages)
}

# Function to install and/or load missing packages from Github 
packagesGithub <- function(requiredPackages, repoName, authToken=NULL, 
                          proxyUrl=NULL, port=NULL,
                          update=F){
  require('devtools')
  
  missingPackages <- requiredPackages[!(requiredPackages %in% installed.packages()[ ,"Package"])]
  
  if(length(missingPackages) > 0 || update){
    setProxy(proxyUrl=proxyUrl, port=port)
    missingPackages <- paste0(repoName, '/', missingPackages)    # Base (missing)
    
    if(update) {
      missingPackages <- paste0(repoName, '/', requiredPackages) # Base (required)
    }
    
    for(i in 1:length(missingPackages)){
      install_github(repo=missingPackages[i], auth_token=authToken)
    }    
  }
  
  loadLibraries(requiredPackages)
}

# Function to ping a server (i.e., does the server exist)
pingServer <- function(url, stderr=F, stdout=F, ...){
  vec <- suppressWarnings(system2("ping", url, stderr=stderr, stdout=stdout, ...))
  if (vec == 0){TRUE} else {FALSE}
}

setProxy <- function(proxyUrl, port){
  require(httr)
  
  port <- as.numeric(port)
  
  if(pingServer(proxyUrl)){
    usr <- readline("Bitte Benutzername eingeben: ")
    pwd <- readline("Bitte Passwort eingeben: ")
    cat("\14")
    
    reset_config()
    set_config(use_proxy(url=proxyUrl, port=port, username=usr, password=pwd))
  }
}
