# import pyodbc
# import pandas as pd
# import numpy as np
#
# df = pd.read_csv("C:\\Technical Training\\Project\\Customers.csv",quotechar="\"")
# df.columns = df.columns.astype(str)
# df.replace({np.inf: np.nan, -np.inf: np.nan}, inplace=True)
# df = df.fillna(0)
#
# cnxn = pyodbc.connect('''Driver=SQL Server;Server=IN3509253W1;Database=Project;Trusted_Connection=yes;''')
# cursor = cnxn.cursor()
# cursor.execute("Truncate table dbo.customers")
#
# for index, row in df.iterrows():
#     cursor.execute("INSERT INTO dbo.Customers(CustomerID, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone, Fax) values(?,?,?,?,?,?,?,?,?,?,?)", row.CustomerID,row.CompanyName,row.ContactName,row.ContactTitle,row.Address,row.City,row.Region,row.PostalCode,row.Country,row.Phone,row.Fax)
# cnxn.commit()
# cursor.close()
