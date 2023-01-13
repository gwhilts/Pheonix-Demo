defmodule Squawk.TimeLineTest do
  use Squawk.DataCase

  alias Squawk.TimeLine

  describe "posts" do
    alias Squawk.TimeLine.Posts

    import Squawk.TimeLineFixtures

    @invalid_attrs %{body: nil, likes: nil, username: nil}

    test "list_posts/0 returns all posts" do
      posts = posts_fixture()
      assert TimeLine.list_posts() == [posts]
    end

    test "get_posts!/1 returns the posts with given id" do
      posts = posts_fixture()
      assert TimeLine.get_posts!(posts.id) == posts
    end

    test "create_posts/1 with valid data creates a posts" do
      valid_attrs = %{body: "some body", likes: 42, username: "some username"}

      assert {:ok, %Posts{} = posts} = TimeLine.create_posts(valid_attrs)
      assert posts.body == "some body"
      assert posts.likes == 42
      assert posts.username == "some username"
    end

    test "create_posts/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TimeLine.create_posts(@invalid_attrs)
    end

    test "update_posts/2 with valid data updates the posts" do
      posts = posts_fixture()
      update_attrs = %{body: "some updated body", likes: 43, username: "some updated username"}

      assert {:ok, %Posts{} = posts} = TimeLine.update_posts(posts, update_attrs)
      assert posts.body == "some updated body"
      assert posts.likes == 43
      assert posts.username == "some updated username"
    end

    test "update_posts/2 with invalid data returns error changeset" do
      posts = posts_fixture()
      assert {:error, %Ecto.Changeset{}} = TimeLine.update_posts(posts, @invalid_attrs)
      assert posts == TimeLine.get_posts!(posts.id)
    end

    test "delete_posts/1 deletes the posts" do
      posts = posts_fixture()
      assert {:ok, %Posts{}} = TimeLine.delete_posts(posts)
      assert_raise Ecto.NoResultsError, fn -> TimeLine.get_posts!(posts.id) end
    end

    test "change_posts/1 returns a posts changeset" do
      posts = posts_fixture()
      assert %Ecto.Changeset{} = TimeLine.change_posts(posts)
    end
  end
end
