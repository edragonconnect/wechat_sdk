defmodule WeChat.SDK.Component do
  @moduledoc """
  第三方平台

  [API Docs Link](https://developers.weixin.qq.com/doc/oplatform/Third-party_Platforms/Third_party_platform_appid.html)
  """
  alias WeChat.SDK

  @doc """
  通过code换取网页授权access_token

  ## API Docs
    [link](#{SDK.doc_link_prefix()}/oplatform/Third-party_Platforms/Official_Accounts/official_account_website_authorization.html)
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
end
