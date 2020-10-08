PROGRAM MAIN(INPUT, OUTPUT);
//USES CRT;

FUNCTION GetWord(VAR FIN: TEXT): UNICODESTRING;
VAR
	TempString: UNICODESTRING;
	Ch: UNICODECHAR;
BEGIN
	TempString := '';
	WHILE NOT(EOLN(FIN) OR EOF(FIN)) DO
	BEGIN
		READ(FIN, Ch);
		IF Ch = ' ' THEN
		BEGIN
			IF LENGTH(TempString) > 0 THEN BREAK
		END
		ELSE TempString := TempString + Ch;
	END;
	GetWord := TempString;
	READLN(FIN)
END;

FUNCTION Minimum(FirstNum, SecondNum: INTEGER): INTEGER;
BEGIN
	Minimum := FirstNum;
	IF FirstNum > SecondNum THEN Minimum := SecondNum
END;

FUNCTION ChangeRegisterChar(Ch: UNICODECHAR): UNICODECHAR;
BEGIN
	IF (Ch >= 'a') AND (Ch <= 'z') THEN
		Ch := CHR(ORD(Ch) + (ORD('A') - ORD('a')));
	IF (Ch >= 'а') AND (Ch <= 'я') THEN
		Ch := CHR(ORD(Ch) + (ORD('А') - ORD('а')));
	ChangeRegisterChar := Ch;
END;

FUNCTION ChangeRegisterWord(SourceWord: UNICODESTRING): UNICODESTRING;
VAR
	Index: INTEGER;
BEGIN
	ChangeRegisterWord := '';
	FOR Index := 1 TO LENGTH(SourceWord) DO
	BEGIN
		ChangeRegisterWord := ChangeRegisterWord + ChangeRegisterChar(SourceWord[Index]);
	END
END;

FUNCTION WordComparison(FirstWord, SecondWord: UNICODESTRING): BOOLEAN;
VAR
	Index: INTEGER;
BEGIN
	WordComparison := TRUE;
	FOR Index := 0 TO Minimum(LENGTH(FirstWord), LENGTH(SecondWord)) DO
		IF FirstWord[Index] <> SecondWord[Index] THEN WordComparison := FALSE
END;

FUNCTION CutString(SourceString: UNICODESTRING; Start, Count: INTEGER): UNICODESTRING;
VAR
	Index: INTEGER;
BEGIN
	CutString := '';
	FOR Index := Start TO Start + Count - 1 DO
		CutString := CutString + SourceString[Index]
END;

FUNCTION SearchWord(SourceString, FindWord: UNICODESTRING):BOOLEAN;
VAR
	Index: INTEGER;
BEGIN
	SearchWord := FALSE;
	IF LENGTH(SourceString) >= LENGTH(FindWord) THEN
		FOR Index := 1 TO LENGTH(SourceString) DO
			IF WordComparison(FindWord, CutString(SourceString, Index, LENGTH(FindWord))) THEN
			BEGIN
				IF (SourceString[Index - 1] IN [' ', '''', '"']) AND
				   (SourceString[Index + LENGTH(FindWord)] IN [' ', ',', '.', '!', '?', ':', ';', '''', '"']) THEN
			   	BEGIN
					SearchWord := TRUE;
					BREAK
				END
			END
END;

VAR
	FIN, FOUT: TEXT;
	FindString, Line: UNICODESTRING;
	Index: INTEGER;

BEGIN
	IF PARAMCOUNT = 2 THEN
	BEGIN
		ASSIGN(FIN, PARAMSTR(1));
		ASSIGN(FOUT, PARAMSTR(2));
		{$I-}
		RESET(FIN);
		{$I+}
		IF IORESULT <> 0 THEN
		BEGIN
			WRITELN(OUTPUT, 'Не удалось открыть файл: ', PARAMSTR(1));
			HALT
		END;
		{$I-}
		REWRITE(FOUT);
		{$I+}
		IF IORESULT <> 0 THEN
		BEGIN
			WRITELN(OUTPUT, 'Не удалось открыть файл: ', PARAMSTR(2));
			HALT
		END;

		FindString := GetWord(INPUT);
		IF FindString = '' THEN 
		BEGIN
			WRITELN(OUTPUT, 'Вы ввели много пробелов и ни одной буквы :С');
			HALT
		END;
		WHILE NOT EOF(FIN) DO
		BEGIN
			READLN(FIN, Line);
			IF SearchWord(Line, FindString) THEN
			BEGIN
				WRITELN(FOUT, Line);
				FOR Index := 1 TO 4 DO
					IF NOT EOF(FIN) THEN
					BEGIN
						READLN(FIN, Line);
						WRITE(FOUT, Line);
						IF Index <> 4 THEN WRITELN(FOUT)
					END
					ELSE
						BREAK;
				CLOSE(FIN);
				CLOSE(FOUT);
				HALT;
				BREAK
			END
		END;
		WRITELN(OUTPUT, 'Слово не было найдено в тексте');
		CLOSE(FIN);
		CLOSE(FOUT);
		HALT
	END;

	WRITELN(OUTPUT, 'Не верное количество аргументов: ', PARAMCOUNT + 1, #13 + #10 + 'Ожидалось: 3' + #13 + #10 + '[имя программы] [имя входного файла] [имя выходного файла]')

END.