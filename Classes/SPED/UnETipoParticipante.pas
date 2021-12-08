unit UnETipoParticipante;

interface

type
  //Tipo de participantes
  ETipoParticipante = (tpCliente, tpFornecedor);

  function TipoParticipante(lCodTipo: Integer): ETipoParticipante; overload;
  function TipoParticipante(lTipo: ETipoParticipante): Integer; overload;

const
  _CLIENTE = 1;
  _FORNECEDORES = 2;

implementation

function TipoParticipante(lCodTipo: Integer): ETipoParticipante;
begin
  case lCodTipo of
    _CLIENTE: Result:= tpCliente;
    _FORNECEDORES: Result:= tpFornecedor;
  end;
end;

function TipoParticipante(lTipo: ETipoParticipante): Integer;
begin
  case lTipo of
    tpCliente: Result:= _CLIENTE;
    tpFornecedor: Result:= _FORNECEDORES;
  end;
end;

end.

