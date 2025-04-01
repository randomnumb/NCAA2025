## Prep data from 2018
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyr, dplyr, data.table, magrittr, ggplot2, gridExtra, ggExtra, stringr, lme4)
#theme_set(theme_bw())


#Load Data
setwd('~/Documents/kaggle/NCAA2025/data/march-machine-learning-mania-2025/')
list.files()

teams <- fread('MTeams.csv')
seasons <- fread('MSeasons.csv')
seeds <- fread('MNCAATourneySeeds.csv')
seas_results <- fread('MRegularSeasonCompactResults.csv')
tour_results <- fread('MNCAATourneyCompactResults.csv')
seas_detail <- fread('MRegularSeasonDetailedResults.csv')
tour_detail <- fread('MNCAATourneyDetailedResults.csv')
#conferences <- fread('MConferences.csv')
team_conferences <- fread('MTeamConferences.csv')
#coaches <- fread('MTeamCoaches.csv')
cities <- fread("MGameCities.csv")
secondResults <- fread("MSecondaryTourneyCompactResults.csv")
#secondTeams <- fread("MSecondaryTourneyTeams.csv")

seas_detail[,.N,Season]

win_stats <- seas_detail[, .(
  Season,
  TeamID = WTeamID,
  Outcome = rep('W', .N),
  score=WScore,
  opp_score=LScore,
  DayNum,
  FGM = WFGM,
  FGA = WFGA,
  FGP = WFGM / WFGA,
  FGP2 = (WFGM - WFGM3) / (WFGA - WFGA3),
  FGM3 = WFGM3,
  FGA3 = WFGA3,
  FGP3 = WFGM3 / WFGA3,
  FTM = WFTM,
  FTA = WFTA,
  FTP = WFTM / WFTA,
  OR = WOR,
  DR = WDR,
  AST = WAst,
  TO = WTO,
  STL = WStl,
  BLK = WBlk,
  PF = WPF,
  ORP = WOR / (WOR + LDR),
  DRP = WDR / (WDR + LOR),
  POS = 0.96 * (WFGA + WTO + 0.44 * WFTA - WOR)
)]

los_stats <- seas_detail[, .(
  Season,
  TeamID = LTeamID,
  Outcome = rep('L', .N),
  score=LScore,
  opp_score=WScore,
  DayNum,
  FGM = LFGM,
  FGA = LFGA,
  FGP = LFGM / LFGA,
  FGP2 = (LFGM - LFGM3) / (LFGA - LFGA3),
  FGM3 = LFGM3,
  FGA3 = LFGA3,
  FGP3 = LFGM3 / LFGA3,
  FTM = LFTM,
  FTA = LFTA,
  FTP = LFTM / LFTA,
  OR = LOR,
  DR = LDR,
  AST = LAst,
  TO = LTO,
  STL = LStl,
  BLK = LBlk,
  PF = LPF,
  ORP = (LOR / (LOR + WDR)),
  DRP = LDR / (LDR + WOR),
  POS = 0.96 * (LFGA + LTO + 0.44 * LFTA - LOR)
  
)]

stats_all <- rbindlist(list(win_stats, los_stats))

stats_season <- stats_all[, .(
  wins=sum(Outcome=='W'),
  loses=sum(Outcome=='L'),
  win_pcnt=sum(Outcome=='W')/(sum(Outcome=='W')+sum(Outcome=='L')),
  wins14=sum(Outcome=='W' & DayNum >= 118),
  loses14=sum(Outcome=='L' & DayNum >= 118),
  win_pcnt14=sum(Outcome=='W' & DayNum >= 118)/sum(DayNum >= 118),
  score=mean(score),
  opp_score=mean(opp_score),
  FGP = sum(FGM) / sum(FGA),
  FGP3 = sum(FGM3) / sum(FGA3),
  FTP = sum(FTM) / sum(FTA),
  ORPG = mean(OR),
  DRPG = mean(DR),
  ASPG = mean(AST),
  TOPG = mean(TO),
  STPG = mean(STL),
  BLPG = mean(BLK),
  PFPG = mean(PF),
  MORP = mean(ORP),
  MPOS = mean(POS),
  TPpcnt = sum(FGM3)/(sum(FGM)+sum(FGM3)),
  Points_per_Pos = sum(score)/sum(POS),
  Opp_Points_per_Pos = sum(opp_score)/sum(POS),
  Margin = mean(score-opp_score),
  Median_Margin = median(as.numeric(score)-as.numeric(opp_score))
), by = c('TeamID', 'Season')]

glimpse(stats_season)

#Recode Conferences to Reduce Levels
team_conferences[,ConfAbbrev2:=ConfAbbrev]
team_conferences[!ConfAbbrev %in% c("mac","caa","wcc","mwc","pac_twelve","mvc",
                                    "cusa","a_ten","big_twelve","sec","big_ten",
                                    "acc","big_east"),ConfAbbrev2:="other"]
team_conferences[ConfAbbrev=="pac_ten",ConfAbbrev2:="pac_twelve"]

#Merge Team Conferences
stats_season2 <- merge(team_conferences,stats_season,by=c("Season","TeamID"),all.y=T)


confernece_dummies <- model.matrix(~ ConfAbbrev2 - 1, data = stats_season2)
nrow(confernece_dummies)

stats_season3 <- cbind(stats_season2,confernece_dummies)


########### Quality Regression #################

r1 = seas_detail[, c("Season", "DayNum", "WTeamID", "WScore", "LTeamID", "LScore", "NumOT", "WFGA", "WAst", "WBlk", "LFGA", "LAst", "LBlk")]
r2 = seas_detail[, c("Season", "DayNum", "LTeamID", "LScore", "WTeamID", "WScore", "NumOT", "LFGA", "LAst", "LBlk", "WFGA", "WAst", "WBlk")]
names(r1) = c("Season", "DayNum", "T1", "T1_Points", "T2", "T2_Points", "NumOT", "T1_fga", "T1_ast", "T1_blk", "T2_fga", "T2_ast", "T2_blk")
names(r2) = c("Season", "DayNum", "T1", "T1_Points", "T2", "T2_Points", "NumOT", "T1_fga", "T1_ast", "T1_blk", "T2_fga", "T2_ast", "T2_blk")
regular_season = rbind(r1, r2)

march_teams = select(seeds, Season, Team = TeamID)
X =  regular_season %>% 
  select(Season, T1, T2, T1_Points, T2_Points, NumOT) %>% distinct()
X$T1 = as.factor(X$T1)
X$T2 = as.factor(X$T2)

quality = list()
for (season in unique(X$Season)) {
  glmm = glmer(I(T1_Points > T2_Points) ~  (1 | T1) + (1 | T2), data = X[X$Season == season & X$NumOT == 0, ], family = binomial) 
  random_effects = ranef(glmm)$T1
  quality[[season]] = data.frame(Season = season, TeamID = as.numeric(row.names(random_effects)), quality = exp(random_effects[,"(Intercept)"]))
}
quality = do.call(rbind, quality)
setDT(quality)
quality
quality[,max(Season)]

stats_season4 <- merge(stats_season3, quality, by=c("Season","TeamID"))

############ Tournament Seeds where Applicable #############

stats_season5 <- merge(stats_season4,seeds,by=c("TeamID","Season"),all.x=T)
stats_season5[,seed := as.numeric(regmatches(Seed, gregexpr("[0-9]+\\.?[0-9]*", Seed)))]


############ Construct Submission File ###########

sample_sub <- fread("SampleSubmissionStage2.csv") 

#String Split all of the match-ups form the sample submission, need to convert to numeric
sub_games <- data.table(str_split_fixed(sample_sub$ID,"_",3))
sub_games <- apply(sub_games,2,as.numeric)
sub_games <- data.table(sub_games)
colnames(sub_games) <- c("Season","Team1","Team2")

#Append Team 1 Stats
Team1s <- stats_season5
names(Team1s) <- paste0(names(stats_season5), "_1")
sub_games1 <- merge(sub_games, Team1s, by.x=c("Season", "Team1"), by.y=c("Season_1", "TeamID_1"), all.x=T)

#Append Team 2 Stats
Team2s <- stats_season5
names(Team2s) <- paste0(names(stats_season5), "_2")
sub_games2 <- merge(sub_games1, Team2s, by.x=c("Season", "Team2"), by.y=c("Season_2", "TeamID_2"), all.x=T)

lapply(sub_games2,function(x) {sum(!is.na(x))})
#sub_games2 is the scoring dataset
Mscoring <- sub_games2[!is.na(wins_1),]
colnames(Mscoring)
Mscoring


#Combine NCAA and other Tourney results
tour_results[,SecondaryTourney:="NCAA"]
combinedResults <- rbindlist(list(tour_results,secondResults))
t1 <- combinedResults


#Team 1 will always be the team with the lower id
t1[,id_diff:=WTeamID - LTeamID]
t1[,Team1:=ifelse(id_diff < 0,WTeamID,LTeamID)]
t1[,Team2:=ifelse(id_diff > 0,WTeamID,LTeamID)]

#Recodes variables so that result is dummy for team 1 wins
t1[,result:=ifelse(Team1==WTeamID,1,0)]

#Merge the Season Stats
tourney_season1 <- merge(t1,Team1s,by.x=c("Season","Team1"),by.y=c("Season_1","TeamID_1"))
tourney_season2 <- merge(tourney_season1,Team2s,by.x=c("Season","Team2"),by.y=c("Season_2","TeamID_2"))

tourney_season2[,.N,Season]
tour_results[,.N,Season]


#### Flip the data to attach to team 2
#Transform tournament results to attach stats to winning and losing teams
t1_rev <- combinedResults
t1_rev[,id_diff:=WTeamID - LTeamID]

#Hear we flip so team 2 has the 
t1_rev[,Team1:=ifelse(id_diff > 0,WTeamID,LTeamID)]
t1_rev[,Team2:=ifelse(id_diff < 0,WTeamID,LTeamID)]

#Recodes variables so that result is dummy for team 1 wins
t1_rev[,result:=ifelse(Team1==WTeamID,1,0)]

#Merge the Season Stats
tourney_season_rev1 <- merge(t1_rev,Team1s,by.x=c("Season","Team1"),by.y=c("Season_1","TeamID_1"))
tourney_season_rev2 <- merge(tourney_season_rev1,Team2s,by.x=c("Season","Team2"),by.y=c("Season_2","TeamID_2"))

tourney_season_rev2[,.N,Season]

tdoubled <- rbindlist(list(tourney_season2,tourney_season_rev2),use.names = T,fill=F)
tdoubled[,.N,Season]
tdoubled

#Add score_diff
tdoubled[,score_diff:=ifelse(WTeamID==Team1,WScore-LScore,LScore-WScore)]

train2 <- tdoubled[Season <= 2019,]
test2 <- tdoubled[Season >= 2020 & Season <= 2024,]


