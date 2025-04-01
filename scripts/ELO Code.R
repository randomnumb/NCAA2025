
#Script based on this webpage.  https://www.kaggle.com/code/jaredcross/silver-free-pure-elo-based-projections Data may need to be refreshed.

# Define the URLs
url1 <- "https://storage.googleapis.com/kagglesdsdata/datasets/6904648/11078206/MTeamSpellings2.csv?X-Goog-Algorithm=GOOG4-RSA-SHA256&X-Goog-Credential=gcp-kaggle-com%40kaggle-161607.iam.gserviceaccount.com%2F20250320%2Fauto%2Fstorage%2Fgoog4_request&X-Goog-Date=20250320T051332Z&X-Goog-Expires=259200&X-Goog-SignedHeaders=host&X-Goog-Signature=4881ddc2ce38e5382ff611c98ca6b646fbfd09fb410ba86cea279cb4128df74e945815bd0f7fc191c24b8838fac60c5f6a814cfb85dbeb06e34d5ca99dbffc8d2bdc09813509dc22920a2398f0e0187c4d4b19625ca407ddc05007ff57d3623bfe45a8c6dfd62aa3b73bbf2952dfcc9bd808af9f8782f4bd8f5fec1bbe8f697afb0270843925376d3d1a0181e8d819ff5f98f8730209faafe2057a2b469fb3e0a3276726268cc33020125f735240407daf19f52806eb8fac9e484e47834f6612329f96408f53a80380dbb6552aff290d54604a0387e75aa3acca128765a2ca0b80ccddc994c5c1e01c4ec7394736edf5b6ce0222106c1ce274c243c5a32f6e49"
url2 <- "https://storage.googleapis.com/kagglesdsdata/datasets/6904648/11078206/WTeamSpellings2.csv?X-Goog-Algorithm=GOOG4-RSA-SHA256&X-Goog-Credential=gcp-kaggle-com%40kaggle-161607.iam.gserviceaccount.com%2F20250320%2Fauto%2Fstorage%2Fgoog4_request&X-Goog-Date=20250320T051904Z&X-Goog-Expires=259200&X-Goog-SignedHeaders=host&X-Goog-Signature=34fb85e21286d58423b7a3157e56cfd5687af3a29a5a5b1a22708033176e64f62c84b1b63715f098bb83d5ec5065e32aec14ad840d40bd23cfa5a55c94c0d6bba57518ec7176dfca0e068502e9b8dfe2688332fe5c967ab6b536923270da878b390e85a4e2f5a71efc3b37213eb4704a369fdeef7191f9ea70c4fe5ac6ed634b442273ec3b0c8e3fdd8eb7893864111d91d9c15d50e191476f2e7a0e00c49dc92265923f7380ac35ec40a1bb7407d7dff838bd55360dc4c3c2d9408398aba2c61452f4c869751182fa9891d1c1481ce12700d30487599ace2b83da0c1cc71e7f5b4533fcd31045f0111afa4dc783aaa144842e200834da066999c88e47103a65"
url3 <- "https://storage.googleapis.com/kagglesdsdata/datasets/6904648/11078206/m_silver_pure_elo.csv?X-Goog-Algorithm=GOOG4-RSA-SHA256&X-Goog-Credential=gcp-kaggle-com%40kaggle-161607.iam.gserviceaccount.com%2F20250320%2Fauto%2Fstorage%2Fgoog4_request&X-Goog-Date=20250320T051950Z&X-Goog-Expires=259200&X-Goog-SignedHeaders=host&X-Goog-Signature=11a8828b33811a9ae6d3ff4e5cfef33bd05edb1d84bb1ca60caed6152c94e7e3cc59d5fac2f0b3cad3c744421deb4f5f4ee39359fd73c4988e74f50d7fa6e18fbb60402bad0a76759810f52eb69718ebe9e184cacc2f7da592b98dd6928134aef9394b94b6c287ef64d67160e5bc0e61b0d443c2c98601657d9f0ff7c07031a8b381ad8eb20ce217070850b4133d6bbdc881410b70d727b8f58fdd3407e0b4cfea411b0709b8c639aab4032fabd27e2c159bc21a2f0c4db23410a02bc3f9575caf078cf2680d9aaceb61546db716c7683bd496d08ef10218f6dd4a667b636f9aa1f96cce4615634738d18c9eb26f1880c80433f9b8255dfe378c07740e7b9bec"
url4 <- "https://storage.googleapis.com/kagglesdsdata/datasets/6904648/11078206/w_silver_pure_elo.csv?X-Goog-Algorithm=GOOG4-RSA-SHA256&X-Goog-Credential=gcp-kaggle-com%40kaggle-161607.iam.gserviceaccount.com%2F20250320%2Fauto%2Fstorage%2Fgoog4_request&X-Goog-Date=20250320T052020Z&X-Goog-Expires=259200&X-Goog-SignedHeaders=host&X-Goog-Signature=5084f0df69b1af5b6dc6e203351b99b0c56b23c39a5ce8dfb6504175452b96f37522008b868474a5b776373010bcbe7560cc54b81a4f2471a5c45bc86ed4108567d8abdb139f9ba1aeb08473790b8341d32ccbedd9795f760d6e5ca957cbef37c3f625f6ea2a7a6787212d5902dae59b3f3e0e26bfacbe38c683895fb4764ac3b05048c8d352da2b43b7d94781c9d89918c0c98aea9d910f1d1791f11e97d850e440e5cc9978d9b222b7564d9eb13e9ea5a8c351fbf034408aede9b08d15513c50c7dd9877251669907caa4bdc50262ea95571a2c6ec35c14fc3b1d819cef32d4ff33370d04bbb197aafa83d3cca480cee793f5188bfbe38822e069d5d90c40a"

# Read the CSV files into data frames
MTeamSpellings2 <- read.csv(url1)
WTeamSpellings2 <- read.csv(url2)
m_silver_pure_elo <- read.csv(url3)
w_silver_pure_elo <- read.csv(url4)

# Check the first few rows of each data frame to ensure they were loaded correctly
head(MTeamSpellings2)
head(WTeamSpellings2)
head(m_silver_pure_elo)
head(w_silver_pure_elo)


Msilver = 
  Msilver %>%
  select(Team, 'Current Elo') %>%
  mutate(TeamNameSpelling = tolower(Team))

Wsilver = 
  Wsilver %>%
  select(Team, 'Current Elo') %>%
  mutate(TeamNameSpelling = tolower(Team))


games_to_predict = function(SampleSubmission){
  games.to.predict <- cbind(SampleSubmission$ID, 
                            colsplit(SampleSubmission$ID, 
                                     split = "_", 
                                     names = c('season', 'team1', 'team2')))   
  colnames(games.to.predict)[1] <- "ID"
  
  games.to.predict$home <- 0
  
  games.to.predict = 
    games.to.predict %>%
    mutate(tourney = ifelse(team1 <= 2500, "M", "W"))
  return(games.to.predict)
}


games.to.predict = games_to_predict(SampleSubmissionStage2)

W.games.to.predict =
  games.to.predict %>%
  filter(tourney == "W")

M.games.to.predict =
  games.to.predict %>%
  filter(tourney == "M")

W.games.to.predict = 
  left_join(W.games.to.predict,
            WNCAATourneySeeds %>% 
              dplyr::rename(team1Seed = Seed), 
            by=c("team1"="TeamID")) %>%
  left_join(.,
            WNCAATourneySeeds %>% 
              dplyr::rename(team2Seed = Seed), 
            by=c("team2"="TeamID"))

W.games.to.predict = 
  W.games.to.predict %>%
  mutate(team1region = substring(team1Seed, 1, 1), 
         team1rank = as.numeric(substring(team1Seed, 2, 3)),
         team2region = substring(team2Seed, 1, 1), 
         team2rank = as.numeric(substring(team2Seed, 2, 3)),
         same_region = team1region == team2region, 
         sum_ranks = team1rank + team2rank, 
         lower_rank = pmin(team1rank, team2rank), 
         higher_rank = pmax(team1rank, team2rank),
         rank_order = paste(lower_rank, higher_rank, sep="_"))

round_2_games = c("1_8", "1_9", "8_16", "9_16",
                  "2_7", "2_10", "7_15", "10_15",
                  "3_6", "3_11", "6_14", "11_14",
                  "4_5", "4_12", "5_13", "12_13")
W.games.to.predict = 
  W.games.to.predict %>%
  mutate(round = 
           case_when(same_region & sum_ranks == 17 ~ "round1",
                     same_region & rank_order %in% round_2_games ~ "round2",
                     TRUE ~ "round3orlater"))
W.games.to.predict =         
  W.games.to.predict %>%
  mutate(home = 
           case_when(round %in% c("round1", "round2") & team1rank <= 4 ~ 1,
                     round %in% c("round1", "round2") & team2rank <= 4 ~ -1,
                     TRUE ~ 0))

Msilver = 
  left_join(Msilver,
            MTeamSpellings,
            by="TeamNameSpelling") %>%
  select(TeamID, 'Current Elo')

Wsilver = 
  left_join(Wsilver,
            WTeamSpellings,
            by="TeamNameSpelling") %>%
  select(TeamID, 'Current Elo')


M.games.to.predict = 
  left_join(M.games.to.predict,
            Msilver %>% 
              dplyr::rename(team1rating = 'Current Elo'),
            by=c("team1"="TeamID")) %>%
  left_join(.,
            Msilver %>% 
              dplyr::rename(team2rating = 'Current Elo'),
            by=c("team2"="TeamID"))

W.games.to.predict = 
  left_join(W.games.to.predict,
            Wsilver %>% 
              dplyr::rename(team1rating = 'Current Elo'),
            by=c("team1"="TeamID")) %>%
  left_join(.,
            Wsilver %>% 
              dplyr::rename(team2rating = 'Current Elo'),
            by=c("team2"="TeamID"))

colnames(M.games.to.predict)

M.games.to.predict = 
  M.games.to.predict %>%
  mutate(PredScoreDiff = 
           1.07*(team1rating - team2rating)/26.5 + 2.7*home,
         Pred = 1 / (1 + 10^(1.07*(team2rating - team1rating)/400)))

W.games.to.predict = 
  W.games.to.predict %>%
  mutate(PredScoreDiff = 
           1.07*(team1rating - team2rating)/26.5 + 2.7*home,
         Pred = 1 / (1 + 10^(1.07*(team2rating - team1rating - 67*home)/400)))

games.to.predict = 
  rbind(M.games.to.predict %>% select(ID, Pred),
        W.games.to.predict %>% select(ID, Pred))

