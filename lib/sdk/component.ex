defmodule WeChat.SDK.Component do
  @moduledoc """
  第三方平台

  [API Docs Link](https://developers.weixin.qq.com/doc/oplatform/Third-party_Platforms/Third_party_platform_appid.html){:target="_blank"}
  """

  import Jason.Helpers
  alias WeChat.SDK

  @doc_link "#{SDK.doc_link_prefix()}/oplatform/Third-party_Platforms/api"

  @typedoc """
  选项名称及可选值说明

  [link](#{@doc_link}/api_get_authorizer_option.html#选项名称及可选值说明){:target="_blank"}

  |   option_name    |   选项名说明    | option_value | 选项值说明 |
  | ---------------- | ------------  | ------------ | -------- |
  | location_report  | 地理位置上报选项 |       0      | 无上报    |
  | location_report  | 地理位置上报选项 |       1      | 进入会话时上报 |
  | location_report  | 地理位置上报选项 |       2      | 每 5s 上报 |
  | voice_recognize  | 语音识别开关选项 |       0      | 关闭语音识别 |
  | voice_recognize  | 语音识别开关选项 |       1      | 开启语音识别 |
  | customer_service | 多客服开关选项   |       0      | 关闭多客服 |
  | customer_service | 多客服开关选项   |       1      | 开启多客服 |
  """
  @type option_name :: String.t()

  @doc """
  通过code换取网页授权access_token

  ## API Docs
    [link](#{SDK.doc_link_prefix()}/oplatform/Third-party_Platforms/Official_Accounts/official_account_website_authorization.html){:target="_blank"}
  """
  @spec code2access_token(SDK.client(), code :: String.t()) :: SDK.response()
  def code2access_token(client, code) do
    client.request(
      :get,
      url: "/sns/oauth2/component/access_token",
      query: [
        grant_type: "authorization_code",
        code: code
      ]
    )
  end

  @doc """
  接口调用次数清零

  ## API Docs
    [link](#{SDK.doc_link_prefix()}/oplatform/Third-party_Platforms/Official_Accounts/Official_account_interface.html){:target="_blank"}
  """
  @spec clear_quota(SDK.client()) :: SDK.response()
  def clear_quota(client) do
    client.request(:post, url: "/cgi-bin/component/clear_quota")
  end

  @doc """
  获取令牌

  ## API Docs
    [link](#{@doc_link}/component_access_token.html){:target="_blank"}
  """
  @spec get_component_token(SDK.client(), component_verify_ticket :: String.t()) :: SDK.response()
  def get_component_token(client, component_verify_ticket) do
    client.request(:post,
      url: "/cgi-bin/component/api_component_token",
      body: json_map(component_verify_ticket: component_verify_ticket)
    )
  end

  @doc """
  获取预授权码

  ## API Docs
    [link](#{@doc_link}/pre_auth_code.html){:target="_blank"}
  """
  @spec create_pre_auth_code(SDK.client()) :: SDK.response()
  def create_pre_auth_code(client) do
    client.request(:post, url: "/cgi-bin/component/api_create_preauthcode")
  end

  @doc """
  使用授权码获取授权信息

  ## API Docs
    [link](#{@doc_link}/authorization_info.html){:target="_blank"}
  """
  @spec query_auth(SDK.client(), authorization_code :: String.t()) :: SDK.response()
  def query_auth(client, authorization_code) do
    client.request(:post,
      url: "/cgi-bin/component/api_query_auth",
      body: json_map(authorization_code: authorization_code)
    )
  end

  @doc """
  获取/刷新接口调用令牌

  ## API Docs
    [link](#{@doc_link}/api_authorizer_token.html){:target="_blank"}
  """
  @spec authorizer_token(SDK.client(), authorizer_refresh_token :: String.t()) :: SDK.response()
  def authorizer_token(client, authorizer_refresh_token) do
    client.request(:post,
      url: "/cgi-bin/component/api_authorizer_token",
      body:
        json_map(
          authorizer_appid: client.appid(),
          authorizer_refresh_token: authorizer_refresh_token
        )
    )
  end

  @doc """
  获取授权方的帐号基本信息

  ## API Docs
    [link](#{@doc_link}/api_get_authorizer_info.html){:target="_blank"}
  """
  @spec get_authorizer_info(SDK.client()) :: SDK.response()
  def get_authorizer_info(client) do
    client.request(:post,
      url: "/cgi-bin/component/api_get_authorizer_info",
      body: json_map(authorizer_appid: client.appid())
    )
  end

  @doc """
  获取授权方选项信息

  ## API Docs
    [link](#{@doc_link}/api_get_authorizer_option.html){:target="_blank"}
  """
  @spec get_authorizer_option(SDK.client(), option_name) :: SDK.response()
  def get_authorizer_option(client, option_name) do
    client.request(:post,
      url: "/cgi-bin/component/api_get_authorizer_option",
      body: json_map(authorizer_appid: client.appid(), option_name: option_name)
    )
  end

  @doc """
  拉取所有已授权的帐号信息

  ## API Docs
    [link](#{@doc_link}/api_get_authorizer_list.html){:target="_blank"}
  """
  @spec get_authorizer_list(SDK.client(), offset :: integer, count :: integer) :: SDK.response()
  def get_authorizer_list(client, offset, count) when count <= 500 do
    client.request(:post,
      url: "/cgi-bin/component/api_get_authorizer_list",
      body: json_map(offset: offset, count: count)
    )
  end

  @doc """
  创建开放平台帐号并绑定公众号/小程序

  该 API 用于创建一个开放平台帐号，并将一个尚未绑定开放平台帐号的公众号/小程序绑定至该开放平台帐号上。新创建的开放平台帐号的主体信息将设置为与之绑定的公众号或小程序的主体。

  ## API Docs
    [link](#{@doc_link}/account/create.html){:target="_blank"}
  """
  @spec create(SDK.client(), SDK.appid()) :: SDK.response()
  def create(client, appid) do
    client.request(:post,
      url: "/cgi-bin/open/create",
      body: json_map(appid: appid)
    )
  end

  @doc """
  将公众号/小程序绑定到开放平台帐号下

  该 API 用于将一个尚未绑定开放平台帐号的公众号或小程序绑定至指定开放平台帐号上。二者须主体相同。

  ## API Docs
    [link](#{@doc_link}/account/bind.html){:target="_blank"}
  """
  @spec create(SDK.client(), SDK.appid(), SDK.appid()) :: SDK.response()
  def create(client, appid, open_appid) do
    client.request(:post,
      url: "/cgi-bin/open/bind",
      body: json_map(appid: appid, open_appid: open_appid)
    )
  end

  @doc """
  将公众号/小程序从开放平台帐号下解绑

  该 API 用于将一个公众号或小程序与指定开放平台帐号解绑。开发者须确认所指定帐号与当前该公众号或小程序所绑定的开放平台帐号一致。

  ## API Docs
    [link](#{@doc_link}/account/unbind.html){:target="_blank"}
  """
  @spec unbind(SDK.client(), SDK.appid(), SDK.appid()) :: SDK.response()
  def unbind(client, appid, open_appid) do
    client.request(:post,
      url: "/cgi-bin/open/unbind",
      body: json_map(appid: appid, open_appid: open_appid)
    )
  end

  @doc """
  获取公众号/小程序所绑定的开放平台帐号

  该 API 用于获取公众号或小程序所绑定的开放平台帐号。

  ## API Docs
    [link](#{@doc_link}/account/get.html){:target="_blank"}
  """
  @spec get(SDK.client(), SDK.appid()) :: SDK.response()
  def get(client, appid) do
    client.request(:post,
      url: "/cgi-bin/open/get",
      body: json_map(appid: appid)
    )
  end
end
