GO
	CREATE DATABASE Faculdade
GO
	USE Faculdade
GO
	CREATE TABLE Aluno
	(
			AlunoId	       INT		NOT NULL IDENTITY(1,1) CONSTRAINT PK_Aluno_AlunoId PRIMARY KEY (AlunoId)
		,	Nome	       VARCHAR(30)      NOT NULL
		,	DataNascimento DATE		NOT NULL
		,	Matricula      VARCHAR(10)
		,	DateModified   DATETIME	        NOT NULL DEFAULT GETDATE()
		,	rowguid	       UNIQUEIDENTIFIER NOT NULL DEFAULT (NEWID())
	)
GO
	CREATE TRIGGER [dbo].[Tr_Aluno_AutoMatricula]
	ON [dbo].[Aluno]
	AFTER INSERT
	AS
		DECLARE @MaxId VARCHAR(4) = ISNULL((SELECT MAX(AlunoId) FROM Aluno), 1)
		DECLARE @Matricula VARCHAR(10) = CAST(YEAR(GETDATE()) AS VARCHAR(10))
		UPDATE Aluno
		SET Matricula = @Matricula + '.' + @MaxId
		WHERE AlunoId = (SELECT AlunoId FROM inserted)
GO
	CREATE TRIGGER [dbo].[tr_Aluno_DateModified]
	ON [dbo].[Aluno]
	AFTER UPDATE
	AS
		UPDATE Aluno
		SET DateModified = GETDATE()
		WHERE AlunoId = (SELECT AlunoId FROM inserted)
-----------------------------------------------------
GO
	CREATE TABLE Disciplina
	(
			DisciplinaId INT	      NOT NULL IDENTITY(1,1) CONSTRAINT PK_Disciplina_DisciplinaId PRIMARY KEY (DisciplinaId)
		,	Nome	     VARCHAR(30)      NOT NULL
		,	Ementa	     VARCHAR(255)
		,	DateModified DATETIME	      NOT NULL DEFAULT GETDATE()
		,	rowguid	     UNIQUEIDENTIFIER NOT NULL DEFAULT (NEWID())
	)
GO
	CREATE TRIGGER [dbo].[tr_Disciplina_DateModified]
	ON [dbo].[Disciplina]
	AFTER UPDATE
	AS
		UPDATE Disciplina
		SET DateModified = GETDATE()
		WHERE DisciplinaId = (SELECT DisciplinaId FROM inserted)
-----------------------------------------------------
GO
	CREATE TABLE DisciplinasMatriculadas
	(
			DisciplinasMatriculadasId INT		   NOT NULL UNIQUE IDENTITY(1,1)
		,	AlunoId			  INT		   NOT NULL CONSTRAINT FK_DisciplinasMatriculadas_Aluno_AlunoId FOREIGN KEY REFERENCES Aluno(AlunoId)
		,	DisciplinaId		  INT		   NOT NULL CONSTRAINT FK_DisciplinasMatriculadas_Disciplina_DisciplinaId FOREIGN KEY REFERENCES Disciplina(DisciplinaId)
		,	DateModified		  DATETIME	   NOT NULL DEFAULT GETDATE()
		,	rowguid			  UNIQUEIDENTIFIER NOT NULL DEFAULT (NEWID())
			CONSTRAINT PK_AlunoId_DisciplinaId PRIMARY KEY (AlunoId, DisciplinaId)
	)
GO
	CREATE TRIGGER [dbo].[tr_DisciplinasMatriculadas_DateModified]
	ON [dbo].[DisciplinasMatriculadas]
	AFTER UPDATE
	AS
		UPDATE DisciplinasMatriculadas
		SET DateModified = GETDATE()
		WHERE DisciplinasMatriculadasId = (SELECT DisciplinasMatriculadasId FROM inserted)
-----------------------------------------------------
GO
	CREATE FUNCTION [dbo].[UDF_RetornarIdadeAluno] (@AlunoId INT)
		RETURNS VARCHAR(30)
		AS
		BEGIN
			RETURN
				(
				SELECT DATEDIFF(YEAR, DataNascimento, GETDATE())
				FROM Aluno
				WHERE AlunoId = @AlunoId
				)
		END
GO
