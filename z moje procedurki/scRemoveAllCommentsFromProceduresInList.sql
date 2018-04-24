DECLARE
	@targetDBName varchar(64)='[C_HARTWIG_SO_DEBUG]',
	@sql VARCHAR(MAX),
	@comment VARCHAR(max), 
	@endPosition INT, 
	@startPosition INT, 
	@commentLen INT,
	@substrlen INT, 
	@len INT,
	@i INT,
	@k INT,
	@pattern varchar(32),
	@multiCharToRemove varchar(2),
	@tabChar char = char(9)

DECLARE c CURSOR FOR 
SELECT definition
FROM sys.procedures p
	JOIN sys.sql_modules m
	ON p.object_id = m.object_id
--procedures list below
WHERE p.name IN (
	'prGetBooking2'
   --,'prGetOperationLCL'
   --,'prGetTransportOrder'
   )
OPEN c

FETCH NEXT FROM c INTO @sql

WHILE @@FETCH_STATUS = 0 
BEGIN
	SET @sql = REPLACE(@sql,'''','''''')
	SET @sql = REPLACE(@sql,'CREATE PROCEDURE','ALTER PROCEDURE')
	SET @targetDBName = REPLACE(@targetDBName,'[','')
	SET @targetDBName = REPLACE(@targetDBName,']','')

--remove multiple tabs
	SET @multiCharToRemove = @tabChar
	SET @i = 15
	WHILE @i > 0
	BEGIN
		SET @k = @i-1
		SET @pattern = @multiCharToRemove
				WHILE @k > 0
				BEGIN
					SET @pattern = @pattern + @multiCharToRemove
					SET @k = @k - 1
				END
		SET @sql = REPLACE(@sql,@pattern,@multiCharToRemove)
		SET @i = @i - 1			
	END
	
--remove comments begins with `--`
	SET @multiCharToRemove = char(10) --Tab=char(9), Linefeed=char(10), CarriageReturn=char(13)
	WHILE Patindex('%--%',@sql) <> 0
    BEGIN
            SET @startPosition = Patindex('%--%',@sql)
            SET @endPosition = Isnull(Charindex(@multiCharToRemove,@sql,@startPosition),0)
            SET @len = (@endPosition) - @startPosition

            -- This happens at the end of the code block, 
            --   when the last line is commented code with no CRLF characters
            IF @len <= 0 
                    SET @len = (Len(@sql) + 1) - @startPosition

            SET @Comment = Substring(@sql,@startPosition,@len)
            SET @sql = REPLACE(@sql,@comment,'')
    END
	
--remove empty tabs 
	SET @sql = REPLACE(@sql,@tabChar+@multiCharToRemove,@multiCharToRemove)

--remove multiple empty lines
	SET @i = 15
	WHILE @i > 0
	BEGIN
		SET @k = @i-1
		SET @pattern = @multiCharToRemove
				WHILE @k > 0
				BEGIN
					SET @pattern = @pattern + @multiCharToRemove
					SET @k = @k - 1
				END
		SET @sql = REPLACE(@sql,@pattern,@multiCharToRemove)
		SET @i = @i - 1			
	END

	SET @sql = 'USE [' + @targetDBName + ']; EXEC(''' + @sql + ''')'

	EXEC(@sql)

	FETCH NEXT FROM c INTO @sql
END

CLOSE c
DEALLOCATE c