#Turning vectors into tidy lexicons

flippingDat <- as.data.frame(flippingVec)
tidyFlipping <- flippingDat %>%
  unnest_tokens(word, flippingVec)
tidyFlipping$type = "flipping the script"

homoDat <- as.data.frame(homoVec)
tidyHomo <- homoDat %>%
  unnest_tokens(word, homoVec)
tidyHomo$type = "homophobic"

hostileDat <- as.data.frame(hostileVec)
tidyHostile <- hostileDat %>%
  unnest_tokens(word, hostileVec)
tidyHostile$type = "hostile language"

violenceDat <- as.data.frame(violenceVec)
tidyViolence <- violenceDat %>%
  unnest_tokens(word, violenceVec)
tidyViolence$type = "violent language"

racismDat <- as.data.frame(racismVec)
tidyRacism <- racismDat %>%
  unnest_tokens(word, racismVec)
tidyRacism$type = "racism"

sexViolenceDat <- as.data.frame(sexViolenceVec)
tidySexViolence <- sexViolenceDat %>%
  unnest_tokens(word, sexViolenceVec)
tidySexViolence$type = "sexual violence"


incelAntiFemVec <- c(stoicVec, antiFemVec, incelVec)
stoicDat <- as.data.frame(incelAntiFemVec)
tidyStoic <- stoicDat %>%
  unnest_tokens(word, incelAntiFemVec)
tidyStoic$type = "incel and antiFeminism"

#bind all lexicons

tidyLex <- bind_rows(tidyLex, tidyStoic, tidySexViolence, tidyRacism, tidyViolence, tidyHostile, tidyHomo, tidyFlipping)

#remove duplicates

tidyLex <- tidyLex %>%
  distinct(word, .keep_all = TRUE)


#making tidy dataset and basic counts

tidyKotaku <- kotakuinactiondate %>%
  unnest_tokens(word, data.body) %>%
  anti_join(stop_words)


tidyHeartsOfIron <- heartsOfIronDate %>%
  unnest_tokens(word, data.body) %>%
  anti_join(stop_words)


tidyVideoGames <- videoGamesDate %>%
  unnest_tokens(word, data.body) %>%
  anti_join(stop_words)

#joining all data

tidySet <- bind_rows(tidyKotaku, tidyVideoGames, tidyHeartsOfIron)

untidySet <- bind_rows(heartsOfIronDate, kotakuInActionDate, videoGamesDate)

#calculating tf_idf untidy

untidySet <- untidySet %>%
  unnest_tokens(word, data.body)

untidySet <- untidySet %>%
  count(subreddit, word, sort = TRUE)

total_words_untidy <- untidySet %>% 
  group_by(subreddit) %>% 
  summarize(total = sum(n))

untidySet <- left_join(untidySet, total_words_untidy)

freqGamesUntidy <- untidySet %>%
  group_by(subreddit) %>%
  mutate(rank = row_number(),
         'term frequency' = n/total) %>%
  ungroup()

allTFIDFUntidy <- untidySet %>%
  bind_tf_idf(word, subreddit, n) %>%
  arrange(desc(tf_idf))

countTDIDFlexUntidy <- allTFIDFUntidy %>%
  inner_join(newTidyLex)

#calculating tf_idf tidy

tidySet <- tidySet %>%
  count(subreddit, word, sort = TRUE)

total_words <- tidySet %>% 
  group_by(subreddit) %>% 
  summarize(total = sum(n))

tidySet <- left_join(tidySet, total_words)

freqGames <- tidySet %>%
  group_by(subreddit) %>%
  mutate(rank = row_number(),
         'term frequency' = n/total) %>%
  ungroup()

allTFIDF <- tidySet %>%
  bind_tf_idf(word, subreddit, n) %>%
  arrange(desc(tf_idf))

countTDIDFlex <- allTFIDF %>%
  inner_join(newTidyLex)

#running basic counts with lexicon by dataset

countLexKotaku <- tidyKotaku %>%
  inner_join(newTidyLex) %>%
  count(word, type)

countLexVideoGames <- tidyVideoGames %>%
  inner_join(newTidyLex) %>%
  count(word, type)

countLexHeartsOfIron <- tidyHeartsOfIron %>%
  inner_join(newTidyLex) %>%
  count(word, type)

#removing unwanted lexicons

newdata <- dataset[testrun2$type != 'violent language' & testrun2$type != 'hostile language', ]
