-- =====================================
-- BLOQUE ANONIMO
-- =====================================
/*
BEGIN

	Sentencias a ejecutar

END;
GO
*/


-- Ejemplo

BEGIN
	
	DECLARE  @NUM1 INT,  @NUM2 INT,  @SUMA INT;
	
	SET @NUM1 =  CAST( RAND() * 100 AS INT );
	SET @NUM2 =  CAST( RAND() * 100 AS INT );
	
	SET @SUMA = @NUM1 + @NUM2;
	
	PRINT CONCAT( 'NUM1 = ', @NUM1 );
	PRINT CONCAT( 'NUM2 = ', @NUM2 );
	PRINT CONCAT( 'SUMA = ', @SUMA );

END;
GO






