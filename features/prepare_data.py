import pandas as pd

MIMICtable = pd.read_csv("MIMICtable2.csv")

extradatatable_columns = ["bloc","icustayid","charttime","re_admission","died_in_hosp","died_within_48h_of_out_time", \
						  "mortality_90d","delay_end_of_record_and_discharge_or_death","median_dose_vaso","max_dose_vaso", \
						  "input_total","input_4hourly","output_total","output_4hourly","cumulated_balance","SOFA","SIRS"]
datatable_columns = ["gender","age","elixhauser","Weight_kg","GCS","HR","SysBP","MeanBP","DiaBP","RR", \
					  "SpO2","Temp_C","FiO2_1","Potassium","Sodium","Chloride","Glucose","BUN","Creatinine", \
					  "Magnesium","Calcium","Ionised_Ca","CO2_mEqL","SGOT","SGPT","Total_bili","Albumin","Hb","WBC_count", \
					  "Platelets_count","PTT","PT","INR","Arterial_pH","paO2","paCO2","Arterial_BE","Arterial_lactate","HCO3","mechvent", \
					  "Shock_Index","PaO2_FiO2"]

extradatatable = MIMICtable[extradatatable_columns]
extradatatable.to_csv("extradatatable.txt", index=False)
datatable = MIMICtable[datatable_columns]
datatable.to_csv("datatable.txt", index=False)
