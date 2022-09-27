


gradient_Table=readtable("Patient_Trajectories_Treatment.csv"); 


%  Columns 1 through 11

%    'icustayid'    'charttime'    'bloc'    'subject_id'    're_admission'    'died_in_hosp'    'died_within_48h_o?'    'mortality_90d'    'archetype'    'GCS'    'HR'

%  Columns 12 through 24

%    'SysBP'    'MeanBP'    'RR'    'SpO2'    'Temp_C'    'FiO2_1'    'Potassium'    'Sodium'    'Chloride'    'Glucose'    'BUN'    'Creatinine'    'Magnesium'

%  Columns 25 through 37

%    'Calcium'    'Ionised_Ca'    'CO2_mEqL'    'SGOT'    'SGPT'    'Total_bili'    'Albumin'    'Hb'    'WBC_count'    'Platelets_count'    'PTT'    'PT'    'INR'

%  Columns 38 through 46

%    'Arterial_pH'    'paO2'    'paCO2'    'Arterial_BE'    'Arterial_lactate'    'HCO3'    'mechvent'    'Shock_Index'    'PaO2_FiO2'

%  Columns 47 through 53

%    'median_dose_vaso' 'max_dose_vaso'   'input_total' 'input_4hourly'   'output_total'    'output_4hourly'  'cumulated_balance'


current_pos=1;

% get a list of unique icustayids
unique_id = unique(gradient_Table.icustayid);

% get the total number of icustays
num_of_unique_id = size(unique_id,1);

% convert to gradient matrix
gradient_array = table2array(gradient_Table);

id_transition_gradient_array_straight = [];

% Loop over all icustays

for i = 1:num_of_unique_id
    fprintf('%i %i\n',i,num_of_unique_id)
    
    % get the current icustayid
    current_id = unique_id(i);
    
    % find the indices where the current icustayid beglongs to the gradient table 
    curr_id_indices = find(gradient_Table.icustayid == current_id);

    % find how many number of points the current stay have
    num_of_points = size(curr_id_indices, 1);

    if num_of_points > 1  
        substrings_straight_position =[];
        % here is the first time point archetype
        current_number = gradient_array(curr_id_indices(1),9);
        % find the last point for the transitions
        for j = 1:num_of_points   % scan through the string.

            % pos        1 2 3 4 5 6 7 8 9

            % archetype  1 1 2 2 3 3 1 4 4
            %               
            %                ^
            %   current_number = 2
            %   substrings_straight_position = [2;4;6;7;9]

            if current_number ~= gradient_array(curr_id_indices(j),9)
                archetype_transition = current_number*10+gradient_array(curr_id_indices(j),9);
                current_number = gradient_array(curr_id_indices(j),9);
                gradient = gradient_array(curr_id_indices(j),10:46)-gradient_array(curr_id_indices(j-1),10:46);
                row = [current_id, archetype_transition, gradient];
                id_transition_gradient_array_straight = [id_transition_gradient_array_straight;row];
            end
        end
    end
end

id_transition_gradient_table_straight=array2table(id_transition_gradient_array_straight,...
    'VariableNames',{'icustayid','AA_transition','GCS','HR','SysBP','MeanBP','RR','SpO2','Temp_C','FiO2_1',...
                     'Potassium','Sodium','Chloride','Glucose','BUN','Creatinine','Magnesium','Calcium','Ionised_Ca','CO2_mEqL',...
                     'SGOT','SGPT','Total_bili','Albumin','Hb','WBC_count','Platelets_count','PTT','PT','INR',...
                     'Arterial_pH','paO2','paCO2','Arterial_BE','Arterial_lactate','HCO3','mechvent','Shock_Index','PaO2_FiO2'});
                 
writetable(id_transition_gradient_table_straight,"id_transition_gradient_table_straight.csv");                 







