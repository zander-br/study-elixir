defmodule Assinante do
  defstruct nome: nil, numero: nil, cpf: nil, plano: nil

  @assinantes %{:prepago => "pre.txt", :pospago => "pos.txt"}

  def buscar_assinante(numero) do
    (read(:prepago) ++ read(:pospago))
    |> Enum.find(fn assinante -> assinante.numero == numero end)
  end

  def cadastrar(nome, numero, cpf, plano \\ :prepago) do
    case buscar_assinante(numero) do
      nil ->
        (read(plano) ++ [%__MODULE__{nome: nome, numero: numero, cpf: cpf, plano: plano}])
        |> :erlang.term_to_binary()
        |> write(plano)

        {:ok, "Assinante #{nome} cadastrado com sucesso"}

      _assinante ->
        {:error, "Assinante com este número Cadastrado!"}
    end
  end

  defp write(lista_assinantes, plano) do
    File.write(@assinantes[plano], lista_assinantes)
  end

  defp read(plano) do
    {:ok, assinantes} = File.read(@assinantes[plano])
    :erlang.binary_to_term(assinantes)
  end
end
