defmodule FocusAtWillEx.SessionTest do
  use ExUnit.Case, async: true

  import Mox

  alias FocusAtWillEx.MockClient
  alias FocusAtWillEx.Session

  describe "authencitate" do
    test "successfull login" do
      expect(MockClient, :authenticate, 1, fn _email, _pwd ->
        {:ok,
         %{
           "authentication_token" => "secrect_token",
           "user" => %{
             "foo" => "bar"
           }
         }}
      end)

      session = Session.new("foo@bar.com", "password")
      assert session.token == "secrect_token"
      assert session.user == %{"foo" => "bar"}
    end

    test "login missing token in reponse" do
      expect(MockClient, :authenticate, 1, fn _email, _pwd ->
        {:ok,
         %{
           "user" => %{
             "foo" => "bar"
           }
         }}
      end)

      {:error, reason} = Session.new("foo@bar.com", "password")
      assert reason == "Invalid response format: missing authentication_token or user"
    end
  end
end
