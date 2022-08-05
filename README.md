# RealTime Retail Demo
The purpose of this demo is to show that MemSQL can stream live retail transaction data to a modern visualization tool aka ZoomData.


## File List and Purpose
- Docker_Notes.txt
    * notes for running a docker image
- ILM_Transactions.sh
    * ILM script to move transactions to the columnstore
- Output_Input_Data.sql
    * Script to export tranactions and import transactions
- dw_data_maker.py
    * Python script to create random transactions
- dw_demo.mwb
    * Data model to be opened in MySQL Workbench
- dw_demo.sql
    * The database creation script
- dw_demo.twb
    * Tableau workbook
- dw_demo_queries.sql
    * Some example queries
- dw_item_maker.py

- items.sql
    * script to add items to the item table
- kill_dw.sh
    * Script to kill the python transaction load script
