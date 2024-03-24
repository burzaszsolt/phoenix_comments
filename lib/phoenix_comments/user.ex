defmodule PhoenixComments.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:url, :string)
    field(:name, :string)
    field(:provider, :string)
    field(:token, :string)
    field(:profile_image, :string)
    has_many(:comments, PhoenixComments.Comment)

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:url, :provider, :token, :name, :profile_image])
    |> validate_required([:url, :provider, :token, :name, :profile_image])
  end
end
