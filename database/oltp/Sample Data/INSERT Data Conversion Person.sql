SET IDENTITY_INSERT Application.Person ON;
INSERT INTO Application.Person (PersonId, FirstName, LastName, RowUpdatePersonId)
VALUES
     (1, N'Data Conversion', N'Only', 1);
SET IDENTITY_INSERT Application.Person OFF;