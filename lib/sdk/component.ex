defmodule WeChat.SDK.Component do
  @moduledoc """
  第三方平台

  [API Docs Link](https://developers.weixin.qq.com/doc/oplatform/Third-party_Platforms/Third_party_platform_appid.html)
  """

  @doc """
  通过code换取网页授权access_token

  ## API Docs
    [link](https://developers.weixin.qq.com/doc/oplatform/Third-party_Platforms/Official_Accounts/official_account_website_authorization.html)
  """
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
