import pyodbc
import pandas as pd
import numpy as np

df = pd.read_csv("C:\\Technical Training\\Project\\Suppliers.csv", quotechar="\"")
df.columns = df.columns.astype(str)
df.replace({np.inf: np.nan, -np.inf: np.nan}, inplace=True)
df = df.fillna(0)

cnxn = pyodbc.connect('''Driver=SQL Server;Server=IN3509253W1;Database=Project;Trusted_Connection=yes;''')
cursor = cnxn.cursor()
cursor.execute("Truncate table dbo.Suppliers")
for index, row in df.iterrows():
    cursor.execute(
        "INSERT INTO dbo.Suppliers(SupplierID, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone) values(?,?,?,?,?,?,?,?,?,?)",
        row.SupplierID, row.CompanyName, row.ContactName, row.ContactTitle, row.Address, row.City, row.Region,
        row.PostalCode, row.Country, row.Phone)
cnxn.commit()
print('Done')
cursor.close()
