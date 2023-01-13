defmodule Squawk.TimeLine.Posts do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :body, :string
    field :likes, :integer, default: 0
    field :username, :string, default: "anon"

    timestamps()
  end

  @doc false
  def changeset(posts, attrs) do
    posts
    |> cast(attrs, [:username])
    |> validate_required([:username])
    |> validate_length(:body, min: 2, max: 256)
  end
end
