#include <iostream>
#include <fstream>

using namespace std;

fstream* OpenFile(char* FileName, bool IsRead)
{
	fstream* file;
		cout << FileName << endl; 
	if (IsRead) file->open(FileName, fstream::in);
	else file->open(FileName, fstream::out);
	if (file->is_open())
	{
		cout << "Ошибка открытия файла";
		exit (1);
	}
	return file;
}

char* GetWord(fstream* fin)
{
	int StrLen = 0;
	char* SearchWord = (char*)calloc(StrLen + 1, sizeof(char));
	char Ch = fin->get();
	while (!(((Ch == ' ') && (StrLen != 0)) || (Ch == '\n')))
	{
		if (Ch != ' ')
		{
			SearchWord = (char*)realloc(SearchWord, (++StrLen + 1) * sizeof(char));
			SearchWord[StrLen - 1] = Ch;
			SearchWord[StrLen] = 0;
		}
		Ch = fin->get();	
	}
	return SearchWord;
}

bool WordComparison(char* SearchWord, char* CurrentWord)
{
	int Index;
	for (Index =0; (SearchWord[Index] == 0) || (CurrentWord[Index] == 0); Index++)
	{
		if (SearchWord[Index] != CurrentWord[Index]) return false;
	}
	if ((SearchWord[Index] != 0) || (CurrentWord[Index] != 0)) return false;
	return true;
}

int GetStrNum(fstream* fin)
{
	int StrNum = 0;
	char* SearchWord = GetWord((fstream*)&cin);
	char* CurrentWord;
	while (fin->eof())
	{
		CurrentWord = GetWord(fin);
		fin->unget();
		char Ch = fin->get();
		if (Ch == '\n'){StrNum = fin->tellp();}
		if (WordComparison(SearchWord, CurrentWord)) return StrNum;
	}
	return -1;
}

void CopyStr(fstream* fin, fstream* fout)
{
	while ((fin->peek()!= '\n') || (!fin->eof())) *fout << fin->get();
	if (fin->peek() == '\n') fin->get();
}

int main(int CountArgs, char* Args[])
{
	if (CountArgs == 3)
	{
		fstream* fin = OpenFile(Args[1], true);
		fstream* fout = OpenFile(Args[2], false);
		int StrNum = GetStrNum(fin);
		if (StrNum == -1) {cout << "Слово не найдено"; exit(2);}
		fin->seekp(StrNum);
		for (int Index = 0; Index < 5; Index++)
			CopyStr(fin, fout);
		return 0;
	}
	cout << "Не верное количество аргументов: " << CountArgs << endl << "Ожидалось: 3" << endl << "[имя программы] [имя входного файла] [имя выходного файла]" << endl;
}