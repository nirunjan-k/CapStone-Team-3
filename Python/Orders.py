import pyodbc
import pandas as pd
import numpy as np

df = pd.read_csv("C:\\Technical Training\\Project\\Orders.csv",quotechar="\"")
df.columns = df.columns.astype(str)
df.replace({np.inf: np.nan, -np.inf: np.nan}, inplace=True)
df = df.fillna(0)

cnxn = pyodbc.connect('''Driver=SQL Server;Server=IN3509253W1;Database=Project;Trusted_Connection=yes;''')
cursor = cnxn.cursor()
cursor.execute("Truncate table dbo.Orders")

for index, row in df.iterrows():
    cursor.execute("INSERT INTO dbo.Orders(OrderID,CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate,ShipVia,Freight,ShipName,ShipAddress,ShipCity,ShipRegion,ShipPostalCode,ShipCountry) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)", row.OrderID,row.CustomerID,row.EmployeeID,row.OrderDate,row.RequiredDate,row.ShippedDate,row.ShipVia,row.Freight,row.ShipName,row.ShipAddress,row.ShipCity,row.ShipRegion,row.ShipPostalCode,row.ShipCountry)

cnxn.commit()
print("done")
cursor.close()
