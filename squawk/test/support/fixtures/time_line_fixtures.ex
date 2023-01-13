defmodule Squawk.TimeLineFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Squawk.TimeLine` context.
  """

  @doc """
  Generate a posts.
  """
  def posts_fixture(attrs \\ %{}) do
    {:ok, posts} =
      attrs
      |> Enum.into(%{
        body: "some body",
        likes: 42,
        username: "some username"
      })
      |> Squawk.TimeLine.create_posts()

    posts
  end
end
