defmodule WeChat.SDK.UserBlacklist do
  @moduledoc """
  黑名单管理

  [API Docs Link](https://developers.weixin.qq.com/doc/offiaccount/User_Management/Manage_blacklist.html){:target="_blank"}
  """
  import Jason.Helpers
  alias WeChat.SDK

  @doc_link "https://developers.weixin.qq.com/doc/offiaccount/User_Management/Manage_blacklist.html"

  @doc """
  获取公众号的黑名单列表

  ## API Docs
    [link](#{@doc_link}#1){:target="_blank"}
  """
  @spec get_black_list(SDK.client()) :: SDK.response()
  def get_black_list(client) do
    client.request(:post, url: "/cgi-bin/tags/members/getblacklist")
  end

  @spec get_black_list(SDK.client(), SDK.openid()) :: SDK.response()
  def get_black_list(client, begin_openid) do
    client.request(
      :post,
      url: "/cgi-bin/tags/members/getblacklist",
      body: json_map(begin_openid: begin_openid)
    )
  end

  @doc """
  拉黑用户

  ## API Docs
    [link](#{@doc_link}#2){:target="_blank"}
  """
  @spec batch_blacklist(SDK.client(), [SDK.openid()]) :: SDK.response()
  def batch_blacklist(client, openid_list) do
    client.request(
      :post,
      url: "/cgi-bin/tags/members/batchblacklist",
      body: json_map(openid_list: openid_list)
    )
  end

  @doc """
  取消拉黑用户

  ## API Docs
    [link](#{@doc_link}#3){:target="_blank"}
  """
  @spec batch_unblacklist(SDK.client(), [SDK.openid()]) :: SDK.response()
  def batch_unblacklist(client, openid_list) do
    client.request(
      :post,
      url: "/cgi-bin/tags/members/batchunblacklist",
      body: json_map(openid_list: openid_list)
    )
  end
end
