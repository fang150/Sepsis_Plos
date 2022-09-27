import numpy as np 


#  1
#  icustayid, charttime, bloc, subject_id, re_admission,
#  6
#  died_in_hosp, died_within_48h_of_out_time, mortality_90d, archetype, GCS, 
#  11
#  HR, SysBP, MeanBP, RR, SpO2,
#  16
#  Temp_C, FiO2_1, Potassium, Sodium, Chloride,
#  21
#  Glucose, BUN, Creatinine, Magnesium, Calcium,
#  26
#  Ionised_Ca, CO2_mEqL, SGOT, SGPT, Total_bili, 
#  31
#  Albumin, Hb, WBC_count, Platelets_count, PTT,
#  36
#  PT, INR, Arterial_pH, paO2, paCO2,
#  41
#  Arterial_BE, Arterial_lactate, HCO3, mechvent, Shock_Index,
#  46
#  PaO2_FiO2, median_dose_vaso, max_dose_vaso, input_total, input_4hourly,
#  51
#  output_total, output_4hourly, cumulated_balance

Patient_Trajectories=np.loadtxt("Patient_Trajectories_Treatment.csv", delimiter = "," , skiprows=1)

# Find unique patient trajectories
distinct_patients_list=np.unique(Patient_Trajectories[:,0])
patient_traj_list=[]

# Get all patient trajectories
for i in range(0,len(distinct_patients_list)):
    
    # Find the indices that belongs to the current stay
    Patient_Trajectories_idx=np.where(Patient_Trajectories[:,0] == distinct_patients_list[i])
    
    # Get the trajectories for this particular stay
    traj_list=Patient_Trajectories[  Patient_Trajectories_idx  ,:]
    
    # Put that trajectory into the list
    if(i==0):
        patient_traj_list=[traj_list]
    else:
        patient_traj_list.append(traj_list)

init_to_Ai_count = np.zeros(6)
Ai_to_Aj_count = np.zeros((6,6))


init_to_Ai_mechvent_total  = np.zeros(6)
init_to_Ai_max_dose_vaso_total = np.zeros(6)
init_to_Ai_input_total = np.zeros(6)


Ai_to_Aj_mechvent_total = np.zeros((6,6))
Ai_to_Aj_max_dose_vaso_total = np.zeros((6,6))
Ai_to_Aj_input_total = np.zeros((6,6))




Ai_to_survive_death_count = np.zeros((6,2))


## Loop over all patient trajectories
## Compute init_to_Ai_count, Ai_to_Aj_count, Ai_to_survive_death_count (end state)
for i in range(0,len(patient_traj_list)):

    ## Get the current trajectory
    traj=patient_traj_list[i]
    ## Go through each time point
    number_of_time_points = traj.shape[1]

    for j in range(number_of_time_points):

        if number_of_time_points == 1:

            Archetype = int(traj[0,j,8])   # 1 to 6
            init_to_Ai_count[ Archetype - 1 ] += 1

            init_to_Ai_mechvent_total[Archetype-1] += traj[0,j, 43]
            init_to_Ai_max_dose_vaso_total[Archetype-1] += traj[0,j, 47]
            init_to_Ai_input_total[Archetype-1] += traj[0,j, 49]

            
            if(traj[0,j,5] == 1):
                Ai_to_survive_death_count[ Archetype - 1, 1 ] += 1
            else:
                Ai_to_survive_death_count[ Archetype - 1, 0 ] += 1

        elif number_of_time_points == 2:


            ## example a b
            ##         
            if(j == 0):
                    ## example a b
                    ##         ^
                Archetype = int(traj[0,j,8])   # 1 to 6
                init_to_Ai_count[Archetype-1] += 1

                init_to_Ai_mechvent_total[Archetype-1] += traj[0,j, 43]
                init_to_Ai_max_dose_vaso_total[Archetype-1] += traj[0,j, 47]
                init_to_Ai_input_total[Archetype-1] += traj[0,j, 49]


                if(traj[0,j,5] == 1):
                    Ai_to_survive_death_count[ Archetype - 1, 1 ] += 1
                else:
                    Ai_to_survive_death_count[ Archetype - 1, 0 ] += 1


            elif (j == 1):
                    ## example a b
                    ##           ^
                Archetype_prev = int(traj[0, j - 1, 8])
                Archetype_cur = int(traj[0, j, 8])
                Ai_to_Aj_count[Archetype_prev - 1, Archetype_cur - 1] += 1

                Ai_to_Aj_mechvent_total[Archetype_prev-1,Archetype_cur-1] += (traj[0,j-1,43])
                Ai_to_Aj_max_dose_vaso_total[Archetype_prev-1,Archetype_cur-1] += (traj[0,j-1,47])
                Ai_to_Aj_input_total[Archetype_prev-1,Archetype_cur-1] += (traj[0,j-1,49])

                if(traj[0,j,5] == 1):
                    Ai_to_survive_death_count[Archetype_cur - 1, 1 ] += 1
                else:
                    Ai_to_survive_death_count[Archetype_cur - 1, 0 ] += 1
        else:

            ## First entrance state, update init_to_Ai_count
            if(j == 0):
                Archetype = int(traj[0,j,8])   # 1 to 6
                init_to_Ai_count[Archetype-1] += 1

                #init_to_Ai_count[Archetype-1]+=1
                init_to_Ai_mechvent_total[Archetype-1] += traj[0,j, 43]
                init_to_Ai_max_dose_vaso_total[Archetype-1] += traj[0,j,47]
                init_to_Ai_input_total[Archetype-1]+= traj[0,j,49]

                if(traj[0,j,5] == 1):
                    Ai_to_survive_death_count[ Archetype - 1, 1 ] += 1
                else:
                    Ai_to_survive_death_count[ Archetype - 1, 0 ] += 1
            
            ## In the middle of states, update Ai_to_Aj_count
            elif(j < number_of_time_points - 1 ):
                ## example a b c 
                ##         ^ ^
                ##         p c
                Archetype_prev = int(traj[0, j - 1, 8])
                Archetype_cur = int(traj[0, j, 8])
                Ai_to_Aj_count[Archetype_prev - 1, Archetype_cur - 1] += 1

                Ai_to_Aj_mechvent_total[Archetype_prev-1,Archetype_cur-1] += (traj[0,j-1,43])
                Ai_to_Aj_max_dose_vaso_total[Archetype_prev-1,Archetype_cur-1] += (traj[0,j-1,47])
                Ai_to_Aj_input_total[Archetype_prev-1,Archetype_cur-1] += (traj[0,j-1,49])


                if(traj[0,j,5] == 1):
                    Ai_to_survive_death_count[ Archetype_cur - 1, 1 ] += 1
                else:
                    Ai_to_survive_death_count[ Archetype_cur - 1, 0 ] += 1


            ## In the end states, update Ai_to_survive_death_count
            else:
                ## example a b c
                ##           ^ ^
                ##           p c
                Archetype_prev = int(traj[0, j - 1, 8])
                Archetype_cur = int(traj[0, j, 8])
                Ai_to_Aj_count[Archetype_prev - 1, Archetype_cur - 1] += 1
                Ai_to_Aj_mechvent_total[Archetype_prev-1,Archetype_cur-1] += (traj[0,j-1,43])
                Ai_to_Aj_max_dose_vaso_total[Archetype_prev-1,Archetype_cur-1] += (traj[0,j-1,47])
                Ai_to_Aj_input_total[Archetype_prev-1,Archetype_cur-1] += (traj[0,j-1,49])

                if(traj[0,j,5] == 1):
                    Ai_to_survive_death_count[Archetype_cur - 1, 1 ] += 1
                else:
                    Ai_to_survive_death_count[Archetype_cur - 1, 0 ] += 1

init_to_Ai_prob=np.zeros(6)
Ai_to_Aj_prob= np.zeros((6,6))
Ai_to_survive_death_prob =np.zeros((6,2))


init_to_Ai_mechvent_avg = np.zeros(6)
init_to_Ai_max_dose_vaso_avg =  np.zeros(6)
init_to_Ai_input_avg = np.zeros(6)

Ai_to_Aj_mechvent_avg = np.zeros((6,6))
Ai_to_Aj_max_dose_vaso_avg = np.zeros((6,6))
Ai_to_Aj_input_avg = np.zeros((6,6))

## Calculate transition probabilities
init_to_Ai_prob=init_to_Ai_count/sum(init_to_Ai_count)


for i in range(6):
    if init_to_Ai_count[i] != 0 :
        init_to_Ai_mechvent_avg[i] = init_to_Ai_mechvent_total[i] / init_to_Ai_count[i]
        init_to_Ai_max_dose_vaso_avg[i] = init_to_Ai_max_dose_vaso_total[i] / init_to_Ai_count[i]
        init_to_Ai_input_avg[i] = init_to_Ai_input_total[i] / init_to_Ai_count[i]

for i in range(6):
    for j in range(6):
        if Ai_to_Aj_count[i][j] != 0:
            Ai_to_Aj_mechvent_avg[i][j] = Ai_to_Aj_mechvent_total[i][j] / Ai_to_Aj_count[i][j]
            Ai_to_Aj_max_dose_vaso_avg[i][j] = Ai_to_Aj_max_dose_vaso_total[i][j] / Ai_to_Aj_count[i][j]
            Ai_to_Aj_input_avg[i][j] = Ai_to_Aj_input_total[i][j] / Ai_to_Aj_count[i][j]

for i in range(0,len(Ai_to_Aj_count)):
    Ai_to_Aj_prob[i] = Ai_to_Aj_count[i] / sum(Ai_to_Aj_count[i])

for i in range(0,len(Ai_to_survive_death_count)):
    Ai_to_survive_death_prob[i] = Ai_to_survive_death_count[i] / sum(Ai_to_survive_death_count[i])

np.savetxt('init_to_Ai_count.csv', init_to_Ai_count, delimiter=',') 
np.savetxt('Ai_to_Aj_count.csv', Ai_to_Aj_count, delimiter=',') 
np.savetxt('Ai_to_survive_death_count.csv', Ai_to_survive_death_count, delimiter=',') 

np.savetxt('init_to_Ai_prob.csv', init_to_Ai_prob, delimiter=',') 
np.savetxt('Ai_to_Aj_prob.csv', Ai_to_Aj_prob, delimiter=',') 
np.savetxt('Ai_to_survive_death_prob.csv', Ai_to_survive_death_prob, delimiter=',') 


np.savetxt('init_to_Ai_mechvent_avg.csv', init_to_Ai_mechvent_avg, delimiter=',') 
np.savetxt('Ai_to_Aj_mechvent_avg.csv', Ai_to_Aj_mechvent_avg, delimiter=',') 

np.savetxt('init_to_Ai_max_dose_vaso_avg.csv', init_to_Ai_max_dose_vaso_avg, delimiter=',') 
np.savetxt('Ai_to_Aj_max_dose_vaso_avg.csv', Ai_to_Aj_max_dose_vaso_avg, delimiter=',') 

np.savetxt('init_to_Ai_input_avg.csv', init_to_Ai_input_avg, delimiter=',') 
np.savetxt('Ai_to_Aj_input_avg.csv', Ai_to_Aj_input_avg, delimiter=',') 



#import pdb;pdb.set_trace();


