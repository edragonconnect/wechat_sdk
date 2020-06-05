defmodule WeChat.SDK.UserTag do
  @moduledoc """
  标签管理

  [API Docs Link](https://developers.weixin.qq.com/doc/offiaccount/User_Management/User_Tag_Management.html){:target="_blank"}
  """
  import Jason.Helpers
  alias WeChat.SDK

  @type tag_id :: integer
  @type tag_name :: String.t

  @doc_link "https://developers.weixin.qq.com/doc/offiaccount/User_Management/User_Tag_Management.html"

  @doc """
  创建标签

  ## API Docs
    [link](#{@doc_link}#1){:target="_blank"}
  """
  @spec create(SDK.client, tag_name) :: SDK.response
  def create(client, name) do
    client.request(
      :post,
      url: "/cgi-bin/tags/create",
      body: json_map(
        tag: %{
          name: name
        }
      )
    )
  end

  @doc """
  获取公众号已创建的标签

  ## API Docs
    [link](#{@doc_link}#2){:target="_blank"}
  """
  @spec get(SDK.client) :: SDK.response
  def get(client) do
    client.request(:get, url: "/cgi-bin/tags/get")
  end

  @doc """
  编辑标签

  ## API Docs
    [link](#{@doc_link}#3){:target="_blank"}
  """
  @spec update(SDK.client, tag_id, tag_name) :: SDK.response
  def update(client, id, name) do
    client.request(
      :post,
      url: "/cgi-bin/tags/update",
      body: json_map(
        tag: %{
          id: id,
          name: name
        }
      )
    )
  end

  @doc """
  删除标签

  ## API Docs
    [link](#{@doc_link}#4){:target="_blank"}
  """
  @spec delete(SDK.client, tag_id) :: SDK.response
  def delete(client, id) do
    client.request(
      :post,
      url: "/cgi-bin/tags/delete",
      body: json_map(
        tag: %{
          id: id
        }
      )
    )
  end

  @doc """
  获取标签下粉丝列表

  ## API Docs
    [link](#{@doc_link}#5){:target="_blank"}
  """
  @spec get_tag_users(SDK.client, tag_id) :: SDK.response
  def get_tag_users(client, id) do
    client.request(
      :post,
      url: "/cgi-bin/user/tag/get",
      body: json_map(
        tagid: id
      )
    )
  end
  @spec get_tag_users(SDK.client, tag_id, next_openid :: SDK.openid) :: SDK.response
  def get_tag_users(client, id, next_openid) do
    client.request(
      :post,
      url: "/cgi-bin/user/tag/get",
      body: json_map(
        tagid: id,
        next_openid: next_openid
      )
    )
  end

  @doc """
  批量为用户打标签

  ## API Docs
    [link](#{@doc_link}){:target="_blank"}
  """
  @spec batch_tagging_users(SDK.client, tag_id, [SDK.openid]) :: SDK.response
  def batch_tagging_users(client, id, openid_list) do
    client.request(
      :post,
      url: "/cgi-bin/tags/members/batchtagging",
      body: json_map(
        tagid: id,
        openid_list: openid_list
      )
    )
  end

  @doc """
  批量为用户取消标签

  ## API Docs
    [link](#{@doc_link}){:target="_blank"}
  """
  @spec batch_untagging_users(SDK.client, tag_id, [SDK.openid]) :: SDK.response
  def batch_untagging_users(client, id, openid_list) do
    client.request(
      :post,
      url: "/cgi-bin/tags/members/batchuntagging",
      body: json_map(
        tagid: id,
        openid_list: openid_list
      )
    )
  end

  @doc """
  获取用户身上的标签列表

  ## API Docs
    [link](#{@doc_link}){:target="_blank"}
  """
  @spec get_user_tags(SDK.client, SDK.openid) :: SDK.response
  def get_user_tags(client, openid) do
    client.request(
      :post,
      url: "/cgi-bin/tags/getidlist",
      body: json_map(
        openid: openid
      )
    )
  end
end
