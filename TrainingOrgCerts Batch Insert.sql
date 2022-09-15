USE [Flow]
GO
/****** Object:  StoredProcedure [dbo].[TrainingOrgCertifications_BatchInsert]    Script Date: 8/25/2022 1:07:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Riley Dickey
-- Create date: 08/22/2022
-- Description:	This is a batch insert for Training Orgs
-- to add the certs they provide training for

-- Code Reviewer: 
-- MODIFIED BY:
-- MODIFIED DATE:
-- Code Reviewer:
-- Note:
-- =============================================

ALTER PROC [dbo].[TrainingOrgCertifications_BatchInsert]
				@OrganizationId int
			    ,@CreatedBy int
				,@batchOrgCerts dbo.CertUDT READONLY

AS
/*-----------TEST CODE-------------

	DECLARE		@OrganizationId int = 1
			   ,@CreatedBy int = 10

	DECLARE @batchOrgCerts dbo.CertUDT
				Insert into @batchOrgCerts (Name)
				Values
					('ACI Certification'),
					('Air-Conditioning'),
					('Workplace Safety')

	EXECUTE dbo.TrainingOrgCertifications_BatchInsert
				@OrganizationId
				,@CreatedBy
				,@batchOrgCerts



				SELECT *
				FROM dbo.TrainingOrgCertifications

*/-----------END TEST CODE---------

BEGIN

Insert Into dbo.CertificationTypes
				([Name])
			SELECT
				b.Name
			FROM @batchOrgCerts as b
			WHERE Not Exists
				(
				SELECT	1	
				FROM dbo.CertificationTypes as s
				Where s.Name = b.Name
				)

	INSERT INTO [dbo].[TrainingOrgCertifications]
			   ([OrganizationId]
			   ,[CertificationTypeId]
			   ,[CreatedBy])

	SELECT
			   @OrganizationId
			   ,s.Id
			   ,@CreatedBy
		 
		 From dbo.CertificationTypes as s
			Where
			Exists (
					Select 1
					From @batchOrgCerts as b
					Where b.[Name] = s.[Name]
					)

END

