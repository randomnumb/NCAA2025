############ Construct Submission File ###########

Preds2 <- rbind(MPreds,WPreds)

#MPreds2$ID[!MPreds2$ID %in% Preds2$ID]

#Missing these teams stats
Wscoring[Team1==3169 & Season==2021,]
Wscoring[Team1==3197 & Season==2021,]

sample_sub <- fread("SampleSubmissionStage2.csv") 

rbind(MPreds,WPreds)

submission <- merge(sample_sub[,.(ID)],Preds2,by="ID",all.x=T)
submission[is.na(Pred),]
submission[is.na(Pred),Pred:=.5]

fwrite(submission,"~/documents/kaggle/NCAA2025/submissions/submission_1.csv")

elo_sub <- merge(sample_sub[,.(ID)],games.to.predict,by="ID",all.x=T)
xgb_sub <- merge(sample_sub[,.(ID)],Preds2,by="ID",all.x=T)

combined_predictions <- merge(elo_sub,xgb_sub,by="ID")

summary(combined_predictions)

combined_predictions[,avg_pred:=(Pred.x + Pred.y)/2]
combined_predictions[,geo_mean_pred:=sqrt(Pred.x * Pred.y)]

summary(combined_predictions)

combined_predictions <- games.to.predict
combined_predictions$Pred <- (games.to.predict$Pred + submission$Pred) / 2

sub_simple_avg <- combined_predictions[,.(ID,Pred=avg_pred)]
sub_geo_mean_pred <- combined_predictions[,.(ID,Pred=geo_mean_pred)]

sub_simple_avg <- sub_simple_avg[!duplicated(ID),]
sub_geo_mean_pred <- sub_geo_mean_pred[!duplicated(ID),]

fwrite(sub_simple_avg,"~/documents/kaggle/NCAA2025/submissions/sub_simple_avg.csv")
fwrite(sub_geo_mean_pred,"~/documents/kaggle/NCAA2025/submissions/sub_geo_mean.csv")

system('kaggle competitions submit -c march-machine-learning-mania-2025 -f ~/documents/kaggle/NCAA2025/submissions/sub_geo_mean.csv -m "sub_geo_mean"')
