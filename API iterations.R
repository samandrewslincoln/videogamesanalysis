#API scraper with custom dataname for dataframe. Outputs 100 comments from selected subreddit and saves them to the dataname. Select after to choose data (days)

get_data <- function(after, subreddit, dataname) {
  data = data
  
  #Get the JSON data from the selected parameters
  
  data <- fromJSON(paste("https://api.pushshift.io/reddit/search/comment/?after=", after, "d&subreddit=", subreddit, "&size=100&fields=body,author", sep = "")) %>%
  
  #Save the data as a dataframe
    
    as.data.frame()
  
  #Assign that data to the specified object name
  
  assign(x = dataname, value = data, envir = globalenv())

}

#API scraper outputs to loopeddata. Each iteration is one day apart. Iterations selected as a vector of numbers (eg. 1:12 for twelve iterations).
#Date object returned is in UNIX format. Change to normal formats using > object <- object %>% + mutate(data.created_utc = as_datetime(data.created_utc))

get_data_loop <- function(after, subreddit, iterations = c(1:2)) {
  
  #Create and empty dataframe for the data
  
  loopeddata <- as.data.frame(NULL)
  
  #Run iterations of the API function accoring to iterations input
  
  for(i in iterations) {
    
    after = after+1
    
    #Get the JSON data from the selected parameters
    
    data <- as.data.frame(fromJSON(paste("https://api.pushshift.io/reddit/search/comment/?after=", after, "d&subreddit=", subreddit, "&size=100&fields=body,author,created_utc,score", sep = "")))
    
    #Add iteration data to empty dataframe
    loopeddata <- rbind(data, loopeddata)
    
    #Sleep for API 
    
    Sys.sleep(5)
    
  }
  
  #Print iterations as a check and view the data
  
  print(i)
  
  view(loopeddata)
  
  return(loopeddata)
  
}