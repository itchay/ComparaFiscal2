unit UnClasseOrdenacaoStringGrid;

interface

uses
  Vcl.Grids, SysUtils;

type
  TSGSortCompareProc = function(SG: TStringGrid; Col, Row1, Row2: Integer): Integer;

procedure SGQuickSort(SG: TStringGrid; L, R: Integer; SCompare: TSGSortCompareProc; Col: Integer);
function ComparaString(SG: TStringGrid; Col, Row1, Row2: Integer): Integer;
function ComparaStringInvertido(SG: TStringGrid; Col, Row1, Row2: Integer): Integer;
function ComparaNumeros(SG: TStringGrid; Col, Row1, Row2: Integer): Integer;
function ComparaNumerosInvertido(SG: TStringGrid; Col, Row1, Row2: Integer): Integer;
function ComparaData(SG: TStringGrid; Col, Row1, Row2: Integer): Integer;
function ComparaDataInvertido(SG: TStringGrid; Col, Row1, Row2: Integer): Integer;
procedure StrGridSort(SG: TStringGrid; Col: Integer; tipo: integer; decrescente: boolean; total: boolean);


implementation


procedure SGQuickSort(SG: TStringGrid; L, R: Integer; SCompare: TSGSortCompareProc; Col: Integer);
var
  I, J, C, M: Integer;
begin
  repeat
    I := L;
    J := R;
    M := (L + R) shr 1;
    repeat
      while SCompare(SG, Col, I, M) < 0 do
        Inc(I);
      while SCompare(SG, Col, J, M) > 0 do
        Dec(J);

      if I <= J then
      begin
        for C := 0 to SG.ColCount - 1 do
          SG.Cols[C].Exchange(I, J);
        if I = M then
          M := J
        else if J = M then
          M := I;

        Inc(I);
        Dec(J);
      end;
    until I > J;

    if L < J then
      SGQuickSort(SG, L, J, SCompare, Col);
    L := I;
  until I >= R;
end;

function ComparaString(SG: TStringGrid; Col, Row1, Row2: Integer): Integer;
begin
  Result := AnsiCompareText(SG.Cells[Col, Row1], SG.Cells[Col, Row2]);
end;

function ComparaStringInvertido(SG: TStringGrid; Col, Row1, Row2: Integer): Integer;
begin
  Result := AnsiCompareText(SG.Cells[Col, Row2], SG.Cells[Col, Row1]);
end;

function ComparaNumeros(SG: TStringGrid; Col, Row1, Row2: Integer): Integer;
var
  a,b : real;
begin
  try
    a := StrToFloat(SG.Cells[col,row1]);
  except
    a := 0;
  end;

  try
    b := StrToFloat(SG.Cells[col,row2]);
  except
    b := 0;
  end;

  Result := Round( (a - b)*100000 );
end;

function ComparaNumerosInvertido(SG: TStringGrid; Col, Row1, Row2: Integer): Integer;
var
  a,b : real;
begin
  try
    a := StrToFloat(SG.Cells[col,row1]);
  except
    a := 0;
  end;

  try
    b := StrToFloat(SG.Cells[col,row2]);
  except
    b := 0;
  end;

  Result := Round( (b - a)*100000 );
end;

function ComparaData(SG: TStringGrid; Col, Row1, Row2: Integer): Integer;
var
  a, b: TDate;
begin
  try
    a := StrToDate(SG.Cells[Col,Row1]);
  except
    a := Date();
  end;

  try
    b := StrToDate(SG.Cells[Col,Row2]);
  except
    b := Date();
  end;

  Result := round(a - b ) ;
end;

function ComparaDataInvertido(SG: TStringGrid; Col, Row1, Row2: Integer): Integer;
var
  a, b: TDate;
begin
  try
    a := StrToDate(SG.Cells[Col,Row1]);
  except
    a := Date();
  end;

  try
    b := StrToDate(SG.Cells[Col,Row2]);
  except
    b := Date();
  end;

  Result := round(b - a ) ;
end;

procedure StrGridSort(SG: TStringGrid; Col: Integer; tipo: integer; decrescente: boolean; total: boolean);
var
  linhas: integer;
begin
if total then
  linhas := SG.RowCount - 2
else
  linhas := SG.RowCount - 1;

if (tipo=1) then //caso for numerico
begin
  if decrescente then //Comeca pela linha 2 porque a Linha 1 é usada para definir o tipo
    SGQuickSort(SG, 2, linhas, @ComparaNumerosInvertido, Col)
  else
    SGQuickSort(SG, 2, linhas, @ComparaNumeros, Col);
end
else if (tipo=2) then//caso for string
begin
  if decrescente then
    SGQuickSort(SG, 2, linhas, @ComparaStringInvertido, Col)
  else
    SGQuickSort(SG, 2, linhas, @ComparaString, Col);
end
else //caso for data
  if decrescente then
    SGQuickSort(SG, 2, linhas, @ComparaDataInvertido, Col)
  else
    SGQuickSort(SG, 2, linhas, @ComparaData, Col);
end;

end.
