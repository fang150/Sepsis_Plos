
delta=0;
opts.maxiter=1000;
opts.conv_crit=1e-6;

gradient_table=readtable("id_transition_gradient_table_straight.csv");




%ans =

%  1x39 cell array

%  Columns 1 through 7

%    {'subject_id'}    {'AA_transition'}    {'GCS'}    {'HR'}    {'SysBP'}    {'MeanBP'}    {'RR'}

%  Columns 8 through 14

%    {'SpO2'}    {'Temp_C'}    {'FiO2_1'}    {'Potassium'}    {'Sodium'}    {'Chloride'}    {'Glucose'}

%  Columns 15 through 21

%    {'BUN'}    {'Creatinine'}    {'Magnesium'}    {'Calcium'}    {'Ionised_Ca'}    {'CO2_mEqL'}    {'SGOT'}

%  Columns 22 through 28

%    {'SGPT'}    {'Total_bili'}    {'Albumin'}    {'Hb'}    {'WBC_count'}    {'Platelets_count'}    {'PTT'}

%  Columns 29 through 34

%    {'PT'}    {'INR'}    {'Arterial_pH'}    {'paO2'}    {'paCO2'}    {'Arterial_BE'}

%  Columns 35 through 39

%    {'Arterial_lactate'}    {'HCO3'}    {'mechvent'}    {'Shock_Index'}    {'PaO2_FiO2'}



dataheaders5 = {'GCS','HR','SysBP','MeanBP','RR','SpO2','Temp_C','FiO2_1','Potassium','Sodium','Chloride','Glucose','BUN','Creatinine','Magnesium','Calcium',...
    'Ionised_Ca','CO2_mEqL','SGOT','SGPT','Total_bili','Albumin','Hb','WBC_count','Platelets_count','PTT','PT','INR','Arterial_pH','paO2','paCO2','Arterial_BE',...
    'Arterial_lactate','HCO3','Shock_Index','PaO2_FiO2'};

ii=find(ismember(gradient_table.Properties.VariableNames,dataheaders5));


gradient_data=gradient_table(:,ii); 
gradient_X=table2array(gradient_data);
gradient_X=transpose(gradient_X);


for noc = 1:30 % Number of archetypes

	U=1:size(gradient_X,2); % Entries in X used that is modelled by the AA model
	I=1:size(gradient_X,2); % Entries in X used to define archetypes

	% if two expensive to useall entries for I find N relevant observations by
	% the following procedure:

	%N=1000;
	%I=FurthestSum(gradient_X,N,ceil(rand*size(X,2)));

	[XC,S,C,SSE,varexpl]=PCHA(gradient_X,noc,I,U,delta,opts);

	varexpl_file = fopen(strcat('./output/gradient_output/varexpl_',int2str(noc),'.txt'),'w');
	fprintf(varexpl_file,'%f',varexpl);
	fclose(varexpl_file);

	SSE_file = fopen(strcat('./output/gradient_output/SSE_',int2str(noc),'.txt'),'w');
	fprintf(SSE_file,'%f',SSE);
	fclose(SSE_file);

	XC_file = strcat('./output/gradient_output/XC_',int2str(noc),'.mat');
	S_file = strcat('./output/gradient_output/S_',int2str(noc),'.mat');
	C_file = strcat('./output/gradient_output/C_',int2str(noc),'.mat');
    
	save(XC_file,'XC');
	save(S_file,'S');
	save(C_file,'C');
end










