# Plos_Sepsis


The goal of this project is to provide implementation of our Plos Digital Health paper 

[Identifying and Analyzing Sepsis States: A Retrospective Study on Patients with Sepsis in ICUs, Plos Digital Health, 2022](https://www.google.com/)


## Prerequisite

1. Our source code for data extraction builds on AI Clinician where the dataset were extracted from MIMIC III database [Identifying and Analyzing Sepsis States: A Retrospective Study on Patients with Sepsis in ICUs, Plos Digital Health, 2022](https://www.google.com/](https://physionet.org/content/mimiciii/1.4/)). To access to the dataset, researchers need to follow the instructions from the [website](https://mimic.mit.edu/docs/gettingstarted/) and then follow the instructions from [here](https://github.com/MIT-LCP/mimic-code) to install the MiMIC III.
2. Once the MIMIC III databased is installed, run [elixhauser_quan.sql](https://github.com/MIT-LCP/mimic-code/blob/main/mimic-iii/concepts/comorbidity/elixhauser_quan.sql) to build public table Elixhauser_Quan Table to derive the comorbidity concept.
3. We use the matlab implementation of PCHA software to compute archetypes. The source code can be donwloaded from [here](http://www.mortenmorup.dk/MMhomepageUpdated_files/Page327.htm).


## Data Extraction

1. Run AI_Clinician_Data_Extraction.ipynb for Data Extraction from MIMIC-III database.
2. Run AI_Clinician_Sepsis3_Definition.m for identifying Sepsis patients.
3. Run AI_Clinician_mimic3_Dataset_premobid.m for obtaining the dataset used in our Plos Digital Health paper.

## Compute Archetype
1. run ./features/prepare_data.py to preprocess the data format used for computing archetypes
2. run run_AA.m to compute the archetypes for each k (the number of archetypes).
3. Note: the derived archetype label in our analysis is saved in "dist_max_labels.mat".

## Compute Z-score and p-value for comorbidity profiles
1. run Premorbid_heatmap_z_score.m for z-score table
2. run Premorbid_heatmap_z_score_p_value.m for p-value table

## Compute First-Order Treatment Transition Graph
1. Generate Patient Trajectories data using "combine_archetype_label_gradient_sepsis.m" 
2. Compute First Order Treatment Transitions using calculate_markov_chain.py. 
3. Generate First Order Treatment Transition Graph using markov_chain_plot_first_order_treatment_combine.m

## Compute Second-Order Transition Graph
1. Generate Patient Trajectories data using "combine_archetype_label_gradient_sepsis.m" 
2. Compute Second Order Transitions using calculate_markov_chain_second_order.py 
3. Generate First Order Treatment Transition Graph using markov_chain_plot_second_order_combine.m

## Compute Third-Order Transition Graph
1. Generate Patient Trajectories data using "combine_archetype_label_gradient_sepsis.m" 
2. Compute Second Order Transitions using calculate_markov_chain_third_orde.py
3. Generate First Order Treatment Transition Graph using markov_chain_plot_third_order.m


## Compute Gradient Archetype
1. run get_gradient_data.m to derive transition data.
2. run run_AA_gradient.m to compute the gradient archetypes for each k (the number of archetypes).
2. Note: the derived gradient archetype label in our analysis is saved in "gradient_dist_max_labels.mat".
3. Run transition_gradient_histo.m to compute gradient histogram for each gradient archetype.
4. Run gradient_heatmap_z_score.m to compute z-score for each gradient archetype.
5. Run gradient_heatmap_z_score_p_value.m to compute its corresponding p-value for each gradient archetype.

   
   
 

