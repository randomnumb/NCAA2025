win_prob_to_line <- function(p) {
  # Cap probabilities to avoid Inf or -Inf
  p <- pmax(p, 0.0001)  # Cap at 0.0001 (close to 0)
  p <- pmin(p, 0.9999)  # Cap at 0.9999 (close to 1)
  
  # Calculate the predicted line
  line <- qnorm(p) * scaling_factor
  
  # Cap the line at reasonable limits (e.g., -30 and 30)
  line <- pmax(line, -30)
  line <- pmin(line, 30)
  
  return(line)
}

t1t22025[, ELO_line := win_prob_to_line(ELO)]
t1t22025[, XGBoost_line := win_prob_to_line(XGBoost_trim)]
t1t22025[, avg_pred_line := win_prob_to_line(avg_pred)]
t1t22025[, geo_mean_pred_line := win_prob_to_line(geo_mean_pred)]

rd1 <- t1t22025[rank_comb==17 & Region1==Region2, .(ID, team1, team2, Team1=TeamName.x, Team2=TeamName.y, 
                                                    Region1, Seed1, Seed2, ELO, XGBoost, avg_pred, geo_mean_pred,
                                                    ELO_line, XGBoost_line, avg_pred_line, geo_mean_pred_line)]

east <- t1t22025[Region1=="East" & Region1==Region2, .(ID, team1, team2, Team1=TeamName.x, Team2=TeamName.y, 
                                                       Region1, Seed1, Seed2, ELO, XGBoost, avg_pred, geo_mean_pred,
                                                       ELO_line, XGBoost_line, avg_pred_line, geo_mean_pred_line)]

south <- t1t22025[Region1=="South" & Region1==Region2, .(ID, team1, team2, Team1=TeamName.x, Team2=TeamName.y, 
                                                         Region1, Seed1, Seed2, ELO, XGBoost, avg_pred, geo_mean_pred,
                                                         ELO_line, XGBoost_line, avg_pred_line, geo_mean_pred_line)]

mw <- t1t22025[Region1=="Midwest" & Region1==Region2, .(ID, team1, team2, Team1=TeamName.x, Team2=TeamName.y, 
                                                        Region1, Seed1, Seed2, ELO, XGBoost, avg_pred, geo_mean_pred,
                                                        ELO_line, XGBoost_line, avg_pred_line, geo_mean_pred_line)]

west <- t1t22025[Region1=="West" & Region1==Region2, .(ID, team1, team2, Team1=TeamName.x, Team2=TeamName.y, 
                                                       Region1, Seed1, Seed2, ELO, XGBoost, avg_pred, geo_mean_pred,
                                                       ELO_line, XGBoost_line, avg_pred_line, geo_mean_pred_line)]

high_seeds <- t1t22025[as.numeric(Rank1) <= 4 & as.numeric(Rank2) <= 4 & Region1!=Region2, .(ID, team1, team2, Team1=TeamName.x, Team2=TeamName.y, 
                                                                                             Region1, Seed1, Seed2, ELO, XGBoost, avg_pred, geo_mean_pred,
                                                                                             ELO_line, XGBoost_line, avg_pred_line, geo_mean_pred_line)]

gs4_auth()

# Combine all subsets into a named list
 sheets_list <- list(
     rd1 = rd1,
     east = east,
     south = south,
     mw = mw,
     west = west,
     high_seeds = high_seeds
   )
# Create a new Google Sheets document
   ss <- gs4_create(name = "2025_MNCAA_Predictions_ELO_XGB", sheets = sheets_list)