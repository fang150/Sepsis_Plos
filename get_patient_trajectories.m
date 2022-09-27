MIMICtable2=readtable("MIMICtable2.csv"); 
load("dist_max_labels.mat","dist_max_labels");
dataheaders5 = {'bloc','icustayid','charttime','re_admission','died_in_hosp','died_within_48h_of_out_time','mortality_90d','subject_id'};
ii=find(ismember(MIMICtable2.Properties.VariableNames,dataheaders5));
reformat3t=MIMICtable2(:,ii); 
reformat3t.archetype=dist_max_labels;  
patient_trajectories = sortrows(reformat3t,[2,3]);
patient_trajectories_sorted = [patient_trajectories(:,2),patient_trajectories(:,3),patient_trajectories(:,1),patient_trajectories(:,8),patient_trajectories(:,4),patient_trajectories(:,5:7),patient_trajectories(:,9)];
writetable(patient_trajectories_sorted,"Patient_Trajectories.csv");



  





