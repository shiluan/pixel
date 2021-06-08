--DROP PROC sp_tool_MappingEntrySyntaxCheck
CREATE proc [dbo].[sp_tool_MappingEntrySyntaxCheck]
	@assuming_company_id int,
	@ceding_company_id int
as 
begin 
	SET NOCOUNT ON

	DROP TABLE IF EXISTS  #tmpV311
	SELECT top 0 * INTO #tmpV311 FROM Tmp_TAI_V311


	DECLARE 
		@idata VARCHAR(4000), @id int,
		@rdata VARCHAR(500),
		@sql  VARCHAR(4000);


	

	DROP TABLE IF EXISTS  #tmpMap
	SELECT Id, IncomingData, RmaData
	INTO #tmpMap
	FROM AssumedDataMapping
	WHERE AssumingCompanyId = @assuming_company_id
		AND CedingCompanyId = @ceding_company_id 


	PRINT '# of mapping entries to validate'
	DECLARE @cnt int
	SELECT @cnt = count(1)
		FROM #tmpMap
		

	DECLARE cur CURSOR
	FOR 
		SELECT Id, IncomingData, RmaData
		FROM #tmpMap

	OPEN cur
	FETCH NEXT FROM cur 
	INTO @id, @idata, @rdata;


	DECLARE @cnt INT = 0
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @cnt = @cnt + 1
		PRINT @cnt

		SET  @sql = N'select TOP 1 case When ' + @idata + ' Then ' + @rdata +' END from #tmpV311 WITH (NOLOCK)';
		PRINT @sql

		BEGIN TRY
			EXEC (@sql);
		END TRY
		BEGIN CATCH
			print('ID:['+cast(@id as varchar)+']'+ @sql);
			print ( ERROR_MESSAGE())
		END CATCH

        FETCH NEXT FROM cur 
		INTO @id, @idata, @rdata;
    END

	CLOSE cur

	DEALLOCATE cur

	DROP TABLE IF EXISTS  #tmpV311
	DROP TABLE IF EXISTS  #tmpMap
end
