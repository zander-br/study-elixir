defmodule AssinanteTest do
  use ExUnit.Case
  doctest Assinante

  setup do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("pos.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("pre.txt")
      File.rm("pos.txt")
    end)
  end

  describe "testes reponsáveis para cadastro de assinantes" do
    test "criar uma conta prepago" do
      assert Assinante.cadastrar("Joe Doe", "123", "123") ==
               {:ok, "Assinante Joe Doe cadastrado com sucesso!"}
    end

    test "deve retornar erro dizendo que assinante já está cadastrado" do
      Assinante.cadastrar("Joe Doe", "123", "123")

      assert Assinante.cadastrar("Joe Doe", "123", "123") ==
               {:error, "Assinante com este número Cadastrado!"}
    end
  end

  describe "testes responsáveis por busca de assinantes" do
    test "busca pospago" do
      Assinante.cadastrar("Joe Doe", "123", "123", :pospago)

      assert Assinante.buscar_assinante("123", :pospago) == %Assinante{
               cpf: "123",
               nome: "Joe Doe",
               numero: "123",
               plano: :pospago
             }
    end

    test "busca prepago" do
      Assinante.cadastrar("Joe Doe", "123", "123")

      assert Assinante.buscar_assinante("123", :prepago) == %Assinante{
               cpf: "123",
               nome: "Joe Doe",
               numero: "123",
               plano: :prepago
             }
    end
  end
end
