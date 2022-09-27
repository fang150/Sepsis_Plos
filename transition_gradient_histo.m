
transition_gradient_table=readtable("id_transition_gradient_table_straight.csv"); 

transition_gradient_table.Properties.VariableNames 


X=table2array(transition_gradient_table(:,3:39));

transition=table2array(transition_gradient_table(:,2));


load('gradient_dist_max_labels.mat','dist_max_labels');


class_1_idx=  find(dist_max_labels==1);
class_2_idx=  find(dist_max_labels==2);
class_3_idx=  find(dist_max_labels==3);
class_4_idx=  find(dist_max_labels==4);
class_5_idx=  find(dist_max_labels==5);
class_6_idx=  find(dist_max_labels==6);

A1_transition=transition(class_1_idx);
A2_transition=transition(class_2_idx);
A3_transition=transition(class_3_idx);
A4_transition=transition(class_4_idx);
A5_transition=transition(class_5_idx);
A6_transition=transition(class_6_idx);

[cnt_unique_A1, unique_A1] = hist(A1_transition,unique(A1_transition));
[cnt_unique_A2, unique_A2] = hist(A2_transition,unique(A2_transition));
[cnt_unique_A3, unique_A3] = hist(A3_transition,unique(A3_transition));
[cnt_unique_A4, unique_A4] = hist(A4_transition,unique(A4_transition));
[cnt_unique_A5, unique_A5] = hist(A5_transition,unique(A5_transition));
[cnt_unique_A6, unique_A6] = hist(A6_transition,unique(A6_transition));

A1_bar= [transpose(cnt_unique_A1), unique_A1];
A2_bar= [transpose(cnt_unique_A2), unique_A2];
A3_bar= [transpose(cnt_unique_A3), unique_A3];
A4_bar= [transpose(cnt_unique_A4), unique_A4];
A5_bar= [transpose(cnt_unique_A5), unique_A5];
A6_bar= [transpose(cnt_unique_A6), unique_A6];

A1_bar=sortrows(A1_bar,1,'descend');
A2_bar=sortrows(A2_bar,1,'descend');
A3_bar=sortrows(A3_bar,1,'descend');
A4_bar=sortrows(A4_bar,1,'descend');
A5_bar=sortrows(A5_bar,1,'descend');
A6_bar=sortrows(A6_bar,1,'descend');

Z = zeros(37,6);

cb = [0    0.4470    0.7410 ; 0.8500    0.3250    0.0980; 0.4660    0.6740    0.1880;0.6350    0.0780    0.1840; 150/255.5    75/255.5    0.0; 0.4940    0.1840    0.5560; 0.7 1 0.4; 1 0.7 1; 0.6 0.6 0.6; 0.7 0.5 0.7; 0.8 0.9 0.8; 1 1 0.4];
%end

cl(1, :) = cb(4, :);
cl(2, :) = cb(1, :);

for i = 1:37
    Z(i,1)=(mean(X(class_1_idx,i))-mean(X(:,i)) )/std(X(:,i)); 
    Z(i,2)=(mean(X(class_2_idx,i))-mean(X(:,i)))/std(X(:,i));
    Z(i,3)=(mean(X(class_3_idx,i))-mean(X(:,i)))/std(X(:,i));
    Z(i,4)=(mean(X(class_4_idx,i))-mean(X(:,i)))/std(X(:,i));
    Z(i,5)=(mean(X(class_5_idx,i))-mean(X(:,i)))/std(X(:,i));
    Z(i,6)=(mean(X(class_6_idx,i))-mean(X(:,i)))/std(X(:,i));
end

% for G1 histo


ylim([0 1])


x = [1:size(A1_bar,1)]; 

bar(x,A1_bar(:,1)/size(A1_transition,1),'FaceColor',cb(1,:));
prob = A1_bar(:,1)/size(A1_transition,1)
xtickangle(60)
title('G1: Probability Histogram of State Transitions', 'fontsize',16)
ylabel('Probability', 'fontsize',16)
axis([0 size(unique_A1,1)+1   0  prob(1)+0.01])
set(gca,'XTick', 1:size(unique_A1,1),'XTickLabel',A1_bar(:,2), 'fontsize',16)
set(gcf, 'PaperUnits', 'inches');




% for G2 histo

x = [1:size(A2_bar,1)]; 
bar(x,A2_bar(:,1)/size(A2_transition,1),'FaceColor',cb(2,:))
xtickangle(60)
title('G2: Probability Histogram of State Transitions', 'fontsize',16)
ylabel('Probability', 'fontsize',16)

prob = A2_bar(:,1)/size(A2_transition,1)
axis([0 size(unique_A2,1)+1   0  prob(1)+0.01])
set(gca,'XTick', 1:size(unique_A2,1),'XTickLabel',A2_bar(:,2), 'fontsize',16)
set(gcf, 'PaperUnits', 'inches');





% for G3 histo
x = [1:size(A3_bar,1)]; 

bar(x,A3_bar(:,1)/size(A3_transition,1),'FaceColor',cb(3,:))
xtickangle(60)
prob = A3_bar(:,1)/size(A3_transition,1)
title('G3: Probability Histogram of State Transitions', 'fontsize',16)
ylabel('Probability', 'fontsize',16)
axis([0 size(unique_A3,1)+1   0  prob(1)+0.01])
set(gca,'XTick', 1:size(unique_A3,1),'XTickLabel',A3_bar(:,2), 'fontsize',16)
set(gcf, 'PaperUnits', 'inches');





% for G4 histo


x = [1:size(A4_bar,1)]; 
bar(x,A4_bar(:,1)/size(A4_transition,1),'FaceColor',cb(4,:))
xtickangle(60)
prob = A4_bar(:,1)/size(A4_transition,1)

title('G4: Probability Histogram of State Transitions', 'fontsize',16)
ylabel('Probability', 'fontsize',16)
axis([0 size(unique_A4,1)+1   0  prob(1)+0.01])
set(gca,'XTick', 1:size(unique_A4,1),'XTickLabel',A4_bar(:,2), 'fontsize',16)
set(gcf, 'PaperUnits', 'inches');







% for G5 histo


x = [1:size(A5_bar,1)]; 
bar(x,A5_bar(:,1)/size(A5_transition,1),'FaceColor',cb(5,:))
xtickangle(60)
prob = A5_bar(:,1)/size(A5_transition,1)

title('G5: Probability Histogram of State Transitions', 'fontsize',16)
ylabel('Probability', 'fontsize',16)
axis([0 size(unique_A5,1)+1   0  prob(1)+0.01])
set(gca,'XTick', 1:size(unique_A5,1),'XTickLabel',A5_bar(:,2), 'fontsize',16)
set(gcf, 'PaperUnits', 'inches');
%}


% for G6 histo
x = [1:size(A6_bar,1)];
prob = A6_bar(:,1)/size(A6_transition,1)
bar(x,prob,'FaceColor',cb(6,:))
xtickangle(60)
title('G6: Probability Histogram of State Transitions','FontSize', 16)
ylabel('Probability','FontSize', 16)
axis([0 size(unique_A6,1)+1   0  prob(1)+0.01])
set(gca,'XTick', 1:size(unique_A6,1),'XTickLabel', A6_bar(:,2), 'fontsize',16)
set(gcf, 'PaperUnits', 'inches');




