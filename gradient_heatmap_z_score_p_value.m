
transition_gradient_table=readtable("id_transition_gradient_table_straight.csv"); 

transition_gradient_table.Properties.VariableNames 

X=table2array(transition_gradient_table(:,3:39));

transition=table2array(transition_gradient_table(:,2));

%format long
%
load('gradient_dist_max_labels.mat','dist_max_labels');
class_1_idx=  find(dist_max_labels==1);
class_2_idx=  find(dist_max_labels==2);
class_3_idx=  find(dist_max_labels==3);
class_4_idx=  find(dist_max_labels==4);
class_5_idx=  find(dist_max_labels==5);
class_6_idx=  find(dist_max_labels==6);

Z = zeros(37,6);

cb = [0    0.4470    0.7410 ; 0.8500    0.3250    0.0980; 0.4660    0.6740    0.1880;0.6350    0.0780    0.1840; 150/255.5    75/255.5    0.0; 0.4940    0.1840    0.5560; 0.7 1 0.4; 1 0.7 1; 0.6 0.6 0.6; 0.7 0.5 0.7; 0.8 0.9 0.8; 1 1 0.4];
%end

cl(1, :) = cb(4, :);
cl(2, :) = cb(1, :);

T = zeros(37,6);

for i = 1:37
    Z(i,1)=(mean(X(class_1_idx,i))-mean(X(:,i)) )/std(X(:,i)); 
    Z(i,2)=(mean(X(class_2_idx,i))-mean(X(:,i)))/std(X(:,i));
    Z(i,3)=(mean(X(class_3_idx,i))-mean(X(:,i)))/std(X(:,i));
    Z(i,4)=(mean(X(class_4_idx,i))-mean(X(:,i)))/std(X(:,i));
    Z(i,5)=(mean(X(class_5_idx,i))-mean(X(:,i)))/std(X(:,i));
    Z(i,6)=(mean(X(class_6_idx,i))-mean(X(:,i)))/std(X(:,i));
    
    [h,p] = ttest2(X(class_1_idx,i),X(:,i));
    T(i,1) = p;
    
    [h,p] = ttest2(X(class_2_idx,i),X(:,i));
    T(i,2) = p;
    
    
    [h,p] = ttest2(X(class_3_idx,i),X(:,i));
    T(i,3) = p;
    
    [h,p] = ttest2(X(class_4_idx,i),X(:,i));
    T(i,3) = p;
    
    [h,p] = ttest2(X(class_5_idx,i),X(:,i));
    T(i,5) = p;
    
    [h,p] = ttest2(X(class_6_idx,i),X(:,i));
    T(i,6) = p;
end

% heatmap for Gradient.

cdata = T;
xname={'G1','G2','G3','G4','G5','G6'};
yname={'GCS', 'HR','SysBP','MeanBP','RR','SpO2','Temp','FiO2','Potassium','Sodium','Chloride','Glucose','BUN','Creatinine','Magnesium','Calcium','Ionised Ca','CO2','SGOT','SGPT','Total Bili','Albumin','Hb','WBC Count','Platelets Count','PTT','PT','INR','Arterial pH','PaO2','PaCO2','Arterial BE','Arterial Lactate','HCO3','Mechvent','Shock Index','PaO2/FiO2'}

mincolor = min(cdata(:));
maxcolor = max(cdata(:));


mycolormap = customcolormap_preset('red-white-blue');
colorbar;
colormap(mycolormap);


%h = heatmap(xname,yname,cdata,'CellLabelColor','none','Colormap',mycolormap);
h = heatmap(xname,yname,cdata,'Colormap',mycolormap);

h.Title = 'P-value';
h.XLabel = 'Archetype';
h.YLabel = 'Gradient of Clinical Measurements';
h.CellLabelFormat = '%.e';
caxis(h,[mincolor maxcolor]);





