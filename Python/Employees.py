import pyodbc
import pandas as pd
import numpy as np

df = pd.read_csv("C:\\Technical Training\\Project\\Employee.csv")
df.columns = df.columns.astype(str)
df.replace({np.inf: np.nan, -np.inf: np.nan}, inplace=True)
df = df.fillna(0)
cnxn = pyodbc.connect('''Driver=SQL Server;Server=IN3509253W1;Database=Project;Trusted_Connection=yes;''')
cursor = cnxn.cursor()
cursor.execute("Truncate table dbo.Employees")

for index, row in df.iterrows():
    cursor.execute(
        "INSERT INTO dbo.Employees(EmployeeID,LastName,FirstName,BirthDate,HireDate,Region,Country) values(?,?,?,?,?,?,?)",
        row.EmployeeID, row.LastName, row.FirstName, row.BirthDate, row.HireDate, row.Region, row.Country)

cnxn.commit()
print('Done')
cursor.close()
