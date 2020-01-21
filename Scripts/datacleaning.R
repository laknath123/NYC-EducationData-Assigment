#Installing Required Library's 
# if the library's are not installed install them using install.packages()
library(data.table)
library(here)
library(dplyr)

#Loading Required Datasets
sat_df<-fread(here('RawData/2012_SAT_Results.csv'),stringsAsFactors = FALSE)
survey_df<-fread(here('RawData/2012_NYC_General_Education_School_Survey.csv'),stringsAsFactors = FALSE)
demog_df<-fread(here('RawData/2006_-_2012_School_Demographics_and_Accountability_Snapshot.csv'),stringsAsFactors = FALSE)

#merging sat_df with demog_df
merged_df<-left_join(sat_df,survey_df,"DBN")

#keeping only 2012 data from demog df
demog_df2012<-demog_df%>%
        filter(schoolyear=='20112012')%>%arrange(Name)

#Merging all three datasets togther
df_final<-left_join(merged_df,demog_df2012,"DBN")

df_final<-df_final%>%select(DBN,`School Name`,
                  `SAT Critical Reading Avg. Score`,
                  `SAT Math Avg. Score`,
                  `SAT Writing Avg. Score`,
                  `School Type`,
                  `Parent Response Rate`,
                  frl_percent,
                  ell_percent,
                  asian_per,
                  black_per,
                  hispanic_per,
                  white_per,
                  male_per,
                  female_per,
                  sped_percent,
                  total_enrollment,
                  `Num of SAT Test Takers`)%>%filter(`School Name`!='NA')%>%na.omit()


df_final%>%distinct(DBN)%>%nrow()
nrow(df_final)
colnames(df_final) #column names
object.size(df_final)/1000000 #object size in MB

write.csv(df_final,'Results/df_final.csv')