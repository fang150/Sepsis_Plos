MIMICtable2=readtable("./features/MIMICtable2.csv"); 

load("dist_max_labels.mat","dist_max_labels");


% For first order treatment transition graph
dataheaders5 = {'bloc','icustayid','charttime','re_admission','died_in_hosp','died_within_48h_of_out_time','mortality_90d','subject_id', ...
      'GCS','HR','SysBP','MeanBP','RR','SpO2','Temp_C','FiO2_1','Potassium','Sodium','Chloride','Glucose','BUN','Creatinine','Magnesium','Calcium',...
      'Ionised_Ca','CO2_mEqL','SGOT','SGPT','Total_bili','Albumin','Hb','WBC_count','Platelets_count','PTT','PT','INR','Arterial_pH','paO2','paCO2','Arterial_BE',...
      'Arterial_lactate','HCO3','mechvent','Shock_Index','PaO2_FiO2','median_dose_vaso','max_dose_vaso','input_total','input_4hourly','output_total','output_4hourly','cumulated_balance'};

ii=find(ismember(MIMICtable2.Properties.VariableNames,dataheaders5));
reformat3t=MIMICtable2(:,ii); 
reformat3t.archetype=dist_max_labels;  

%    reformat3t columns
%    1
%    'bloc'    'icustayid'    'charttime'    're_admission' 'died_in_hosp'
%    6 
%    'died_within_48h_o…'    'mortality_90d'  'GCS'    'HR'    'SysBP'
%    11
%    'MeanBP'    'RR'    'SpO2' 'Temp_C'    'FiO2_1'
%    16
%    'Potassium'    'Sodium'    'Chloride' 'Glucose'    'BUN' 
%	 21
%    'Creatinine'    'Magnesium'    'Calcium' 'Ionised_Ca'    'CO2_mEqL'
%    26
%    'SGOT'    'SGPT'    'Total_bili' 'Albumin'    'Hb'
%    31
%    'WBC_count'    'Platelets_count'    'PTT'  'PT'    'INR'
%    36
%    'Arterial_pH'    'paO2'    'paCO2' 'Arterial_BE'    'Arterial_lactate'
%    41
%    'HCO3'    'mechvent'  'Shock_Index'    'PaO2_FiO2'   'median_dose_vaso'
%    46     
%    'max_dose_vaso'    'input_total'    'input_4hourly' 'output_total'    'output_4hourly'
%    51
%    'cumulated_balance' 'subject_id'    'archetype'

patient_trajectories = sortrows(reformat3t,[2,3]);
patient_trajectories_sorted = [patient_trajectories(:,2),patient_trajectories(:,3),patient_trajectories(:,1),patient_trajectories(:,52),patient_trajectories(:,4),patient_trajectories(:,5:7),patient_trajectories(:,53),patient_trajectories(:,8:51)];

writetable(patient_trajectories_sorted,"Patient_Trajectories_Treatment.csv");




% For higher order transition graph  
dataheaders5 = {'bloc','icustayid','charttime','re_admission','died_in_hosp','died_within_48h_of_out_time','mortality_90d','subject_id'};
ii=find(ismember(MIMICtable2.Properties.VariableNames,dataheaders5));
reformat3t=MIMICtable2(:,ii); 
reformat3t.archetype=dist_max_labels;  
patient_trajectories = sortrows(reformat3t,[2,3]);
patient_trajectories_sorted = [patient_trajectories(:,2),patient_trajectories(:,3),patient_trajectories(:,1),patient_trajectories(:,8),patient_trajectories(:,4),patient_trajectories(:,5:7),patient_trajectories(:,9)];
writetable(patient_trajectories_sorted,"Patient_Trajectories.csv");





