

%Generate Archetype i radar plot
type= 1 ;

label_table=readtable("./features/extradatatable.txt"); 
data_table=readtable("./features/datatable.txt"); 


labels=["Gender","Age","Elixhauser","Weight Kg","GCS","HR","SysBP","MeanBP","DiaBP","RR","SpO2","TempC","FiO21","Potassium","Sodium","Chloride","Glucose","BUN","Creatinine","Magnesium","Calcium","IonisedCa","CO2MEqL","SGOT","SGPT","TotalBili","Albumin","Hb","WBCCount","PlateletsCount","PTT","PT","INR","ArterialPH","paO2","paCO2","ArterialBE","ArterialLactate","HCO3","mechvent","ShockIndex","PaO2/FiO2"];

Y=table2array(label_table);
feature_array=table2array(data_table);
feature_array(:,2)=feature_array(:,2)/365.0;

% 1 , 2 ,3 ,4 ,5, 6, 7
% bloc , id, died_in_hosp, died_within_48, mortality_90d, SOFA,SIRS,max_dose_vaso
Y_want= Y(:,[1,2,5,6,7,16,17,10,9]);


load('./dist_max_labels.mat','dist_max_labels');
class_1_idx=  find(dist_max_labels==1);
class_2_idx=  find(dist_max_labels==2);
class_3_idx=  find(dist_max_labels==3);
class_4_idx=  find(dist_max_labels==4);
class_5_idx=  find(dist_max_labels==5);
class_6_idx=  find(dist_max_labels==6);


% just initialization
feature_mean=zeros(6,42);
max_dose_vaso_mean=zeros(6,1);
feature_mean(1,:)=mean(feature_array(class_1_idx(:,1),:),1);
feature_mean(2,:)=mean(feature_array(class_2_idx(:,1),:),1);
feature_mean(3,:)=mean(feature_array(class_3_idx(:,1),:),1);
feature_mean(4,:)=mean(feature_array(class_4_idx(:,1),:),1);
feature_mean(5,:)=mean(feature_array(class_5_idx(:,1),:),1);
feature_mean(6,:)=mean(feature_array(class_6_idx(:,1),:),1);

max_dose_vaso_mean(1,1)=mean(Y_want(class_1_idx(:,1),8),1);
max_dose_vaso_mean(2,1)=mean(Y_want(class_2_idx(:,1),8),1);
max_dose_vaso_mean(3,1)=mean(Y_want(class_3_idx(:,1),8),1);
max_dose_vaso_mean(4,1)=mean(Y_want(class_4_idx(:,1),8),1);
max_dose_vaso_mean(5,1)=mean(Y_want(class_5_idx(:,1),8),1);
max_dose_vaso_mean(6,1)=mean(Y_want(class_6_idx(:,1),8),1);




feature_max=zeros(1,42);

for i = 1:42
    feature_max(1,i)=max(feature_mean(:,i));
end


Resipitory_idx=[ [35,3,100]; [13,2,0.21]; [42,3,500]; [40,2,0]]; % "Pa02, Fio2, Pao2/Fio2, Mecvent "
Liver_idx=[ [25,3,56] ; [24,3,40] ; [38,3,1]];  % "SGPT, SGOT, ArterialLactate"
Kidney_idx=[[19,1,11.5] ; [18,1,20];[17,1,130]]; % "S. creatinine, BUN, glucose"
Coagulation_idx=[[32,3,13.5];[31,3,40];[33,3,11]];    % "PT, APTT, INR"
Inflammation_idx=[[29,3,11];[30,3,450];[6,2,90]]; % "WBC count, Platelets count,HR"
Nervous_idx=[5,2,15]; % "GCS"
Cardiovascular_idx=[[9,1,80];[38,3,1]];   % DiaBP, ArterialLactate 

Resipitory_list=zeros(6,1);
Liver_list=zeros(6,1);
Kidney_list=zeros(6,1);
Inflammation_list=zeros(6,1);
Coagulation_list=zeros(6,1);
Nervous_list=zeros(6,1);
Cardiovascular_list=zeros(6,1);


Resipitory_number=0;
Liver_number=0;
Kidney_number=0;
Inflammation_number=0;
Coagulation_number=0;
Nervous_number=0;
Cardiovascular_number=0;


for i=1:size(Resipitory_idx,1)
    feature_idx=Resipitory_idx(i,1);
    feature_weight=Resipitory_idx(i,2);
    feature_normal_max=Resipitory_idx(i,3);
    for j=1:6  
        feature_scale = feature_max(1,feature_idx)-feature_normal_max;
        feature_value = feature_mean(j,feature_idx)-feature_normal_max;
        feature_value = feature_value/feature_scale;
        if feature_value<0
            feature_value=0;
        end
        
        if feature_scale<0
            feature_value=0;
        end
        
        Resipitory_list(j)=Resipitory_list(j)+feature_weight*feature_value;
    end
end


for i=1:size(Liver_idx,1)
    feature_idx=Liver_idx(i,1);
    feature_weight=Liver_idx(i,2);
    feature_normal_max=Liver_idx(i,3);
    
    for j=1:6
        feature_scale = feature_max(1,feature_idx)-feature_normal_max;
        feature_value = feature_mean(j,feature_idx)-feature_normal_max;
        feature_value = feature_value/feature_scale;
        
        if feature_value<0
            feature_value=0;
        end
        
        if feature_scale<0
            feature_value=0;
        end
        Liver_list(j)=Liver_list(j)+feature_weight*feature_value;
    end
end


for i=1:size(Kidney_idx,1)
    feature_idx=Kidney_idx(i,1);
    feature_weight=Kidney_idx(i,2);
    feature_normal_max=Kidney_idx(i,3);
    for j=1:6
        feature_scale = feature_max(1,feature_idx)-feature_normal_max;
        feature_value = feature_mean(j,feature_idx)-feature_normal_max;
        feature_value = feature_value/feature_scale;
        if feature_value<0
            feature_value=0;
        end
        
        if feature_scale<0
            feature_value=0;
        end
        
        Kidney_list(j)=Kidney_list(j)+feature_weight*feature_value;
    end
end


for i=1:size(Inflammation_idx,1)
    feature_idx=Inflammation_idx(i,1);
    feature_weight=Inflammation_idx(i,2);
    feature_normal_max=Inflammation_idx(i,3);
    
    for j=1:6
        feature_scale = feature_max(1,feature_idx)-feature_normal_max;
        feature_value = feature_mean(j,feature_idx)-feature_normal_max;
        feature_value = feature_value/feature_scale;
        if feature_value<0
            feature_value=0;
        end
        
        if feature_scale<0
            feature_value=0;
        end
        
        Inflammation_list(j)=Inflammation_list(j)+feature_weight*feature_value;
    end
end



for i=1:size(Coagulation_idx,1)
    feature_idx=Coagulation_idx(i,1);
    feature_weight=Coagulation_idx(i,2);
    feature_normal_max=Coagulation_idx(i,3);
    
    for j=1:6
        feature_scale = feature_max(1,feature_idx)-feature_normal_max;
        feature_value = feature_mean(j,feature_idx)-feature_normal_max;
        feature_value = feature_value/feature_scale;
        if feature_value<0
            feature_value=0;
        end
        
        if feature_scale<0
            feature_value=0;
        end
        
        Coagulation_list(j)=Coagulation_list(j)+feature_weight*feature_value;
    end
end



for i=1:size(Nervous_idx,1)
    feature_idx=Nervous_idx(i,1);
    feature_weight=Nervous_idx(i,2);
    feature_normal_max=Nervous_idx(i,3);
    
    for j=1:6
        feature_scale = feature_max(1,feature_idx)-feature_normal_max;
        feature_value = feature_mean(j,feature_idx)-feature_normal_max;
        feature_value = feature_value/feature_scale;
        if feature_value<0
            feature_value=0;
        end
        
        Nervous_list(j)=Nervous_list(j)+feature_weight*feature_value;
    end
end




for i=1:size(Cardiovascular_idx,1)
    feature_idx=Cardiovascular_idx(i,1);
    feature_weight=Cardiovascular_idx(i,2);
    feature_normal_max=Cardiovascular_idx(i,3);
    
    for j=1:6
        feature_scale = feature_max(1,feature_idx)-feature_normal_max;
        feature_value = feature_mean(j,feature_idx)-feature_normal_max;
        feature_value = feature_value/feature_scale;
        if feature_value<0
            feature_value=0;
        end
        
        if feature_scale<0
            feature_value=0;
        end
        Cardiovascular_list(j)=Cardiovascular_list(j)+feature_weight*feature_value;
    end
end


Cardiovascular_list=Cardiovascular_list+max_dose_vaso_mean;


Resipitory_list= (Resipitory_list/max(Resipitory_list))*10;
Liver_list = (Liver_list/max(Liver_list))*10;
Kidney_list = (Kidney_list/max(Kidney_list))*10;
Inflammation_list =(Inflammation_list/max(Inflammation_list))*10;
Coagulation_list = (Coagulation_list/max(Coagulation_list))*10;
Nervous_list =(Nervous_list/max(Nervous_list))*10;
Cardiovascular_list = (Cardiovascular_list/max(Cardiovascular_list))*10;





if type==1
D1 = [Resipitory_list(1) Liver_list(1) Kidney_list(1) Inflammation_list(1) Coagulation_list(1) Nervous_list(1),Cardiovascular_list(1)];
P = [D1];
title_str='A1';
save_str='A1_spider.pdf';
color_vec=[0    0.4470    0.7410] ;%[139, 0, 0]/255;
end

if type==2
D2 = [Resipitory_list(2) Liver_list(2) Kidney_list(2) Inflammation_list(2) Coagulation_list(2) Nervous_list(2),Cardiovascular_list(2)];
P = [D2];
title_str='A2';
save_str='A2_spider.pdf';
color_vec=[0.8500    0.3250    0.0980] ;
end
if type==3
D3 = [Resipitory_list(3) Liver_list(3) Kidney_list(3) Inflammation_list(3) Coagulation_list(3) Nervous_list(3),Cardiovascular_list(3)];
P = [D3];
title_str='A3';
save_str='A3_spider.pdf';
color_vec=[0.4660    0.6740    0.1880] ;
end
if type==4
D4 = [Resipitory_list(4) Liver_list(4) Kidney_list(4) Inflammation_list(4) Coagulation_list(4) Nervous_list(4),Cardiovascular_list(4)];
P = [D4];
title_str='A4';
save_str='A4_spider.pdf';
color_vec=[0.6350    0.0780    0.1840] ;
end
if type==5
D5 = [Resipitory_list(5) Liver_list(5) Kidney_list(5) Inflammation_list(5) Coagulation_list(5) Nervous_list(5),Cardiovascular_list(5)];
P = [D5];
title_str='A5';
save_str='A5_spider.pdf';
color_vec=[150    75    0]/255.0 ;
end
if type==6
D6 = [Resipitory_list(6) Liver_list(6) Kidney_list(6) Inflammation_list(6) Coagulation_list(6) Nervous_list(6),Cardiovascular_list(6)];
P = [D6];
title_str='A6';
save_str='A6_spider.pdf';
color_vec=[0.4940    0.1840    0.5560] ;
end

% Spider plot

spider_plot(P,...
    'AxesLabels', {'Respiratory', 'Liver', 'Kidney', 'Inflammation', 'Coagulation','Nervous','Cardiovascular',},...
    'AxesInterval', 4,...
    'AxesDisplay', 'one',...
    'AxesLimits', [0, 0, 0, 0, 0,0,0; 10, 10, 10, 10, 10,10,10],...
    'FillOption', 'on',...
    'Color', color_vec,...
    'FillTransparency', 0.1,...
    'LabelFontSize', 16);
% Title and legend properties

title(title_str,'FontSize', 30);

