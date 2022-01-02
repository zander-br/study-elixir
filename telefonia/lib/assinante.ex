defmodule Assinante do
  defstruct nome: nil, numero: nil, cpf: nil, plano: nil

  @assinantes %{:prepago => "pre.txt", :pospago => "pos.txt"}

  def buscar_assinante(numero, key \\ :all), do: buscar(numero, key)

  defp buscar(numero, :prepago), do: filtro(assinantes_prepago(), numero)
  defp buscar(numero, :pospago), do: filtro(assinantes_pospago(), numero)
  defp buscar(numero, :all), do: filtro(assinantes(), numero)
  defp filtro(lista, numero), do: Enum.find(lista, &(&1.numero == numero))
  defp assinantes(), do: read(:prepago) ++ read(:pospago)
  defp assinantes_prepago(), do: read(:prepago)
  defp assinantes_pospago(), do: read(:pospago)

  def cadastrar(nome, numero, cpf, plano \\ :prepago) do
    case buscar_assinante(numero) do
      nil ->
        (read(plano) ++ [%__MODULE__{nome: nome, numero: numero, cpf: cpf, plano: plano}])
        |> :erlang.term_to_binary()
        |> write(plano)

        {:ok, "Assinante #{nome} cadastrado com sucesso!"}

      _assinante ->
        {:error, "Assinante com este número Cadastrado!"}
    end
  end

  defp write(lista_assinantes, plano) do
    File.write(@assinantes[plano], lista_assinantes)
  end

  defp read(plano) do
    case File.read(@assinantes[plano]) do
      {:ok, assinantes} -> :erlang.binary_to_term(assinantes)
      {:error, _reason} -> {:error, "Arquivo inválido"}
    end
  end
end
