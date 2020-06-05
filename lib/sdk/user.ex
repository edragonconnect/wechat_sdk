defmodule WeChat.SDK.User do
  @moduledoc "用户管理"
  import Jason.Helpers
  alias WeChat.SDK

  @doc """
  设置用户备注名

  ## API Docs
    [link](https://developers.weixin.qq.com/doc/offiaccount/User_Management/Configuring_user_notes.html){:target="_blank"}
  """
  @spec update_remark(SDK.client(), SDK.openid(), remark :: String.t()) :: SDK.response()
  def update_remark(client, openid, remark) do
    client.request(
      :post,
      url: "/cgi-bin/user/info/updateremark",
      body: json_map(openid: openid, remark: remark)
    )
  end

  @doc """
  获取用户基本信息(UnionID机制)

  ## API Docs
    [link](https://developers.weixin.qq.com/doc/offiaccount/User_Management/Get_users_basic_information_UnionID.html#UinonId){:target="_blank"}
  """
  @spec user_info(SDK.client(), SDK.openid()) :: SDK.response()
  def user_info(client, openid) do
    client.request(
      :get,
      url: "/cgi-bin/user/info",
      query: [
        openid: openid
      ]
    )
  end

  @doc """
  拉取用户信息(需scope为 snsapi_userinfo)

  如果网页授权作用域为snsapi_userinfo,则此时开发者可以通过access_token和openid拉取用户信息了.

  ## API Docs
    [link](https://developers.weixin.qq.com/doc/offiaccount/OA_Web_Apps/Wechat_webpage_authorization.html#3){:target="_blank"}
  """
  @spec sns_user_info(SDK.client(), SDK.openid(), access_token :: String.t()) :: SDK.response()
  def sns_user_info(client, openid, access_token) do
    client.request(
      :get,
      url: "/sns/userinfo",
      query: [
        access_token: access_token,
        openid: openid
      ]
    )
  end

  @doc """
  获取用户列表

  ## API Docs
    [link](https://developers.weixin.qq.com/doc/offiaccount/User_Management/Getting_a_User_List.html){:target="_blank"}
  """
  @spec get_users(SDK.client()) :: SDK.response()
  def get_users(client) do
    client.request(:get, url: "/user/get")
  end

  @spec get_users(SDK.client(), SDK.openid()) :: SDK.response()
  def get_users(client, next_openid) do
    client.request(
      :get,
      url: "/user/get",
      query: [
        next_openid: next_openid
      ]
    )
  end
end
